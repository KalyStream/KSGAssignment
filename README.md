# KSGAssignment
Manual: Склонировать данный проект или скачать .zip file. Открыть проект в Xcode, запустить проект. На главной странице приложения нажать "Open Live" чтобы установить соединение через веб сокет. Также это нажатие откроет страницу "Live" с артефактами. При переходе можно увидеть "InfoView" c описанием событий. Можно прерывать и снова устанавливать соединения("P2P Live paused", "P2P Live activated").

Review: 
1. Основной задачей было установить соединение с wss сервером. Так как сервер требует аутентификация были отправлены cookie в конфигурации SocketManager. Также для удобства разработки были включены логи по событиям в веб сокете. Дополнительно аутентификацию можно пройти отправив API ключ в header запроса(подробнее https://github.com/skylight-ity/waxpeer-wiki/blob/main/socket-io.md)
2. После установки соединения нужно было обработать поток данных и отобразить на UI. Для этого был использован список(UITableView) с UITableViewDataSource для обновление только необходимых данных.
3. Также каждое событие веб сокета было обработано(new, removed, updated) и преобразовано в удобный вид для отображения затем передано на UI.
4. События пользователя(.connect, .disconnect, .error и тд) обрабатываются и отображаются в виде тостера(Toast-Swift).
5. Для внедрения зависимости был использован SPM. А сборка самих модулей происходит в Assembly.
