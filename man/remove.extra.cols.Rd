% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/onlineNewsPopularity.R
\name{remove.extra.cols}
\alias{remove.extra.cols}
\title{remove.extra.cols
Removes url and id columns}
\usage{
remove.extra.cols(data)
}
\arguments{
\item{data}{}
}
\value{
data without url and id columns
}
\description{
remove.extra.cols
Removes url and id columns
}
\examples{
data.train <- data('news_popularity_training')
data.test <- data('news_popularity_test')
training.data <- remove.extra.cols(data)
test.data <- remove.extra.cols(data)

}

