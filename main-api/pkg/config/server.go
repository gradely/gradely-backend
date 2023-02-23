package config

type DatabaseConfiguration struct {
	Driver         string
	Dbname         string
	CampaignDbname string
	GameDbname     string
	AppDbname      string
	Username       string
	Password       string
	Host           string
	Port           string
	LogMode        bool
}

type RedisConfiguration struct {
	Redishost string
	Redisport string
}

type ParamsConfiguration struct {
	MasterPassword       string
	LiveClassSecretToken string

	//BBB
	LiveClassClient  string
	BBBSecret        string
	BBBServerBaseUrl string

	//Logging
	Sentrydsn      string
	Environment    string
	Debug          bool
	Release        string
	StackTract     bool
	AppBaseUrl     string
	PaystackApiKey string
	SummerSchoolID int
	V2ApiBaseUrl   string
}

type ParamsNotification struct {
	BaseUrl string
}

type EmailConfiguration struct {
	EmailUser     string
	EmailPassword string
	EmailHost     string
	EmailPort     string
}
