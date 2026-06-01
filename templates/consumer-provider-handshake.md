# Consumer–Provider Handshake

## Thông tin chung

- Lab: FIT4110 Lab 03
- Ngày: 2026-06-01
- Provider team: team-vision (AI Vision)
- Consumer team: team-iot (IoT Ingestion)
- Provider service: AI Vision
- Consumer service: IoT Ingestion

## Contract

- Contract file: `contracts/ai-vision.openapi.yaml`
- Mock base URL: `http://localhost:4011` (`{{aiVisionMockUrl}}`)
- Auth method: HTTP Bearer token (`Authorization: Bearer {{authToken}}`)
- Endpoint được test: `POST /detect`

## Smoke test

### Request

```http
POST /detect
Authorization: Bearer {{authToken}}
Content-Type: application/json
```

```json
{
  "camera_id": "CAM01",
  "image_url": "https://example.com/frame.jpg"
}
```

### Expected response

```json
{
  "detection_id": "DET001",
  "camera_id": "CAM01",
  "label": "person",
  "confidence": 0.91,
  "risk_level": "medium"
}
```

## Kết quả

- [x] Consumer gọi mock thành công. (POST {{aiVisionMockUrl}}/detect → 200 OK)
- [x] Consumer parse được field cần dùng. (đọc được detection_id, label, confidence)
- [x] Consumer hiểu lỗi 4xx/5xx provider trả về. (contract định nghĩa 400 invalid-image, 401 unauthorized theo ProblemDetails)
- [x] Có Newman report hoặc screenshot. (folder 05_Consumer_side_Smoke trong reports/newman-report.html)

## Ghi chú thay đổi hợp đồng

| Nội dung | Trước | Sau | Người đồng ý |
|---|---|---|---|
| Không có thay đổi hợp đồng trong lab này | - | - | - |

## Xác nhận

- Provider representative: team-vision
- Consumer representative: team-iot (ManhVuok)
