module "qa" {
    source = "../modules/blog"

    instance_type = "t3.micro"

    environment = {
        name = "qa"
        network_prefix = "172.24"
    }

    asg_min_size = 1
    asg_max_size = 1
}
