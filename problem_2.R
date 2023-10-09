# Calling various libraries
library(tidyverse)

# Importing the text data into a vector
raw_file <- readLines(con = "http://www.sao.ru/lv/lvgdb/article/suites_dw_Table1.txt")

# Getting the line number of the separator line
sep_line = grep("^--", raw_file,TRUE)

# Getting a header of the table by using sep_line as a reference for the header line
header <- read.table(text = raw_file[sep_line-1], nrows = 1, header = FALSE, sep ='|',strip.white = TRUE)

# Getting the data of the table and skipping the separator line 
data <- read.table(text = raw_file,skip = sep_line, header = FALSE, sep = "|", strip.white = TRUE)

# Adding the  header to the data
colnames(data) <- header

# Storing the descriptions into a separate text file
write.table(raw_file[1:(sep_line-2)], # Using sep_line as a reference for the interval of lines
            file = "suites_dw_descriptions.txt", sep = "\t",row.names = FALSE, quote=FALSE)


# Plotting the distribution of the m_b variable which tells us the absolute magnitude of the galaxy
# the lower the value the bigger is the magnitude of the respective galaxy

data %>% 
  ggplot(aes(x=m_b)) + 
  geom_histogram(aes(y=..density..), # Histogram with density instead of count on y-axis
                 binwidth=.5,
                 colour="black", fill="white") +
  geom_density(alpha=.2, fill="#FF6666") +
  geom_vline(aes(xintercept=mean(m_b, na.rm=T)),# Adding mean and ignoring NA values
             color="red", linetype="dashed", size=1)

# It can be seen that that the observations of the variable are much less dense in the -5,0 interval
# of observations which does point at the under-representation of the smaller magnitude galaxies,
# furthermore the distribution of the variable seems to be skewered to the left and does not seem to
# follow a normal distribution Which is confirmed when we run the Shapiro-Wilk test where we can 
# reject h0 (w = 0.975, p < 0.01)
shapiro.test(data$m_b)

# If we look at the mean its value is -13.73 which coincides with the lack of smaller
# magnitude observations. 
summary(data$m_b)
 

