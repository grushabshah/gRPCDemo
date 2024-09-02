# Private
source .env
VPC_NETWORK=$VPC_NETWORK
VPC_NETWORK_SUBNET=$VPC_NETWORK_SUBNET
GCP_PROJECT=$GCP_PROJECT

# Common
GCP_REGION=asia-south1

# gRPC Server
gRPC_SERVER_NAME=grpc-server
gRPC_SERVER_IMAGE=grpc-server
gRPC_SERVER_VERSION=latest
gRPC_SERVER_IMAGE_URL="asia.gcr.io/$GCP_PROJECT/$gRPC_SERVER_IMAGE:$gRPC_SERVER_VERSION"

# Build & Push
docker build -t $gRPC_SERVER_IMAGE_URL -f server.Dockerfile --platform=linux/amd64 .
docker push $gRPC_SERVER_IMAGE_URL

# Deploy
gcloud run deploy "$gRPC_SERVER_NAME" \
    --image="$gRPC_SERVER_IMAGE_URL" \
    --region="$GCP_REGION" \
    --network="$VPC_NETWORK" \
    --subnet="$VPC_NETWORK_SUBNET" \
    --vpc-egress="all-traffic" \
    --ingress="internal" \
    --allow-unauthenticated \
    --use-http2

sleep 5
ENDPOINT="$(gcloud run services describe --region="$GCP_REGION" --format="value(status.url)" "$gRPC_SERVER_NAME")"
ENDPOINT=${ENDPOINT#https://}

echo "Set the client server_address to $ENDPOINT:443"
