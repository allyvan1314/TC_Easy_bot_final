# Chuẩn bị môi trường chạy

1. Python & robot framework

Kiểm tra python đã cài đặt:

```python
python --version
```

Kiểm tra robot framework:

```robot
robot --version
rebot --version
```

2. Chrome

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

# Chạy robot

## Cách 1: Dùng Command line

```cmd
robot <filename>
```

## Cách 2: Dùng VSCode

[Instruction](https://robocorp.com/docs/developer-tools/visual-studio-code/overview)

## Cách 3: Dùng Robocorp Lab

[Instruction](https://robocorp.com/docs/developer-tools/robocorp-lab/installation)
