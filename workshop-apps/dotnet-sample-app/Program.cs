using Microsoft.EntityFrameworkCore;
using DotnetSampleApp.Models;
using DotnetSampleApp.Services;

var builder = WebApplication.CreateBuilder(args);

// Configure SQLite database
builder.Services.AddDbContext<TaskDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddSingleton<NotificationService>();

var app = builder.Build();

// Ensure database is created
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<TaskDbContext>();
    db.Database.EnsureCreated();
}

// GET /api/tasks — List all tasks
app.MapGet("/api/tasks", async (TaskDbContext db) =>
    await db.Tasks.ToListAsync());

// GET /api/tasks/{id} — Get a specific task
app.MapGet("/api/tasks/{id}", async (int id, TaskDbContext db) =>
    await db.Tasks.FindAsync(id) is TaskItem task
        ? Results.Ok(task)
        : Results.NotFound());

// POST /api/tasks — Create a new task
app.MapPost("/api/tasks", async (TaskItem task, TaskDbContext db, NotificationService notifier) =>
{
    db.Tasks.Add(task);
    await db.SaveChangesAsync();
    notifier.SendNotification($"Task created: {task.Title}");
    return Results.Created($"/api/tasks/{task.Id}", task);
});

// PUT /api/tasks/{id} — Update a task
app.MapPut("/api/tasks/{id}", async (int id, TaskItem input, TaskDbContext db) =>
{
    var task = await db.Tasks.FindAsync(id);
    if (task is null) return Results.NotFound();

    task.Title = input.Title;
    task.Description = input.Description;
    task.IsCompleted = input.IsCompleted;
    await db.SaveChangesAsync();
    return Results.NoContent();
});

// DELETE /api/tasks/{id} — Delete a task
app.MapDelete("/api/tasks/{id}", async (int id, TaskDbContext db) =>
{
    var task = await db.Tasks.FindAsync(id);
    if (task is null) return Results.NotFound();

    db.Tasks.Remove(task);
    await db.SaveChangesAsync();
    return Results.NoContent();
});

app.Run();

// Database context
public class TaskDbContext : DbContext
{
    public TaskDbContext(DbContextOptions<TaskDbContext> options) : base(options) { }
    public DbSet<TaskItem> Tasks => Set<TaskItem>();
}
