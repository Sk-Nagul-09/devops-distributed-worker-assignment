# API Gateway Setup

## Purpose

The API gateway exposes inference functionality over HTTP.

It acts as the public-facing entry point to the internal worker mesh.

---

# Planned Flow

```text
Client -> HTTP API -> iii-http -> iii-engine -> workers
```

---

# Setup Steps

## Configure environment

```bash
export III_URL=ws://<ENGINE_PRIVATE_IP>:49134
```

## Start HTTP layer

```bash
iii http
```

---

# Example API Request

```bash
curl -X POST http://<PUBLIC_IP>:3111/inference \
-H "Content-Type: application/json" \
-d '{"prompt":"hello"}'
```

---

# Expected Response

```json
{
  "response": "Hello from inference worker"
}
```

---

# Notes

The HTTP gateway integration was partially tested during implementation. Internal RPC communication between workers and engine was successfully validated.
