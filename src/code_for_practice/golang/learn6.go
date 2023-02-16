//切片
package main

import (
	"fmt"
)

func main(){
	//make(类型, 切片初始长度, 容量（切片最长可达多长，可选）)
	//make创建slice时先创建一个数组再闯将一个基于该数组的切片并返回
	var slice1 []int = make([]int, 10)
	var slice2 []int = []int{1, 2, 3}
	var slice3 []int = make([]int, 5, 6) 

	fmt.Println(slice1)
	fmt.Println(slice2)

	var arr1 [10]int
	var slice_arr1 []int
	for i := 0; i < 10; i++ {
		arr1[i] = i
	}
	//slice_arr1 = arr1[:]
	slice_arr1 = arr1[0:10]
	fmt.Println(slice_arr1)

	var slice_nil []int

	fmt.Println(slice_nil)

	slice3 = append(slice3, 11)
	fmt.Println(slice3, cap(slice3))

	var slice3_copy []int = make([]int, len(slice3), cap(slice3) * 2)
	copy(slice3_copy, slice3)			//复制切片
	fmt.Println(slice3_copy, cap(slice3_copy))
	slice3_copy = append(slice3_copy, 1, 2, 3, 4, 5, 6, 7)	//追加超过容量限制，默认容量翻倍
	fmt.Println(slice3_copy, cap(slice3_copy))

	//切片本质上是对底层数组的引用
	var slice4 []int = make([]int, 1, 10)

	slice4_1 := append(slice4, 1)
	slice4_2 := append(slice4, 2)

	fmt.Println(slice4_1)
	fmt.Println(slice4_2)
	//slice4_1和slice4_2都是[0, 2]
}