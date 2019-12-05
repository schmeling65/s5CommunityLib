
# Siedler5 CommunityLib

Eine Sammlung von kleinen und größeren Svcriptteilen.

## Benutzung
- download:
	- git submodule [https://git-scm.com/book/en/v2/Git-Tools-Submodules]
	- oder: datei als zip runterladen
	- einzelne dateien kopieren
	- oder: mcbPacker.require nutzen
- benutzungsanleitung (1. kommentar der datei lesen)
- requirements beachten (oder von mcbPacker verwalten lassen)

## Hinzufügen
- jede comfort in eigener datei
- benutzungsanleitung als 1. kommentar der datei
- 4 wichtige informationen für jede datei:
	- ursprünglucher autor: kommentar 'author'
	- aktuelle ansprechperson: kommentar 'current maintainer'
	- version: kommentar, bei größeren projekten zusätzlich in lua variable
	- requirements: im kommentar und (wenn möglich) als mcbPacker.require
- eigener branch mit namen (evt zweck)
- pull request

## Ändern vorhandener Funktionen:
- zuerst den 'current maintainer' fragen
- wenn nicht mehr erreichbar: sich selbst als 'current maintainer' eintragen
- eigener branch mit namen (evt zweck)
- pull request

## Eigene branches
- wichtig ist nur der status beim pull request, solange sich niemand beschwert

## Lizenz
- wenn nicht extra in der datei etwas anderes steht, gilt die MIT lizenz (die erlaubt praktisch alles, ohne schadensersatzansprüche)
