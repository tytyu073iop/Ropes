/*
 это документация к моему проекту
 1. из используемых типов данных
 1.ToDo
 переменные: id(UUID), name(string), date(Date)
 функции: remove() - делает полное удаление таска( делает ремув, сохраняет, удаляет уведомление связанное с ним)
 init(context: context(не точное название))
 convenience init(context : NSManagedObjectContext, name : String, id : UUID = UUID(), time : Date) throws - сразу сохраняет таск и запускает уведомление по дате
 init(context : NSManagedObjectContext, name : String, id : UUID = UUID(), auto : Bool = true) - делает сохранение обьекта, если auto true то запланирует уведомление
 2.FastAnswers
 переменные: id : UUID, name : String
 функции: remove() - убирает быстрый ответ
 init(context : NSManagedObjectContext, id : UUID = UUID(), name : String) - добавляет и сохраняет быстрый ответ
 2.LocalNotficationManager
 переменные:
 1. isGranted говорит получено ли разрешение
 2. static let shared - общий экземпляр класса
 функции:
 1. request(text : String, time : Double, id : UUID = UUID()) - кидает запрос на уведомление через time времени
 2. request(text : String, time : Date, id : UUID = UUID()) throws - кидает запрос на уведомление в time
 3. requestAuthorization(Options : UNAuthorizationOptions) async throws - кидает алерт с разрешением на уведомления
 4. updatePermition() async - если надо обновить разрешение уведомлений
 5. openSettings() - открывает пользователю настройки приложения
 6. static func remove(id : String) - удаляет запрос на уведомление по его индефикатору
 7. moveAll (time : Double = defaults.double(forKey: "time")) async - сдвигает время тригера для всех уведомлений
 8. PrintRequests() async - вывести все отправленные запросы в консоль
 3. PersistenceController
 переменные:
 shared - эземпляр функции
 функции:
 1. static save() - сохраняет сделанное
 */
