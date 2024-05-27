# Archive a single file.
data "archive_file" "init" {
  type        = "zip"
  source_dir  = "${path.module}/python-synthetics/canary1/"
  output_path = "${path.module}/python-synthetics/canary1.zip"
}
