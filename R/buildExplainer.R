#' Step 1: Build an lightgbmExplainer
#'
#' This function outputs an lightgbmExplainer (a data table that stores the feature impact breakdown for each leaf of each tree in an lightgbm model). It is required as input into the explainPredictions and showWaterfall functions.
#' @param lgb_tree A lightgbm.dt.tree
#' @return The lightgbm Explainer for the model. This is a data table where each row is a leaf of a tree in the lightgbm model
#'  and each column is the impact of each feature on the prediction at the leaf.
#'
#'  The leaf and tree columns uniquely identify the node.
#'
#'  The sum of the other columns equals the prediction at the leaf (log-odds if binary response).
#'
#'  The 'intercept' column is identical for all rows and is analogous to the intercept term in a linear / logistic regression.
#'
#' @export
#' @import data.table
#' @import lightgbm
#' @examples
#' library(lightgbm) # v2.1.0 or above
#' library(lightgbmExplainer)
#'
#' # Load Data
#' data(agaricus.train, package = "lightgbm")
#' # Train a model
#' lgb.dtrain <- lgb.Dataset(agaricus.train$data, label = agaricus.train$label)
#' lgb.params <- list(objective = "binary")
#' lgb.model <- lgb.train(lgb.params, lgb.dtrain, 5)
#' # Build Explainer
#' lgb.trees <- lgb.model.dt.tree(lgb.model) # First get a lgb tree
#' explainer <- buildExplainer(lgb.trees)
#' # compute contribution for each data point
#' pred.breakdown <- explainPredictions(lgb.model, explainer, agaricus.train$data)
#' # Show waterfall for the 8th observation
#' showWaterfall(lgb.model, explainer, lgb.dtrain, agaricus.train$data,  8, type = "binary")


buildExplainer = function(lgb_tree){

  # TODO - Add test case for lgb.dt.tree order

  cat('\nBuilding the Explainer...')
  cat('\nSTEP 1 of 2')
  lgb_tree_with_stat = getStatsForTrees(lgb_tree)
  cat('\n\nSTEP 2 of 2')
  explainer = buildExplainerFromTree(lgb_tree_with_stat)

  cat('\n\nDONE!\n')

  return (explainer)
}
