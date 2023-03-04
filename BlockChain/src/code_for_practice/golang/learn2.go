//闭包、函数方法的学习
package main

import (
	"fmt"
	// "unsafe"
	// "math"
)

type Circle struct {
	radius float64
}

func accumulate(value int) func(int) int {
	return func(count int) int {
		value += count
		return value
	}
}

func playerGen(name string) func() (string, int){

	var hp int = 150

	return func() (string, int){
		return name, hp
	}
}

func main(){
	// var accumulator1 func(int) int = accumulate(0)
	// var accumulator2 func(int) int = accumulate(1)

	// fmt.Println(accumulator1(1))
	// fmt.Println(accumulator1(2))
	// fmt.Println(accumulator1(1))

	// fmt.Println(accumulator2(1))
	// fmt.Println(accumulator2(0))
	// fmt.Println(accumulator2(2))

	var player1 func() (string, int) = playerGen("wang")
	fmt.Println(player1())

	var c1 Circle
	c1.radius = 10
	fmt.Println(c1.getArea())
}

func (c Circle) getArea() float64 {
	return 3.14 * c.radius * c.radius 
}