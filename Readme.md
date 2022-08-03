# Browser Switcher
Browser switcher is a small utility to open URLs in a different browser / profile based on predefined URL patterns. For example: When clicking on links in emails, slack, etc., you can configure browser switcher to open the link in your personal or work chrome profile based on the URL. It will be useful for people who use different profiles/browsers for personal uses and work.

## How it works
1. Browser switcher will configure itself as the default browser for all links.
2. When you click a link in an app, that app will invoke browser switcher with the URL as a parameter.
3. Browser switcher will then parse your configuration and decides which profile to use based on the patterns defined.
4. Then corresponding command for the profile will be executed.

## Installation
To install browser switcher, run the following command:
```
curl -Ls https://raw.githubusercontent.com/kishorv06/browser-switcher/main/install.sh | bash -s
```
After installing, create configuration file with profiles at `~/.local/etc/browser-switcher.yaml`. Example:
```yaml
# Profile Configurations.
profiles:
  # Use a unique name for each browser/profile combination.
  - name: chrome-private
    # Command to execute when opening a page with this profile.
    # %s will be replaced by the URL.
    command: "google-chrome --profile-directory='Default' %s"

  - name: chrome-work
    command: "google-chrome --profile-directory='Profile 1' %s"
    # List of URLs (regex) for which this profile should be used.
    filters:
      - 'https?://.*\.workdomain\.com/?.*'

# Default profile for URL not matching any of the filters
default_profile: chrome-private


```