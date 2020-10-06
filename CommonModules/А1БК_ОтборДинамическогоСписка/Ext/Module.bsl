﻿Функция ДобавитьОписание(МассивОписаний, ИмяСписка, ИмяПоляОтбора, ОписаниеТипов, Заголовок = "", РодительЭлемента = Неопределено, ПередЭлементом = Неопределено, Параметры = Неопределено, Действия = Неопределено) Экспорт
	РабочиеПараметры = А1Э_Структуры.СкопироватьВШаблон(Параметры,
	"КнопкаОчистки", Истина);
		
	РабочиеДействия = А1Э_Структуры.Скопировать(Действия);
	А1Э_УниверсальнаяФорма.ДобавитьОбработчикМодуляКДействиям(РабочиеДействия, ИмяМодуля(), "ПриИзменении");
	А1Э_УниверсальнаяФорма.ДобавитьОбработчикМодуляКДействиям(РабочиеДействия, ИмяМодуля(), "ФормаПриСозданииНаСервере");
	А1Э_УниверсальнаяФорма.ДобавитьОбработчикМодуляКДействиям(РабочиеДействия, ИмяМодуля(), "ФормаПриЗагрузкеДанныхИзНастроекНаСервере");
	
	А1БК_СохраняемоеПоле.ДобавитьОписание(МассивОписаний, ИмяСписка + "__Отбор__" + ИмяПоляОтбора, ОписаниеТипов, А1Э_Общее.НепустоеЗначение(Заголовок, ИмяПоляОтбора), РодительЭлемента, ПередЭлементом, РабочиеПараметры, РабочиеДействия); 
КонецФункции

#Область Компонент
 
Функция ФормаПриСозданииНаСервере(ИмяКомпонента, Форма, Отказ, СтандартнаяОбработка) Экспорт  
	ЧастиИмени = А1Э_Строки.ПередПосле(ИмяКомпонента, "__Отбор__");
	ИмяСписка = ЧастиИмени.Перед;
	ИмяПоляОтбора = ЧастиИмени.После;
	Если Форма.Параметры.Отбор.Свойство(ИмяПоляОтбора) Тогда
		Форма[ИмяКомпонента] = Форма.Параметры.Отбор[ИмяПоляОтбора];
	КонецЕсли;
КонецФункции 

Функция ФормаПриЗагрузкеДанныхИзНастроекНаСервере(ИмяКомпонента, Форма, Настройки) Экспорт 
	УстановитьОтбор(Форма, ИмяКомпонента);
КонецФункции

Функция ПриИзменении(Форма, Элемент) Экспорт 
	ИмяКомпонента = Элемент.Имя;
	УстановитьОтбор(Форма, ИмяКомпонента);
КонецФункции

Функция УстановитьОтбор(Форма, ИмяКомпонента) 
	Значение = Форма[ИмяКомпонента];
	ЧастиИмени = А1Э_Строки.ПередПосле(ИмяКомпонента, "__Отбор__");
	ИмяСписка = ЧастиИмени.Перед;
	ИмяПоляОтбора = ЧастиИмени.После;
	А1Э_СКД.УстановитьЭлементОтбораДинамическогоСписка(Форма[ИмяСписка],
		ИмяПоляОтбора,
		Значение,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Значение));
	
КонецФункции

#КонецОбласти 

#Область Механизм

Функция Механизм_НастройкиМеханизма() Экспорт
	Настройки = А1Э_Механизмы.НовыйНастройкиМеханизма();
	
	Настройки.Обработчики.Вставить("ФормаСпискаПриСозданииНаСервере", Истина);
	Настройки.Обработчики.Вставить("А1Э_ПриПодключенииКонтекста", Истина);
	
	Настройки.ПорядокВыполнения = 1000;
	
	Возврат Настройки;
КонецФункции 

