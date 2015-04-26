library(shiny)
library(plyr)

beaches <- read.csv("data/beaches.csv", header=T, sep=",")
beaches$LatLon <- paste(beaches$Latitude,beaches$Longitude, sep=":")
maxLength <- as.numeric(max(beaches$Length, na.rm=T))
maxWidth <- as.numeric(max(beaches$Width, na.rm=T))

# Define the overall UI
shinyUI(
        
        # Use a fluid Bootstrap layout
        fluidPage(    
                
                # Give the page a title
                titlePanel("Spanish beaches"),
                
                # Generate a row with a sidebar
                sidebarLayout(      
                        
                        # Define the sidebar with one input
                        sidebarPanel(
                                
                                # List box for Occupation level
                                selectInput("occupation", "Occupation level:", 
                                            choices=c("All", 
                                                as.character(unique(beaches$Occupation_level))), 
                                                selected="Low"),
                                
                                # List box for Urban level
                                selectInput("urbanization", "Urbanization level:", 
                                            choices=c("All", 
                                                as.character(unique(beaches$Urbanization_level))), 
                                                selected="Semiurban"),
                        
                                # Slidebar for beach length
                                sliderInput("beachLength", 
                                            label = "Range of beach length:",
                                            min = 0, max = maxLength, value = c(0, maxLength),
                                            step = 50),
                                
                                # Slidebar for beach width
                                 sliderInput("beachWidth", 
                                             label = "Range of beach width:",
                                             min = 0, max = maxWidth, value = c(0, maxWidth),
                                             step = 50),
                                
                                radioButtons("vegetation", 
                                             label = h3("Do you want a beach with vegetation?"),
                                             choices = list("Yes" = 1, "No" = 2,
                                                            "Don't care" = 3),selected = 1),
                                
                                helpText("The points in the map will be truncated if there are too many beaches selected")
                        ),
                        

                
                        # Create a map with html
                        mainPanel(
                                HTML("<h4>Play with the filters for discovering beaches in Spain.</h4>"),
                                htmlOutput("gvis"),
                                HTML("<br><br><p>Author: <em>Sergio Aguado</em><br><a href='https://github.com/sergioaguado/Beaches_Project'>Github</a></p>")
                        )
                        
                )
        )
)