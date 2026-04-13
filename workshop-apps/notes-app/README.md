# NotesApp Workshop App

> ⚠️ **Warning**: This application intentionally uses file-based logging anti-patterns for cloud environments. It is designed as a workshop exercise for the "Logging to Console" predefined task in Lab 4.

## Intentional Issues

| # | Issue | Location | Description |
|---|-------|----------|-------------|
| 1 | File-based log appender | `src/main/resources/logback-spring.xml` | RollingFileAppender writes logs to `logs/notes-app.log` with time-based rolling policy and 30-day retention |
| 2 | FileWriter-based audit log | `src/main/java/.../service/NoteService.java` | `writeAuditLog()` method writes directly to `logs/audit.log` using `java.nio.file.Files` |

## Why This Is a Problem in Cloud

- **Ephemeral containers**: Log files are lost when containers restart or scale down
- **No centralized monitoring**: File-based logs cannot be aggregated in Azure Monitor or Application Insights
- **Unnecessary disk I/O**: Rolling file policies consume disk space and I/O in containerized environments
- **No structured logging**: File-based audit logs lack the structured format needed for cloud log analytics

## Build & Run

```bash
# Build
mvn clean package

# Run
mvn spring-boot:run

# The app runs on port 8083
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/notes` | Get all notes |
| GET | `/api/notes/{id}` | Get note by ID |
| POST | `/api/notes` | Create a new note |
| PUT | `/api/notes/{id}` | Update a note |
| DELETE | `/api/notes/{id}` | Delete a note |
| GET | `/api/notes/search?tag=X` | Search notes by tag |
