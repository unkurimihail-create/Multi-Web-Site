# Windows Full Terminal (PowerShell)

Этот проект добавляет «полноценный» интерактивный терминал для Windows на базе PowerShell со следующими возможностями:

- цветной prompt с текущей директорией;
- встроенные команды (`help`, `cd`, `pwd`, `clear`, `history`, `exit`);
- запуск обычных команд Windows (`dir`, `ipconfig`, `git`, `python`, и т.д.);
- запуск PowerShell-выражений;
- история команд в файле пользователя;
- автосохранение истории между сессиями;
- .bat-лаунчер для запуска двойным кликом.

## Быстрый старт

1. Откройте PowerShell от обычного пользователя.
2. Перейдите в папку проекта.
3. Запустите:

```powershell
./start-terminal.bat
```

или напрямую:

```powershell
powershell -ExecutionPolicy Bypass -File .\windows-terminal.ps1
```

## Поддерживаемые встроенные команды

- `help` — подсказка по командам;
- `cd <path>` — переход по директориям;
- `pwd` — показать текущую директорию;
- `clear` — очистка экрана;
- `history [N]` — последние N команд (по умолчанию 20);
- `exit` — завершение терминала.

Все остальные команды выполняются как обычные команды Windows/PowerShell.

## Пример

```text
PS-Terminal C:\Users\you> cd projects
PS-Terminal C:\Users\you\projects> git status
PS-Terminal C:\Users\you\projects> history 5
PS-Terminal C:\Users\you\projects> exit
```

## Примечание

Это не замена Windows Terminal GUI, а удобная терминальная оболочка, которую можно расширять под свои сценарии.
