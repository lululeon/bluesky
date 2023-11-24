from diagrams import Cluster, Diagram
from diagrams.aws.compute import EC2
from diagrams.aws.network import InternetGateway, NATGateway, RouteTable

with Diagram("AWS region us-east-1", show=False, direction="TB" ):

    with Cluster("Bluesky VPC - 10.1.0.0/16", direction="TB" ):
        igw = InternetGateway("IGW")

        with Cluster("us-east-1a", direction="TB"):
        
            with Cluster("Public A", direction="LR"):
                rtpubA = RouteTable("Route Table")
                natgwA = NATGateway("NAT GW")
                bastion = EC2("Bastion Host")
                webserver = EC2("Web or API server")

            with Cluster("Private A", direction="LR"):
                ubuntu = EC2("Ubuntu Server")
                rtprivA = RouteTable("Route Table")

        igw >> rtpubA

        with Cluster("us-east-1b", direction="TB"):

            with Cluster("Public B", direction="LR"):
                rtpubB = RouteTable("Route Table")
                natgwB = NATGateway("NAT GW")


            with Cluster("Private B", direction="LR"):
                rtprivB = RouteTable("Route Table")


        igw >> rtpubB

        bastion >> ubuntu
        natgwA >> rtprivA
        natgwB >> rtprivB
