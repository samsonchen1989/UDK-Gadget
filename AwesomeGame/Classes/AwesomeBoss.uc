class AwesomeBoss extends AwesomeEnemy;

auto state Seeking
{
	function BeginState(Name PreviousStateName)
	{
		SetTimer(4.0, true, 'Attack');
	}

	function Tick(float DeltaTime)
	{
		local vector NewLocation;

		if (Enemy == none)
		{
			GetEnemy();
		}

		if (Enemy != none)
		{
			NewLocation = Location;
			NewLocation += normal(Enemy.Location - Location) * MovementSpeed * DeltaTime;
			NewLocation += normal((Enemy.Location - Location) cross 
								vect(0, 0, 1)) * MovementSpeed * DeltaTime;
			SetLocation(NewLocation);
		}
	}
}

state StageTwo extends Seeking
{
	function Attack()
	{
		local UTProj_Rocket MyRocket;
		MyRocket = spawn(class'UTProj_Rocket', self, , Location);
		MyRocket.Init(normal(Enemy.Location - Location));
		MyMesh.SetMaterial(0, AttackingMat);
	}
}

event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation,
				vector Momentum, class<DamageType> DamageType, optional TraceHitinfo HitInfo,
				optional Actor DamageCauser)
{
	local AwesomeEnemy AE;

	Health--;

	if (Health == 0 && EventInstigator != none && 
		EventInstigator.PlayerReplicationInfo != none)
	{
		WorldInfo.Game.ScoreObjective(EventInstigator.PlayerReplicationInfo, 1);
		foreach DynamicActors(class'AwesomeEnemy', AE)
		{
			if (AE != self)
			{
				AE.RunAway();
			}
		}

		Destroy();
	}

	if (Health == 10)
	{
		GotoState('StageTwo');
	}
}

function Attack()
{
	spawn(class'AwesomeEnemy_Minion', , , Location);
	MyMesh.SetMaterial(0, AttackingMat);
	SetTimer(1, false, 'EndAttack');
}

DefaultProperties
{
	Health=30
	MovementSpeed=128.0

	Begin Object Name=EnemyMesh
		Scale3D=(X=1.0,Y=1.0,Z=2.0)
	End Object

	Begin Object Name=CollisionCylinder
		CollisionRadius=128.0
		CollisionHeight=256.0
	End Object	
}