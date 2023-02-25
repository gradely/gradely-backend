package config

type ServerConfiguration struct {
	Port                       string              `mapstructure:"PORT"`
	Secret                     string              `mapstructure:"SECRET"`
	AccessTokenExpireDuration  int                 `mapstructure:"ACCESS_TOKEN_EXPIRE_DURATION"`
	RefreshTokenExpireDuration int                 `mapstructure:"REFRESH_TOKEN_EXPIRE_DURATION"`
	LimitCountPerRequest       float64             `mapstructure:"LIMIT_COUNT_PER_REQUEST"`
	StaticProxy                bool                `mapstructure:"STATIC_PROXY"`
	Proxies                    map[string][]string `mapstructure:"PROXIES"`
}
