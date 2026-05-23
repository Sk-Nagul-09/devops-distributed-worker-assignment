# TypeScript Worker Setup

## VM Purpose

This VM hosts the TypeScript caller-worker responsible for dispatching inference requests.

---

# Setup Steps

## Install Node.js

```bash
sudo apt update
sudo apt install nodejs npm -y
```

## Clone repository

```bash
git clone <repo-url>
cd quickstart/workers/caller-worker
```

## Install dependencies

```bash
npm install
```

## Configure engine connection

```bash
export III_URL=ws://<ENGINE_PRIVATE_IP>:49134
```

## Start worker

```bash
npm run dev
```

---

# Validation

Worker registration validated using:

```bash
iii trigger engine::workers::list
```

---

# Notes

The TypeScript worker successfully connected to the engine after configuring the correct III_URL value pointing to the engine VM private IP.
