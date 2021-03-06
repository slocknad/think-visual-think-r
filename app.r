install.packages(setdiff(c("pacman"), rownames(installed.packages())))  

pacman::p_load(shiny, ggplot2, plotly, shinyjs)

#library(shiny)
#library(shinyjs)
#library(modeldata)
#library(DAAG)
#library(ggplot2)
#library(plotly)
#library(devtools)
#library(RCurl)
#library(httr)
#library(magick)
#library(gganimate)

# global variables
csvfile <- NULL

server <- function(input, output) {
    # upload button
    observeEvent(
        eventExpr = input[["upload_button"]],
        handlerExpr = {
            
            insertUI(
                selector = "#upload_button",
                where = "afterEnd",
                ui = tags$div(HTML('<div id="axis_content">
                        <div class="btn-group dropend d-block axis-dropdown">
                            <button type="button" class="btn btn-secondary">
                                Select X axis column:
                            </button>
                            <button type="button" class="btn btn-secondary dropdown-toggle dropdown-toggle-split" data-bs-toggle="dropdown" aria-expanded="false">
                                <span class="visually-hidden">Toggle Dropright</span>
                            </button>
                            <ul class="dropdown-menu"></ul>
                        </div>
                        <div class="btn-group dropend d-block axis-dropdown">
                            <button type="button" class="btn btn-secondary">
                                Select Y axis column:
                            </button>
                            <button type="button" class="btn btn-secondary dropdown-toggle dropdown-toggle-split" data-bs-toggle="dropdown" aria-expanded="false">
                                <span class="visually-hidden">Toggle Dropright</span>
                            </button>
                            <ul class="dropdown-menu"></ul>
                        </div>
                    </div>'),
                    actionButton(
                        inputId = "generate_button",
                        label = "Set axis"
                    )
                    ),
                multiple = FALSE,
                immediate = FALSE,
                session = getDefaultReactiveDomain()
                )
        }
    )

    # generate graph
    observeEvent (
        eventExpr = input[["generate_button"]],
        handlerExpr = {
            xx <- input$x
            yy <- input$y
            csvfile <- data.frame(matrix(unlist(input$csvfile), nrow=length(input$csvfile), byrow=TRUE))
            cols <- names(csvfile)
            print(match(xx,cols))
            print(match(1, cols))

            output$plot <- renderPlotly({
                fig <- plot_ly(csvfile, x=~csvfile[,match(xx, cols)], y=~csvfile[,match(yy, cols)], type = "scatter", mode="lines")
                fig <- fig %>%
                layout(hovermode = "x unified", xaxis = list(title = cols[1]), yaxis = list (title = cols[2]))
            })
        })
}



# parte de html

ui <- fluidPage(
    tags$html(
        HTML('<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Think Visual :: Think R</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <nav class="navbar navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">Think Visual :: Think R</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbar" aria-controls="offcanvasNavbar">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="offcanvas bg-secondary offcanvas-end" tabindex="-1" id="offcanvasNavbar" aria-labelledby="offcanvasNavbarLabel">
                <div class="offcanvas-header">
                <h5 class="offcanvas-title text-light" id="offcanvasNavbarLabel">Think Visual :: Think R</h5>
                <button type="button" class="btn-close btn-close-light text-reset" data-bs-dismiss="offcanvas" aria-label="Close"></button>
                </div>
                <div class="offcanvas-body">
                <ul class="navbar-nav justify-content-end flex-grow-1 pe-3">
                    <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="index.html">Home</a>
                    </li>
                    <li class="nav-item">
                    <a class="nav-link" href="https://github.com/slocknad/think-visual-think-r">Github Repo <i class="bi bi-github"></i></a>
                    </li>
                </ul>
                </div>
            </div>
        </div>
    </nav>
    
    <div class="container m-0">
        <div class="row p-3">
            <div class="col-5" id="shinytest">
                <h4>Import a file:</h4>
                    <div class="rounded border border-primary text-center mt-3 p-3" id="dragdrop">
                        <input type="file" name="dataFile" id="dataFile" onchange="importData(this.files)" style="display: none;">
                        <label for="dataFile" style="display: block; cursor: pointer;"><i class="bi bi-upload"></i></label>
                        <label for="dataFile" style="text-decoration: underline;cursor: pointer;">Choose a file</label> or drag it here.
                    </div>
            <div class="col-7" id="plot"></div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
    <script src="main.js"></script>
    <script src="jquerytest.js"></script>
</body>
</html>')
    ),
        actionButton(
                inputId = "upload_button",
                label = "Upload"),
        div(plotlyOutput("plot",width = "500px", height = "300px"), align = "center")
)


shinyApp(ui, server)

# animated_plot <- ggplot(m, aes(x = time, y = measles)) +
#   geom_line(size = 1, color = "blue") +
#   transition_reveal(time) +
#   theme_minimal()
# 
# animation <- animate(animated_plot, nframes=70, renderer=magick_renderer())
# 
# animation








# animated_plot <- ggplot(m, aes(x = time, y = measles)) +
#   geom_line(size = 1, color = "blue") +
#   transition_reveal(time) +
#   theme_minimal()
# 
# animation <- animate(animated_plot, nframes=70, renderer=magick_renderer())
# 
# animation