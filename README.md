# cphtbo

R package for making classification predictions. Targeted at online news popularity challenge as specified for [BGSE Data Science Masters Kaggle Competition](https://inclass.kaggle.com/c/predicting-online-news-popularity)

## Install

Install the package:

```{r}
if (!require('devtools')) install.packages('devtools')
devtools::install_github("abarciauskas-bgse/cphtbo")
library(cphtbo)
```

## Use

```{r}
library(cphtbo)
# Change directory to wherever online news data files are stored locally from
# https://inclass.kaggle.com/c/predicting-online-news-popularity/data
data.dir <- '~/Projects/kaggle-onlinenewspopularity/data'
data <- setupOnlineNewsData(data.dir)
data.train <- data[['data.train']]
data.validation <- data[['data.validation']]

model <- train.randomForest(data.train)
preds <- predict(model, data.validation[,1:59])
success.rate(preds, data.validation[,'popularity'])

# Generate predictions file for BGSE inclass kaggle
# https://inclass.kaggle.com/c/predicting-online-news-popularity/
# 
# Default seed for randomForest.train is 187 which was used for generating classifications
# As submitted Sun, 14 Feb 2016 16:35:33
data.train.full <- rbind(data.train, data.validation)

data.dir <- '~/Projects/kaggle-onlinenewspopularity/data'
model <- train.randomForest(data.train.full)
# Generates a new predictions file using datetime as file prefix
generatePredictionsFile(model, data.dir)
```

## Additionally...

**`cross.val`** Runs k-fold cross validation via rolling window.

```{r}
res <- cross.val(
  model.function = train.randomForest,
  model.args = list(data.train = data.train.full),
  data.train = data.train.full)
```

**`loglik`** Calculates Log Likelihood from model deviance (model passed as argument must respond to `deviance`)

```{r}
model <- multinom(popularity ~ ., data = data.train)
loglik(model)
```

## Contributing

```{r}
# Build the package
R -e 'devtools::install()'
# Generate documentation
R -e 'devtools::document()'
```

## Authors

* Aimee Barciauskas
* Zsuzsa Holler
* Sarah Inman
