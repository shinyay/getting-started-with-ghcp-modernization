package com.example.notesapp;

import com.example.notesapp.model.Note;
import com.example.notesapp.repository.NoteRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class NotesApplicationTests {

    @Autowired
    private NoteRepository noteRepository;

    @Test
    void contextLoads() {
    }

    @Test
    void createAndRetrieveNote() {
        Note note = new Note("Test Note", "Test Content", "test,junit");
        Note saved = noteRepository.save(note);

        assertNotNull(saved.getId());
        assertEquals("Test Note", saved.getTitle());
        assertEquals("Test Content", saved.getContent());

        Note found = noteRepository.findById(saved.getId()).orElse(null);
        assertNotNull(found);
        assertEquals("Test Note", found.getTitle());
    }
}
