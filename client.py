import grpc, os, random

import calculator_pb2
import calculator_pb2_grpc

from flask import Flask

_OPERATIONS = {
    "add": calculator_pb2.ADD,
    "subtract": calculator_pb2.SUBTRACT,
}

server_address = "<Server GCR URL>:443"

def run(first_operand=1, second_operand=2, operation=_OPERATIONS['add']):

    # Uncomment for insecure http only servers
    # server_address = "localhost:8999"
    # channel = grpc.insecure_channel(server_address)

    channel = grpc.secure_channel(server_address, grpc.ssl_channel_credentials())

    try:
        stub = calculator_pb2_grpc.CalculatorStub(channel)
        request = calculator_pb2.BinaryOperation(first_operand=first_operand,
                                                 second_operand=second_operand,
                                                 operation=operation)
        return stub.Calculate(request).result
    finally:
        channel.close()

# Add a Flask Wrapper to run as a WebApp
app = Flask(__name__)

@app.route("/")
def grpc_up():
    first_operand = random.randint(50,100)
    second_operand = random.randint(0,50)
    operation = random.choice([_OPERATIONS['add'], _OPERATIONS['subtract']])

    grpc_run = run(first_operand, second_operand, operation)

    return f"Answer: {grpc_run}"

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
