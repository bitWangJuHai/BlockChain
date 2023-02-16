//range索引及map（集合）
package main

import (
	"fmt"
)

func main(){
	var pow []int = []int{1, 2, 4, 8, 16, 32, 64, 128, 256, 512}	

	//在循环内改变pow不会增加循环次数，在循环开始之前range表达式已经构建完成
	for i, v := range pow {
		fmt.Printf("2**%d = %d\n", i, v)
		pow = append(pow, i)
	}
	fmt.Println(pow)

	var map1 map[int]int = make(map[int]int)
	
	//若不对map进行初始化生成nilmap，无法存放键值
	map1 [ 1 ] = 6
	map1 [ 2 ] = 5
	map1 [ 3 ] = 4
	map1 [ 4 ] = 3
	map1 [ 5 ] = 2
	map1 [ 6 ] = 1
	map1 [ 7 ] = 17
	map1 [ 8 ] = 18
	map1 [ 9 ] = 19
	fmt.Println(map1)

	//map在迭代时访问顺序随机，若在迭代中插入新key value迭代次数也随机
	for key, value := range map1 {
		//fmt.Println(key)
		map1 [ value ] = key	
		fmt.Println(map1)
	}
	fmt.Println(map1)

	//检查元素在集合中是否存在
	value, ok := map1 [ 6 ]
	if (ok){
		fmt.Println("6在map中,对应值是", value)
	} else {
		fmt.Println("6不在map中")
	}

	//delete的用法
	delete(map1, 7)
	fmt.Println(map1)

	//range迭代字符串是以utf8编码迭代，并不是以字节迭代
	for pos, value := range "我hh笑" {
		fmt.Println(pos, value)
	}
}