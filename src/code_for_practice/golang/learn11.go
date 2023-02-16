//leetcode：两数之和，O(n2)
package main

import (
	"fmt"
)

func twoSum(nums []int, target int) []int {

	var res []int = []int{0, 0}
	var len int = len(nums)
	for i := 0; i < len - 1; i++ {
		for j := i + 1; j < len; j++ {
			if nums[ i ] + nums[ j ] == target {
				res[ 0 ] = i
				res[ 1 ] = j
				break
			}
		}
	}
	return res
}

func main(){
	var test_arr1 []int = []int{3, 2, 4}//{5, 7, 11, 2, 8, 3, 1}
	var ans1 int = 6//5

	var test_arr2 []int = []int{3, 3}//{2, 7, 11, 15}
	var ans2 int = 6//9

	fmt.Println(twoSum(test_arr1, ans1))
	fmt.Println(twoSum(test_arr2, ans2))
}
