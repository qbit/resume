DEST=hosting.bolddaemon.com:/var/www/deftly/
SIGKEY=~/signify/primary.sec
PUBKEY=~/signify/primary.pub
SHA256=resume-SHA256
SIG=resume-SHA256.sig
ASC=resume-SHA256.asc

all: lint pdf html

lint:
	mandoc -T lint resume.7

pdf:
	mandoc -T pdf resume.7 > resume.pdf

html:
	mandoc -T html -O style=resume.css resume.7 > resume.html

sign:
	@sha256 resume.* > ${SHA256}
	@signify -S -s ${SIGKEY} -m ${SHA256} -x ${SIG}
	gpg2 --armor -o ${ASC} --detach-sig ${SHA256}
	@cat ${SHA256} >> ${SIG}

verify:
	@signify -C -p ${PUBKEY} -x ${SIG} resume.*

publish: lint pdf html sign
	scp resume* ${DEST}

