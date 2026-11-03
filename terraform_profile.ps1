function terraform {
    $repositoryRoot = $PSScriptRoot
    $runnerPath = Join-Path $repositoryRoot 'terraform_runner.py'

    if ($args.Count -ge 3) {
        $basePath = if ([System.IO.Path]::IsPathRooted([string]$args[0])) {
            [System.IO.Path]::GetFullPath([string]$args[0])
        } else {
            [System.IO.Path]::GetFullPath((Join-Path $repositoryRoot ([string]$args[0])))
        }
        $rootPrefix = [System.IO.Path]::GetFullPath($repositoryRoot).TrimEnd('\') + '\'

        if (
            $basePath.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase) -and
            (Test-Path -LiteralPath (Join-Path $basePath 'main.tf') -PathType Leaf)
        ) {
            $python = Get-Command python -CommandType Application -ErrorAction SilentlyContinue |
                Select-Object -First 1
            if (-not $python) {
                Write-Error 'Python was not found. Install Python and ensure it is on PATH.'
                return 127
            }

            & $python.Source $runnerPath @args
            return $LASTEXITCODE
        }
    }

    $terraformExecutable = Get-Command terraform -CommandType Application -ErrorAction SilentlyContinue |
        Select-Object -First 1
    if (-not $terraformExecutable) {
        Write-Error 'Terraform was not found. Install Terraform and ensure it is on PATH.'
        return 127
    }

    & $terraformExecutable.Source @args
    return $LASTEXITCODE
}
