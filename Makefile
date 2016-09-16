DEST=akb.io:/var/www/deftly/

all: lint pdf html

lint:
	mandoc -T lint resume.7

pdf:
	mandoc -T pdf resume.7 > resume.pdf

html:
	mandoc -T html resume.7 > resume.html

publish: html
	scp resume.html ${DEST}
