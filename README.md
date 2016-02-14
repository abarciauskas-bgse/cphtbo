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

model <- randomForest.train(data.train)
preds <- predict(model, data.validation[,1:59])
success.rate(preds, data.validation[,'popularity'])

# Generate predictions file for BGSE inclass kaggle
# https://inclass.kaggle.com/c/predicting-online-news-popularity/
# 
# Default seed for randomForest.train is 187 which was used for generating classifications
# As submitted Sun, 14 Feb 2016 16:35:33
data.train.full <- rbind(data.train, data.validation)

data.dir <- '~/Projects/kaggle-onlinenewspopularity/data'
model <- randomForest.train(data.train.full)
generatePredictionsFile(model, data.dir)
```

## Additionally...

* `cross.val` Runs k-fold cross validation via rolling window.
* `loglik` Calculates Log Likelihood from model deviance (model passed as argument must respond to `deviance`)

## Authors

* Aimee Barciauskas
* Zsuzsa Holler
* Sarah Inman
