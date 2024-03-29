/**
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 */
class MaterialExpressionScreenSize extends MaterialExpression
	native(Material);

cpptext
{
	virtual INT Compile(FMaterialCompiler* Compiler, INT OutputIndex);
	virtual FString GetCaption() const;
}

defaultproperties
{
	MenuCategories(0)="Vectors"
	Outputs(0)=(OutputName="X/Y",Mask=1,MaskR=1,MaskG=1,MaskB=0,MaskA=0)
	Outputs(1)=(OutputName="X",Mask=1,MaskR=1,MaskG=0,MaskB=0,MaskA=0)
	Outputs(2)=(OutputName="Y",Mask=1,MaskR=0,MaskG=1,MaskB=0,MaskA=0)
}
