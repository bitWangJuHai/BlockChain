//go语言函数递归
package main

import (
	"fmt"
)

func factorial(n uint64) uint64 {
	if n > 0 {
		return n * factorial(n - 1)
	} else {
		return 1
	}
}

func fibonacci(n int) int {
	if n < 2 {
		return n
	} else {
		return fibonacci(n - 1) + fibonacci(n - 2)
	}
}

func main(){
	fmt.Println(factorial(5))
	fmt.Println(fibonacci(6))
}