# AWS Network Design

## Overview

The infrastructure was designed using a private network architecture where internal workers communicate over RPC inside a private subnet.

Only the API gateway layer is intended to expose a public endpoint.

---

# Planned AWS Architecture

## VPC
- Custom VPC created for worker communication.

## Public Subnet
Used for:
- API Gateway VM
- Internet Gateway attachment

Purpose:
- Accept external HTTP requests.

## Private Subnet
Used for:
- iii-engine VM
- Python worker VM
- TypeScript worker VM

Purpose:
- Internal RPC communication only.
- No direct public internet exposure.

---

# Components

| Component | Purpose |
|---|---|
| iii-engine | RPC coordination layer |
| math-worker (Python) | Performs inference/computation |
| caller-worker (TypeScript) | Dispatches requests |
| iii-http | Public HTTP API layer |
| iii-state | Shared state management |

---

# Networking Flow

1. Client sends HTTP request using curl.
2. Request reaches iii-http API gateway.
3. iii-http communicates with iii-engine.
4. iii-engine routes RPC calls to workers.
5. Workers process inference tasks.
6. Response flows back to the client.

---

## Security Group Design

Two separate security groups were used in the architecture:

### app-sg
Attached to the public-facing API/Engine VM.

Allowed:
- SSH access (Port 22)
- HTTP API access (Port 3111)

Purpose:
- Allows external access for testing the API endpoint.

---

### private-sg
Attached to internal worker VMs.

Allowed:
- Internal RPC communication on Port 49134
- Internal SSH access from the public subnet

Purpose:
- Keeps worker machines private and inaccessible from the public internet.
- Enables secure communication between workers inside the VPC only.

---

# Planned Ports

| Service | Port |
|---|---|
| iii-engine | 49134 |
| iii-http | 3111 |
| SSH | 22 |

---

# Notes

The infrastructure was partially deployed and validated during testing. Worker-to-worker RPC communication across separate VMs was successfully verified.
