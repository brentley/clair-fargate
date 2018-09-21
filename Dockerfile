FROM golang:alpine as build

RUN apk --no-cache add ca-certificates git

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

RUN go get github.com/coreos/clair/cmd/clair

FROM alpine:latest

RUN apk --no-cache add git xz rpm ca-certificates

COPY config.yaml /config/config.yaml
COPY --from=build /go/bin/clair /usr/bin/clair

ENTRYPOINT []
CMD sed -i "s/localhost/$DB_HOST/" /config/config.yaml && sed -i "s/db_password/$DB_PASSWORD/" /config/config.yaml && exec /usr/bin/clair -config=/config/config.yaml
