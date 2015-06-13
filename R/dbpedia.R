source("R/main.R", TRUE)

pkgTest("SPARQL")
library(SPARQL)

# Step 1 - Set up preliminaries and define query
# Define the data.gov endpoint
endpoint <- "http://dbpedia.org/sparql/"

# create query statement
query <-"
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema/>
SELECT ?p, ?o WHERE { <http://dbpedia.org/resource/Malabaine> ?p ?o . }
"

# Step 2 - Use SPARQL package to submit query and save results to a data frame
qd <- SPARQL(url = endpoint, query = query)
df <- qd$results
df$p
df$o

