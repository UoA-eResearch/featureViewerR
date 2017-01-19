# featureViewerR

An R package that acts as an htmlwidgets wrapper for feature-viewer

## Installation

```
install.packages("devtools")
devtools::install_github("UoA-eResearch/featureViewerR")
```

## Usage:

```
library("featureViewerR")

sequence <- "MALWMRLLPLLALLALWGPGPGAGSLQPLALEGSLQKRGIVEQCCTSICSLYQLE"
features <- list(list(data = list(list(x = 20,y = 32)), name = "test feature 1", className="test1", color = "#0F8292", type = "rect"))
featureViewerR::featureViewer(sequence, features)

# Vignette

vignette("simple_example")

# Note: it may be necessary to build the vignette like so:
devtools::install_github("UoA-eResearch/featureViewerR", build_vignettes = TRUE)

# Shiny example

library("shiny")

ui = shinyUI(fluidPage(
    checkboxInput("showAxis", "Show axis", value = TRUE),
    checkboxInput("showSequence", "Show sequence", value = TRUE),
    checkboxInput("brushActive", "Brush active", value = TRUE),
    checkboxInput("toolbar", "Toolbar", value = TRUE),
    checkboxInput("bubbleHelp", "Bubble help", value = FALSE),
    numericInput("zoomMax", "Zoom max", value = 1),
    featureViewerOutput("fv1")
))

server = function(input, output) {
    output$fv1 <- renderFeatureViewer(
        featureViewer(
          sequence,
          features,
          showAxis = input$showAxis,
          showSequence = input$showSequence,
          brushActive = input$brushActive,
          toolbar = input$toolbar,
          bubbleHelp = input$bubbleHelp,
          zoomMax = input$zoomMax
        )
    )
}

shinyApp(ui = ui, server = server)
```


