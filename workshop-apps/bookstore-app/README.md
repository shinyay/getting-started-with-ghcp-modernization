# BookStore Workshop App

> ⚠️ **Warning:** This application intentionally uses legacy patterns for the workshop upgrade exercise (Lab 1). Do NOT use these patterns in new projects.

## Intentional Legacy Patterns

| # | Legacy Pattern | Location | Upgrade Target |
|---|----------------|----------|----------------|
| 1 | `javax.persistence.*` imports | `Book.java` | `jakarta.persistence.*` |
| 2 | JUnit 4 (`@RunWith`, `org.junit.Test`, `Assert.*`) | `BookServiceTest.java`, `BookControllerTest.java` | JUnit 5 (`@ExtendWith`, `org.junit.jupiter.api.Test`, `Assertions.*`) |
| 3 | Spring Boot 2.7.18 + Java 11 | `pom.xml` | Spring Boot 3.x + Java 17+ |

## Build & Run

```bash
# Build
mvn clean package

# Run
mvn spring-boot:run

# Run tests only
mvn test
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/books` | Get all books |
| GET | `/api/books/{id}` | Get book by ID |
| POST | `/api/books` | Create a new book |
| PUT | `/api/books/{id}` | Update a book |
| DELETE | `/api/books/{id}` | Delete a book |
| GET | `/api/books/author/{author}` | Find books by author |

## H2 Console

Available at: [http://localhost:8082/h2-console](http://localhost:8082/h2-console)
- JDBC URL: `jdbc:h2:mem:bookstoredb`
- Username: `sa`
- Password: *(empty)*
