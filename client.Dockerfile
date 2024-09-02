FROM python:3.12

WORKDIR /srv/grpc

COPY client.py *.proto requirements.txt ./

RUN pip install -r requirements.txt && \
    python -m grpc_tools.protoc \
    -I. \
    --python_out=. \
    --grpc_python_out=. \
    calculator.proto

CMD ["python", "client.py"]