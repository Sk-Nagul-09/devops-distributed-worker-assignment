# Python Worker Setup

## VM Purpose

This VM hosts the Python inference worker.

---

# Setup Steps

## Install dependencies

```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv -y
```

## Clone repository

```bash
git clone <repo-url>
cd quickstart
```

## Create virtual environment

```bash
python3 -m venv venv
source venv/bin/activate
```

## Install requirements

```bash
pip install -r requirements.txt
```

## Configure engine connection

```bash
export III_URL=ws://<ENGINE_PRIVATE_IP>:49134
```

## Start worker

```bash
python3 inference_worker.py
```

---

# Validation

Worker registration validated using:

```bash
iii trigger engine::workers::list
```

---

# Notes

The Python worker successfully connected to the iii-engine and exposed inference-related RPC functions.
