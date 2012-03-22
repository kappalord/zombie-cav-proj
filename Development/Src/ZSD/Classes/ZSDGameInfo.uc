class ZSDGameInfo extends UTGame;

event PostBeginPlay()
{
	super.PostBeginPlay();

	`log("Loading Custom ZSD Game");
}

DefaultProperties
{
	PlayerControllerClass=class'ZSDPlayerController'
	DefaultPawnClass=class'ZSDPawn'
	BotClass=class'ZSDZombie'

	bDelayedStart=false

	// *********** Below is for UTTeamGame Extension trying *********** //

	//bScoreTeamKills=false
	//bMustJoinBeforeStart=false
	//bTeamGame=true
	//TeamAIType(1)=class'ZSD.ZSDZombieAI'

	//HUDType=class'ZSD.ZSDHud'

	//bIgnoreTeamForVoiceChat=false

	//OnlineStatsWriteClass=Class'UTStatsWriteTDM'
}
