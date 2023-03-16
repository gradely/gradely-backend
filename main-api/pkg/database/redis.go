package database

import (
	"context"
	"fmt"
	"github.com/go-redis/redis/v8"
	"github.com/gradely/gradely-backend/pkg/config"
	"log"
)

var (
	Rds *redis.Client
	Ctx = context.Background()
)

func SetupRedis() {
	getConfig := config.GetConfig()
	rdb := redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%v:%v", getConfig.Redis.RedisHost, getConfig.Redis.RedisPort),
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	if err := rdb.Ping(Ctx).Err(); err != nil {
		fmt.Printf("The redis conection: %v:%v", getConfig.Redis.RedisHost, getConfig.Redis.RedisPort)
		log.Fatalln("Redis db error: ", err)
	}

	// Set the global variable
	Rds = rdb
}

func GetRedisDb() *redis.Client {
	return Rds
}
