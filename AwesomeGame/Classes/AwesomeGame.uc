class AwesomeGame extends UTDeathmatch;

var int EnemiesLeft;
var array<AwesomeEnemySpawner> EnemySpawners;
var float MinSpawnerDistance, MaxSpawnerDistance;
var bool bFirstEnemySpawned;
var bool bSpawnBoss;
var AwesomeEnemy TheBoss;

simulated function PostBeginPlay()
{
	//local TestEnemy TE;
	local AwesomeEnemySpawner ES;
	super.PostBeginPlay();
/*
	GoalScore = 0;
	foreach DynamicActors(class'TestEnemy', TE)
	{
		GoalScore++;
	}
*/
	GoalScore = 1;

	foreach DynamicActors(class'AwesomeEnemySpawner', ES)
	{
		EnemySpawners[EnemySpawners.length] = ES;
	}

	`log("Number of spwners:" @(EnemySpawners.length));
	SetTimer(5.0, false, 'ActivateSpawners');
}

function ActivateSpawners()
{
	local int i;
	local array<AwesomeEnemySpawner> InRangeSpawner;
	local AwesomePlayerController PC;
	local float distance;

	foreach LocalPlayerControllers(Class'AwesomePlayerController', PC)
		break;

	bFirstEnemySpawned = true;
	if (PC.Pawn == none)
	{
		SetTimer(1.0, false, 'ActivateSpawners');
		return;
	}

	for (i = 0; i < EnemySpawners.length; i++)
	{
		distance = VSize(PC.Pawn.Location - EnemySpawners[i].Location);

		if (distance > MinSpawnerDistance && distance < MaxSpawnerDistance)
		{
			if (EnemySpawners[i].CanSpawnEnemy())
			{
				InRangeSpawner[InRangeSpawner.length] = EnemySpawners[i];
			}
		}
	}

	if (InRangeSpawner.length == 0)
	{
		`log("No enemy spawners within range!");
		SetTimer(1.0, false, 'ActivateSpawners');
	}

	if (bSpawnBoss == true)
	{
		TheBoss = InRangeSpawner[Rand(InRangeSpawner.length)].SpawnBoss();
	}	
	else
	{
		InRangeSpawner[Rand(InRangeSpawner.length)].SpawnEnemy();
		SetTimer(1.0 + Frand() * 3.0, false, 'ActivateSpawners');
	}
}

function ScoreObjective(PlayerReplicationInfo Scorer, int Score)
{
	super.ScoreObjective(Scorer, Score);
}

function EnemyKilled()
{
	local int i;

	if (bSpawnBoss)
	{
		return;
	}

	EnemiesLeft--;

	if (EnemiesLeft <= 0)
	{
		for (i = 0; i < EnemySpawners.length; i++)
		{
			EnemySpawners[i].MakeEnemyRunAway();
			ClearTimer('ActivateSpawners');
		}

		bSpawnBoss = true;
		ActivateSpawners();
	}
}

DefaultProperties
{
	EnemiesLeft=5
	bScoreDeaths=false
	MinSpawnerDistance=1700.0
	MaxSpawnerDistance=3000.0
	bFirstEnemySpawned=false
	//DefaultInventory(0)=none
	DefaultPawnClass=class'AwesomeGame.AwesomePawn'
	PlayerControllerClass=class'AwesomeGame.AwesomePlayerController'
}