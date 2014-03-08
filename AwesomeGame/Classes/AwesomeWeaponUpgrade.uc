class AwesomeWeaponUpgrade extends AwesomeActor
	placeable;

event Touch(Actor Other, PrimitiveComponent OtherComp,
			vector HitLocation, vector HitNormal)
{
	if (Pawn(Other) != none && AwesomeWeapon(Pawn(Other).Weapon) != none)
	{
		AwesomeWeapon(Pawn(Other).Weapon).UpgradeWeapon();
		Destroy();
	}
}

DefaultProperties
{
	bCollideActors=True

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bEnabled=True
	End Object
	Components.Add(MyLightEnvironment)

	Begin Object Class=StaticMeshComponent Name=PickupMesh
		StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
		Materials(0)=Material'EditorMaterials.WidgetMaterial_Y'
		LightEnvironment=MyLightEnvironment
		Scale3D=(X=0.125,Y=0.125,Z=0.125)
	End Object
	Components.Add(PickupMesh)

	Begin Object Class=CylinderComponent Name=CollisionCylinder
		CollisionRadius=16.0
		CollisionHeight=16.0
		BlockNonZeroExtent=True
		BlockZeroExtent=True
		BlockActors=True
		CollideActors=True
	End Object
	CollisionComponent=CollisionCylinder
	Components.Add(CollisionCylinder)
}