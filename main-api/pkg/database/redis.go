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
		Addr:     fmt.Sprintf("%v:%v", getConfig.Redis.Redishost, getConfig.Redis.Redisport),
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	if err := rdb.Ping(Ctx).Err(); err != nil {
		fmt.Printf("%v:%v", getConfig.Redis.Redishost, getConfig.Redis.Redisport)
		log.Fatalln("Redis db error: ", err)
	}
	pong, _ := rdb.Ping(Ctx).Result()
	fmt.Println("Redis says: ", pong)
	Rds = rdb
}

func GetRedisDb() *redis.Client {
	return Rds
}
