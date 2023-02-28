package config

import (
	"github.com/mitchellh/mapstructure"
	"github.com/spf13/viper"
	"log"
	"reflect"
	"strconv"
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

var Params ParamsConfiguration

// Setup reads the configuration data from the config file
func Setup(configFile string) {

	var server *ServerConfiguration
	var database *DatabaseConfiguration
	var redis *RedisConfiguration
	var params *ParamsConfiguration

	// get environment variable from .env file
	viper.SetConfigFile(configFile)
	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err != nil {
		log.Fatalf("Error reading config file, %s", err)
	}

	decoderConfigs := []mapstructure.DecoderConfig{
		{
			TagName: "mapstructure",
			Result:  &server,
			//	Convert number in env to int from string
			DecodeHook: mapstructure.ComposeDecodeHookFunc(
				mapstructure.StringToTimeDurationHookFunc(),
				StringToTypeHookFunc(),
			),
		},
		{
			TagName: "mapstructure",
			Result:  &database,
		},
		{
			TagName: "mapstructure",
			Result:  &redis,
		},
		{
			TagName: "mapstructure",
			Result:  &params,
			DecodeHook: mapstructure.ComposeDecodeHookFunc(
				mapstructure.StringToTimeDurationHookFunc(),
				StringToTypeHookFunc(),
			),
		},
	}

	for _, dc := range decoderConfigs {
		decoder, err := mapstructure.NewDecoder(&dc)
		if err != nil {
			log.Fatalf("error creating decoder: %s", err.Error())
		}
		if err := decoder.Decode(viper.AllSettings()); err != nil {
			log.Fatalf("error decoding config: %s", err.Error())
		}
	}
	Config = &Configuration{
		Server:   *server,
		Database: *database,
		Redis:    *redis,
		Params:   *params,
	}
}

func StringToTypeHookFunc() mapstructure.DecodeHookFuncType {
	return func(from, to reflect.Type, data interface{}) (interface{}, error) {
		if from.Kind() == reflect.String && to.Kind() == reflect.Int {
			return convertStringToInt(data.(string))
		} else if from.Kind() == reflect.String && to.Kind() == reflect.Float64 {
			return convertStringToFloat64(data.(string))
		} else if from.Kind() == reflect.String && to.Kind() == reflect.Bool {
			return convertStringToBool(data.(string))
		}
		return data, nil
	}
}

func convertStringToInt(str string) (int, error) {
	i, err := strconv.Atoi(str)
	if err != nil {
		return 0, err
	}
	return i, nil
}

func convertStringToFloat64(str string) (float64, error) {
	value, err := strconv.ParseFloat(str, 64)
	if err != nil {
		return 0, err
	}
	return value, nil
}
func convertStringToBool(str string) (bool, error) {
	i, err := strconv.ParseBool(str)
	if err != nil {
		return false, err
	}
	return i, nil
}

// GetConfig helps you to get configuration data
func GetConfig() *Configuration {
	return Config
}
