# Issues and Fixes

## 1. Engine timeout issue

Problem:
Workers could not connect to engine.

Cause:
Incorrect III_URL value.

Fix:
Used engine private IP instead of localhost.

---

## 2. Python module issue

Problem:

ModuleNotFoundError: No module named 'iii'

Cause:
Virtual environment not activated.

Fix:
Activated venv before starting worker.

---

## 3. Duplicate TypeScript workers

Problem:
Multiple Node workers connected to engine.

Fix:
Killed duplicate processes using pkill node.
