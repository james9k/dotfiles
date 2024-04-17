import argparse
import json
import subprocess
import urllib.parse
import urllib.request

from pprint import pprint

base_rpc_url = "https://aur.archlinux.org/rpc/v5/info"
config = {
    "upgrade": False,
    "verbosity": 0,
}
COLOUR_GREEN = "\033[1;32m"
COLOUR_RED = "\033[1;31m"
COLOUR_RESET = "\033[0m"


def output(payload, level=0, payload_type="string"):
    if config["verbosity"] >= 3:
        print(f'Verbosity Level: {config["verbosity"]}')

    if 0 <= level <= config["verbosity"] and payload_type == "string":
        print(payload)
    elif 0 <= level <= config["verbosity"] and payload_type == "json":
        print(json.dumps(payload, indent=2))
    elif 0 <= level <= config["verbosity"] and payload_type == "dict":
        pprint(payload)


def get_installed_aur_pkgs():
    """Use pacman to query foreign installed packages e.g. AUR packages.
    Returns a list of tuples with (pkg name, pkg version)
    """
    result = subprocess.run(["pacman", "-Qm"], capture_output=True)
    output(result, level=2)
    lines = result.stdout.decode().strip().split("\n")
    return [tuple(l.split(" ")) for l in lines]


def get_installed_aur_pkg_names():
    """Get just the names of installed AUR packages."""
    pkgs = get_installed_aur_pkgs()
    pkg_names = [p[0] for p in pkgs]
    output(f"pkg_names: {pkg_names}", level=1)
    return pkg_names


def aur_rpc_request(url: str):
    output(f"Requesting: {url}", level=1)
    request = urllib.request.Request(url)

    with urllib.request.urlopen(request) as response:
        response_data = response.read().decode("utf-8")
    data = json.loads(response_data)
    output(data, level=2, payload_type="dict")
    output(f"Packages: {data['resultcount']}", level=1)
    return data


def aur_rpc_info_single_package(pkg_name: str):
    url = f"{base_rpc_url}/{pkg_name}"

    return aur_rpc_request(url)


def aur_rpc_info_multiple_packages(pkg_names: list):
    query_string = [("arg[]", p) for p in pkg_names]
    encoded_query_string = urllib.parse.urlencode(query_string)
    url = f"{base_rpc_url}?{encoded_query_string}"

    return aur_rpc_request(url)


def arguments():
    """"""
    main_parser = argparse.ArgumentParser(
        prog="aur_pkg_tool.py",
        description="Upgrade AUR packages, by default only checks use -u to do the actual upgrade.",
        epilog="",
    )
    main_parser.version = "0.0.1"
    main_parser.add_argument(
        "--version", action="version", help="Shows the version of the program and exits"
    )
    main_parser.add_argument(
        "--verbose", "-v", action="count", help="Increase verbosity", default=0
    )
    main_parser.add_argument(
        "--upgrade", "-u", action="store_true", help="Go ahead and upgrade the package"
    )
    main_parser.add_argument(
        dest="pkgs",
        metavar="pkg",
        nargs="*",
        default=[],
        help="List of pkgs to upgrade.",
    )

    return {
        "main": main_parser,
    }


def find_longest_strings(aur_data):
    """Loop through data returned from AUR RPC and find the longest package name, and version string"""
    installed_names_versions = get_installed_aur_pkgs()
    installed_versions = [i[1] for i in installed_names_versions]

    aur_names = []
    aur_versions = []
    for result in aur_data.get("results", []):
        aur_names.append(result.get("Name"))
        aur_versions.append(result.get("Version"))

    longest_name = max(aur_names, key=len)
    longest_installed_version = max(installed_versions, key=len)
    longest_aur_version = max(aur_versions, key=len)

    name_length = len(longest_name)
    installed_version_length = len(longest_installed_version)
    aur_version_length = len(longest_aur_version)

    output(
        f"Longest strings: {longest_name}:{name_length} {longest_installed_version}:{installed_version_length} {longest_aur_version}:{aur_version_length}",
        level=1,
    )
    return name_length, installed_version_length, aur_version_length


def handle_versions(aur_data: dict) -> None:
    """Check versions and display them. Upgrade package if upgrade flag is set."""
    installed_name_and_versions = get_installed_aur_pkgs()
    name_length, installed_version_length, aur_version_length = find_longest_strings(
        aur_data
    )

    for result in aur_data.get("results", []):
        aur_name = result.get("Name")
        out_of_date = result.get("OutOfDate")
        aur_version = result.get("Version")

        for installed_name, installed_version in installed_name_and_versions:
            if installed_name == aur_name:
                newer_version = aur_version > installed_version
                if out_of_date is not None:
                    aur_version = f"{COLOUR_RED}{aur_version}{COLOUR_RESET}"
                elif newer_version:
                    aur_version = f"{COLOUR_GREEN}{aur_version}{COLOUR_RESET}"

                print(
                    f"{aur_name:<{name_length}} {installed_version:^{installed_version_length}} --> {aur_version:<{aur_version_length}}"
                )

                if newer_version and config["upgrade"]:
                    print(f"Upgrading package: {aur_name}")
                    upgrade_pkg(aur_name)

                break


def upgrade_pkg(pkg_name: str):
    result = subprocess.run(["aur_upgrade_single_pkg", pkg_name], capture_output=True)
    output(result.stdout.decode())


def main():
    parsers = arguments()
    main_parser = parsers["main"]
    args = main_parser.parse_args()

    if args.verbose:
        config["verbosity"] = args.verbose

    if args.upgrade:
        config["upgrade"] = args.upgrade

    output(args, level=1)

    if len(args.pkgs) == 1:
        output(args.pkgs, level=1)
        aur_data = aur_rpc_info_single_package(args.pkgs[0])
        handle_versions(aur_data)
    elif len(args.pkgs) > 1:
        output(args.pkgs, level=1)
        aur_data = aur_rpc_info_multiple_packages(args.pkgs)
        handle_versions(aur_data)
    elif len(args.pkgs) == 0:
        print("Getting all installed AUR packages.")
        names = get_installed_aur_pkg_names()
        aur_data = aur_rpc_info_multiple_packages(names)
        handle_versions(aur_data)
    else:
        main_parser.print_help()


if __name__ == "__main__":
    main()
