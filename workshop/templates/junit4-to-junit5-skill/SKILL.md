---
name: junit4-to-junit5
description: Migrate JUnit 4 tests to JUnit 5 (Jupiter) — replaces @RunWith with @ExtendWith, org.junit.Test with org.junit.jupiter.api.Test, and Assert.* with Assertions.*.
language: java
applicable_to:
  - "**/pom.xml"
  - "**/build.gradle"
  - "**/build.gradle.kts"
  - "**/src/test/java/**/*.java"
requires:
  - "org.junit.Test"
---

<!--
  STARTER template for Lab 3. Copy this into `.github/skills/junit4-to-junit5/`
  then extend it with the patterns the lab guides you through. The finished
  reference (with all patterns, including the Pattern 4 BookStore note and
  Pattern 5 @MockitoBean additions) lives at `docs/examples/SKILL.md.example`.
-->

# JUnit 4 → JUnit 5 Migration Skill

## Overview

This skill migrates Java test files from **JUnit 4** to **JUnit 5 (Jupiter)**. It handles the most common migration patterns found in Spring Boot applications.

## Migration Patterns

### Pattern 1: Test Runner

**Before (JUnit 4):**
```java
import org.junit.runner.RunWith;
import org.springframework.test.context.junit4.SpringRunner;

@RunWith(SpringRunner.class)
@SpringBootTest
public class MyServiceTest {
```

**After (JUnit 5):**
```java
// @RunWith is no longer needed — Spring Boot Test auto-configures JUnit 5
@SpringBootTest
public class MyServiceTest {
```

### Pattern 2: Test Annotation

**Before (JUnit 4):**
```java
import org.junit.Test;
```

**After (JUnit 5):**
```java
import org.junit.jupiter.api.Test;
```

### Pattern 3: Assertions

**Before (JUnit 4):**
```java
import static org.junit.Assert.*;

Assert.assertEquals("expected", actual);
Assert.assertNotNull(result);
Assert.assertTrue(condition);
```

**After (JUnit 5):**
```java
import static org.junit.jupiter.api.Assertions.*;

assertEquals("expected", actual);
assertNotNull(result);
assertTrue(condition);
```

<!-- TODO: Add additional patterns specific to your organization's codebase -->

### Pattern 4: Setup and Teardown

<!-- TODO: Extend this pattern with any project-specific @Before/@After teardown logic -->

**Before (JUnit 4):**
```java
import org.junit.Before;
import org.junit.After;

@Before
public void setUp() { }

@After
public void tearDown() { }
```

**After (JUnit 5):**
```java
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;

@BeforeEach
void setUp() { }

@AfterEach
void tearDown() { }
```

## Steps

1. Find all test files using JUnit 4 imports (`org.junit.Test`, `org.junit.Assert`, `org.junit.runner.RunWith`)
2. Replace `@RunWith(SpringRunner.class)` — remove entirely (Spring Boot Test handles this with JUnit 5)
3. Replace `import org.junit.Test` with `import org.junit.jupiter.api.Test`
4. Replace `import static org.junit.Assert.*` with `import static org.junit.jupiter.api.Assertions.*`
5. Replace `@Before` / `@After` with `@BeforeEach` / `@AfterEach`
6. Update `pom.xml`: remove explicit JUnit 4 dependency, ensure `spring-boot-starter-test` includes JUnit Jupiter
7. Run `mvn test` to verify all tests pass

## Verification Checks

- [ ] No `org.junit.Test` imports remain (should be `org.junit.jupiter.api.Test`)
- [ ] No `@RunWith` annotations remain
- [ ] No `org.junit.Assert` imports remain (should be `org.junit.jupiter.api.Assertions`)
- [ ] `mvn test` passes with all tests green
