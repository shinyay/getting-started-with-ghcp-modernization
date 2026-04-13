package com.example.notesapp.service;

import com.example.notesapp.model.Note;
import com.example.notesapp.repository.NoteRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class NoteService {

    private static final Logger logger = LoggerFactory.getLogger(NoteService.class);

    private final NoteRepository noteRepository;

    public NoteService(NoteRepository noteRepository) {
        this.noteRepository = noteRepository;
    }

    public List<Note> getAllNotes() {
        logger.debug("Fetching all notes");
        return noteRepository.findAll();
    }

    public Optional<Note> getNoteById(Long id) {
        logger.debug("Fetching note with id: {}", id);
        return noteRepository.findById(id);
    }

    public Note createNote(Note note) {
        logger.info("Creating new note: {}", note.getTitle());
        Note savedNote = noteRepository.save(note);
        writeAuditLog("CREATE", savedNote);
        return savedNote;
    }

    public Note updateNote(Long id, Note noteDetails) {
        logger.info("Updating note with id: {}", id);
        Note note = noteRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Note not found with id: " + id));
        note.setTitle(noteDetails.getTitle());
        note.setContent(noteDetails.getContent());
        note.setTags(noteDetails.getTags());
        Note updatedNote = noteRepository.save(note);
        writeAuditLog("UPDATE", updatedNote);
        return updatedNote;
    }

    public void deleteNote(Long id) {
        logger.info("Deleting note with id: {}", id);
        Note note = noteRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Note not found with id: " + id));
        writeAuditLog("DELETE", note);
        noteRepository.deleteById(id);
    }

    public List<Note> searchByTag(String tag) {
        logger.debug("Searching notes with tag: {}", tag);
        return noteRepository.findByTagsContaining(tag);
    }

    private void writeAuditLog(String action, Note note) {
        try {
            // ⚠️ CLOUD ANTI-PATTERN: Writing directly to filesystem
            Path logDir = Paths.get("logs");
            Files.createDirectories(logDir);
            Path auditFile = logDir.resolve("audit.log");
            String entry = LocalDateTime.now() + " | " + action + " | Note ID: " + note.getId() + " | Title: " + note.getTitle() + "\n";
            Files.write(auditFile, entry.getBytes(), StandardOpenOption.CREATE, StandardOpenOption.APPEND);
        } catch (IOException e) {
            logger.error("Failed to write audit log", e);
        }
    }
}
