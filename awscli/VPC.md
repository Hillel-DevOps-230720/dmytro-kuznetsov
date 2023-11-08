# Створення VPC

```
aws ec2 create-vpc --cidr-block 10.0.0.0/16
```
```
{
    "Vpc": {
        "CidrBlock": "10.0.0.0/16",
        "DhcpOptionsId": "dopt-00ef86b0588421610",
        "State": "pending",
        "VpcId": "vpc-07f338eb632e16de1",
        "OwnerId": "654683599527",
        "InstanceTenancy": "default",
        "Ipv6CidrBlockAssociationSet": [],
        "CidrBlockAssociationSet": [
            {
                "AssociationId": "vpc-cidr-assoc-05cc177557718c481",
                "CidrBlock": "10.0.0.0/16",
                "CidrBlockState": {
                    "State": "associated"
                }
            }
        ],
        "IsDefault": false
    }
}
```

# Збереження ідентифікатора VPC в змінну щоб далі підставити
```
VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text)
```
оутпут пустий(без помилок)

# Створення Internet Gateway
```
IGW_ID=$(aws ec2 create-internet-gateway --output text --query 'InternetGateway.InternetGatewayId')
```
оутпут пустий(без помилок)

# Прикріплення Internet Gateway до VPC
```
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID
```
оутпут пустий(без помилок), там вже якийсь був , але я ще один створив

# Створення route table
```
ROUTE_TABLE_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --output text --query 'RouteTable.RouteTableId')
```
оутпут пустий(без помилок)

# Додавання route для Internet Gateway до route table
```
aws ec2 create-route --route-table-id $ROUTE_TABLE_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
```

```
{
    "Return": true
}
```

# Створення публічного subnet #1
```
SUBNET_ID_1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --availability-zone eu-north-1a --output text --query 'Subnet.SubnetId')
```
```
аутпут пустий(все ок)
```

# Створення публічного subnet #2
```
SUBNET_ID_2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.2.0/24 --availability-zone eu-north-1b --output text --query 'Subnet.SubnetId')
```
```
аутпут пустий(все ок)
```

# Створення Security Group sg_A
```
SG_A_ID=$(aws ec2 create-security-group --group-name sg_A --description "Security Group A" --vpc-id $VPC_ID --output text --query 'GroupId')
```
```
без аутпуту
```

# Створення Security Group sg_B

```
SG_B_ID=$(aws ec2 create-security-group --group-name sg_B --description "Security Group B" --vpc-id $VPC_ID --output text --query 'GroupId')
```
```
без аутпуту
```

# Налаштування правил для sg_A
aws ec2 authorize-security-group-ingress --group-id $SG_A_ID --protocol tcp --port 22 --source-group $SG_B_ID
```{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0d48d1b549cea6a0c",
            "GroupId": "sg-0121a4ee4c9a4d95b",
            "GroupOwnerId": "654683599527",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 22,
            "ToPort": 22,
            "ReferencedGroupInfo": {
                "GroupId": "sg-0499b21d21c2cd777",
                "UserId": "654683599527"
            }
        }
    ]
}
```

aws ec2 authorize-security-group-ingress --group-id $SG_A_ID --protocol tcp --port 80 --source-security-group-id $SG_B_ID
```
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0cc3d6443ddd94459",
            "GroupId": "sg-0121a4ee4c9a4d95b",
            "GroupOwnerId": "654683599527",
            "IsEgress": false,
            "IpProtocol": "tcp",
            "FromPort": 80,
            "ToPort": 80,
            "ReferencedGroupInfo": {
                "GroupId": "sg-0499b21d21c2cd777",
                "UserId": "654683599527"
            }
        }
    ]
}
```


# Налаштування правил для sg_B

```
aws ec2 authorize-security-group-ingress --group-id $SG_B_ID --protocol -1 --source-group $SG_A_ID
```
```
{
    "Return": true,
    "SecurityGroupRules": [
        {
            "SecurityGroupRuleId": "sgr-0f58d36580ec58076",
            "GroupId": "sg-0499b21d21c2cd777",
            "GroupOwnerId": "654683599527",
            "IsEgress": false,
            "IpProtocol": "-1",
            "FromPort": -1,
            "ToPort": -1,
            "ReferencedGroupInfo": {
                "GroupId": "sg-0121a4ee4c9a4d95b",
                "UserId": "654683599527"
            }
        }
    ]
}
```

# створення инстанс
```
INSTANCE_ID_1=$(aws ec2 run-instances --image-id ami-03a2c69daedb78c95 --instance-type t3.micro --subnet-id $SUBNET_ID_1 --key-name forLesson --security-group-ids $SG_A_ID --output text --query 'Instances[0].InstanceId')
INSTANCE_ID_2=$(aws ec2 run-instances --image-id ami-03a2c69daedb78c95 --instance-type t3.micro --subnet-id $SUBNET_ID_2 --key-name forLesson --security-group-ids $SG_B_ID --output text --query 'Instances[0].InstanceId')
```

аутпутов не було
запуск робив вже на т3
т2 нема )
