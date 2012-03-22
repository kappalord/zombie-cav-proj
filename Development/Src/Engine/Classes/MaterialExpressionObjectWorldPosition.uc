/**
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 */
class MaterialExpressionObjectWorldPosition extends MaterialExpression
	native(Material)
	collapsecategories
	hidecategories(Object);

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	virtual FString GetCaption() const;
}

defaultproperties
{
	MenuCategories(0)="Vectors"
	MenuCategories(1)="Coordinates"
	MenuCategories(2)="WorldPosOffset"
}
