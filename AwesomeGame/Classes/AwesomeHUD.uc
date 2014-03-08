class AwesomeHUD extends UTGFxHUDWrapper;

simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

event DrawHUD()
{
	super.DrawHUD();

	Canvas.DrawColor = WhiteColor;
	Canvas.Font = class'Engine'.Static.GetLargeFont();

	if (PlayerOwner.Pawn != none && AwesomeWeapon(PlayerOwner.Pawn.Weapon) != none)
	{
		Canvas.SetPos(Canvas.ClipX * 0.1, Canvas.ClipY * 0.9);
		Canvas.DrawText("Weapon Level:" @AwesomeWeapon(PlayerOwner.Pawn.Weapon).CurrentWeaponLevel);
	}

	if (AwesomeGame(WorldInfo.Game) != none)
	{
		Canvas.SetPos(Canvas.ClipX * 0.1, Canvas.ClipY * 0.95);
		if (AwesomeGame(WorldInfo.Game).bSpawnBoss == false)
		{
			Canvas.DrawText("Enemies Left:" @AwesomeGame(WorldInfo.Game).EnemiesLeft);
		}
		else if (AwesomeGame(WorldInfo.Game).TheBoss != none)
		{
			Canvas.DrawText("Boss Health:" @AwesomeGame(WorldInfo.Game).TheBoss.Health);
			if (AwesomeGame(WorldInfo.Game).TheBoss.Health <= 10)
			{
				Canvas.SetPos(Canvas.ClipX * 0.4, Canvas.ClipY * 0.7);
				Canvas.DrawText("BOSS SUPER RAGE MODE");
			}
		}
	}

/*
	if (AwesomeGame(WorldInfo.Game) != none && !AwesomeGame(WorldInfo.Game).bFirstEnemySpawned &&
		AwesomeGame(WorldInfo.Game).IsTimerActive('ActivateSpawners'))
	{
		Canvas.SetPos(Canvas.ClipX * 0.1, Canvas.ClipY * 0.85);
		Canvas.DrawText("Time Left To First Spawn:" 
			@AwesomeGame(WorldInfo.Game).GetRemainingTimeForTimer('ActivateSpawners'));
	}
*/
}

DefaultProperties
{
	
}