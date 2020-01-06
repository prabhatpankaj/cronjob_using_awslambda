PROJECT = cron_function
FUNCTION = $(PROJECT)

REGION = ap-south-1
ROLE = arn:aws:iam::number:role/lambdafullaccess
.phony: clean

clean:
	cd $(FUNCTION); rm -f -r site-packages;\
	rm -f -r $(FUNCTION)-env;\
	rm -f -r $(FUNCTION).zip;\
	sleep 2

build-cron_function: clean
	cd $(FUNCTION);\
	zip -r $(FUNCTION).zip . -x "*.git*" "tests/*";\
	virtualenv $(FUNCTION)-env -p python3;\
	. $(FUNCTION)-env/bin/activate; pip install -r requirements.txt;\
	cp -r $$VIRTUAL_ENV/lib/python3.7/site-packages/ ./site-packages
	cd $(FUNCTION)/site-packages; zip -g -r ../$(FUNCTION).zip .

create-cron_function: build-cron_function
	aws lambda create-function \
		--handler lambda_function.lambda_handler \
		--function-name $(FUNCTION) \
		--region $(REGION) \
		--zip-file fileb://$(FUNCTION)/$(FUNCTION).zip \
		--role $(ROLE) \
		--runtime python3.7 \
		--timeout 120 \
		--memory-size 512 \

update-cron_function: build-cron_function
	aws lambda update-function-code \
		--function-name $(FUNCTION) \
		--region $(REGION) \
		--zip-file fileb://$(FUNCTION)/$(FUNCTION).zip \
		--publish \

delete-cron_function:
	aws lambda delete-function --function-name $(FUNCTION)

build: build-cron_function
create : create-cron_function
update : update-cron_function
clean: clean
delete: delete-cron_function