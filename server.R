# server.R
# This server.r depends on the DataPrep.r script to have prepared the data from raw data
library(googleVis)
library(shiny)
library(dplyr)

## Prepare final dataset

shinyServer(function(input, output) {
        datasetInput <- reactive({
               switch(input$Region,
                       "Africa",
                       "Americas",
                       "Eastern Mediterranean",
                       "Europe",
                       "South-East Asia",
                       "Western Pacific")
        })

        kid_stats <- read.csv("kid_stats.csv")
        
        regions <- kid_stats %>% group_by(Region) %>% summarize(n())
        
        ## To set the right options, go to the visualization, set up the chart just right, then copy the advanced text       
        motionOptions <- '
        {"xZoomedDataMax":1388534400000,"nonSelectedAlpha":0.4,"iconKeySettings":[],"sizeOption":"4","yLambda":1,
         "uniColorForNonSelected":false,"dimensions":{"iconDimensions":["dim0"]},"yAxisOption":"8","showTrails":true,
        "xAxisOption":"_TIME","xZoomedDataMin":631152000000,"yZoomedDataMin":0,"orderedByY":false,"yZoomedDataMax":0.007260195735,
        "time":"1990","duration":{"multiplier":1,"timeUnit":"Y"},"colorOption":"3","xLambda":1,"xZoomedIn":false,"iconType":"BUBBLE",
        "playDuration":15000,"orderedByX":false,"yZoomedIn":false}
        '
        
        output$view1 <- renderGvis({
                kid_stats_R <- kid_stats %>% filter(Region==input$Region)
                gvisMotionChart(kid_stats_R, "Country", "Year",
                                options=list(state=motionOptions))
                })
##        output$view2 <- renderGvis({
##                gvisGeoChart(kid_stats, locationvar="Country",
##                                  colorvar="Infant_Deaths_Per_Million",options=list(width=600, height=400))
##        })
})