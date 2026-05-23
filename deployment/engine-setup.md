# Engine Setup

## VM Purpose

This VM hosts the iii-engine responsible for coordinating RPC communication between distributed workers.

---

# Installation

## Install iii CLI

```bash
curl -fsSL https://iii.dev/install.sh | bash
```

## Verify installation

```bash
iii --version
```

---

# Start Engine

```bash
iii dev
```

Engine runs on:

```text
ws://0.0.0.0:49134
```

---

# Validation

List connected workers:

```bash
iii trigger engine::workers::list
```

List registered functions:

```bash
iii trigger engine::functions::list
```

---

# Notes

The engine successfully coordinated communication between:
- Python worker
- TypeScript worker
- HTTP gateway layer
