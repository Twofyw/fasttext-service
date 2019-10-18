FROM frolvlad/alpine-gxx
RUN apk add --no-cache --update make

# install websocketd
WORKDIR /workdir
RUN wget -q -O websocketd.zip \
    https://github.com/joewalnes/websocketd/releases/download/v0.3.0/websocketd-0.3.0-linux_386.zip \
    && mkdir websocketd \
    && unzip websocketd.zip -d websocketd \
    && rm websocketd.zip \
    && mv websocketd/websocketd /usr/bin \
    && rm -rf websocketd

# install fasttext
RUN wget -q -O fastText.zip https://github.com/facebookresearch/fastText/archive/v0.9.1.zip \
    && unzip fastText.zip \
    && rm fastText.zip \
    && cd fastText-0.9.1 \
    && make -j12 \
    && mv fasttext /usr/bin/ \
    && cd .. \
    && rm -rf fastText-0.9.1

EXPOSE 8080
VOLUME /data
# Requires weights in data
CMD websocketd --port=8080 fasttext print-word-vectors /data/cc.zh.300.bin
