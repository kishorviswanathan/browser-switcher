package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"os/exec"
	"os/user"
	"regexp"

	"gopkg.in/yaml.v2"
)

// Structure for YAML config file
type Config struct {
	DefaultProfile string `yaml:"default_profile"`
	Profiles       []struct {
		Name    string   `yaml:"name"`
		Command string   `yaml:"command"`
		Filters []string `yaml:"filters"`
	} `yaml:"profiles"`
}

// Find profile by URL
func FindProfile(url string, config Config) string {
	for _, profile := range config.Profiles {
		for _, filter := range profile.Filters {
			matched, _ := regexp.MatchString(filter, url)
			if matched {
				return profile.Name
			}
		}
	}
	return config.DefaultProfile
}

// Find command for profile
func FindCommand(profileName string, config Config) string {
	for _, profile := range config.Profiles {
		if profile.Name == profileName {
			return profile.Command
		}
	}
	return ""
}

// Run command
func RunCommand(command string) {
	cmd := exec.Command("sh", "-c", command)
	err := cmd.Run()
	if err != nil {
		panic(err)
	}
}

// Open URL in given browser
func OpenUrlInProfile(profile string, url string, config Config) {
	fmt.Printf("Opening url in profile '%s'\n", profile)
	command := FindCommand(profile, config)
	if command != "" {
		command = fmt.Sprintf(command, url)
		RunCommand(command)
	}
}

func main() {
	usr, _ := user.Current()
	homedir := usr.HomeDir
	configPath := homedir + "/.local/etc/browser-switcher.yaml"

	// Read YAML from config file
	yamlFile, err := ioutil.ReadFile(configPath)

	if err != nil {
		panic(err)
	}

	// Parse YAML
	var config Config
	err = yaml.Unmarshal(yamlFile, &config)
	if err != nil {
		panic(err)
	}

	// Get URL from command line
	if len(os.Args) > 1 {
		url := os.Args[1]
		profile := FindProfile(url, config)
		OpenUrlInProfile(profile, url, config)
	} else {
		fmt.Println("No URL specified. Usage: browser-switcher <url>")
	}
}
