# Shiny UI component for the Dashboard

# Ensure district names are lowercase for merging with map data
#library(dplyr)

# Read the data from CSV file and convert district column to lowercase
my_data <- read.csv("TeleLawData.csv") %>%
  mutate(district = tolower(district))


dashboardPage(
  
  dashboardHeader(title = "Exploring FIRs Registered in India with R & Shiny Dashboard", titleWidth = 650, 
                  tags$li(class = "dropdown", tags$a(href = "https://www.youtube.com/playlist?list=PL6wLL_RojB5xNOhe2OTSd-DPkMLVY9DfB", icon("youtube"), "My Channel", target = "_blank")),
                  tags$li(class = "dropdown", tags$a(href = "https://www.linkedin.com/in/abhinav-agrawal-pmp%C2%AE-safe%C2%AE-5-agilist-csm%C2%AE-5720309", icon("linkedin"), "My Profile", target = "_blank")),
                  tags$li(class = "dropdown", tags$a(href = "https://github.com/aagarw30/R-Shiny-Dashboards/tree/main/USArrestDashboard", icon("github"), "Source Code", target = "_blank"))
  ),
  
  dashboardSidebar(
    sidebarMenu(id = "sidebar",
                menuItem("Dataset", tabName = "data", icon = icon("database")),
                menuItem("Visualization", tabName = "viz", icon = icon("chart-line"))
                
    )
  ),
  
  dashboardBody(
    
    tabItems(
      ## First tab item
      tabItem(tabName = "data", 
              tabBox(id = "t1", width = 12, 
                     tabPanel("About", icon = icon("address-card"),
                              fluidRow(
                                column(width = 4, 
                                       tags$br(),
                                       tags$p("This data set contains statistics on FIRs registered for the Indian population with districts and the number of CSCs, Cases Registered, and Advice Enabled.")
                                )
                              )
                     ),
                     tabPanel("Data", dataTableOutput("dataT"), icon = icon("table")), 
                     tabPanel("Structure", verbatimTextOutput("structure"), icon = icon("uncharted")),
                     tabPanel("Summary Stats", verbatimTextOutput("summary"), icon = icon("chart-pie"))
              )
      ),
      
      # Second Tab Item
      tabItem(tabName = "viz", 
              tabBox(id = "t2",  width = 12, 
                     tabPanel(" Trends by Districts", value = "district",
                              fluidRow(tags$div(align = "center", box(tableOutput("top5"), title = textOutput("head1"), collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE)),
                                       tags$div(align = "center", box(tableOutput("low5"), title = textOutput("head2"), collapsible = TRUE, status = "primary",  collapsed = TRUE, solidHeader = TRUE))
                              ),
                              withSpinner(plotlyOutput("bar"), id = "spinner1")
                     ),
                     tabPanel("Distribution ", value = "distro",
                              withSpinner(plotlyOutput("histogram", height = "350px"), id = "spinner2")),
                        tabPanel("Correlation Matrix", id = "corr", withSpinner(plotlyOutput("cor"), id = "spinner3")),
                     tabPanel("Relationship among No. of CSCs, Cases Registered & Advice Enabled", 
                              #  radioButtons(inputId = "fit", label = "Select smooth method", choices = c("loess", "lm"), selected = "lm", inline = TRUE), 
                              withSpinner(plotlyOutput("scatter"), id = "spinner4"), value = "relation"),
                     side = "left"
              )
      )
      
      
      
    )
  )
)

