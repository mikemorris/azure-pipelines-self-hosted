param (
    [string]$URL,
    [string]$TOKEN,
    [string]$POOL,
    [string]$AGENT
)

Start-Transcript
Write-Host "start"

# Test if an old installation exists, if so, delete the folder.

if (test-path "c:\agent")
{
    Remove-Item -Path "c:\agent" -Force -Confirm:$false -Recurse
}

# Create a new folder

new-item -ItemType Directory -Force -Path "c:\agent"
set-location "c:\agent"

# TODO: Is this necessary? What is it doing?
$env:VSTS_AGENT_HTTPTRACE = $true

# GitHub requires TLS 1.2

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Get the latest build agent version

$wr = Invoke-WebRequest https://api.github.com/repos/Microsoft/azure-pipelines-agent/releases/latest -UseBasicParsing
$tag = ($wr | ConvertFrom-Json)[0].tag_name
$tag = $tag.Substring(1)

write-host "$tag is the latest version"

$download = "https://vstsagentpackage.azureedge.net/agent/$tag/vsts-agent-win-x64-$tag.zip"

Invoke-WebRequest $download -Out agent.zip

# Expand the zip

Expand-Archive -Path agent.zip -DestinationPath $PWD

# Run the config script of the build agent

.\config.cmd --unattended --url "$URL" --auth pat --token "$TOKEN" --pool "$POOL" --agent "$AGENT" --replace --runAsService

Stop-Transcript
exit 0
