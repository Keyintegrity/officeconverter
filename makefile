build: stop
	docker pull keyintegrity/jodconverter:base
	docker build --target development . -t keyintegrity/kontextwork-converter:development
	docker build --target production . -t keyintegrity/kontextwork-converter:production

push:
	docker push keyintegrity/kontextwork-converter:development
	docker push keyintegrity/kontextwork-converter:production

start-src: stop
	./start.sh

watch:
	./watch.sh

start: stop
    # 5001 is the remote debugger port, which we enable by default
	docker run -m 512m --name converter-dev --rm -p 5001:5001 -p 8080:8080 keyintegrity/kontextwork-converter:development

start-prod: stop
	docker run -m 512m --name converter-prod --rm -p 8080:8080 keyintegrity/kontextwork-converter:production

test:
	docker run -m 512m --name converter-test --rm -v ${PWD}/.:/src --workdir /src keyintegrity/kontextwork-converter:development ./gradlew test

stop:
	docker stop --name converter-prod > /dev/null 2>&1 || true
	docker stop --name converter-dev > /dev/null 2>&1 || true

build-local:
	SPRING_PROFILES_ACTIVE=dev ./gradlew build

start-local:
	SPRING_PROFILES_ACTIVE=dev ./gradlew bootRun

test-local:
	./gradlew test
