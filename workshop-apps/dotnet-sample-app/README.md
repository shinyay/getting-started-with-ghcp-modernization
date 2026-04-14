# .NET Sample App — Dotnet Task API

> ⚠️ **This application intentionally contains hardcoded secrets and uses an outdated .NET version for workshop demonstration purposes.**

## Intentional Issues

| # | Location | Issue | Pattern |
|---|----------|-------|---------|
| 1 | `appsettings.json` | `Password=SuperSecret123!` in connection string + API keys | Config file secrets |
| 2 | `Services/NotificationService.cs` | `_apiKey` and `_webhookSecret` as string fields | C# class field secrets |
| 3 | `DotnetSampleApp.csproj` | `<TargetFramework>net6.0</TargetFramework>` | Outdated .NET version |

These patterns represent common enterprise security anti-patterns and are designed to be detected by the `@modernize-dotnet` agent.

## Tech Stack

| Property | Value |
|----------|-------|
| **Framework** | ASP.NET Core 6.0 (Minimal API) |
| **Database** | SQLite in-memory |
| **Build** | `dotnet build` |
| **Run** | `dotnet run` (port 5081) |

## Build & Run

```bash
cd workshop-apps/dotnet-sample-app
dotnet build
dotnet run
# API available at http://localhost:5081
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/tasks` | List all tasks |
| GET | `/api/tasks/{id}` | Get a specific task |
| POST | `/api/tasks` | Create a new task |
| PUT | `/api/tasks/{id}` | Update a task |
| DELETE | `/api/tasks/{id}` | Delete a task |

## Quick Test

```bash
# Create a task
curl -X POST http://localhost:5081/api/tasks \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","description":"Hello from .NET"}'

# List tasks
curl http://localhost:5081/api/tasks
```

## Workshop Usage

This app is used in [Lab 7: .NET Upgrade](../../workshop/lab7-dotnet-upgrade.md) (50 min, full-day workshop).
