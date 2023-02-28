package utility

import "github.com/gradely/gradely-backend/pkg/database"

func RedisDelete(key string) (int64, error) {
	rdb := database.GetRedisDb()
	deleted, err := rdb.Del(database.Ctx, key).Result()
	if err != nil {
		return 0, err
	}
	return deleted, nil
}
