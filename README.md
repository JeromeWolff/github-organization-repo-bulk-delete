# GitHub Repository Deletion Tool

A PowerShell script to delete multiple GitHub repositories within an organization based on a specific prefix. This tool utilizes a fine-grained personal access token (PAT) for authentication and interacts with the GitHub REST API.

## Features

- Deletes repositories with a specified prefix.
- Works for repositories within an organization.
- Supports GitHub's fine-grained access token for secure and scoped authentication.
- Handles paginated results for organizations with many repositories.

## Prerequisites

1. **GitHub Token**: A fine-grained personal access token with the `delete_repo` permission scoped to the target organization.
2. **PowerShell**: PowerShell 7 or higher is recommended.

## Usage

### 1. Clone or Download the Script
Save the script as `Delete-GitHubRepos.ps1`.

### 2. Run the Script
Execute the script in PowerShell with the following parameters:

```powershell
.\Delete-GitHubRepos.ps1 -GitHubToken "<your_token>" -OrganizationName "<your_organization>" -RepoPrefix "<prefix>"
```
