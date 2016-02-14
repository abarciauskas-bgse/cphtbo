# cphtbo

R package for making classification predicitions

## Install

```{r}
if (!require('devtools')) install.packages('devtools')
devtools::install_github("abarciauskas-bgse/cphtbo")
library(cphtbo)
```

## Use

```{r}
library(cphtbo)
# Change directory as appropriate
data <- setupOnlineNewsData('~/Projects/kaggle-onlinenewspopularity/data')
data.train <- data[['data.train']]
data.validation <- data[['data.validation']]

model <- randomForest.train(data.train)
preds <- predict(model, data.validation[,1:59])
success.rate(preds, data.validation[,'popularity'])
```
