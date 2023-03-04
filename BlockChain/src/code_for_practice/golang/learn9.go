//接口类型
package main

import (
	"fmt"
)

type Human interface {//Human接口包含Say()方法
	Say()
	Run()
}
type women struct {
}
func (w1 women) Say() {//women类有Say方法，实现了Human接口（实现了全部方法）
	fmt.Println("I'm a women")
}
type man struct {
	Name string
}
func (m1 *man) Say() {
	fmt.Println("I'm a man")
}
func (m1 man) Run() {
	fmt.Println(m1.Name, "are Runing")
}

type Flyable interface {
	Fly()
}
type Climbable interface {
	Climb()
}
type Skills interface {
	Flyable
	Climbable
	Change()
}
type Monkey struct {
	Name string
}
func (monkey1 *Monkey) Climb() {
	fmt.Println(monkey1.Name,"会爬树")
}
type Wukong struct {
	Monkey
	Tool string
}
func (w Wukong) Fly() {
	fmt.Println("筋斗云，来……")
}
func (w Wukong) Change() {
	fmt.Println("变！")
}

func main(){
	//var h1 Human	//接口变量，可以接收实现了该接口的类的对象
	var h2 Human	
	var m2 = man{"Wang"}
	//h1 = new(women)	Women类没有实现Human接口的全部方法所以无法可以赋值成功
	h2 = &m2	//只能传递地址因为man对接口的一部分实现是以指针形式
	//h1.Say()
	h2.Say()
	h2.Run()

}