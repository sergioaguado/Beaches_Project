library(shiny)
library(plyr)
library(googleVis)

beaches <- read.csv("data/beaches.csv", header=T, sep=",")


beaches$LatLon <- paste(beaches$Latitude,beaches$Longitude, sep=":")

# Define a server for the Shiny app
shinyServer(function(input, output) {
        
        # Reactive functions for the occupation level
        occupationLevel <- reactive({
                input$occupation
        })
        
        # Reactive function for urbanization level
        urbanizationLevel <- reactive({
                input$urbanization
        })
        
        # Reactive functions for the length
        maxLength <- reactive({
                input$beachLength[2]
        })
        minLength <- reactive({
                input$beachLength[1]
        })
        
        # Reactive functions for the width
        maxWidth <- reactive({
                input$beachWidth[2]
        })
        minWidth <- reactive({
                input$beachWidth[1]
        })
        
        # Reactive function for vegetation level
        vegetation <- reactive({
                input$vegetation
        })
        
        # Render the google map with the points
        output$gvis <- renderGvis({
                
                #FILTERS
                
                # Occupation filter
                occupation <- rep(TRUE, dim(beaches)[1])
                if (input$occupation != "All") {
                        occupation <- beaches$Occupation_level == occupationLevel()   
                } 
                
                # Urbanization level filter
                urbanization <- rep(TRUE, dim(beaches)[1])
                if (input$urbanization != "All") {
                        occupation <- beaches$Urbanization_level == urbanizationLevel()   
                } 
                
                # Length filter
                Length <- beaches$Length >= minLength() & 
                        beaches$Length <= maxLength()
                
                # Width filter
                Width <- beaches$Width >= minWidth() &
                        beaches$Width <= maxWidth() & !is.na(beaches$Width)
                
                # Vegetation filter. 1 = T, 2 = F, 3 = ALL
                vegetation <- rep(TRUE, dim(beaches)[1]) 
                if(vegetation()==1) {
                        vegetation <- beaches$Vegetation == TRUE 
                }
                else if(vegetation()==2) {
                        vegetation <- beaches$Vegetation == FALSE 
                }

                # Filter the beaches data and asign to num.beaches
                num.beaches <- beaches[Width & Length & occupation & urbanization &
                                               vegetation, ]
                
                # Load the google map. "Point" is a variable i have created for
                # printing the results with html code
                gvisMap(num.beaches,
                        locationvar="LatLon", 
                        tipvar="Point")  
        })
        
        
})

