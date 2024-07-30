#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

SERVICES() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  
  echo "Welcome to My Salon, how can I help you?"
  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim\n6) exit"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1|2|3|4|5) APPOINTMENT $SERVICE_ID_SELECTED ;;
    6) EXIT ;;
    *) SERVICES "I could not find that service. What would you like today?" ;;
    esac
}

APPOINTMENT() {
  SELECTED_SERVICE_ID=$1;
  SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id=$SELECTED_SERVICE_ID;")

  echo "What's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    echo "What time would you like your $SERVICE_SELECTED, $CUSTOMER_NAME?"
    read SERVICE_TIME

    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(service_id, customer_id, time) VALUES($SELECTED_SERVICE_ID, $CUSTOMER_ID, '$SERVICE_TIME')")

    echo "I have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
}

EXIT() {
  echo -e "\nThank you for stopping by. Have a nice day!"
}

SERVICES