#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t -c"

function SERVICES_MENU () {

SERVICES_LIST=$($PSQL "SELECT * FROM services")
echo "$SERVICES_LIST" | while IFS="|" read SERVICE_ID SERVICE_NAME
do
   SERVICE_ID=$(echo $SERVICE_ID | sed 's/ //g')
   SERVICE_NAME=$(echo $SERVICE_NAME | sed -r 's/ ([a-z]+) /$1/g')
   echo -e "\n$SERVICE_ID) $SERVICE_NAME"
done

echo -e "\n Choose a service from list above:"
read SERVICE_ID_SELECTED
SERVICE_ID_SELECTED=$($PSQL "SELECT service_id FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
}


SERVICES_MENU

while [[ -z $SERVICE_ID_SELECTED ]] 
do
 SERVICES_MENU
done

  echo -e "\n Enter your phone number:"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\n Enter your name:"
    read CUSTOMER_NAME
    CUSTOMER_INSERT=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
  fi
  echo -e "\nEnter appointment time:"
  read SERVICE_TIME
  SERVICE_INSERT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
