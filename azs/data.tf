data "aws_availability_zones" "az_info" {}


locals {
  instance_tenancy = "default"
  az_count = 2
  all_az = data.aws_availability_zones.az_info.names
  az = slice(local.all_az, 0, local.az_count)
  az_lables = [element(split("-", local.az[0]), length(split("-",local.az[0]))-1),
               element(split("-", local.az[1]), length(split("-",local.az[1]))-1)
  ]        
  
}

output "az" {
    value = local.az
}

output "az_lables" {
    value = local.az_lables
  
}



# output "az_info" {
#     value = data.aws_availability_zones.az_info
# }

# output "az_names" {
#     value = data.aws_availability_zones.az_info.names
  
# }

