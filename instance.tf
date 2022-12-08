# # For EC2 instance
resource "aws_instance" "ec2" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.key-tf.key_name //Optional not necessary
  vpc_security_group_ids = ["${aws_security_group.sg-for-ec2-instance.id}"]
  tags = {
    Name = "ec2-frm-terraform"
  }
  user_data = file("${path.module}/script.sh")

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.module}/id_rsa")
    host        = self.public_ip
  }

  #file, local-exec, remote-exec
  provisioner "file" {
    source      = "readme.md"      // local machine where terraform is running
    destination = "/tmp/readme.md" //remote machine where the terraform script will execute
  }

  provisioner "file" {
    content     = "This is the content of file for testing" // local machine where terraform is running
    destination = "/tmp/content.md"                         //remote machine where the terraform script will execute
  }

  provisioner "file" {
    source      = "maker" // local machine where terraform is running
    destination = "/tmp/" //remote machine where the terraform script will execute
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public.txt " //to be checked.
  }

  provisioner "local-exec" {
    //working_dir = "/tmp/"
    command = "echo ${self.public_ip} >> env_vars.txt" //to be checked not working
  }

  provisioner "local-exec" {
    on_failure = continue //to bypass the error occur
    command    = "env>env.txt"
    environment = {
      envname = "envvalue"
    }
  }

  provisioner "local-exec" {
    command = "echo 'Invoked, at Created' "
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Invoked, when destroyed' "
  }

  provisioner "remote-exec" {
    inline = [
      "ifconfig >> /tmp/config.text", // ipconfig is not getting copied
      "echo 'hello waseem' > /tmp/test.text"
    ]
  }

  provisioner "remote-exec" {
    script = "./test.sh"
  }
}
