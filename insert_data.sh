#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games, teams restart identity cascade")
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals

#check winner
do
	if [[ $winner != "winner" ]]
	then
		#get winner_id
		winner_id=$($PSQL "select team_id from teams where name='$winner'")
		#if not found
		if [[ -z $winner_id ]]
		then
			insert_winner=$($PSQL "insert into teams(name) values('$winner')")
			if [[ $insert_winner == "INSERT 0 1" ]]
			then
				echo "inserted $winner"
			fi
			#get new id
			winner_id=$($PSQL "select team_id from teams where name='$winner'")
		fi
		#get opponent_id
		opponent_id=$($PSQL "select team_id from teams where name='$opponent'")
		#if not found
		if [[ -z $opponent_id ]]
		then
			insert_opponent=$($PSQL "insert into teams(name) values('$opponent')")
			if [[ $insert_opponent == "INSERT 0 1" ]]
			then
				echo "inserted $opponent"
			fi
			#get new id
			opponent_id=$($PSQL "select team_id from teams where name='$opponent'")
		fi
	#insert into game
	insert_into=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($year,'$round',$winner_id,$opponent_id,$winner_goals,$opponent_goals)")
	#if [[ $insert_into == "INSERT 0 1" ]]
	#then
	#	echo "inserted game: $winner vs $opponent"
	#fi
fi
done

