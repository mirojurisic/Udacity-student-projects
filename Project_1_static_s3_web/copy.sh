bucket="udacity-webhosting-bucket-miro"

aws s3api put-object --bucket ${bucket} --key index.html --body index.html 
# Copy over folders from local to S3 
aws s3 cp vendor/ s3://${bucket}/vendor/ --recursive 
aws s3 cp css/ s3://${bucket}/css/ --recursive 
aws s3 cp img/ s3://${bucket}/img/ --recursive 