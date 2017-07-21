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
    #print("index = " + str(index))
    #print("indexOfChange = " + str(indexOfChange))
    #print("indexOfEnd = " + str(indexOfEnd))
    begin = content[:indexOfChange]
    end = content[indexOfEnd:]
    # The - because the motor is inverted
    middle = zeroString + ":" + str(-zero)
    #print("begin :\n" + str(begin))
    #print("middle :\n" + str(middle))
    #print("end :\n" + str(end))
    # Rewritting the whole thing
    content = begin + middle + end
    f.seek(0)
    f.truncate()
    f.write(content)

if ( __name__ == "__main__"):
    if(len(sys.argv) != 5) :
        print("Usage setOffset.py path2file DOFName currentValue expectedValue")
        sys.exit()
    path = sys.argv[1]
    dofName = sys.argv[2]
    current = sys.argv[3]
    expected = sys.argv[4]
    zero = float(expected) - float(current)
    print("Setting a zero of " + str(zero) + ", in dof : '" + str(dofName) + "'")
    main(path, dofName, zero)
    print("Done !")
