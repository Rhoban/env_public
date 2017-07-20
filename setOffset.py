#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys

def main(path, dofName, zero) :
    try:
        f = open(path, 'r+')
    except:
        print("Failed to open file at '" + str(path) + "'")
        sys.exit()
    content = f.read()

    try:
        index = content.index(dofName)
    except:
        print("Couldn't find the string '" + str(dofName) + "'")
        sys.exit()
    try:
        zeroString = "zero\""
        indexOfChange = content.index(zeroString, index)
        indexOfEnd = content.index('\n', indexOfChange)
    except:
        print("Couldn't find the string '" + str(dofName) + "'")
        sys.exit()
    #Erasing between "zero" and the breakline
    print("index = " + str(index))
    print("indexOfChange = " + str(indexOfChange))
    print("indexOfEnd = " + str(indexOfEnd))
    begin = content[:indexOfChange]
    end = content[indexOfEnd: ]
    middle = zeroString + ":" + str(zero)
    # Rewritting the whole thing
    content = begin + middle + end
    f.seek(0)
    f.write(content)

if ( __name__ == "__main__"):
    if(len(sys.argv) != 4) :
        print("Usage setOffset.py path2file DOFName zeroValue")
        sys.exit()
    path = sys.argv[1]
    dofName = sys.argv[2]
    zero = sys.argv[3]
    main(path, dofName, zero)
    print("Done !")
