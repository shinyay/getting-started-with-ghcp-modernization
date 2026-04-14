namespace DotnetSampleApp.Services;

/// <summary>
/// ⚠️ SECURITY ISSUE: API credentials are hardcoded below.
/// These should be stored in Azure Key Vault and accessed via Managed Identity.
/// This is intentional for workshop demonstration purposes.
/// </summary>
public class NotificationService
{
    // 🔑 HARDCODED SECRET: External analytics API key
    private readonly string _apiKey = "sk-proj-abc123def456ghi789jkl012mno345pqr678stu901vwx234";

    // 🔑 HARDCODED SECRET: Webhook signing secret
    private readonly string _webhookSecret = "whsec_MjAyNS0wNC0xM1QwMDowMDowMFo_a1b2c3d4e5f6g7h8";

    public void SendNotification(string message)
    {
        // In production, this would call an external API using _apiKey
        // and sign the payload with _webhookSecret
        Console.WriteLine($"[NotificationService] {message} (apiKey: {_apiKey[..10]}...)");
    }
}
