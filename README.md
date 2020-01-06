# Create Lambda function 

```
make create

```
# create a rule

* Use the following put-rule command to create a rule that triggers itself on a schedule:

```
aws events put-rule \
    --region ap-south-1 \
    --name my-scheduled-rule \
    --schedule-expression 'rate(1 minute)'

```
* When this rule triggers, it generates an event that serves as input to the targets of this rule. 

```

{
    "RuleArn": "arn:aws:events:ap-south-1:number:rule/my-scheduled-rule"
}

```

* Use the following add-permission command to trust the CloudWatch Events service principal (events.amazonaws.com) and scope permissions to the rule with the specified Amazon Resource Name (ARN):

```
aws lambda add-permission \
    --region ap-south-1 \
    --function-name cron_function \
    --statement-id my-scheduled-event \
    --action 'lambda:InvokeFunction' \
    --principal events.amazonaws.com \
    --source-arn arn:aws:events:ap-south-1:number:rule/my-scheduled-rule

```

* Use the following put-targets command to add the Lambda function that you created to this rule so that it runs every five minutes:

```
aws events put-targets --rule my-scheduled-rule --targets file://targets.json

```
* Create the file targets.json with the following contents:

```
[
  {
    "Id": "1", 
    "Arn": "arn:aws:lambda:ap-south-1:number:function:cron_function"
  }
]
```