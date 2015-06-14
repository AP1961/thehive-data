source("R/helper.R", TRUE)

pkgTest("SPARQL")
library(SPARQL)

# Step 1 - Set up preliminaries and define query
# Define the data.gov endpoint
endpoint <- "http://dbpedia.org/sparql/"

## helper functions

# load suburbs
loadSuburbs <- function() {
  # Read locations table
  suburbnames = read.table("data/westernsydney_suburbnames.txt", sep=",", header = TRUE, row.names = 1)
  suburbnames <- rbind(suburbnames, "Mount Druitt")

  return (suburbnames)
}

# Construct the query
constructQuery <- function(query_parts) {
  location <- gsub(" ", "_", query_parts[1])
  return (c(paste0(query_parts[2], location, query_parts[3]), query_parts[1]))
}

# Execute the query
doQuery <- function(query) {
  qd <- SPARQL(url = endpoint, query = query[1])
  df <- data.frame(qd$results)
  if ( length(df) > 0 )
    df$location <- query[2]
  return (df)
}

# Create queries
createQueries <- function() {
  suburbnames <- loadSuburbs()
  # create query statement
  query_pt1 <- "
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema/>
SELECT ?p, ?o WHERE { <http://dbpedia.org/resource/"
  query_pt2 <- "> ?p ?o . }"
  
  # Entities
  #query_parts <- data.frame(suburbnames$x[33])
  query_parts <- data.frame(suburbnames)
  query_parts[, "pt1"] <- (query_pt1)
  query_parts[, "pt2"] <- (query_pt2)
  queries <- apply(query_parts, 1, constructQuery) 
  
  return (queries)
}

# Generate results
generateResults <- function() {
  queries <- createQueries()   
  # Step 2 - Use SPARQL package to submit query and save results to a data frame
  results <- apply(queries, 2, doQuery)
  merged_data <- data.frame(location=character(), p=character(), o=character(), stringsAsFactors=FALSE)
  for (row in results) {
    df <- data.frame(row)
    df$location
    merged_data <- rbind(merged_data, df)
  }
  print(results)
  return (results)  
}

generateResults()