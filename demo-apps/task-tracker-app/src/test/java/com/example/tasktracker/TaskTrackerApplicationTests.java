package com.example.tasktracker;

import com.example.tasktracker.model.Task;
import com.example.tasktracker.repository.TaskRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
class TaskTrackerApplicationTests {

    @Autowired
    private TaskRepository taskRepository;

    @Test
    void contextLoads() {
    }

    @Test
    void createAndRetrieveTask() {
        Task task = new Task("Test Task", "A task for testing", "HIGH");
        Task saved = taskRepository.save(task);
        assertNotNull(saved.getId());
        assertEquals("Test Task", saved.getTitle());
        assertEquals("HIGH", saved.getPriority());
    }
}
