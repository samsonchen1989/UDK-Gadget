class AwesomeWeapon extends UTWeapon;

const MAX_LEVEL = 5;

var int CurrentWeaponLevel;
var float FireRates[MAX_LEVEL];

static function float GetDefaultFireRate()
{
	return default.FireRates[0];
}

function UpgradeWeapon()
{
	if (CurrentWeaponLevel < MAX_LEVEL)
	{
		CurrentWeaponLevel++;
	}

	FireInterval[0] = FireRates[CurrentWeaponLevel - 1];
	`log("Current Weapon Level:" @CurrentWeaponLevel);

	if (IsInState('WeaponFiring'))
	{
		ClearTimer(nameof(RefireCheckTimer));
		TimeWeaponFiring(CurrentFireMode);
	}

	AddAmmo(MaxAmmoCount);
}

DefaultProperties
{
	FireRates(0)=1.5
	FireRates(1)=1.0
	FireRates(2)=0.5
	FireRates(3)=0.3
	FireRates(4)=0.1

	FireInterval(0)=1.75
	FireInterval(1)=1.75
}