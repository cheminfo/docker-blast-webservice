FROM node:10.4.1-alpine

RUN mkdir /blast

ENV BLAST_VERSION 2.7.1

RUN wget -qO- "ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/${BLAST_VERSION}/ncbi-blast-${BLAST_VERSION}+-x64-linux.tar.gz" | tar xvz -C /blast

ENV VERSION 6350c66d7a353e0b67d0fc0dbf66a04305e9caab

RUN vVERSION=$(echo $VERSION | sed -E s/^[0-9]\\.+\[0-9]+\\.[0-9]+/v\\0/g) && \
    apk add --no-cache curl && \
    echo https://github.com/cheminfo/blast-webservice/archive/$vVERSION.tar.gz && \
    curl -fSL https://github.com/cheminfo/blast-webservice/archive/$vVERSION.tar.gz -o $VERSION.tar.gz && \
    tar -xzf $VERSION.tar.gz && \
    mv blast-webservice-${VERSION} blast-webservice-source && \
    npm i -g pm2 && \
    cd /blast-webservice-source && \
    npm i && \
    rm -rf /root/.npm /usr/local/share/.cache /root/.cache /${VERSION}.tar.gz


ENV BLAST_DIRECTORY /blast/ncbi-blast-${BLAST_VERSION}+/bin
WORKDIR /blast-webservice-source
CMD ["node", "src/server.js"]