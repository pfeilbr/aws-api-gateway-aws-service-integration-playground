REGION = us-east-1
STACK_NAME = aws-api-gateway-aws-service-integration-playground

.PHONY: deploy
deploy:
	sam deploy

.PHONY: test
test:
	$(eval API_ENDPOINT := $(shell aws cloudformation describe-stacks --region "$(REGION)" --stack-name "$(STACK_NAME)" --query "Stacks[0].Outputs[?OutputKey=='ApiEndpoint'].OutputValue" --output text))
	curl -X POST -H "Content-Type: application/json" -d @event-bus-events.json  "$(API_ENDPOINT)"

.PHONY: teardown
teardown:
	aws cloudformation delete-stack --region "$(REGION)" --stack-name "$(STACK_NAME)"
	aws cloudformation wait stack-delete-complete --region "$(REGION)" --stack-name "$(STACK_NAME)"
