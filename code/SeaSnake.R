#Set working directory
list.files()
library(ggplot2)
library(tidyverse)
install.packages("plotly")
library(dplyr)
library(plotly)
library(viridis)
install.packages("viridis")
install.packages("hrbrthemes")
library(hrbrthemes)
library(readxl)
install.packages("htmlwidgets")
library(htmlwidgets)

#Quick way to load in files
Sea_snake <- readxl::read_excel(file.choose())

#Showcases values within depth
unique(Sea_snake2$Depth)

#Shows 
colnames(Sea_snake)
  
unique(Sea_snake$Taxa)

#Cleaning
#Within Seasnake taxa remove NA the column
Sea_snake$Taxa[2] <- "Spotted sea snake"
Sea_snake$Taxa[5] <- "Horned sea snake"  
Sea_snake$Taxa[7] <-  "Hydrophis sp"   
Sea_snake$Taxa[9] <-  "Unidentified" 
Sea_snake$Taxa[c(13,14,15,16)] <-  "Olive-brown sea snake"  
Sea_snake$Taxa[18] <-  "White-crowned sea snake"  
Sea_snake$Taxa[20] <-   "Slender-necked sea snake"

#Cleaning the methods 
Sea_snake$`BRUV (2004)`[is.na(Sea_snake$`BRUV (2004)`)] <- "0"
Sea_snake$`BRUV(2016)`[is.na(Sea_snake$`BRUV(2016)`)] <- "0"

Sea_snake$`ROV(2021)`[is.na(Sea_snake$`ROV(2021)`)] <- "0"

colnames(Sea_snake)


#Reshaping dataset

Sea_snake3 <- Sea_snake %>%
  pivot_longer(
    cols = c(`BRUV (2004)`,  `BRUV(2016)`,`ROV(2021)`),
    names_to = "Method"
  )



print(Sea_snake3)

S <- Sea_snake %>%
  mutate(text = paste(
    "Species:", Taxa,
    "<br>Depth:", Depth,
    "<br>Total:",Total,
    sep = ""
  ))
class(S)


#<br> separates the lines 
Bub <- ggplot(S,aes(x= Depth, 
                    y = Total, 
                    size = Total,
                    colour = Taxa,
                    text = text))+
  geom_point(alpha = 0.7) +
  scale_size(range = c(2,15))+
  theme_minimal()+
  labs(
    x= "Depth(m) ",
    y = " Total Abundance",
    colour = "Species"
  ) 

#Plotting bubble plot
#Tool tip makes the bubbles interactive 
pp <- ggplotly(Bub,tooltip = "text")
pp

saveWidget(pp, "Sea_snake_interactive.html", selfcontained = TRUE)

