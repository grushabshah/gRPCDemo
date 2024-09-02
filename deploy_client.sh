# Private
source .env
VPC_NETWORK=$VPC_NETWORK
VPC_NETWORK_SUBNET=$VPC_NETWORK_SUBNET
GCP_PROJECT=$GCP_PROJECT

# Common
GCP_REGION=asia-south1

# gRPC Client
gRPC_CLIENT_NAME=grpc-client
gRPC_CLIENT_IMAGE=grpc-client
gRPC_CLIENT_VERSION=latest
gRPC_CLIENT_IMAGE_URL="asia.gcr.io/$GCP_PROJECT/$gRPC_CLIENT_IMAGE:$gRPC_CLIENT_VERSION"

# Build & Push
docker build -t $gRPC_CLIENT_IMAGE_URL -f client.Dockerfile --platform=linux/amd64 .
docker push $gRPC_CLIENT_IMAGE_URL

# Deploy
gcloud run deploy "$gRPC_CLIENT_NAME" \
    --image="$gRPC_CLIENT_IMAGE_URL" \
    --region="$GCP_REGION" \
    --network="$VPC_NETWORK" \
    --subnet="$VPC_NETWORK_SUBNET" \
    --vpc-egress="all-traffic" \
    --allow-unauthenticated

sleep 5
ENDPOINT="$(gcloud run services describe --region="$GCP_REGION" --format="value(status.url)" "$gRPC_CLIENT_NAME")"
ENDPOINT=${ENDPOINT#https://}
