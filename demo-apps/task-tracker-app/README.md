# Task Tracker App

> ⚠️ **This application intentionally contains hardcoded secrets for demonstration purposes.**

A simple REST API for tracking tasks. Built as the target application for the **Secrets → Azure Key Vault** demo scenario.

## Intentional Security Issues

| # | Location | Secret | Type |
|---|----------|--------|------|
| 1 | `src/main/resources/application.properties` | `spring.datasource.password=SuperSecret123!` + API keys | Properties file |
| 2 | `src/main/java/.../config/ExternalApiConfig.java` | `apiKey` and `apiSecret` fields | Java config class |
| 3 | `src/main/java/.../service/NotificationService.java` | `@Value("${app.webhook.secret:whsec_...}")` | @Value with hardcoded default |

## Tech Stack

**Spring Boot 3.2.5** · **Java 17** · **H2** in-memory DB · **Maven**

## Build & Run

```bash
mvn clean package        # Build + test
mvn spring-boot:run      # Run on port 8081
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tasks` | List all |
| GET | `/api/tasks/{id}` | Get by ID |
| GET | `/api/tasks/incomplete` | List incomplete |
| POST | `/api/tasks` | Create |
| PUT | `/api/tasks/{id}` | Update |
| PUT | `/api/tasks/{id}/complete` | Mark complete (sends webhook) |
| DELETE | `/api/tasks/{id}` | Delete |

## Quick Test

```bash
curl -X POST http://localhost:8081/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Demo task","priority":"HIGH"}'

curl http://localhost:8081/api/tasks
```
