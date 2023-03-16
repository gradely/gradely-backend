package notification

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/gradely/gradely-backend/pkg/config"
	"io"
	"io/ioutil"
	"net/http"
	"net/url"
	"strconv"
)

type NotificationModel struct {
	ActionName string                 `db:"action_name" json:"action_name"`
	ReceiverID string                 `db:"receiver_id" json:"receiver_id,omitempty"`
	ActionData map[string]interface{} `db:"action_data" json:"action_data"`
}

func (payload *NotificationModel) SendNotification() error {
	getConfig := config.GetConfig()
	baseUrl := getConfig.Notification.BaseUrl
	method := "POST"

	Url, err := url.Parse(baseUrl + "/notification/v2.1")
	if err != nil {
		fmt.Println(err)
		return err
	}

	buf := new(bytes.Buffer)
	err = json.NewEncoder(buf).Encode(payload)
	if err != nil {
		return err
	}

	req, _ := http.NewRequest(method, Url.String(), buf)
	req.Header.Add("Content-Type", "application/json")
	client := &http.Client{}

	response, err := client.Do(req)
	if err != nil {
		return err
	}

	_, err = ioutil.ReadAll(response.Body)
	if err != nil {
		return err
	}

	defer func(Body io.ReadCloser) {
		err := Body.Close()
		if err != nil {
			fmt.Println(err)
		}
	}(response.Body)

	if response.StatusCode < 200 && response.StatusCode > 299 {
		return fmt.Errorf("Error " + strconv.Itoa(response.StatusCode))
	}

	return nil
}
