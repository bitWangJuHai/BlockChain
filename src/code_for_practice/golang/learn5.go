//结构体
package main

import (
	"fmt"
)

type Books struct {
	title string
	author string
	subject string
	book_id int
}

func main(){
	var book1 Books = Books{"Go 语言", "www.xxxxx", "Go语言教程", 6495407}
	var book2 Books = Books{title:"Go 语言", subject:"Go语言教程", author:"www.xxxxx"}
	fmt.Println(book1)
	fmt.Println(book2)

	book1.title = "GoGo"
	fmt.Println(book1)

	var ptr_book1 *Books = &book1
	ptr_book1.title = "GGGGGGG"
	fmt.Println(ptr_book1, book1.title)

	var a int = 5
	var ptr_a *int = &a
	fmt.Println(ptr_a, a)
}