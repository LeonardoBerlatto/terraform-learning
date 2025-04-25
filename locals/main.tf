resource "local_file" "lorem-ipsum" {
  content  = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
  filename = "${path.module}/lorem-ipsum.txt"
}