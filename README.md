# DevOps Internship Assignment

## Overview

This project demonstrates deployment of a distributed worker architecture using AWS infrastructure.

The system was designed using:
- AWS VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Multiple EC2 Instances
- Python Worker
- TypeScript Worker
- Engine VM
- API Gateway VM

The goal was to deploy workers across separate VMs and enable communication through RPC inside a private subnet.

---

# Architecture

## Components

| Component | Purpose |
|---|---|
| API Gateway VM | Public-facing HTTP endpoint |
| Engine VM | Central orchestration and RPC coordination |
| Python Worker VM | Model inference worker |
| TypeScript Worker VM | HTTP/RPC caller worker |

---

# Network Design

- API Gateway deployed in Public Subnet
- Workers deployed in Private Subnet
- Communication between workers performed using private IP addresses
- Internet access for private instances provided through NAT Gateway

---

# Architecture Diagram

<img width="726" height="320" alt="image" src="https://github.com/user-attachments/assets/b952cee8-95b6-440b-b6c9-6ef1e2f1cd65" />





                        Public Internet
                               |
                         curl / HTTP
                               |
                     +----------------+
                     |   API Gateway  |
                     |   iii-http     |
                     | Port: 3111     |
                     +----------------+
                               |
                               | RPC / WS
                               |
        -------------------------------------------------
        |               Private Subnet                  |
        |                                               |
        |   +------------------------+                  |
        |   | iii-engine :49134      |                  |
        |   +------------------------+                  |
        |        |               |                      |
        |        | RPC           | RPC                  |
        |        v               v                      |
        |  +-------------+   +----------------+         |
        |  | math-worker |   | caller-worker  |         |
        |  | Python      |   | TypeScript     |         |
        |  +-------------+   +----------------+         |
        |                                               |
        |               +------------+                  |
        |               | iii-state  |                  |
        |               +------------+                  |
        -------------------------------------------------


## Architecture Overview

- `iii-engine` acts as the RPC coordination layer between workers.
- `caller-worker` is a TypeScript worker that receives requests and dispatches inference tasks.
- `math-worker` is a Python worker that performs computation/inference.
- `iii-http` exposes a public HTTP API endpoint for external access.
- Internal worker communication happens over RPC inside the private subnet.
- Only the HTTP API endpoint is intended to be publicly reachable.
---

# Worker Communication Flow

1. Client sends HTTP request to API Gateway
2. API Gateway forwards request to Engine VM
3. Engine dispatches RPC call to worker mesh
4. Python worker performs inference
5. Result returned through Engine back to API Gateway

---

# Infrastructure Setup

## Resources Created

- VPC
- Public Subnet
- Private Subnet
- Route Tables
- Internet Gateway
- NAT Gateway
- EC2 Instances

---

# EC2 Layout

| VM | Role |
|---|---|
| Engine VM | Runs iii engine |
| Python Worker VM | Runs inference worker |
| TypeScript Worker VM | Runs caller worker |
| API Gateway VM | Planned public entrypoint |

---

# Commands Used

## Start Engine

```bash
iii --config config.yaml
```

## Start Python Worker

```bash
export III_URL=ws://<ENGINE_PRIVATE_IP>:49134

python inference_worker.py
```

## Start TypeScript Worker

```bash
export III_URL=ws://<ENGINE_PRIVATE_IP>:49134

npm run dev
```

---

# Validation

Verified worker registration using:

```bash
iii trigger engine::workers::list
```

Successfully observed:
- Python worker connected
- TypeScript worker connected
- RPC functions registered in engine

---

# Issues Faced and Debugging

## Issue 1 — localhost connection problem

Problem:
TypeScript worker attempted connection to:

```bash
ws://localhost:49134
```

Fix:
Updated environment variable:

```bash
export III_URL=ws://<ENGINE_PRIVATE_IP>:49134
```

---

## Issue 2 — npm package.json not found

Problem:

```bash
npm ERR! package.json not found
```

Cause:
Command executed from `/root` directory.

Fix:
Changed into correct project directory before running npm commands.

---

## Issue 3 — Duplicate worker connections

Problem:
Multiple Node workers connected simultaneously.

Fix:
Stopped duplicate Node processes using:

```bash
pkill node
```

---

# Production Improvements

If deploying to production, I would additionally implement:

- Load balancer
- HTTPS/TLS
- IAM role hardening
- Auto-scaling groups
- Monitoring and alerting
- CI/CD pipeline
- Containerization using Docker
- Kubernetes orchestration
- Secret management using AWS Secrets Manager

---

# If Model Size Was 100x Larger

For larger models:
- GPU instances would be required
- Model sharding would be necessary
- Distributed inference architecture would be needed
- Kubernetes would manage scaling
- Dedicated model serving systems like vLLM or Triton Inference Server would be used

---
# Terraform Usage

## Initialize Terraform

```bash
terraform init
```

## Validate configuration

```bash
terraform validate
```

## Preview infrastructure

```bash
terraform plan
```

## Apply infrastructure

```bash
terraform apply
```

---

# Current Status

The distributed worker architecture, RPC communication, and multi-VM deployment flow were successfully tested across separate machines.

The repository includes:
- Infrastructure planning and Terraform structure
- Worker deployment documentation
- Network architecture design
- Engine and API gateway setup flow
- Debugging notes and troubleshooting steps

Due to time and cloud budget constraints, the complete production-grade deployment lifecycle was not finalized end-to-end. However, the core distributed architecture and worker communication flow were successfully validated and documented.
