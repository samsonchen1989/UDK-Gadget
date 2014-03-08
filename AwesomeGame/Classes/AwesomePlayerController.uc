class AwesomePlayerController extends UTPlayerController;

var vector PlayerViewOffset;
var vector CurrentCameraLocation;
var vector DesiredCameraLocation;
var rotator CurrentCameraRotation;

var array<AwesomeActor> MyAwesomeActorArray;
var int arrayLength;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
	bNoCrosshair = true;

	`log("AwesomePlayerController spawned!");
}

reliable client function ClientSetHUD(class<HUD> newHUDType)
{
	if (myHUD != none)
	{
		myHUD.Destroy();
	}

	myHUD = spawn(class'AwesomeHUD', self);
}

function PlayerTick(float DeltaTime)
{
	super.PlayerTick(DeltaTime);

	if (Pawn != none)
	{
		DesiredCameraLocation = Pawn.Location + (PlayerViewOffset >> Pawn.Rotation);
		CurrentCameraLocation += (DesiredCameraLocation - CurrentCameraLocation) * DeltaTime * 3;
	}
}

simulated event GetPlayerViewPoint(out vector out_Location, out Rotator out_Rotation)
{
	super.GetPlayerViewPoint(out_Location, out_Rotation);

	if (Pawn.Weapon != none)
	{
		Pawn.Weapon.SetHidden(true);
	}

	if (Pawn != none)
	{
		//out_Location = Pawn.Location + (PlayerViewOffset >> Pawn.Rotation);
		out_Location = CurrentCameraLocation;
		out_Rotation = rotator(out_Location * vect(1, 1, 0) - out_Location);
	}

	CurrentCameraRotation = out_Rotation;
}

state PlayerWalking
{
	//move with camera's up, down, left, right, not the pawn's
	function ProcessMove(float DeltaTime, vector newAccel, eDoubleClickDir DoubleClickMove,
						rotator DeltaRot)
	{
		local vector X, Y, Z, AltAccel;

		GetAxes(CurrentCameraRotation, X, Y, Z);
		AltAccel = PlayerInput.aForward * Z + PlayerInput.aStrafe * Y;
		AltAccel.Z = 0;
		AltAccel = Pawn.AccelRate * Normal(AltAccel);

		super.ProcessMove(DeltaTime, AltAccel, DoubleClickMove, DeltaRot);
	}
}

function Rotator GetAdjustedAimFor(Weapon W, Vector StartFireLoc)
{
	return Pawn.Rotation;
}

exec function StartFire(optional byte FireModeNum)
{
	super.StartFire(FireModeNum);

	if (Pawn != none && UTWeap_RocketLauncher(Pawn.Weapon) != none)
	{
		Pawn.SetHidden(false);
		SetTimer(1, false, 'MakeMeInvisible');
	}
}

function MakeMeInvisible()
{
	if (Pawn != none && UTWeap_RocketLauncher(Pawn.Weapon) != none)
	{
		Pawn.SetHidden(true);
	}
}

function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
	super.NotifyChangedWeapon(PrevWeapon, NewWeapon);
	`log("NotifyChangedWeapon");
	NewWeapon.SetHidden(true);

	if (Pawn == none)
		return;

	//if AwesomeWeapon, pawn will be invisible
	if (UTWeap_RocketLauncher(NewWeapon) != none)
	{
		`log("pawn set hidden.");
		Pawn.SetHidden(true);
	} else 
	{
		`log("pawn set hidden false.");
		Pawn.SetHidden(false);
	}
}

exec function Upgrade()
{
	//call a static function
	//local float f;
	//f = class'AwesomeWeapon_RocketLauncher'.static.GetDefaultFireRate();

	if (Pawn != none && AwesomeWeapon(Pawn.Weapon) != none)
	{
		AwesomeWeapon(Pawn.Weapon).UpgradeWeapon();
	}
}

DefaultProperties
{
	PlayerViewOffset=(X=256,Y=0,Z=1024)
	arrayLength=0
}