class AwesomeEnemySpawner extends AwesomeActor
	placeable;

var AwesomeEnemy MySpawnedEnemy;
var AwesomeBoss MySpawnedBoss;

function SpawnEnemy()
{
	`log("SpawnEnemy called.");
	if (MySpawnedEnemy == none)
	{
		MySpawnedEnemy = spawn(class'AwesomeEnemy_Minion', self, , Location);
	}	
}

function AwesomeEnemy SpawnBoss()
{
	if (MySpawnedBoss == none)
	{
		MySpawnedBoss = spawn(class'AwesomeBoss', self, , Location);
	}

	return MySpawnedBoss;
}

//Stop the spawned TestEnemy
function MakeEnemyRunAway()
{
	if (MySpawnedEnemy != none)
	{
		MySpawnedEnemy.RunAway();
	}
}

//Spawn an enemy when prev one got shoot
function EnemyDied()
{
	SpawnEnemy();
}

function TimeEnemySpawn()
{
	SetTimer(FRand() * 5.0, false, 'SpawnEnemy');
}

function bool CanSpawnEnemy()
{
	return (MySpawnedEnemy == none);
}

DefaultProperties
{
	Begin object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'EditorResources.S_NavP'
		HiddenGame=true
	End Object
	Components.Add(Sprite)
}