Функция Механизм_А1Э_ПриПодключенииКонтекста(ТекущийКонтекст, НовыйКонтекст) Экспорт
	Если ТекущийКонтекст = Неопределено Тогда
		ТекущийКонтекст = А1Э_Структуры.Создать(
		"Список", "Список",
		"РодительЭлемента", Неопределено,
		"ПередЭлементом", "Список",
		"Отборы", Новый Массив,
		);
	КонецЕсли;
	Если ТипЗнч(НовыйКонтекст) = Тип("Структура") Тогда
		Исключения = "";
		Если НовыйКонтекст.Свойство("Отборы") Тогда
			Исключения = "Отборы";
			Отборы = НовыйКонтекст.Отборы;
		Иначе
			Отборы = Неопределено;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(ТекущийКонтекст, НовыйКонтекст, , Исключения);
	ИначеЕсли ТипЗнч(НовыйКонтекст) = Тип("Массив") Или ТипЗнч(НовыйКонтекст) = Тип("Строка") Тогда
		Отборы = НовыйКонтекст;
	Иначе
		А1Э_Служебный.СлужебноеИсключение("Ошибка подключения механизма А1БК_ОтборДинамическогоСписка - контекст должен быть массивом, строкой или структурой!");
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(Отборы) Тогда Возврат Неопределено; КонецЕсли;
	Отборы = А1Э_Массивы.Массив(Отборы);
	Для Каждого Отбор Из Отборы Цикл
		Если ТипЗнч(Отбор) = Тип("Строка") Тогда
			ЧастиСтроки = А1Э_Строки.ПередПосле(Отбор, ":");
			ОтборСтруктура = НовыйОтбор(ЧастиСтроки.Перед, ЧастиСтроки.После);
		ИначеЕсли ТипЗнч(Отбор) = Тип("Структура") Тогда
			ОтборСтруктура = НовыйОтбор(Отбор.Имя);
			ЗаполнитьЗначенияСвойств(ОтборСтруктура, Отбор);
		Иначе
			А1Э_Служебный.СлужебноеИсключение("Ошибка подключения механизма А1БК_ОтборДинамическогоСписка - добавляемый отбор должен быть строкой или структурой!");
		КонецЕсли;	
		ТекущийКонтекст.Отборы.Добавить(ОтборСтруктура);
	КонецЦикла;
		
КонецФункции

Функция Механизм_ФормаСпискаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	Контекст = А1Э_Механизмы.КонтекстМеханизма(Форма, "А1БК_ОтборДинамическогоСписка");
	Если ТипЗнч(Контекст) <> Тип("Структура") Тогда
		А1Э_Служебный.СлужебноеИсключение("Контекст механизма А1БК_ОтборДинамическогоСписка должен быть Структурой!");
	КонецЕсли;
	
	МассивОписаний = Новый Массив;
	А1Э_Формы.ДобавитьОписаниеГоризонтальнойГруппы(МассивОписаний, "А1БК_ОтборДинамическогоСписка", , Контекст.РодительЭлемента, Контекст.ПередЭлементом);
	Для Каждого Отбор Из Контекст.Отборы Цикл
		//ТУДУ: Перенести это в подключение механизма (сейчас невозможно т. к. подключение механизма ничего не знает про объект).
		Если НЕ ЗначениеЗаполнено(Отбор.ТипЗначения) Тогда
			Если СтрНачинаетсяС(Форма.ИмяФормы, "ОбщаяФорма") Тогда
				А1Э_Служебный.СлужебноеИсключение("Ошибка создания компонента А1БК_ОтборДинамичискогоСписка - в общей форме тип отбора должен быть задан в явном виде!");
			КонецЕсли;
			ОбъектМетаданных = А1Э_Формы.МетаданныеВладельцаФормы(Форма);
			ТипЗначения = А1Э_Метаданные.ОписаниеТипаПоля(ОбъектМетаданных, Отбор.Имя);
		Иначе
			ТипЗначения = Отбор.ТипЗначения;
		КонецЕсли;
		ДобавитьОписание(МассивОписаний, Контекст.Список, Отбор.Имя, ТипЗначения, Отбор.Заголовок, "А1БК_ОтборДинамическогоСписка");
	КонецЦикла;
	А1Э_УниверсальнаяФорма.ДобавитьРеквизитыИЭлементы(Форма, МассивОписаний);
КонецФункции

Функция НовыйОтбор(Имя, ТипЗначения = Неопределено, Заголовок = "") Экспорт
	Возврат А1Э_Структуры.Создать(
	"Имя", Имя,
	"ТипЗначения", ТипЗначения,
	"Заголовок", Заголовок);
КонецФункции

#КонецОбласти

Функция ИмяМодуля() Экспорт
	Возврат "А1БК_ОтборДинамическогоСписка";
КонецФункции 

