///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Отключение конфигурации от хранилища.
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////////////////////////////////////

#Использовать logos

Перем Лог;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

// Регистрация команды
//
// Параметры:
//   ИмяКоманды - Строка - Имя команды
//   Парсер - Парсер - Парсер
//
Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания =
		"     Отключение ИБ от хранилища конфигурации 1С.
		|";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИмяКоманды,
		ТекстОписания);
    Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, "--extension", "Имя расширения");
	Парсер.ДобавитьКоманду(ОписаниеКоманды);

КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
//
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры - Соответствие - дополнительные параметры (необязательно)
//
// Возвращаемое значение:
//	Число - код возврата скрипта
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Лог = ДополнительныеПараметры.Лог;

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];
	СтрокаПодключения = ДанныеПодключения.СтрокаПодключения;
	Если Не ЗначениеЗаполнено(СтрокаПодключения) Тогда
		ВызватьИсключение "Не задана строка подключения к БД";
	КонецЕсли;

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;

	МенеджерКонфигуратора.Конструктор(ДанныеПодключения, ПараметрыКоманды);

	Попытка
		МенеджерКонфигуратора.ОтключитьсяОтХранилища(, ПараметрыКоманды["--extension"]);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	МенеджерКонфигуратора.Деструктор();

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции // ВыполнитьКоманду
