"""Run Terraform commands for a base configuration and its environment."""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


ROOT_DIR = Path(__file__).resolve().parent
VARIABLE_COMMANDS = {"apply", "destroy", "plan"}


def find_variable_file(base_dir: Path, environment: str) -> Path | None:
    """Find an environment's tfvars file using nested or legacy flat layout."""
    candidates = (
        base_dir / "env" / environment / f"{environment}.tfvars",
        base_dir / f"{environment}.tfvars",
    )
    return next((candidate for candidate in candidates if candidate.is_file()), None)


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Run Terraform in a base folder with an optional environment tfvars file. "
            "PowerShell can dispatch 'terraform BASE ENV COMMAND' through terraform_profile.ps1."
        ),
        epilog=(
            r"PowerShell example: python .\terraform_runner.py "
            r".\base_eks_cluster\ dev init"
        ),
    )
    parser.add_argument("base_folder", help="Terraform configuration folder")
    parser.add_argument("environment", help="Environment name, such as dev")
    parser.add_argument("command", help="Terraform subcommand, such as init or plan")
    parser.add_argument(
        "terraform_args",
        nargs=argparse.REMAINDER,
        help="Additional arguments passed to Terraform",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_arguments()
    base_dir = (ROOT_DIR / args.base_folder).resolve()

    if not base_dir.is_relative_to(ROOT_DIR) or not (base_dir / "main.tf").is_file():
        print(f"Error: '{args.base_folder}' is not a Terraform base folder.", file=sys.stderr)
        return 2

    environment = Path(args.environment)
    if environment.name != args.environment or args.environment in {".", ".."}:
        print("Error: environment must be a single folder name.", file=sys.stderr)
        return 2

    terraform_args = list(args.terraform_args)
    if terraform_args and terraform_args[0] == "--":
        terraform_args.pop(0)

    command = [args.command, *terraform_args]
    if args.command in VARIABLE_COMMANDS and not any(
        item == "-var-file"
        or item.startswith("-var-file=")
        or item == "-var"
        or item.startswith("-var=")
        for item in terraform_args
    ):
        variable_file = find_variable_file(base_dir, args.environment)
        if variable_file is None:
            print(
                f"Error: no variables file found for '{args.environment}' in "
                f"'{base_dir / 'env' / args.environment}' or '{base_dir}'.",
                file=sys.stderr,
            )
            return 2
        command.append(f"-var-file={variable_file.relative_to(base_dir)}")

    try:
        return subprocess.run(["terraform", *command], cwd=base_dir, check=False).returncode
    except FileNotFoundError:
        print("Error: Terraform was not found. Install it and ensure it is on PATH.", file=sys.stderr)
        return 127


if __name__ == "__main__":
    raise SystemExit(main())
