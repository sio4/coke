package grifts

import (
  "github.com/gobuffalo/buffalo"
	"coke/actions"
)

func init() {
  buffalo.Grifts(actions.App())
}
