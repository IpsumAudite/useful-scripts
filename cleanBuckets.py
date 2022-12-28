import boto3
import sys

s3 = boto3.resource('s3')
bucket = s3.Bucket(str(sys.argv[1]))
print("[INFO] Removing all objects and versions from bucket", sys.argv[1])
bucket.object_versions.delete()

# if you want to delete the now-empty bucket as well, uncomment this line:
print("[INFO] Deleting bucket", sys.argv[1])
bucket.delete()
