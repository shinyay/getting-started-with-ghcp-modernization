# Act 1: "The Problem" — Opening Hook

> **Duration**: 5 minutes (00:00–05:00)  
> **Mode**: Narration + VS Code screen share  
> **Visual**: PhotoAlbum-Java pre-opened in VS Code
>
> **Verified With**: `claude-sonnet-4.6` + `modernize` CLI v0.0.293+ + GitHub Copilot App Modernization for Java, 2026-04-25

---

## Minute 0:00–1:00 — The Hook

> "Quick show of hands — how many of you have applications running on **Java 8** right now?"
>
> *(pause for hands)*
>
> "And how many have **Spring Boot 2.x** in production?"
>
> *(pause)*
>
> "And here's the fun one — how many of you have **hardcoded secrets** somewhere in your codebase? Be honest."
>
> *(laughter, most hands up)*

**Why this works**: Establishes shared pain, builds rapport, sets up both Scenario 1 (version upgrade) and Scenario 2 (secrets migration).

---

## Minute 1:00–2:30 — The Pain (Make It Visceral)

**In VS Code** (PhotoAlbum-Java already open):

### Show `pom.xml` — highlight these lines:
```xml
<parent>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.7.18</version>  <!-- ⚠️ EOL since Nov 2023 -->
</parent>

<properties>
    <java.version>1.8</java.version>  <!-- ⚠️ Legacy -->
</properties>
```

### Show `Photo.java` — highlight the imports:
```java
import javax.persistence.*;           // ⚠️ Must become jakarta.*
import javax.validation.constraints.*; // ⚠️ Must become jakarta.*
```

### Show `application.properties` — highlight:
```properties
spring.datasource.password=photoalbum  # ⚠️ Hardcoded credential
```

**Presenter script:**

> "This is a real photo gallery application — Spring Boot 2.7, Java 8, Oracle Database."
>
> "Spring Boot 2.7 reached **end-of-life in 2023**. These `javax` imports need to become `jakarta` — that's a namespace change across every JPA entity, every validation annotation, every servlet reference."
>
> "And yes — that's a hardcoded database password, right there in version control."
>
> "Upgrading manually means reading migration guides, updating hundreds of imports, fixing breaking API changes, resolving dependency conflicts. Our teams estimate **2 to 4 weeks per application**. And most enterprises have dozens — sometimes hundreds — of these."

---

## Minute 2:30–4:00 — The Promise

> "**GitHub Copilot modernization** is an agentic, end-to-end solution that assesses, upgrades, and migrates Java and .NET applications to Azure."
>
> "It follows a three-stage workflow:"
>
> "**Assess** — analyze what's in your codebase: dependencies, deprecated APIs, security issues."
>
> "**Plan** — generate a human-reviewable transformation plan with ordered tasks and success criteria."
>
> "**Execute** — apply the changes automatically, with build validation and git traceability at every step."
>
> "Humans remain in the loop at every checkpoint. This is **supervised automation** — not black-box magic."

---

## Minute 4:00–5:00 — The Journey Preview

> "Today I'll take you through the natural modernization journey:"
>
> "First, we'll **Discover** — use the Modernize CLI to assess an entire portfolio of applications and understand what needs modernization."
>
> "Then, we'll **Modernize** — dive into two apps and fix them live. One needs a framework upgrade from Java 8 to 21. The other has security issues with hardcoded secrets."
>
> "Finally, we'll **Scale** — see how custom skills let you capture successful migration patterns and apply them consistently across your entire organization."
>
> "Let's start with discovery."

---

## Preparation Checklist

- [ ] PhotoAlbum-Java open in VS Code
- [ ] `pom.xml` tab visible
- [ ] `Photo.java` easily accessible (Explorer panel)
- [ ] `application.properties` easily accessible
- [ ] Font size 16+ for projector readability
