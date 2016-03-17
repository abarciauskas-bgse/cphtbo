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

data('news_popularity_training')
data('news_popularity_test')

train <- remove.extra.cols(news_popularity_training)
test <- news_popularity_test

# Split the data for validating the model
partitions <- training.partitions(train, p = 0.2)
data.train <- partitions$data.train
data.validation <- partitions$data.validation

# Validate the model
model <- train.randomForest(data.train)
preds <- predict(model, data.validation[,1:59])
# Accuracy on validation set
success.rate(preds, data.validation$popularity)
```

## Replicate results

Replicates results from 16032016-2-final-predictions.csv submission @Wed, 16 Mar 2016 22:11:30

```{r}
# Generate predictions for REAL test set
# Replicates results from 16032016-2-final-predictions.csv submission @Wed, 16 Mar 2016 22:11:30
model <- train.randomForest(train)
# Generates a new predictions file using datetime as file prefix
file <- generate.predictions.file(model, test)
```

Test for equality:

```{r}
expected <- read.csv('16032016-2-final-predictions.csv')
new <- read.csv(file)
assert_that(all(expected[,2] == new[,2]))
```

## Additionally...

**`cross.val`** Runs k-fold cross validation via rolling window.

```{r}
res <- cross.val(
  model.function = train.randomForest,
  model.args = list(data.train = data.train),
  data.train = data.train)
```

**`loglik`** Calculates Log Likelihood from model deviance (model passed as argument must respond to `deviance`)

```{r}
if (!require('nnet')) install.packages('nnet')
model <- multinom(popularity ~ ., data = data.train)
loglik(model)
```

## Contributing

```{sh}
git clone git@github.com:abarciauskas-bgse/cphtbo.git
cd cphtbo
```

```{r}
library(devtools)
# Build the package
devtools::install()
# Generate documentation
devtools::document()
```

## Authors

* Aimee Barciauskas
* Zsuzsa Holler
* Sarah Inman
