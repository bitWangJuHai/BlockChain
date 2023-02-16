//go语言错误处理 函数返回时return的用法 if初始化子句 标识符重声明
package main

import (
	"fmt"
)

type DivideError struct {
	dividee int
	divider int 
}

func (de DivideError) Error() string {
	strFormat := `
	Cannot procees, the divider is zero.
	dividee: %d
	divider: 0
`
	return fmt.Sprintf(strFormat, de.dividee)
}

func Divide(varDividee int, varDivider int) (result int, errorMsg string) {
	if varDivider == 0 {
		var dData DivideError = DivideError{
			dividee: varDividee,
			divider: varDivider,
		}
		//result = 1
		errorMsg = dData.Error()
		return			//直接写return默认返回定义时声明的作为返回值的变量
	} else {
		return varDividee / varDivider, ""
	}
}

func main() {
	if result, errorMsg := Divide(100, 10); errorMsg == "" {	//if语句的初始化子句
		fmt.Println("100/10 = ", result)
	}

	if result, errorMsg := Divide(100, 0); errorMsg != "" {
		fmt.Println("errorMsg is: ", errorMsg)
		fmt.Println(result)
	}

	var number int =  10	
	if number := 4; number < 100 {	//对number标识符进行重声明 不影响if语句外声明的number
		number += 3
		//fmt.Println(number)
	} else if number > 100 {
		number -= 2
	} else {
		fmt.Println("OK!")
	}
	fmt.Println(number)
}