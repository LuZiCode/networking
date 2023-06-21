# Import the ActiveDirectory module
Import-Module ActiveDirectory

# Specify the domain
$domain = "DC=kursus1,DC=com"

# Specify the name of the parent OU
$parentOUName = "Kursus A/S"

# Check if the parent OU exists
if (-not (Get-ADOrganizationalUnit -Filter { Name -eq $parentOUName })) {
    # If the parent OU doesn't exist, create it
    New-ADOrganizationalUnit -Name $parentOUName -Path $domain -PassThru
    Write-Host "Created OU: $parentOUName"
} else {
    Write-Host "Skipped creating OU: $parentOUName. It already exists."
}

# Specify the names of the child OUs
$childOUNames = @("Økonimi afd.", "Kursus Afd", "Adm. & IT afd.")

# Specify the path for the child OUs (including the parent OU)
$childOUPath = "OU=$parentOUName,$domain"

# Create each child OU
foreach ($ouName in $childOUNames) {
    # Check if the child OU exists
    if (-not (Get-ADOrganizationalUnit -Filter { Name -eq $ouName })) {
        # If the child OU doesn't exist, create it
        New-ADOrganizationalUnit -Name $ouName -Path $childOUPath -PassThru
        Write-Host "Created OU: $ouName"
    } else {
        Write-Host "Skipped creating OU: $ouName. It already exists."
    }

    # Specify the names of the subchild OUs for the current child OU
    $subchildOUNames = @()

    # Add subchild OUs based on the current child OU
    switch ($ouName) {
        "Økonimi afd." {
            $subchildOUNames = @("Bogholderi", "Løn")
            break
        }
        "Kursus Afd" {
            $subchildOUNames = @("Marketing", "Lærerteam")
            break
        }
        "Adm. & IT afd." {
            $subchildOUNames = @("Kundeservice", "HR", "IT Helpdesk")
            break
        }
    }

    # Specify the path for the subchild OUs (including the current child OU)
    $subchildOUPath = "OU=$ouName,$childOUPath"

    # Create each subchild OU
    foreach ($subouName in $subchildOUNames) {
        # Check if the subchild OU exists
        if (-not (Get-ADOrganizationalUnit -Filter { Name -eq $subouName })) {
            # If the subchild OU doesn't exist, create it
            New-ADOrganizationalUnit -Name $subouName -Path $subchildOUPath -PassThru
            Write-Host "Created OU: $subouName"
        } else {
            Write-Host "Skipped creating OU: $subouName. It already exists."
        }
    }
}

# Confirm the OUs were created
Get-ADOrganizationalUnit -Filter 'Name -like "*"'
