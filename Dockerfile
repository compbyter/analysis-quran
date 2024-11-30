
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

COPY neo4j.conf /var/lib/neo4j/conf/neo4j.conf

RUN mkdir -p /var/lib/neo4j/certificates/https
RUN mkdir -p /var/lib/neo4j/certificates/https/trusted
RUN mkdir -p /var/lib/neo4j/certificates/https/revoked

COPY server-logs.xml /var/lib/neo4j/conf/server-logs.xml
COPY user-logs.xml /var/lib/neo4j/conf/server-logs.xml

COPY private.key /var/lib/neo4j/certificates/https/private.key
COPY public.crt /var/lib/neo4j/certificates/https/public.crt
COPY public.crt /var/lib/neo4j/certificates/https/trusted/public.crt



EXPOSE 7474 7687 7473

CMD ["neo4j"]

 
