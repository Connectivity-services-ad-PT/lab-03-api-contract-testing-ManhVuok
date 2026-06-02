# Consumer–Provider Handshake — FIT4110 Lab 03

Biên bản handshake cho consumer-side smoke test.

## 1. Thông tin chung

| Mục | Giá trị |
| --- | --- |
| Consumer | **team-gate — Access Gate** |
| Provider (service phụ thuộc) | **team-core — Core Business** |
| Endpoint được gọi | `POST /policies/evaluate-access` |
| Mock base URL | `{{coreMockUrl}}` = `http://localhost:4011` (Prism mock từ `contracts/core-business.openapi.yaml`) |
| Auth rule | `Authorization: Bearer {{authToken}}` (bearer JWT) |
| Folder test | `05_Consumer_side_Smoke` |

> Bối cảnh: Trong sơ đồ Smart Campus `Access Gate → Core Business`, Access Gate (consumer) gửi
> thông tin một lần quẹt thẻ tới Core Business (provider) để xin quyết định allow/deny theo chính sách.
> Vì Core Business có thể chưa code xong, Access Gate gọi **mock** của Core Business để smoke test.

## 2. Contract provider công bố

- `openapi.yaml`: `contracts/core-business.openapi.yaml`
- `mock_base_url`: `http://localhost:4011`
- `auth rule`: Bearer JWT (endpoint `POST /policies/evaluate-access` yêu cầu token)

### Example request

```http
POST {{coreMockUrl}}/policies/evaluate-access
Authorization: Bearer {{authToken}}
Content-Type: application/json

{
  "cardId": "RFID-2026-001",
  "gateId": "GATE-01",
  "direction": "IN"
}
```

### Example response (200)

```json
{
  "decision": "ALLOW",
  "policyId": "POL-ACCESS-001",
  "reason": "Thẻ hợp lệ, còn hạn, cổng đang mở"
}
```

## 3. Smoke test của consumer

Request trong collection: **05_Consumer_side_Smoke → "Consumer smoke - Access Gate calls Core Business mock (evaluate-access)"**

Assertions:

- `pm.response.code === 200` — consumer nhận thành công từ provider mock.
- `decision ∈ {ALLOW, DENY}` — đọc được trường quyết định cần dùng.
- response có `policyId` và `reason` — đủ thông tin để Access Gate ghi log / hiển thị.

## 4. Tiêu chí pass (theo docs/CONSUMER_SIDE_TESTING.md)

- [x] Gọi đúng endpoint của provider (`POST /policies/evaluate-access`).
- [x] Request body đúng schema (`cardId`, `gateId`, `direction`).
- [x] Đọc được field cần dùng trong response (`decision`, `policyId`, `reason`).
- [x] Xử lý được ít nhất 1 lỗi 4xx/5xx — contract Core Business khai báo `400` và `401`; consumer giả định nhận và xử lý các mã này.
- [x] Có Newman report làm bằng chứng (`reports/newman-report.html`, `reports/newman-report.xml`).

## 5. Kết quả

| Lần chạy | Môi trường | Kết quả |
| --- | --- | --- |
| Newman (CI + local) | mock (`:4011`) | Pass — 200, đọc được `decision`/`policyId`/`reason` |
