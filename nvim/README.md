## Vim Tricks
### 复制到系统剪切板
```vim
"+Y
```

### Coc Plug Notes
- CocConfig
```json
{
    "languageserver": {
        "ccls": {
            "command": "ccls",
            "filetypes": [
                "c",
                "cc",
                "cpp",
                "objc",
                "objcpp"
            ],
            "rootPatterns": [
                ".ccls",
                "compile_commands.json",
                ".vim/",
                ".git/",
                ".hg/"
            ],
            "initializationOptions": {
                "cache": {
                    "directory": "/tmp/ccls"
                }
            }
        }
    }
}
```

- coc-clangd
```bash
  {
          "languageserver":
          {
                  "coc-clangd":
                  {
                          "command": "clangd",
                          "rootPatterns": ["compile_flags.txt",
                                          "compile_commands.json"],
                          "filetypes":["c",
                                          "cc",
                                          "cpp",
                                          "c++",
                                          "objc",
                                          "objcpp"]
                  },
                  "cmake":
                  {
                          "command": "cmake-language-server",
                          "filetypes": ["cmake"],
                          "rootPatterns": ["build/"],
                          "initializationOptions":
                          { 
                                  "buildDirectory": "build"
                          }
                  }
          }
          
  }

```
