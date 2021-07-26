-- 1
SELECT LEFT(LastName, 1) AS Initial_of_Surname, COUNT(*) AS Count_of_Players
FROM player
GROUP BY(LEFT(LastName, 1))
ORDER BY(LEFT (LastName, 1));

-- 2
SELECT game.GameID AS Game_ID, season.SeasonYear AS Season_Year, t1.TeamName AS Team1_Name, t2.TeamName AS Team2_Name
FROM season, game, team t1, team t2
WHERE (season.SeasonID = game.SeasonID
    AND game.Team1 = t1.TeamID
    AND t2.TeamID = game.Team2
    AND game.T1Score IS NULL
    AND game.T2Score IS NULL);
    

-- 3
SELECT FirstName, LastName
FROM player
WHERE player.PlayerID IN (SELECT PlayerID
											FROM playerteam
											GROUP BY PlayerID
											HAVING COUNT(*) > 20) ;
                                            
-- 4
SELECT FirstName, LastName, COUNT(*) AS Number_of_Games_Played
FROM player NATURAL JOIN clubplayer NATURAL JOIN playerteam
WHERE clubplayer.ClubID = 2
	AND clubplayer.ToDate IS NULL
    AND player.PlayerID IN (SELECT PlayerID
											FROM playerteam
											GROUP BY PlayerID
											HAVING COUNT(*) <12)
GROUP BY playerteam.PlayerID
ORDER BY COUNT(*) desc;

-- 5
SELECT DISTINCT FirstName, LastName
FROM player NATURAL JOIN playerteam NATURAL JOIN game NATURAL JOIN season NATURAL JOIN competition
WHERE (Sex LIKE 'M' 
	AND PlayerID = playerteam.PlayerID 
    AND playerteam.GameID = game.GameID
    AND game.SeasonID = season.SeasonID
    AND season.CompetitionID = competition.CompetitionID
    AND (competition.CompetitionID <> 1 AND competition.CompetitionID = 3));
    
-- 6
SELECT CONCAT(FirstName, ' ', LastName) AS Full_Name, club.ClubName
FROM player NATURAL JOIN club NATURAL JOIN team NATURAL JOIN game NATURAL JOIN season NATURAL JOIN playerteam
WHERE (club.ClubID = team.ClubID
	AND (team.TeamID = game.Team1  OR team.TeamID = game.Team2)
    AND game.SeasonID = season.SeasonID
    AND season.SeasonID = 2017
    AND player.PlayerID IN (SELECT PlayerID
											FROM playerteam
											GROUP BY PlayerID
											HAVING COUNT(*) = 0));
                                            
-- 7
SELECT ClubName , COUNT(*) AS Number_of_Female_Players
FROM club NATURAL JOIN clubplayer NATURAL JOIN player
WHERE (ClubID = clubplayer.ClubID
	AND clubplayer.PlayerID = player.PlayerID
    AND Sex LIKE 'F')
GROUP BY ClubName
ORDER BY Count(*)
LIMIT 1;

-- 8

SELECT GameID,
CASE WHEN game.T1score > game.T2score THEN team2
WHEN game.T1score < game.T2score THEN team1
ELSE 'Draw'
END AS LostTeam
FROM game;

-- 9
SELECT DISTINCT FirstName, LastName
FROM player NATURAL JOIN clubplayer
WHERE (PlayerID = clubplayer.PlayerID
	AND clubplayer.ToDate IS NOT NULL);

-- 10
SELECT SUM(score) AS TotalScore
FROM (
   (SELECT SUM(T1Score) AS score
   FROM team NATURAL JOIN playerteam NATURAL JOIN game
   WHERE (game.SeasonID = 2 
   AND playerteam.TeamID = 12 
   AND game.Team1 = 12)
   )
UNION
   (SELECT SUM(T2Score) AS score
   FROM team NATURAL JOIN playerteam NATURAL JOIN game
   WHERE (game.SeasonID = 2 
	AND playerteam.TeamID = 12 
    AND Team2 = 12)
    )
)
AS scores;