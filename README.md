## Simple gRPC Client - Server Demo in Google Cloud Run (Python)

Credits: https://github.com/grpc-ecosystem/grpc-cloud-run-example/blob/master/python

#### Steps:

1) Replace the environment variables in `deploy_client.sh` and `deploy_server.sh` with values from your project
2) Deploy the server code to GCR first and get the URL
```
sh deploy_server.sh
```
3) Replace the URL for `server_address` in `client.py`. **Remove `https://` from the URL and specify the port `:443`
4) Deploy the client

```
sh deploy_client.sh
```
