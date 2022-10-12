import boto3
s3 = boto3.resource("s3")
bucket = s3.Bucket("mlops-aws-nauman")
for each in bucket.objects.all():
    print(each.key)