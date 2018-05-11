FROM croservices/cro-http:0.7.5
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN apt-get update
RUN apt-get install -y make gcc
RUN zef install LibraryMake
RUN zef install --deps-only --/test . && perl6 -c -Ilib service.p6
ENV MYJUDO_HOST="0.0.0.0" MYJUDO_PORT="10000"
EXPOSE 10000
CMD perl6 -Ilib service.p6
