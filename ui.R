# ui.R
##shinyUI(pageWithSidebar(
##        headerPanel("World Infant Mortality Visualization"),
##        sidebarPanel(
##                selectInput("Region", "Choose a Region:", 
##                            choices = as.character(regions$Region),
##                            selected = "Africa")
##        ),
##        mainPanel(
##                htmlOutput("view")
##        )
##))

shinyUI(fluidPage(
        
        titlePanel("World Infant Mortality Visualization"),
        
        sidebarLayout(
                
                sidebarPanel(
                        selectInput("Region", "Choose a Region:", 
                                    choices = list("Africa","Americas","Eastern Mediterranean","Europe",
                                                   "South-East Asia","Western Pacific"),
                                    selected = "Africa")
                ),
                
                mainPanel(
                        h3("Select a region, then press play!"),
                        htmlOutput("view1"),
                        h4("Documentation"),
                        h5("Example Use: Follow these instructions to get familiar with the interface"),
                        p("1-Change the chart type to bar chart using icon in upper right of the graph"),
                        p("2-Select Rawanda on the Lower right selection panel"),
                        p("3-Select play at the bottom of the chart"),
                        p("4-Notice what happens to Rawanda Infant Deaths during the 90's"),
                        h5("Data Definitions"),
                        p("Infant_Deaths_Per_Million = Number of reported infant deaths per 1 Million population"),
                        p("Neonatal_Deaths_Per_Million = Number of reported neonatal deaths per 1 Million population"),
                        p("Under5_Deaths_Per_Million = Number of reported deaths of children under 5 years old per 1 Million population"),
                        p("For further review of data elements and definitions see Data Sources below"),
                        h5("Use the instructions below to explore further:"),
                        img(src = "gViz_Motion_Chart.png", height = 600, width = 600),
                        p("Picture above is from https://cran.r-project.org/web/packages/googleVis/vignettes/googleVis.pdf"),
                        h5("Data Source:"),
                        p("The source of Infant Mortality data is the World Health Organization:"),
                        p("http://apps.who.int/gho/data/node.main.POP107?lang=en"),
                        p("The source of country population is the World Bank:"),
                        p("http://data.worldbank.org/indicator/SP.POP.TOTL")
                        
##                        htmlOutput("view2")
                                )
                )
        )
)