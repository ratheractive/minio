# minio

MinIO server and client (`mc`) on Alpine, built weekly from Alpine's packages. Made for the
ratheractive platform, whose backups live in MinIO; generic enough for anyone who needs a
pullable MinIO image now that MinIO no longer publishes community ones (`quay.io/minio/*` and
`docker.io/minio/*` answer 401).

```
docker run -d -p 9000:9000 -p 9001:9001 -v minio:/data \
  -e MINIO_ROOT_USER=admin -e MINIO_ROOT_PASSWORD=change-me-please \
  ghcr.io/ratheractive/minio:latest
```

## What you get

- `minio` - Alpine's `minio` package: the upstream release, compiled from source with Alpine's
  current Go
- `mc` - Alpine's `minio-client`, installed there as `mcli`; `mc` is a symlink to it
- the default command is `server /data --console-address :9001`; any `minio` arguments replace it
- no user is set: run it as whatever owns the data (`securityContext.runAsUser` in Kubernetes)

## Tags

| Tag | Moves? | |
| --- | --- | --- |
| `RELEASE.<upstream>-<yyyymmdd>` | never | one build; pin this |
| `RELEASE.<upstream>` | weekly | the newest build of that release |
| `latest` | weekly | the newest build |

The weekly rebuild picks up Alpine's security fixes for MinIO and for the Go runtime it is
compiled with. Every build is smoke-tested before it is published: the server must answer its
health check and `mc` must create and list a bucket.

## Licence

The files in this repository are MIT. The image contains MinIO and the MinIO Client, which are
GNU AGPL v3; their source is at github.com/minio/minio and github.com/minio/mc, and Alpine's
build of them at gitlab.alpinelinux.org/alpine/aports (`community/minio`, `community/minio-client`).
