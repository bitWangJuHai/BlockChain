//指针
package main

import(
	"fmt"
)

const MAX int = 3

func main(){
	var a int = 1
	var ptr1, ptr2 *int = &a, nil

	fmt.Println(a, *ptr1, ptr1, &a, ptr2)

	var arr_value [MAX]int = [MAX]int{10, 100, 1000}
	var arr_int_ptr [MAX]*int
	for i := range arr_value {
		arr_int_ptr[i] = &arr_value[i];
	}
	for i := range arr_int_ptr {
		fmt.Println(*arr_int_ptr[i])
	}
}