﻿#Если НЕ Клиент Тогда
	
	Функция ДобавитьОписание(Форма, МассивОписаний, ИмяКомпонента, Знач Заголовок = "", РодительЭлемента = Неопределено, ПередЭлементом = Неопределено, Параметры = Неопределено, Действия = Неопределено) Экспорт
		Если НЕ ЗначениеЗаполнено(Заголовок) Тогда
			МетаданныеОбъекта = Форма.Объект.Ссылка.Метаданные();
			Заголовок = МетаданныеОбъекта.Реквизиты[ИмяКомпонента].Синоним;
		КонецЕсли;
		
		ДействияКомпонента = А1Э_Структуры.Скопировать(Действия);
		А1Э_УниверсальнаяФорма.ДобавитьОбработчикМодуляКДействиям(ДействияКомпонента, ИмяМодуля(), "ФормаПриСозданиинаСервере", 0);
		А1Э_УниверсальнаяФорма.ДобавитьОбработчикМодуляКДействиям(ДействияКомпонента, ИмяМодуля(), "ФормаОбновитьСвойстваЭлементов");
		
		ДействияЭлементов = А1Э_Структуры.Скопировать(Действия);
		А1Э_УниверсальнаяФорма.УбратьОбработчикиСобытийФормы(ДействияЭлементов);
		
		ДействияФлага = А1Э_Структуры.Скопировать(ДействияЭлементов);
		А1Э_УниверсальнаяФорма.ДобавитьОбработчикКДействиям(ДействияФлага, "ПриИзменении", ИмяМодуля() + ".ФлагПриИзменении");
		
		А1Э_Формы.ДобавитьОписаниеГоризонтальнойГруппы(МассивОписаний, ИмяКомпонента, , РодительЭлемента, ПередЭлементом, Параметры, ДействияКомпонента);
		А1Э_Формы.ДобавитьОписаниеРеквизитаИЭлемента(МассивОписаний, ИмяКомпонента + "___Флаг", "Булево", , Заголовок, ИмяКомпонента, , , ДействияФлага);
		А1Э_Формы.ДобавитьОписаниеПоляОбъекта(МассивОписаний, ИмяКомпонента, ИмяКомпонента, , 
		А1Э_Структуры.Создать(
		"ИмяЭлемента", ИмяКомпонента + "___Дата",
		"ПоложениеЗаголовка", ПоложениеЗаголовкаЭлементаФормы.Нет,
		), ДействияЭлементов);
КонецФункции

Функция ФормаПриСозданиинаСервере(ИмяКомпонента, Форма, Отказ, СтандартнаяОбработка) Экспорт
	Форма[ИмяКомпонента + "___Флаг"] = ЗначениеЗаполнено(Форма.Объект[ИмяКомпонента]);
КонецФункции

#КонецЕсли

Функция ФормаОбновитьСвойстваЭлементов(ИмяКомпонента, Форма) Экспорт 
	Форма.Элементы[ИмяКомпонента + "___Дата"].Видимость = ЗначениеЗаполнено(Форма.Объект[ИмяКомпонента]);	
КонецФункции 

Функция ФлагПриИзменении(Форма, Элемент) Экспорт
	ИмяКомпонента = А1Э_Строки.Перед(Элемент.Имя, "___Флаг");
	Если Форма[Элемент.Имя] Тогда
		Форма.Объект[ИмяКомпонента] = ТекущаяДата();
	Иначе
		Форма.Объект[ИмяКомпонента] = Неопределено;
	КонецЕсли;
	Форма.Модифицированность = Истина;
	ФормаОбновитьСвойстваЭлементов(ИмяКомпонента, Форма);
КонецФункции

Функция ИмяМодуля() Экспорт
	Возврат "А1БК_ПолеОбъектаБулеваяДата";
КонецФункции 