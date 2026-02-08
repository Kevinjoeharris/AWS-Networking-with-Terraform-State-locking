#S3 Bucket
resource "aws_s3_bucket" "state-locking" {
    bucket = "kev-state-locking-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.state-locking.id

  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
    }
  }
}

#DyanamoDB
resource "aws_dyanamo_db" "db-state-locking" {

}