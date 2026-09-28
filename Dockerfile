# MinIO on Alpine - the object store the ratheractive platform keeps its backups in.
#
# MinIO stopped publishing community images: quay.io/minio/* and docker.io/minio/* answer 401
# since late 2025. A platform whose backups all live in MinIO cannot restore without an image it
# can pull before anything else is back, so this is built from Alpine's packages, which compile
# MinIO and its client from source and track their fixes, and rebuilt weekly by
# .github/workflows/build.yaml so those flow through.
FROM alpine:3.23
# Alpine installs the client as `mcli`, because `mc` is Midnight Commander there. Scripts, habit
# and MinIO's own documentation say `mc`, so both names work.
RUN apk add --no-cache minio minio-client \
 && ln -s mcli /usr/bin/mc
EXPOSE 9000 9001
VOLUME /data
HEALTHCHECK --interval=30s --timeout=5s CMD wget -q -O /dev/null http://127.0.0.1:9000/minio/health/live || exit 1
ENTRYPOINT ["minio"]
CMD ["server", "/data", "--console-address", ":9001"]
