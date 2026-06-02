# Reliability Checklist — FIT4110 Lab 03

Điền checklist này trước khi nộp Lab 03.

Service: **team-gate — Access Gate**
Contract: `contracts/access-gate.openapi.yaml` (provider) + `contracts/core-business.openapi.yaml` (mock service phụ thuộc cho consumer-side smoke)
Collection: `postman/collections/FIT4110_lab03_access_gate.postman_collection.json`
Evidence: `reports/newman-report.html`, `reports/newman-report.xml`, `reports/contract-lint-report.txt` (17 requests / 30 assertions, 0 failed; lint 0 errors)

## 1. Functional tests

- [x] Có test cho endpoint health. (00_Health → GET /health → status=ok, service)
- [x] Có test happy path cho endpoint chính. (01_Functional → POST /events GATE_SCAN → 201, có eventId)
- [x] Có kiểm tra status code 2xx. (GET /access/logs/recent → 200, GET /cards/{id} → 200, GET /gates/{id}/status → 200)
- [x] Có kiểm tra field quan trọng trong response. (holderType/status enum, gate mode enum, items[].logId/cardId/status)
- [x] Có ít nhất 1 test đọc dữ liệu danh sách hoặc chi tiết. (GET /access/logs/recent → items là array + paginated shape)

## 2. Auth tests

- [x] Có test thiếu token. (02_Auth → GET /access/logs/recent không token → 401; POST /events không token → 401)
- [x] Có test sai token hoặc token rỗng. (02_Auth → GET /cards/{id} với Bearer invalid-token; skip có kiểm soát trên mock, assert 401/403 trên local)
- [x] Endpoint public được khai báo rõ nếu không cần auth. (GET /health khai báo `security: []`)
- [x] Test thể hiện đúng expected status 401/403. (assert [401,403]; KHÔNG ép `Prefer: code=401` — Prism enforce security thật cho request thiếu token)

## 3. Negative tests

- [x] Có test thiếu field bắt buộc. (03_Negative → POST /events thiếu cardId → 4xx)
- [x] Có test sai kiểu dữ liệu / sai enum / sai định dạng. (03_Negative → GET /gates/BADGATE/status sai pattern gateId → 422)
- [x] Có test resource không tồn tại. (03_Negative → GET /cards/RFID-9999-999 → 404, card không tồn tại)
- [x] Lỗi trả về theo cùng một error model. (Problem: có field title/status; 404 có status=404)

## 4. Boundary tests

- [x] Có test min/max hoặc dữ liệu sát ngưỡng. (04 → limit=100 max hợp lệ → 200; limit=101 vượt max → 422)
- [x] Có test limit/pagination vì endpoint có danh sách. (GET /access/logs/recent dùng query `limit`)
- [x] Có test allow/deny. (04 → GET /access/logs/{logId} → status ∈ {ALLOWED, DENIED}, direction ∈ {IN, OUT})
- [x] Có ghi chú kỳ vọng xử lý dữ liệu biên. (test kiểm tra response của server, không kiểm tra lại request body đã gửi)

## 5. Reliability tests cơ bản

- [x] Có kiểm tra response time. (06_Local_only_NonFunctional → POST /events response time threshold)
- [x] Có mô tả timeout mong muốn. (ngưỡng response time < 1000ms, chỉ assert ở env=local)
- [x] Có test hoặc ghi chú retry/idempotency nếu phù hợp. (latency/SLA chỉ đo trên service thật; mock latency không phải bằng chứng độ tin cậy)
- [x] Có consumer-side smoke test với ít nhất 1 mock của nhóm khác. (05 → Access Gate gọi Core Business mock `POST /policies/evaluate-access`)

## 6. Evidence

- [x] Collection export JSON. (postman/collections/FIT4110_lab03_access_gate.postman_collection.json)
- [x] Environment mock export JSON. (postman/environments/FIT4110_lab03_mock.postman_environment.json)
- [x] Environment local export JSON. (postman/environments/FIT4110_lab03_local.postman_environment.json)
- [x] Newman report XML/HTML. (reports/newman-report.xml, reports/newman-report.html, + reports/contract-lint-report.txt)
- [x] Test-case matrix đã điền. (templates/test-case-matrix.csv)
- [x] Biên bản handshake đã điền. (templates/consumer-provider-handshake.md)
- [x] Không hardcode baseUrl/authToken — tất cả qua environment ({{baseUrl}}, {{authToken}}, {{coreMockUrl}}).
