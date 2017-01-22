#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
featureViewer <- function(sequence = NULL,
                          features = list(),
                          showAxis = TRUE,
                          showSequence = TRUE,
                          brushActive = TRUE, #zoom
                          toolbar = TRUE, #current zoom & mouse position
                          bubbleHelp = FALSE,
                          zoomMax = 1, #define the maximum range of the zoom
                          width = NULL,
                          height = NULL,
                          elementId = NULL,
                          widget = NULL
) {

  if (!is.null(widget)) {
    f = "function(el, x, features) {
      console.log('appending', features);
      x.features = x.features.concat(features);
      add_features();
    }"
    htmlwidgets::onRender(widget, f, features)
  } else {
    # create a list that contains the settings
    settings <- list(
      showAxis = showAxis,
      showSequence = showSequence,
      brushActive = brushActive, #zoom
      toolbar = toolbar, #current zoom & mouse position
      bubbleHelp = bubbleHelp,
      zoomMax = zoomMax #define the maximum range of the zoom
    )

    # pass the data and settings using 'x'
    x <- list(
      sequence = sequence,
      features = features,
      settings = settings
    )

    htmlwidgets::createWidget(
      name = "featureViewer",
      x,
      width = width,
      height = height,
      package = "featureViewerR",
      elementId = elementId
    )
  }
}

"+.featureViewer" <- function(e1, e2) {
  if (is(e1, "featureViewer")) {
    featureViewer(features=e2, widget=e1)
  } else {
    featureViewer(features=e1, widget=e2)
  }
}

#' @rdname featureViewer-add
#' @export
"%+%" <- `+.featureViewer`

#' Shiny bindings for featureViewer
#'
#' Output and render functions for using featureViewer within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a featureViewer
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name featureViewer-shiny
#'
#' @export
featureViewerOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'featureViewer', width, height, package = 'featureViewerR')
}

#' @rdname featureViewer-shiny
#' @export
renderFeatureViewer <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, featureViewerOutput, env, quoted = TRUE)
}
