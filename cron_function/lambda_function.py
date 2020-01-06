

def lambda_handler(event=None, context=None):

    print("cronjob done")
    
    return {"message" : "Script execution completed. See Cloudwatch logs for complete output"}


if __name__ == "__main__":
    lambda_handler()