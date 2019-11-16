#!/bin/bash

set -ex

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

#pip3 install awscli --upgrade --user
#aws --version
source awsume ep-playground
echo "ec2 Keypair jha-key anlegen"

export ENVOY_IMAGE_ACCOUNT_ID=840364872350 #
export AWS_ACCOUNT_ID=998978876161 # assumed-role/PlaygroundAdminRole/jens.hanack
export ENVIRONMENT_NAME=JhaAppMeshSample
export MESH_NAME=jha_mesh
export KEY_PAIR_NAME=jha-key
export ENVOY_IMAGE=${ENVOY_IMAGE_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/aws-appmesh-envoy:v1.12.1.0-prod
# Cluster size nicht zu klein dimensionieren, sonst kann man nicht genug ENIs an die EC2 Instanzen hängen
export CLUSTER_SIZE=5
export SERVICES_DOMAIN="jha.ecs.cluster.local"
export COLOR_GATEWAY_IMAGE=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/color/gateway:latest
export COLOR_TELLER_IMAGE=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com/color/teller:latest


echo "VPC setup ./vpc.sh"
echo "   Name: ${ENVIRONMENT_NAME}:VPC  Value: !Ref VPC"
echo "   Name: ${ENVIRONMENT_NAME}:PublicSubnet1  Value: !Ref PublicSubnet1"
echo "   Name: ${ENVIRONMENT_NAME}:PublicSubnet1  Value: !Ref PublicSubnet1"
echo "   Name: ${ENVIRONMENT_NAME}:PublicSubnet2  Value: !Ref PublicSubnet2"
echo "   Name: ${ENVIRONMENT_NAME}:PrivateSubnet1  Value: !Ref PrivateSubnet1"
echo "   Name: ${ENVIRONMENT_NAME}:PrivateSubnet2  Value: !Ref PrivateSubnet2"
echo "   Name: ${ENVIRONMENT_NAME}:VpcCIDR  Value: !Ref VpcCIDR"
#./vpc.sh
#./appmesh-mesh.sh
#./ecs-cluster.sh

echo "Manuelles anlegen der Repos color/teller und color/gateway"

echo "Push der docker images ins Repo"
#${DIR}/../apps/colorapp/src/colorteller/deploy.sh
#${DIR}/../apps/colorapp/src/gateway/deploy.sh

#$(aws ecr get-login --no-include-email --region eu-central-1 --registry-ids 111345817488)

#${DIR}/../apps/colorapp/servicemesh/appmesh-colorapp.sh
#${DIR}/../apps/colorapp/ecs/ecs-colorapp.sh

export colorapp=$(aws cloudformation describe-stacks --stack-name=$ENVIRONMENT_NAME-ecs-colorapp --query="Stacks[0].Outputs[?OutputKey=='ColorAppEndpoint'].OutputValue" --output=text); echo $colorapp
curl $colorapp/color

#ecs-cli local up --task-def-file task-definition.json
#ecs-cli local up --task-def-compose docker-compose.ecs-local.yml
#ecs-cli local ps --task-def-file task-definition.json
#ecs-cli logs
