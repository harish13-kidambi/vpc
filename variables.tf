variable "Project_name" {
    type = string
    default = "Time"
    description = "this is the project name"

  
}

variable "tags" {
    type = map(string)
    default = {
      Name = "Time"
      Terraform = true
      Environment = "Dev"
    }
  
}