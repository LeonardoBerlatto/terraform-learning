resource "aws_s3_bucket" "image_bucket" {
  bucket = "temp-image-bucket-leonardo-berlatto"

  tags = {
    Name = "Image Bucket"
  }
}
