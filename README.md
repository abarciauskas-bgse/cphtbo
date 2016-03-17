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

train <- remove.extra.cols(data('news_popularity_training'))
test <- data('news_popularity_test')

# Split the data for validating the model
partitions <- training.paritions(train, p = 0.2)
data.train <- parititions$data.train
data.validation <- parititions$data.validation

# Validate the model
model <- train.randomForest(data.train)
preds <- predict(model, data.validation[,1:59])
# Accuracy on validation set
success.rate(preds, data.validation$popularity)

# Generate predictions
model <- train.randomForest(train)
# Generates a new predictions file using datetime as file prefix
generate.predictions.file(model, test)
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
if (!require('nnet')) install.packages('nnet')
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
