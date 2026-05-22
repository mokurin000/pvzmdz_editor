# pvzmdz_editor

[《植物大战僵尸抽卡版》](https://space.bilibili.com/167141989/dynamic)存档编辑器。

编译好的程序可于 [CI](https://github.com/mokurin000/pvzmdz_editor/actions/workflows/ci.yaml) 下载。

## Android

[Shizuku]: https://shizuku.rikka.app/

在使用 Android 版本之前，你必须先安装并启动 [Shizuku]。随后在提示时授予本应用权限。

注意，由于 Shizuku 基于运行 daemon 时所在的用户运行，且本项目不打算引入 root-only 命令，您无法在 Shizuku 与本应用、抽卡版用户不同时使用。

具体来说， `/data/media/${userId}` 是唯一一种 User 无关的可靠存储目录，但其需要 media_rw 组。

## 开发

```bash
dart run build_runner build
```
