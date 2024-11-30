
FROM neo4j:5.25.1 as neo4j-import
 

ENV NEO4J_AUTH=neo4j/testtest
 

RUN mkdir -p /data /import
 

COPY node.csv /import/node.csv

COPY relation.csv /import/relation.csv


 
RUN neo4j-admin database import full neo4j \

    --nodes=/import/node.csv \

    --relationships=/import/relation.csv
 

FROM neo4j:5.25.1
 

ENV NEO4J_AUTH=neo4j/testtest
 

COPY --from=neo4j-import /data /data







EXPOSE 7474 7687

CMD ["neo4j"]

 