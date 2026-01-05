import sys
import unittest
from unittest.mock import patch, MagicMock, call
from pathlib import Path

# Add the bin directory to the path so we can import aur_pkg_tool
bin_dir = Path(__file__).parent.parent / "bin"
sys.path.insert(0, str(bin_dir))

import aur_pkg_tool

class TestAurPkgTool(unittest.TestCase):
    """Test cases for aur_pkg_tool.py functions"""

    def setUp(self):
        """Set up test fixtures before each test method"""
        # Reset config to default state
        aur_pkg_tool.config = {
            "upgrade": False,
            "verbosity": 0,
        }

    @patch('aur_pkg_tool.subprocess.run')
    def test_get_installed_aur_pkgs(self, mock_run):
        """Test getting installed AUR packages"""
        # Mock the subprocess output
        mock_result = MagicMock()
        mock_result.stdout = b"package1 1.0.0\npackage2 2.0.0\n"
        mock_run.return_value = mock_result

        result = aur_pkg_tool.get_installed_aur_pkgs()

        # Verify the result
        self.assertEqual(result, [('package1', '1.0.0'), ('package2', '2.0.0')])
        mock_run.assert_called_once_with(['pacman', '-Qm'], capture_output=True)

    @patch('aur_pkg_tool.get_installed_aur_pkgs')
    def test_get_installed_aur_pkg_names(self, mock_get_pkgs):
        """Test getting just package names"""
        mock_get_pkgs.return_value = [('package1', '1.0.0'), ('package2', '2.0.0')]

        result = aur_pkg_tool.get_installed_aur_pkg_names()

        self.assertEqual(result, ['package1', 'package2'])

    @patch('aur_pkg_tool.urllib.request.urlopen')
    def test_aur_rpc_info_single_package(self, mock_urlopen):
        """Test AUR RPC request for single package"""
        # Mock the response
        mock_response = MagicMock()
        mock_response.read.return_value = b'{"resultcount": 1, "results": [{"Name": "test-pkg"}]}'
        mock_response.__enter__ = MagicMock(return_value=mock_response)
        mock_response.__exit__ = MagicMock(return_value=False)
        mock_urlopen.return_value = mock_response

        result = aur_pkg_tool.aur_rpc_info_single_package("test-pkg")

        self.assertEqual(result['resultcount'], 1)
        self.assertEqual(result['results'][0]['Name'], 'test-pkg')

    def test_is_version_newer(self):
        """Test version comparison"""
        self.assertTrue(aur_pkg_tool.is_version_newer("2.0.0", "1.0.0"))
        self.assertFalse(aur_pkg_tool.is_version_newer("1.0.0", "2.0.0"))
        self.assertFalse(aur_pkg_tool.is_version_newer("1.0.0", "1.0.0"))
        self.assertTrue(aur_pkg_tool.is_version_newer("1.0.101", "1.0.91"))

    @patch('aur_pkg_tool.subprocess.run')
    def test_upgrade_pkg(self, mock_run):
        """Test package upgrade function"""
        mock_result = MagicMock()
        mock_result.stdout = b"Upgrade complete\n"
        mock_run.return_value = mock_result

        aur_pkg_tool.upgrade_pkg("test-pkg")

        mock_run.assert_called_once_with(
            ['aur_upgrade_single_pkg', 'test-pkg'],
            capture_output=True
        )


if __name__ == '__main__':
    unittest.main()