# Pre-Workshop Email Template

**Subject:** GitHub Copilot Modernization Workshop — Setup Required

---

Hi [Team/Participants],

Looking forward to our GitHub Copilot Modernization workshop on [DATE]!

**⏱ Format:** [Half-day (3.5 hours) / Full-day (6.5 hours)]

**🔧 Please complete these setup steps BEFORE the workshop:**

1. **GitHub Copilot**: Confirm your subscription is active at https://github.com/settings/copilot
2. **Java 21+**: `java -version` should show 21 or later
3. **Maven 3.8+**: `mvn -version` should show 3.8 or later
4. **VS Code 1.106+** (Insiders recommended for the latest modernization features): Install from https://code.visualstudio.com/ or https://code.visualstudio.com/insiders/
5. **VS Code Extensions**: Install these 3 extensions:
   - GitHub Copilot (`github.copilot`)
   - GitHub Copilot Chat (`github.copilot-chat`)
   - GitHub Copilot App Modernization for Java (`vscjava.migrate-java-to-azure`)
6. **`modernize` CLI** (required for Labs 2 and 5): see [docs/04](../docs/04-modernization-agent-cli.md) for installation. Confirm with `modernize --version`.
7. **Restart VS Code** after installing extensions
8. **Clone the workshop repo**:
   ```
   git clone https://github.com/shinyay/getting-started-with-ghcp-modernization.git
   ```
9. **Run setup validation**:
   ```
   cd getting-started-with-ghcp-modernization
   bash workshop/setup.sh
   ```

**⚠️ Important:** The setup script builds Java applications and downloads Maven dependencies. Please run it on a reliable network connection (not airport/conference WiFi).

**For .NET Lab participants** (full-day only, Lab 7):
- .NET SDK 8+ (10 SDK preview recommended): `dotnet --version`
- VS Code (Insiders) with the GitHub Copilot App Modernization for .NET extension OR Visual Studio 2026 with the equivalent extension
- The `setup.sh` script will build `workshop-apps/dotnet-sample-app` if `dotnet` is on your PATH

If you encounter any issues, please reply to this email before the workshop.

See you there!
[Instructor Name]
