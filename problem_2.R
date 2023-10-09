# Calling various libraries
library(tidyverse)

# Importing the text data into a vector
raw_file <- readLines(con = "http://www.sao.ru/lv/lvgdb/article/suites_dw_Table1.txt")

# Getting the line number of the separator line
sep_line = grep("^--", raw_file,TRUE)

# Getting a header of the table by using sep_line as a reference for the header line
header <- read.table(text = raw_file[sep_line-1], nrows = 1, header = FALSE, sep ='|')

# Getting the data of the table and skipping the separator line 
data <- read.table(text = raw_file,skip = sep_line, header = FALSE, sep = "|")

# Adding the  header to the data
colnames(data) <- header

# Storing the descriptions into a separate text file
write.table(raw_file[1:(sep_line-2)], # Using sep_line as a reference for the interval of lines
            file = "suites_dw_descriptions.txt", sep = "\t",row.names = FALSE, quote=FALSE)
