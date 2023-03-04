package utility

import (
	"crypto/rand"
	"fmt"
	"github.com/dongri/phonenumber"
	"github.com/go-playground/locales/en"
	ut "github.com/go-playground/universal-translator"
	"github.com/go-playground/validator/v10"
	enTranslations "github.com/go-playground/validator/v10/translations/en"
	"io"
	"strings"
)

type StagStr struct {
	Value string
}

func ValidationResponse(err error, validate *validator.Validate) validator.ValidationErrorsTranslations {
	errs := err.(validator.ValidationErrors)
	english := en.New()
	uni := ut.New(english, english)
	trans, _ := uni.GetTranslator("en")
	_ = enTranslations.RegisterDefaultTranslations(validate, trans)
	return errs.Translate(trans)
}

func ValidateNumber(number string) (string, error) {
	// Check if number is empty
	if number == "" {
		return "", fmt.Errorf("empty number")
	}

	// Create a StagStr object to make string operations easier
	stringData := StagStr{Value: number}

	// If the number contains a plus sign, parentheses, or its length is greater than 11, assume it's in the correct format
	if stringData.Contains("+") || stringData.Contains("(") || len(number) > 11 {
		return number, nil
	}

	// If the number starts with 0, replace it with 234 (Nigeria's international calling code)
	if string(number[0]) == "0" {
		return strings.Replace(number, "0", "234", 1), nil
	}

	// If the number is a valid Nigerian phone number, return it
	includeLandLine := true // include landlines in the search
	if country := phonenumber.GetISO3166ByNumber(number, includeLandLine); country.CountryName != "" {
		return number, nil
	}

	// If the number is not in the correct format or is not a valid Nigerian phone number, return an error
	return number, fmt.Errorf("wrong format")
}

// Contains checks if a given substring is present in the string value of the StagStr struct
func (str StagStr) Contains(val string) bool {
	// loop through each character in the string value of the struct
	for _, v := range str.Value {
		if string(v) == val { // if the character matches the substring, return true
			return true
		}
	}
	return false // substring not found, return false
}

// GenerateString This function accept length and it generates random string
func GenerateString(length int) string {
	table := [...]byte{'1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'}
	b := make([]byte, length)
	_, _ = io.ReadAtLeast(rand.Reader, b, length)
	for i := 0; i < len(b); i++ {
		b[i] = table[int(b[i])%len(table)]
	}
	return string(b)
}

func GenerateLetters(length int) string {
	table := [...]byte{'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'}
	b := make([]byte, length)
	_, _ = io.ReadAtLeast(rand.Reader, b, length)
	for i := 0; i < len(b); i++ {
		b[i] = table[int(b[i])%len(table)]
	}
	return string(b)
}
