class AwesomeEnemy extends AwesomeActor
	abstract;

var float BumpDamage;
var Pawn Enemy;
var float MovementSpeed;
var float AttackDistance;
var Material SeekingMat, AttackingMat, FleetingMat;
var StaticMeshComponent MyMesh;
var bool bAttacking;
var int Health;

//An actor can only be in one state at a time
//So Tick() is everywhere
auto state Seeking
{
	function BeginState(Name PreviousStateName)
	{
		if (bAttacking == false)
		{
			MyMesh.SetMaterial(0, SeekingMat);
		}
	}

	function Tick(float DeltaTime)
	{
		local vector NewLocation;

		if (bAttacking)
		{
			return;
		}

		if (Enemy == none)
		{
			GetEnemy();
		}

		if (Enemy != none)
		{
			NewLocation = Location;
			//normal, length always 1, to make speed always the same
			//, from Location to Enemy Location
			NewLocation += normal(Enemy.Location - Location) * MovementSpeed * DeltaTime;
			SetLocation(NewLocation);

			if (VSize(NewLocation - Enemy.Location) < AttackDistance)
			{
				GoToState('Attacking');
			}
		}
	}
}

/*	Subclassing states
auto state FastSeeking extends Seeking
{
	function BeginState(Name PreviousStateName)
	{
		MovementSpeed = default.MovementSpeed * 2.0;

		if (bAttacking == false)
		{
			MyMesh.SetMaterial(0, SeekingMat);
		}
	}
}
*/
state Attacking
{
	function BeginState(Name PreviousStateName)
	{
		MyMesh.SetMaterial(0, AttackingMat);
	}

	function EndState(Name NextStateName)
	{
		SetTimer(1, false, 'EndAttack');
	}

	function Tick(float DeltaTime)
	{
		bAttacking = true;

		if (Enemy == none)
		{
			GetEnemy();
		}

		if (Enemy != none)
		{
			Enemy.Bump(self, CollisionComponent, vect(0, 0, 0));

			if (VSize(Location - Enemy.Location) > AttackDistance)
			{
				GoToState('Seeking');
			}
		}
	}
}

state Fleeting
{
	//not take any damage while fleeting
	ignores TakeDamage;

	function BeginState(Name PreviousStateName)
	{
		if (bAttacking == false)
		{
			MyMesh.SetMaterial(0, FleetingMat);
		}
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
			NewLocation -= normal(Enemy.Location - Location) * MovementSpeed * DeltaTime;
			SetLocation(NewLocation);
		}
	}
}

function EndAttack()
{
	bAttacking = false;

	if (GetStateName() == 'Seeking' || IsChildState(GetStateName(), 'Seeking'))
	{
		MyMesh.SetMaterial(0, SeekingMat);
	}
}

function RunAway()
{
}

function GetEnemy()
{
	local AwesomePlayerController PC;

	foreach LocalPlayerControllers(class'AwesomePlayerController', PC)
	{
		if (PC.Pawn != none)
		{
			Enemy = PC.Pawn;
		}
	}
}

DefaultProperties
{
	BumpDamage=5.0
	MovementSpeed=256.0
	AttackDistance=96.0

	bBlockActors=true
	bCollideActors=true

	SeekingMat=Material'EditorMaterials.WidgetMaterial_Z'
	AttackingMat=Material'EditorMaterials.WidgetMaterial_X'
	FleetingMat=Material'EditorMaterials.WidgetMaterial_Y'

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=true
	End Object
	Components.Add(MyLightEnvironment)

	Begin Object Class=StaticMeshComponent Name=EnemyMesh
		StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
		Materials(0)=Material'EditorMaterials.WidgetMaterial_X'
		LightEnvironment=MyLightEnvironment
		Scale3D=(x=0.25,Y=0.25,Z=0.5)
	End Object
	Components.Add(EnemyMesh)
	MyMesh=EnemyMesh

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=32.0
		CollisionHeight=64.0
		BlockNonZeroExtent=true
		BlockZeroExtent=true
		BlockActors=true
		CollideActors=true
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)
}