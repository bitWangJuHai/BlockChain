### git新建文件基本流程
- 在当前目录创建新的git仓库
    ```
    git init
    ```
- 添加readme文件
    ```
    touch readme.md     //新建readme文件
    git status -s       //查看git状态
    git status
    ```
    文件状态：尚未被git跟踪，用??标识
- 将readme文件添加到暂存区中（git开始跟踪该文件）
    ```
    git add readme.md
    git status -s
    ```
    文件状态：文件因新建文件被添加进暂存区中，工作区与暂存区文件一致，用A标识
- 编辑文件、在其中添加任意内容
    ```
    vim readme.md
    git status -s
    ```
    文件状态：文件因新建文件被添加进暂存区中，工作区与暂存区文件不一致，用AM标识。A和M在终端中应该是不同的颜色，**A的颜色代表该文件在本地仓库视角下的状态，M的颜色代表该文件在暂存区视角下的状态**
- 将工作区中的文件更改提交到暂存区
    ```
    git add readme.md 
    git status -s
    ```
    文件状态：文件因新建文件被添加进暂存区中，工作区与暂存区文件一致，用A标识。和上上步执行后的状态相同，因为从本地仓库的视角来该文件无论如何改动都是一个新添加的带有某个“初始”内容的文件。
- 将暂存区提交到本地仓库并标注
    ```
    git commit -m "新建readme文件"
    ```
    文件状态：新文件从暂存区被提交到本地仓库。当工作区与暂存区内容不一致的时候是无法将暂存区提交到本地仓库的，需要先将工作区提交到暂存区。
- 将本地仓库提交到远程仓库
    ```
    git push <远程仓库地址，在github上查看>
    ```
    上传并同步到远程仓库，通过密码身份验证用户身份已经弃用，现在用token的方式验证身份，如何操作请看[这里](https://docs.github.com/en/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls)，生成token之后用token代替密码即可。
### 常用操作
- 回退操作
```
git restore <文件>              //丢弃工作区文件的改动，用暂存区文件内容覆盖
git restore --staged <文件>     //丢弃该文件在暂存区的改动，工作区的内容不变
git reset           //退回暂存区到本地仓库的commit提交,有三种退回方式，如下表格所示
```
![git_reset讲解表格](../../img/%E6%88%AA%E5%9B%BE%202023-02-17%2014-11-05.png)
- 文件改动
```
git add .                       //将该git项目下的所有文件添加到暂存区
git mv <文件> <新文件>             //移动或重命名文件，相当于先删除后新建
git rm <文件>                   //删除没有修改过（和本地库一致）的文件并将改动提交到暂存区
git rm -f <文件>                //从工作区及暂存区删除改动过且已经被git追踪了的文件（工作区和暂存区的文件均可）
git rm --cached <文件>          //停止跟踪暂存区的文件，工作的内容不变
```
- 信息查看
```
git diff <文件>                 //比较暂存区和工作区文件的不同
git log                         //查看历史commit记录
git blame <文件>                //查看指定文件的修改记录
```