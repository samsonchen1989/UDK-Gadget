class AwesomePawn extends UTPawn;

var bool bInvulnerable;
var float InvulnerableTime;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	`log("AwesomePawn Spawned ! =====");

	if (ArmsMesh[0] != none)
	{
		ArmsMesh[0].SetHidden(true);
	}

	if (ArmsMesh[1] != none)
	{
		ArmsMesh[1].SetHidden(true);
	}
}

simulated function SetMeshVisibility(bool bVisible)
{
	super.SetMeshVisibility(bVisible);
	Mesh.SetOwnerNoSee(false);
}

function EndInvulnerable()
{
	bInvulnerable = false;
}

event Bump(Actor Other, PrimitiveComponent OtherComp, vector HitNormal)
{
	//god like for 0.6s, in case of persistent damage
	if (AwesomeEnemy(Other) != none && bInvulnerable != true)
	{
		bInvulnerable = true;
		SetTimer(InvulnerableTime, false, 'EndInvulnerable');
		TakeDamage(AwesomeEnemy(Other).BumpDamage, none, Location, vect(0, 0, 0),
				class'UTDmgType_LinkPlasma');
	}
}

DefaultProperties
{
	InvulnerableTime=0.6
}