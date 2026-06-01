# Reliability Checklist — FIT4110 Lab 03

Điền checklist này trước khi nộp Lab 03.

Service: **team-iot — IoT Ingestion**
Contract: `contracts/iot-ingestion.openapi.yaml`
Collection: `postman/collections/FIT4110_lab03_iot_ingestion.postman_collection.json`
Evidence: `reports/newman-report.html`, `reports/newman-report.xml`, `reports/contract-lint-report.txt` (13 requests / 21 assertions, 0 failed; lint 0 errors)

## 1. Functional tests

- [x] Có test cho endpoint health. (00_Health → GET /health)
- [x] Có test happy path cho endpoint chính. (01_Functional → POST /readings)
- [x] Có kiểm tra status code 2xx. (POST /readings → 201, GET /readings/latest → 200)
- [x] Có kiểm tra field quan trọng trong response. (reading_id / accepted)
- [x] Có ít nhất 1 test đọc dữ liệu danh sách hoặc chi tiết. (GET /readings/latest → items là array)

## 2. Auth tests

- [x] Có test thiếu token. (02_Auth → POST /readings missing token)
- [x] Có test sai token hoặc token rỗng. (02_Auth → POST /readings invalid token)
- [x] Endpoint public được khai báo rõ nếu không cần auth. (GET /health là public)
- [x] Test thể hiện đúng expected status 401/403. (assert [401,403] trên service thật, không ép Prefer: code=401)

## 3. Negative tests

- [x] Có test thiếu field bắt buộc. (03_Negative → thiếu device_id)
- [x] Có test sai kiểu dữ liệu / sai enum. (03_Negative → wrong enum value cho metric)
- [x] Có test sai enum hoặc giá trị ngoài miền. (metric ngoài enum, limit ngoài range)
- [x] Lỗi trả về theo cùng một error model. (ProblemDetails: có field status/detail)

## 4. Boundary tests

- [x] Có test min/max hoặc dữ liệu sát ngưỡng. (04 → boundary 80 accepted, 81 rejected)
- [x] Có test limit/pagination nếu endpoint có danh sách. (GET /readings/latest?limit=101 bị từ chối)
- [x] Có test payload lớn hoặc metadata thiếu. (negative missing device_id + boundary out-of-range)
- [x] Có ghi chú kỳ vọng xử lý dữ liệu biên. (test kiểm tra response server, không kiểm tra lại request body)

## 5. Reliability tests cơ bản

- [x] Có kiểm tra response time. (06_Local_only_NonFunctional → response time threshold)
- [x] Có mô tả timeout mong muốn. (ngưỡng response time < 1000ms chỉ chạy ở env=local)
- [x] Có test hoặc ghi chú retry/idempotency nếu phù hợp. (latency/SLA chỉ đo trên service thật, không dùng mock latency)
- [x] Có consumer-side smoke test với ít nhất 1 mock của nhóm khác. (05 → gọi AI Vision mock POST /detect)

## 6. Evidence

- [x] Collection export JSON. (postman/collections/FIT4110_lab03_iot_ingestion.postman_collection.json)
- [x] Environment mock export JSON. (postman/environments/FIT4110_lab03_mock.postman_environment.json)
- [x] Environment local export JSON. (postman/environments/FIT4110_lab03_local.postman_environment.json)
- [x] Newman report XML/HTML. (reports/newman-report.xml, reports/newman-report.html, + reports/contract-lint-report.txt)
- [x] Test-case matrix đã điền. (templates/test-case-matrix.csv)
- [x] Biên bản handshake đã điền. (templates/consumer-provider-handshake.md)
