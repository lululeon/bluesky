from diagrams import Cluster, Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB
from diagrams.aws.network import InternetGateway, NATGateway
from diagrams.aws.network import PublicSubnet, PrivateSubnet

with Diagram("Bluesky VPC", show=False, direction="TB" ):
    igw = InternetGateway("IGW")
    with Cluster("VPC", direction="TB"):
       
        with Cluster("Public A", direction="LR"):
            bastion = EC2("Bastion Host")
            natgwA = NATGateway("NAT GW")
            pub_a = [
                bastion,
                natgwA
            ]

        with Cluster("Public B", direction="LR"):
            natgwB = NATGateway("NAT GW")
            pub_b = [ natgwB ]

        with Cluster("Private A", direction="LR"):
            ubuntu = EC2("Ubuntu Server")

        with Cluster("Private B", direction="LR"):
            priv_b = PrivateSubnet("Private-B")

    igw >> natgwA
    igw >> natgwB
    bastion >> ubuntu
    pub_b >> priv_b