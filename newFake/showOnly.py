# -*- coding: utf-8 -*-
#Author : Rémi Fabre

import sys

from xml.dom.minidom import parse, parseString
import xml.dom.minidom
import json


def sign(x) :
    if (x > 0) :
        return 1
    if (x < 0) :
        return -1
    return 1

def isNumber(value):
    try:
        float(value)
        return True
    except:
        return False


# Puts all graphics to false except for the filters in listOfFilters whom
# graphics are set to true
def setGraphics(xmlFilePath, listOfFiltersPath):
    #Reading the list of filters contained in the second file.
    listFile = open(listOfFiltersPath)
    listOfFilters = []
    for line in listFile :
        if (line.strip() == "") :
            continue
        listOfFilters.append(line.strip())
        
    #Taking out empty lines ans annoying spaces
    xmlFile = open(xmlFilePath, 'r')
    output = ""
    for line in xmlFile :
        if line.strip() :
            output = output + line.rstrip() + '\n'
    xmlFile.close()

    xmlFile = open(xmlFilePath, 'w+')
    xmlFile.write(output)
    xmlFile.close()

    #Parsing the xml file
    dom = parse(xmlFilePath)
    listOfServos = []
    for node in dom.getElementsByTagName('filter'):
        name =  node.getElementsByTagName('name')[0].childNodes[0].nodeValue
        if (name in listOfFilters) :
            node.getElementsByTagName('graphics')[0].childNodes[0].nodeValue = "true"
            print name
        else :
            node.getElementsByTagName('graphics')[0].childNodes[0].nodeValue = "false"
            


    print "Writing at ", xmlFilePath
    dom.writexml( open(xmlFilePath, 'w'))
'''    
    f = open(outputFile,'w')
    f.write(result)
    f.close()'''

if ( __name__ == "__main__"):
    print("A new day dawns")
    setGraphics(sys.argv[1], sys.argv[2])
    print("Done !")




'''
    index = xmlFile.rfind(".")
    if (index < 0) :
        fileName = "output"
    else :
        fileName = xmlFile[:index]
'''
