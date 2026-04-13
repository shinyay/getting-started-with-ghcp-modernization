package com.example.bookstore;

import com.example.bookstore.model.Book;
import com.example.bookstore.service.BookService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@SpringBootTest
public class BookServiceTest {

    @Autowired
    private BookService bookService;

    @Test
    public void testCreateBook() {
        Book book = new Book("Test Book", "Test Author", "978-0-TEST-0001", 2023, new BigDecimal("29.99"));
        Book saved = bookService.createBook(book);

        assertNotNull(saved.getId());
        assertEquals("Test Book", saved.getTitle());
        assertEquals("Test Author", saved.getAuthor());
    }

    @Test
    public void testFindByAuthor() {
        Book book1 = new Book("Book One", "Jane Doe", "978-0-TEST-0002", 2020, new BigDecimal("19.99"));
        Book book2 = new Book("Book Two", "Jane Doe", "978-0-TEST-0003", 2021, new BigDecimal("24.99"));
        bookService.createBook(book1);
        bookService.createBook(book2);

        List<Book> books = bookService.findByAuthor("Jane Doe");
        assertTrue(books.size() >= 2);
    }
}
