<!-- Generated: April 2026 | Static fallback shown when the live demo stalls. Regenerate from `modernize assess --source ./.github/modernize/repos.json --format markdown` if the actual output diverges materially. -->
# GitHub Copilot Modernization — Portfolio Assessment Report

> **Last refreshed**: 2026-04-25
>
> **Tested With**: `modernize` CLI v0.0.293+ · `claude-sonnet-4.6` (default model). Numbers below are illustrative — captured from a representative run; real runs will vary by repo content, tooling versions, and model.
>
> **Generated** *(illustrative)*: 2026-04-25
> **Repositories assessed**: 3
> **Execution time** *(illustrative)*: ~4–5 minutes for 3 small Spring Boot apps on `claude-sonnet-4.6`

> 📂 **See also**: [`scenario1-expected-diff.md`](scenario1-expected-diff.md) (Java 8→21 + Spring Boot 2.7→3.x) · [`scenario2-expected-diff.md`](scenario2-expected-diff.md) (secrets → Azure Key Vault) for the per-scenario fallback diffs.

---

## Dashboard

| Metric | Value |
|--------|-------|
| **Applications assessed** | 3 |
| **Need framework upgrade** | 2 |
| **Need security remediation** | 1 |
| **Total issues** | 47 |
| Mandatory | 12 |
| Potential | 23 |
| Optional | 12 |

### Effort Distribution

| Effort Level | Count | Applications |
|-------------|-------|--------------|
| 🟢 Small | 1 | TaskTracker |
| 🟡 Medium | 1 | PhotoAlbum-Java |
| 🔴 Large | 1 | NewsFeedSite |

---

## Technology Distribution

| Technology | Apps | Versions Found |
|-----------|------|----------------|
| **Java** | 3 | Java 8 (1 app), Java 17 (2 apps) |
| **Spring Boot** | 2 | 2.7.18 (1 app), 3.2.5 (1 app) |
| **Servlet/Jetty** | 1 | Jetty 9.4, javax.servlet 4 |
| **Build Tool** | 3 | Maven (all) |
| **Database** | 2 | Oracle 21c XE (1 app), H2 (1 app) |
| **Message Broker** | 1 | RabbitMQ 3 (1 app) |

---

## Recommendations

### Azure Services Mapping

| Current Dependency | Recommended Azure Service | Affected Apps |
|-------------------|--------------------------|---------------|
| Oracle Database | Azure Database for PostgreSQL + Managed Identity | PhotoAlbum-Java |
| H2 (development) | Azure Database for PostgreSQL + Managed Identity | TaskTracker |
| RabbitMQ | Azure Service Bus | NewsFeedSite |
| Hardcoded secrets | Azure Key Vault | TaskTracker |
| File-based logging | Azure Monitor (console logging) | PhotoAlbum-Java |
| javax.servlet | Spring Boot Web (embedded Tomcat) | NewsFeedSite |

### Target Platform

| Application | Recommended Platform | Rationale |
|------------|---------------------|-----------|
| PhotoAlbum-Java | **Azure Container Apps** | Web app, Spring Boot, stateless, containerizable |
| TaskTracker | **Azure Container Apps** | REST API, lightweight, auto-scaling |
| NewsFeedSite | **Azure Kubernetes Service** | Multi-component (client + service), WebSocket, needs orchestration |

### Upgrade Paths

| Application | Current | Target | Key Changes |
|------------|---------|--------|-------------|
| PhotoAlbum-Java | Java 8, Spring Boot 2.7.18 | Java 21, Spring Boot 3.3+ | javax→jakarta, Oracle JDBC update, config migration |
| TaskTracker | Java 17, Spring Boot 3.2.5 | *(current)* | Secrets externalization only |
| NewsFeedSite | Java 17, Servlet/Jetty (multi-module: client + service) | Java 21, Spring Boot 3.3+ | Architecture migration (Servlet→Spring Boot), RabbitMQ→Service Bus |

---

## Migration Waves

### Wave 1: Quick Win 🟢

| Application | Effort | Key Change | Risk |
|------------|--------|------------|------|
| **TaskTracker** | Small | Secrets → Azure Key Vault | Low — already on modern framework |

> **Rationale**: Already on Spring Boot 3.2 and Java 17. Only issue is hardcoded secrets. Quick win that delivers immediate security improvement and proves the modernization process.

### Wave 2: Core Upgrade 🟡

| Application | Effort | Key Changes | Risk |
|------------|--------|-------------|------|
| **PhotoAlbum-Java** | Medium | Java 8→21, Spring Boot 2.7→3.x, Oracle→PostgreSQL | Medium — standard upgrade path |

> **Rationale**: Well-structured Spring Boot app. The upgrade follows a well-documented path that Copilot modernization handles efficiently. Patterns learned here can be captured as custom skills.

### Wave 3: Major Modernization 🔴

| Application | Effort | Key Changes | Risk |
|------------|--------|-------------|------|
| **NewsFeedSite** | Large | Java 17→21, Jetty→Spring Boot, RabbitMQ→Service Bus | Higher — architectural changes |

> **Rationale**: Requires architectural migration beyond framework upgrade. Leverage patterns and custom skills from Wave 1 and 2 to accelerate. Consider using Cloud Coding Agents for parallel processing.

---

## Application Assessment Matrix

| App | Framework | Java | Target Platform | Upgrade Recommendation | Mandatory | Potential | Optional | Effort |
|-----|-----------|------|-----------------|----------------------|-----------|-----------|----------|--------|
| PhotoAlbum-Java | Spring Boot 2.7 | 8 | Container Apps | Java 21 + SB 3.x + DB migration | 8 | 12 | 5 | 🟡 Medium |
| TaskTracker | Spring Boot 3.2 | 17 | Container Apps | Secrets externalization | 3 | 5 | 4 | 🟢 Small |
| NewsFeedSite | Servlet/Jetty | 8 | AKS | Java 21 + SB 3.x + messaging | 1 | 6 | 3 | 🔴 Large |

---

*Report generated by GitHub Copilot Modernization Agent (Modernize CLI)*
