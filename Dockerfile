FROM alpine:3.9.6

RUN apk add --no-cache --virtual .build-deps \
	samba-common-tools \
	bind-tools \
	bash

COPY adpasswdrotate.sh /
RUN chmod 755 /adpasswdrotate.sh

ENTRYPOINT [ "/adpasswdrotate.sh" ]


