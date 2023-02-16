//变量作用域
//数组
package main

import (
	"fmt"
)

var a int = 10
var b int = 11

func main(){
	var a int = 5
	fmt.Println(a)

	var arr1 [10] int = [10]int{1, 2, 7, 8, 9, 10, 9:11}
	for i := 0; i < 10; i++ {
		fmt.Println(arr1[i])
	}

	//var arr [x][y] int  x行y列的二维数组
	var arr2 [2][3] int = [2][3]int{{8, 8, 8}, {8, 8, 8}}
	var row1 [] int = []int{1, 2, 3}
	var row2 [] int = []int{4, 5, 6}
	arr2 = append(arr2, row1)
	arr2 = append(arr2, row2)
	fmt.Println(arr2[0])
	fmt.Println(arr2[1])

	//各行元素数量不等的二维数组
	var arr3 [][] string = [][]string{
		{"fish", "shark", "eel"},
		{"brid"},
		{"lizard", "salamander"}}

	for i := range arr3 {
		fmt.Println(arr3[i])
	}

}