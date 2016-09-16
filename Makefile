DEST=akb.io:/var/www/deftly/
SIGKEY=~/signify/primary.sec
PUBKEY=~/signify/primary.pub
SHA256=resume-SHA256
SIG=resume-SHA256.sig

all: lint pdf html

lint:
	mandoc -T lint resume.7

pdf:
	mandoc -T pdf resume.7 > resume.pdf

html:
	mandoc -T html resume.7 > resume.html

sign:
	@sha256 resume.* > ${SHA256}
	@signify -S -s ${SIGKEY} -m ${SHA256} -x ${SIG}
	@cat ${SHA256} >> ${SIG}

verify:
	@signify -C -p ${PUBKEY} -x ${SIG} resume.*

publish: html sign
	scp resume* ${DEST}

