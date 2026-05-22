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

(Add your screenshot here)

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
iii run
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

# Current Status

The distributed worker architecture and internal RPC communication were successfully tested.

Due to time and cloud cost constraints, the final API gateway integration and complete infrastructure-as-code automation were not fully completed.

However, the networking, worker orchestration, debugging process, and distributed deployment flow were successfully implemented and documented.
