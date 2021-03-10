# Download file

1. Truy cập link [github](https://github.com/allyvan1314/TC_Easy_bot_final)
2. Chọn download file (Zip) như hình:

![image](https://user-images.githubusercontent.com/49230626/110578210-df845000-8196-11eb-9960-8e9fc9a4f7a2.png)

# Chuẩn bị môi trường chạy

1. Python & robot framework

Kiểm tra python đã cài đặt:

```cmd
python --version
```

Kiểm tra robot framework:

```cmd
robot --version
rebot --version
```

Cài đặt rpaframework:

```cmd
pip install rpaframework
pip install pymysql
```

1. Chrome

Cài đặt chrome version mới tại [Chrome](https://www.google.com/chrome/)

Chạy chrome trên port 9222:

- Windows
```cmd
start chrome.exe -remote-debugging-port=9222
```
- MacOS or Linux
```cmd
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222
```

Sau đó đăng nhập vào web easycredit.

# Chạy robot

## Cách 1: Dùng Command line

```cmd
robot <filename>
```

## Cách 2: Dùng VSCode

[Instruction](https://robocorp.com/docs/developer-tools/visual-studio-code/overview)

## Cách 3: Dùng Robocorp Lab

[Instruction](https://robocorp.com/docs/developer-tools/robocorp-lab/installation)
