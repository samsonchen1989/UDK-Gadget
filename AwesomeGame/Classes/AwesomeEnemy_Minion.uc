class AwesomeEnemy_Minion extends AwesomeEnemy;

function RunAway()
{
	GoToState('Fleeting');
}

event TakeDamage(int DamageAmount, Controller EventInstigator,
	vector HitLocation, vector Momentum, class<DamageType> DamageType,
	optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (AwesomeGame(WorldInfo.Game) != none)
	{
		AwesomeGame(WorldInfo.Game).EnemyKilled();
	}

	Destroy();
}

DefaultProperties
{
}