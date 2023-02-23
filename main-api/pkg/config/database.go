package config

type ServerConfiguration struct {
	Port                       string
	Secret                     string
	AccessTokenExpireDuration  int
	RefreshTokenExpireDuration int
	LimitCountPerRequest       float64
	StaticProxy                bool
	Proxies                    map[string][]string
}
