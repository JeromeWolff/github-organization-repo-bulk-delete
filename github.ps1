# GitHub Repository Deletion Tool
# Author: Jerome Wolff
# Purpose: Deletes all GitHub repositories in an organization with a specific prefix.

# Define parameters
param (
    [string]$GitHubToken,            # Fine-grained personal access token
    [string]$OrganizationName,       # GitHub organization name
    [string]$RepoPrefix			         # Prefix for repositories to delete
)

# Check for required inputs
if (-not $GitHubToken -or -not $OrganizationName) {
    Write-Error "GitHubToken and OrganizationName are required parameters."
    exit 1
}

# GitHub API endpoint
$GitHubApiUrl = "https://api.github.com"

# Function to get repositories with a specific prefix
function Get-RepositoriesWithPrefix {
    param (
        [string]$Organization,
        [string]$Prefix
    )
    $headers = @{ Authorization = "Bearer $GitHubToken" }
    $url = "$GitHubApiUrl/orgs/$Organization/repos?per_page=100"
    $repositories = @()
    do {
        $response = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorAction Stop
        $repositories += $response | Where-Object { $_.name -like "$Prefix*" }
        $url = ($response | Get-Member -Name "Link" -ErrorAction Ignore).Definition -match 'rel="next"' ? $matches[1] : $null
    } while ($url)
    return $repositories
}

# Function to delete a repository
function Delete-Repository {
    param (
        [string]$RepoFullName
    )
    $headers = @{ Authorization = "Bearer $GitHubToken" }
    $url = "$GitHubApiUrl/repos/$RepoFullName"
    try {
        Invoke-RestMethod -Uri $url -Headers $headers -Method Delete -ErrorAction Stop
        Write-Host "Deleted repository: $RepoFullName" -ForegroundColor Green
    } catch {
        Write-Error "Failed to delete repository: $RepoFullName. $_"
    }
}

# Main script
Write-Host "Fetching repositories with prefix '$RepoPrefix' in organization '$OrganizationName'..." -ForegroundColor Yellow
$repositories = Get-RepositoriesWithPrefix -Organization $OrganizationName -Prefix $RepoPrefix

if ($repositories.Count -eq 0) {
    Write-Host "No repositories found with prefix '$RepoPrefix' in organization '$OrganizationName'." -ForegroundColor Cyan
    exit 0
}

Write-Host "Found $($repositories.Count) repositories to delete." -ForegroundColor Yellow
foreach ($repo in $repositories) {
    Delete-Repository -RepoFullName $repo.full_name
}

Write-Host "Deletion process completed." -ForegroundColor Green
