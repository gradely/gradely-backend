package auth

import (
	"github.com/gin-gonic/gin"
	response "github.com/gradely/gradely-backend/pkg/common"
	"github.com/gradely/gradely-backend/pkg/middleware"
	"github.com/gradely/gradely-backend/service/auth"
	"github.com/gradely/gradely-backend/utility"
	"net/http"
)

func (ctrl *Controller) FindStudentWithCode(c *gin.Context) {
	form := struct {
		Code string `json:"code"  validate:"required"`
	}{}
	err := c.ShouldBind(&form)

	if err != nil {
		rd := response.BuildErrorResponse(http.StatusBadRequest, "error", "Failed to parse request body", err.Error(), nil)
		c.JSON(http.StatusBadRequest, rd)
		return
	}

	err = ctrl.Validate.Struct(&form)
	if err != nil {
		rd := response.BuildErrorResponse(http.StatusBadRequest, "error", "Validation failed", utility.ValidationResponse(err, ctrl.Validate), nil)
		c.JSON(http.StatusBadRequest, rd)
		return
	}

	user, err := auth.FindStudentWithCode(form.Code)
	if err != nil {
		rd := response.BuildErrorResponse(http.StatusInternalServerError, "error", err.Error(), err, nil)
		c.JSON(http.StatusInternalServerError, rd)
		return
	}

	rd := response.BuildResponse(http.StatusOK, "successful", user)
	c.JSON(http.StatusOK, rd)
}

func (ctrl *Controller) ConnectToStudent(c *gin.Context) {
	form := struct {
		ID           int    `json:"id"  validate:"required"`
		Relationship string `json:"relationship"  validate:"required"`
	}{}
	err := c.ShouldBind(&form)

	if err != nil {
		rd := response.BuildErrorResponse(http.StatusBadRequest, "error", "Failed to parse request body", err.Error(), nil)
		c.JSON(http.StatusBadRequest, rd)
		return
	}

	err = ctrl.Validate.Struct(&form)
	if err != nil {
		rd := response.BuildErrorResponse(http.StatusBadRequest, "error", "Validation failed", utility.ValidationResponse(err, ctrl.Validate), nil)
		c.JSON(http.StatusBadRequest, rd)
		return
	}

	err = auth.ConnectToStudent(form.ID, form.Relationship, middleware.MyIdentity)
	if err != nil {
		rd := response.BuildErrorResponse(http.StatusInternalServerError, "error", err.Error(), err, nil)
		c.JSON(http.StatusInternalServerError, rd)
		return
	}

	rd := response.BuildResponse(http.StatusOK, "successful", gin.H{"status": true})
	c.JSON(http.StatusOK, rd)
}
func (ctrl *Controller) AddChild(c *gin.Context) {
	form := struct {
		FirstName    string `json:"first_name"  validate:"required"`
		LastName     string `json:"last_name"  validate:"required"`
		Class        int    `json:"class"  validate:"required"`
		Relationship string `json:"relationship"  validate:"required"`
	}{}
	err := c.ShouldBind(&form)

	if err != nil {
		rd := response.BuildErrorResponse(http.StatusBadRequest, "error", "Failed to parse request body", err.Error(), nil)
		c.JSON(http.StatusBadRequest, rd)
		return
	}

	err = ctrl.Validate.Struct(&form)
	if err != nil {
		rd := response.BuildErrorResponse(http.StatusBadRequest, "error", "Validation failed", utility.ValidationResponse(err, ctrl.Validate), nil)
		c.JSON(http.StatusBadRequest, rd)
		return
	}

	child, err := auth.AddChild(form.FirstName, form.LastName, form.Class, form.Relationship, middleware.MyIdentity)
	if err != nil {
		rd := response.BuildErrorResponse(http.StatusInternalServerError, "error", err.Error(), err, nil)
		c.JSON(http.StatusInternalServerError, rd)
		return
	}

	rd := response.BuildResponse(http.StatusOK, "successful", child)
	c.JSON(http.StatusOK, rd)
}

func (ctrl *Controller) GetStudentRelations(c *gin.Context) {
	form := struct {
		Code  string `json:"code"`
		Email string `json:"email"`
		Phone string `json:"phone"`
	}{}
	err := c.ShouldBind(&form)

	if err != nil {
		rd := response.BuildErrorResponse(http.StatusBadRequest, "error", "Failed to parse request body", err.Error(), nil)
		c.JSON(http.StatusBadRequest, rd)
		return
	}

	err = ctrl.Validate.Struct(&form)
	if err != nil {
		rd := response.BuildErrorResponse(http.StatusBadRequest, "error", "Validation failed", utility.ValidationResponse(err, ctrl.Validate), nil)
		c.JSON(http.StatusBadRequest, rd)
		return
	}

	relations, err := auth.GetStudentRelations(form.Code, form.Email, form.Phone, middleware.MyIdentity)
	if err != nil {
		rd := response.BuildErrorResponse(http.StatusInternalServerError, "error", err.Error(), err, nil)
		c.JSON(http.StatusInternalServerError, rd)
		return
	}

	rd := response.BuildResponse(http.StatusOK, "successful", relations)
	c.JSON(http.StatusOK, rd)
}
