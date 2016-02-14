if (!require('assertthat')) install.packages('assertthat')

# Helper functions

# ----------------------------------------------------------------------
# Cross-Validation of a Classifier Algorithm
# ----------------------------------------------------------------------
#' cross.val
#' 
#' Runs k-fold cross validation via rolling window.
#' Any required libraries to run the classification algorithm should already be loaded.
#'
#' @param model.function function name of the classification algorithm call 
#' @param model.args arguments to pass to the function call
#' @param data.train data frame or matrix of training data, depending on what the algorithm requires
#' @param no.subsets number of folds to run cross-validation on. Defaults to 5.
#'
#' @return list(rates, mean.rates) success rates and mean success rates of algorithm on each subset
#' @export
#'
#' @examples
#' # Example with multinom
# cross.val(model.function = multinom, model.args = list(formula = popularity ~ ., data = training), data = training)
# $rates
# [1] 0.4941667 0.4810417 0.4658333 0.4770833 0.4935417
# $mean.rate
# [1] 0.4823333
#
cross.val <- function(model.function, model.args = list(), data.train, no.subsets = 5) {
  assert_that(nrow(data.train) > 0)
  assert_that(mode(model.function) == 'function')
  assert_that(mode(model.args) == 'list')

  no.obs <- nrow(data.train)
  training <- data.train
  batch.size <- floor(no.obs/no.subsets)
  batches <- list()
  batch.pointer <- batch.size
  starting.position <- 1

  # break data into subsets
  for (batch.idx in 1:no.subsets) {
    batches[[batch.idx]] <- training[starting.position:batch.pointer,]
    starting.position <- starting.position + batch.size
    batch.pointer <- batch.pointer + batch.size
  }
  
  rates <- c()
  # rolling window
  for (test.batch.idx in 1:no.subsets) {
    print(paste0('Processing batch: ', test.batch.idx))
    # join the training subsets
    train.batch.idcs <- setdiff(1:no.subsets,test.batch.idx)
    training <- batches[[train.batch.idcs[1]]]
    lapply(train.batch.idcs[2:length(train.batch.idcs)], function(idx) {
      training <- rbind(training, batches[[idx]])
    })
    
    test <- batches[[test.batch.idx]]
    test.x <- test[,1:(ncol(test)-1)]
    test.y <- test[,'popularity']
    
    # train a model on training data
    if (deparse(substitute(model.function)) == "xgb.train") {
      model.args[['data']] <- xgb.DMatrix(training[,1:59], label = training[,'popularity']-1)
    }
    model <- do.call(model.function, model.args)
    # predict the last subset
    preds <- predict(model, test.x)
    if (deparse(substitute(model.function)) == "xgb.train") {
      preds <- preds + 1
    }
    sr <- success.rate(preds, test.y)
    print(paste0('Success rate: ', as.numeric(sr)))
    rates <- append(rates, as.numeric(sr))
  }
  return(list(rates = rates, mean.rate = mean(rates)))
}


# ----------------------------------------------------------------------
# Success Rate of predictions vs actual values
# ----------------------------------------------------------------------
#' success.rate
#'
#' @param predictions vector of predictions
#' @param actual vector of actual values
#'
#' @return success rate as float point
#' @export
#'
#' @examples
#' success.rate(model$predicted, data.train$popularity)
#' 
success.rate <- function(predictions, actual) {
  assert_that(length(predictions) == length(actual))
  errors <- 0
  # count number of mistakes
  for (i in 1:length(actual)) {
    if (predictions[i] != actual[i]) {
      errors <- errors + 1
    }
  }
  print(paste0('Number of errors: ', errors))
  rate <- 1 - errors/length(actual)
  print(paste0('Rate: ', rate))
  return (1 - errors/length(actual))
}

# ----------------------------------------------------------------------
# Log Likelihood from Deviance
# ----------------------------------------------------------------------
#' loglik
#'
#' @param model model which should respond to deviance
#'
#' @return -model$deviance/2
#' @export
#'
#' @examples
#' loglik(model)
#' 
loglik <- function(model) {
  assert_that(exists(paste0(deparse(substitute(model)),'$deviance')))
  # deviance = -2 log likelihoods
  -model$deviance/2
}
