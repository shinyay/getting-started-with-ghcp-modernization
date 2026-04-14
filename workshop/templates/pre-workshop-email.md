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
4. **VS Code 1.106+**: Install from https://code.visualstudio.com/
5. **VS Code Extensions**: Install these 3 extensions:
   - GitHub Copilot (`github.copilot`)
   - GitHub Copilot Chat (`github.copilot-chat`)
   - GitHub Copilot Modernization (`vscjava.migrate-java-to-azure`)
6. **Restart VS Code** after installing extensions
7. **Clone the workshop repo**:
   ```
   git clone https://github.com/shinyay/getting-started-with-ghcp-modernization.git
   ```
8. **Run setup validation**:
   ```
   cd getting-started-with-ghcp-modernization
   bash workshop/setup.sh
   ```

**⚠️ Important:** The setup script builds Java applications and downloads Maven dependencies. Please run it on a reliable network connection (not airport/conference WiFi).

**For .NET Lab participants** (full-day only, Lab 7):
- .NET SDK (latest): `dotnet --version`
- VS Code with `@modernize-dotnet` extension OR Visual Studio 2026

If you encounter any issues, please reply to this email before the workshop.

See you there!
[Instructor Name]
