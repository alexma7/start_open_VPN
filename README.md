# start_open_VPN
Powershell script for run RDP on Windows

## Алгоритм скрипта
- Снимаем процесс RDP
- Проверяем включенный TAP интерфейс, если не включен, то закрываем openvpn-gui и запускаем его заного в скрытом режиме
- В одноминутном цикле проверяем журнал open vpn каждую секунду, пока не будет найдена запись "CONNECTED,SUCCESS", которая означает, что мы удачно подключились
- После подключения запускается файл .RDP

## Инструкция 
- Создать файл .RDP в любом месте на ПК с сохраненными данными для авторизации
- Понятное дело, что OpenVPN должен быть настроен и работать, все пароли должны быть сохранены
- Заполняем JSON-файл, возле каждого параметра стоят коментарии + заполнены тестовые данные, все делать по аналогии
- После этого можно сделать ярлык на рабочий стол из EXE файла. У EXE файла не должно быть ограничений на запуск скриптов. Но, если будут выводиться ошибки, то у вас отключен запуск Powershell скриптов. Разблокируется вводом команды в Poweshell от админа "Set-ExecutionPolicy Unrestricted" - это максимальное разрешение на запуск всех скриптов.  Можно попробовать "Set-ExecutionPolicy RemoteSigned" - это разрешение только для локальных скриптов. 
