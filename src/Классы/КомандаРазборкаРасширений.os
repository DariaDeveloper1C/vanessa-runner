///////////////////////////////////////////////////////////////////
//
// Служебный модуль с набором методов работы с командами приложения
//
// Структура модуля реализована в соответствии с рекомендациями 
// oscript-app-template (C) EvilBeaver
//
///////////////////////////////////////////////////////////////////

#Использовать asserts

Перем Лог;

///////////////////////////////////////////////////////////////////////////////////////////////////
// Прикладной интерфейс

Процедура ЗарегистрироватьКоманду(Знач ИмяКоманды, Знач Парсер) Экспорт

	ТекстОписания = 
		"     разбираем расширение из конфигурации в исходники
		|     ";

	ОписаниеКоманды = Парсер.ОписаниеКоманды(ПараметрыСистемы.ВозможныеКоманды().РазборкаРасширений, ТекстОписания);

	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "extensionName", 
		"Имя расширения, под которым оно зарегистрировано в списке расширений");
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, "outputPath", "Путь к исходникам расширения");
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
КонецПроцедуры // ЗарегистрироватьКоманду

// Выполняет логику команды
// 
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   ДополнительныеПараметры (необязательно) - Соответствие - дополнительные параметры
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач ДополнительныеПараметры = Неопределено) Экспорт

	Лог = ДополнительныеПараметры.Лог;

	ДанныеПодключения = ПараметрыКоманды["ДанныеПодключения"];
	
	РазобратьНаИсходникиРасширение(
		ПараметрыКоманды["extensionName"], ОбщиеМетоды.ПолныйПуть(ПараметрыКоманды["outputPath"]), 
		ДанныеПодключения.СтрокаПодключения, ДанныеПодключения.Пользователь, ДанныеПодключения.Пароль,
		ПараметрыКоманды["--v8version"]);

	Возврат МенеджерКомандПриложения.РезультатыКоманд().Успех;
КонецФункции // ВыполнитьКоманду

Процедура РазобратьНаИсходникиРасширение(Знач ИмяРасширения, Знач Каталог, 
		Знач СтрокаПодключения="", Знач Пользователь="", Знач Пароль="", 
		Знач ВерсияПлатформы="", Знач КодЯзыка = "")

	Лог.Информация("Выполняю разборку расширения %1 на исходники в каталог %2", ИмяРасширения, Каталог);
	Ожидаем.Что(СтрокаПодключения, "Ожидаем, что строка подключения к ИБ задана, а это не так").Заполнено();

	МенеджерКонфигуратора = Новый МенеджерКонфигуратора;
	МенеджерКонфигуратора.Инициализация(СтрокаПодключения, Пользователь, Пароль, ВерсияПлатформы, , КодЯзыка);

	Конфигуратор = МенеджерКонфигуратора.УправлениеКонфигуратором();
	
	ПараметрыЗапуска = Конфигуратор.ПолучитьПараметрыЗапуска();
	ПараметрыЗапуска.Добавить("/Visible");
	ПараметрыЗапуска.Добавить("/DumpConfigToFiles """ + Каталог + """");
	ПараметрыЗапуска.Добавить("-Extension """ + ИмяРасширения + """");
	Конфигуратор.ВыполнитьКоманду(ПараметрыЗапуска);

	МенеджерКонфигуратора.Деструктор();
	
	Лог.Информация("Разборка расширения завершена");
	
КонецПроцедуры
