# Fallback: Scenario 1 — Version Upgrade Expected Diff

> Use this if the live demo stalls. Walk through these changes to show what the upgrade produces.

---

## 1. `pom.xml` — Version & Dependency Changes

### Before
```xml
<parent>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.7.18</version>
</parent>
<properties>
    <java.version>1.8</java.version>
    <maven.compiler.source>8</maven.compiler.source>
    <maven.compiler.target>8</maven.compiler.target>
</properties>
```

### After
```xml
<parent>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.3.5</version>
</parent>
<properties>
    <java.version>21</java.version>
    <maven.compiler.source>21</maven.compiler.source>
    <maven.compiler.target>21</maven.compiler.target>
</properties>
```

### Dependency changes
- `ojdbc8` → `ojdbc17` (Oracle JDBC for Java 17+)
- `commons-io` version updated for compatibility
- Spring Boot starters auto-aligned via parent

---

## 2. `Photo.java` — Namespace Migration

### Before
```java
import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;
import javax.validation.constraints.Size;
```

### After
```java
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
```

> **Talking point**: "This namespace change — javax to jakarta — affects every JPA entity, every validation annotation, every servlet reference. OpenRewrite handles it deterministically across all files."

---

## 3. Other Java Files — Same Pattern

All files with `javax.persistence`, `javax.validation`, or `javax.servlet` imports updated to `jakarta.*`:
- `PhotoAlbumApplication.java`
- Controller classes
- Repository interfaces
- Service classes

---

## 4. `application.properties` — Config Updates

Potential changes:
- `spring.jpa.database-platform` may update or be removed (auto-detection in SB3)
- Deprecated properties replaced with Spring Boot 3.x equivalents
- Character encoding config format may change

---

## 5. Expected Git Commits

```
a1b2c3d  chore: upgrade Spring Boot to 3.3.5 and Java to 21
e4f5g6h  refactor: migrate javax.* to jakarta.* namespace
i7j8k9l  fix: update Oracle JDBC driver to ojdbc17
m0n1o2p  fix: resolve Spring Boot 3.x configuration deprecations
q3r4s5t  chore: update remaining dependency versions
```

---

## Recovery Script

> "While the agent works on this, let me show you what the output looks like from a previous successful run."
>
> "Here's the pom.xml — Java version moved from 1.8 to 21, Spring Boot from 2.7 to 3.3. The Oracle JDBC driver upgraded from ojdbc8 to ojdbc17."
>
> "And here's the big one — the namespace migration. Every javax.persistence import becomes jakarta.persistence. Every javax.validation becomes jakarta.validation. Across every file in the project."
>
> "Each step is a separate git commit — fully auditable, fully reversible."
