source("R/main.R", TRUE)

pkgTest("SPARQL")
library(SPARQL)

# Step 1 - Set up preliminaries and define query
# Define the data.gov endpoint
endpoint <- "http://dbpedia.org/sparql/"

# helper functions
concat <- function(pre, part, post) {
  return (paste0(pre, part, post))
}

# create query statement
query_pt1 <- "
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema/>
SELECT ?p, ?o WHERE { <http://dbpedia.org/resource/"
query_pt2 <- "> ?p ?o . }"

# Entities
locations <- c("Mount_Druitt", "")
query_parts <- data.frame(locations)
query_parts[, "pt1"] <- (query_pt1)
query_parts[, "pt2"] <- (query_pt2)
apply(locations, 1, concat) 
paste0(query_pt1, , query_pt2)

# Step 2 - Use SPARQL package to submit query and save results to a data frame
qd <- SPARQL(url = endpoint, query = query)
df <- qd$results
df$p
df$o

