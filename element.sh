#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#echo -e "\n\n~~~~ Periodic Table ~~~~\n\n"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi


if [[ $1 =~ ^[0-9]+$ ]]
then
  element=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")
else
#if argument is string
  element=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' or symbol = '$1'")
fi


#the element isn't found in the database:
if [[ -z $element ]]
then
  echo "I could not find that element in the database."
else
  echo $element | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
  do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
  done
fi

