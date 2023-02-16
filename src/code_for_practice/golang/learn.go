package main		//每个go文件必须有归属的包
//import "fmt"		//引入程序需要用的包，为了使用包下的函数

import(
	"fmt"
	"unsafe"
)

var(
	a int
	b int
	c int
)

func main(){
	//fmt.Println("Hello Golang!")
	/*
	var age1 int = 0		
	var age2 = 1			//自动类型推断为int型
	age3 := 1.5			//省略var
	*/
	var age4,age5,age6 int = 4,5,6
	const c_name = "Wang"

	
	fmt.Println("age = ", age4, age5, age6)
	fmt.Println()
	fmt.Println(unsafe.Sizeof(age4))
	
	fmt.Println(len(c_name))
	fmt.Println(unsafe.Sizeof(c_name))

	//
	const(
		a = 1
		b
		c = iota
		d = "haha"
		e = "wuwu"
		f
		g = iota
		h = 1<<iota
		i 
		j = 4
		k 
		l = iota
	)

	fmt.Println(a,b,c,d,e,f,g,h,i,j,k,l)	//1 1 2 haha wuwu 6 128 256 4 4 11
	//test()
	//test2()
	//test3()
	//test4()
	
	// var swap1, swap2 = swap_value("111", "222")
	// fmt.Println(swap1, swap2)
	// swap_reference(&swap1, &swap2)
	// fmt.Println(swap1, swap2)
}

func test(){
	a = 1
	b = 5

	if a < 10 {
		fmt.Println("haha")
	} else {
		fmt.Println("wuwu")
	}

	if b > 5 {
		fmt.Println("b>5")
		if b >= 10 {
			fmt.Println("b>=10")
		} else {
			fmt.Println("5<b<10")
		}
	} else {
		fmt.Println("b<=5")
	}
}

func test2(){
	var a = 1

	switch a {
		case 2:
			fmt.Println(2)
			fallthrough
		case 1:
			fmt.Println(1)
			fallthrough
		case 3:
			fmt.Println(3)
		default:
			fmt.Println("other")
	}
}

func test3(){
	var a = 0
	var b = 2
	var string1 [2]string = [2]string{"google", "runood"}

	for i := 0; i <= 10; i++ {
		a += i
	}
	fmt.Println(a)
	for b < 10 {
		b += b
	}
	fmt.Println(b)
	for i, s := range string1 {
		fmt.Println(i, s)
	}
}

func test4(){
	var i, j int = 0, 0
	var tmp int = 0

	fmt.Println("2 是素数")
	for i = 3; i < 100; i += 2 {
		tmp = 0
		for j = 3; j <= i / j; j++ {
			if i % j == 0 {
				tmp = 1
				break
			}
		}
		if tmp == 0 {
			fmt.Println(i, "是素数")
		}
	}
}

func swap_value(x, y string)(string, string){
	return y, x
}

func swap_reference(x, y *string){
	var tmp string = "default_string"

	tmp = *x
	*x = *y
	*y = tmp
}