package config

import (
	"github.com/spf13/viper"
	"log"
)

// Config is a global variable that stores the configuration data
var Config *Configuration

type Configuration struct {
	Server       ServerConfiguration
	Database     DatabaseConfiguration
	Redis        RedisConfiguration
	Params       ParamsConfiguration
	Email        EmailConfiguration
	Notification ParamsNotification
}

// Setup initialize configuration
var (
	Params ParamsConfiguration
	Email  EmailConfiguration
)

// Setup reads the configuration data from the config file
func Setup() {
	var configuration *Configuration

	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath(".")

	if err := viper.ReadInConfig(); err != nil {
		log.Fatalf("Error reading config file, %s", err)
	}

	err := viper.Unmarshal(&configuration)
	if err != nil {
		log.Fatalf("Unable to decode into struct, %v", err)
	}

	Params = configuration.Params
	Email = configuration.Email
	Config = configuration
}

// GetConfig helps you to get configuration data
func GetConfig() *Configuration {
	return Config
}
