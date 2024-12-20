#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams CASCADE")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  #INSERT WINNER TEAMS
  if [[ $WINNER != "winner" ]]
  then 
    INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_RESULT == "INSERT 0 1" ]]
    then 
      echo INSERT into teams, $WINNER
    fi
    # get WINNER_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")

  #INSERT OPPONENT TEAMS
    INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_RESULT == "INSERT 0 1" ]]
    then 
      echo INSERT into teams, $OPPONENT
    fi
    
    # get OPPONENT_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")

  #insert into games
    INSERT_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
      VALUES('$YEAR', '$ROUND','$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
    if [[ $INSERT_RESULT == "INSERT 0 1" ]]
    then 
      echo INSERT into games $YEAR $ROUND $WINNER_ID $OPPONENT_ID $WINNER_GOALS $OPPONENT_GOALS
    fi
  fi
done