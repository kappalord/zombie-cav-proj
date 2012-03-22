/**
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 */

/**
 * Title file downloading implementation via web service request
 */
class OnlineTitleFileDownloadWeb extends OnlineTitleFileDownloadBase
	native;

/** Struct that matches one download object per file for parallel downloading */
struct native TitleFileWeb extends OnlineSubsystem.TitleFile
{
	/** web response or string data if download succeeded */
	var string StringData;
};

/** The list of title files that have been read or are being read */
var private array<TitleFileWeb> TitleFiles;

/**
 * Starts an asynchronous read of the specified file from the network platform's
 * title specific file store
 *
 * @param FileToRead the name of the file to read
 *
 * @return true if the calls starts successfully, false otherwise
 */
function bool ReadTitleFile(string FileToRead)
{
	local FacebookIntegration FB;
	local int FileIndex,Idx;
	local string URL;

	// check for a prior request
	FileIndex = INDEX_NONE;
	for (Idx=0; Idx < TitleFiles.Length; Idx++)
	{
		// case sensitive
		if (InStr(TitleFiles[Idx].Filename,FileToRead,true,false) != INDEX_NONE)
		{
			FileIndex = Idx;
			break;
		}
	}
	// add new entry for this file request if not found
	if (FileIndex == INDEX_NONE)
	{
		FileIndex = TitleFiles.Length;
		TitleFiles.Length = TitleFiles.Length + 1;
		TitleFiles[FileIndex].Filename = FileToRead;
		TitleFiles[FileIndex].AsyncState = OERS_NotStarted;
	}
	// file has been downloaded before successfuly so already done
	if (TitleFiles[FileIndex].AsyncState == OERS_Done)
	{
		TriggerDelegates(true,FileToRead);
	}
	// file has been downloaded before but failed
	else if (TitleFiles[FileIndex].AsyncState == OERS_Failed)
	{
		TriggerDelegates(false,FileToRead);
		return false;
	}
	// download needs to start if not already in progress
	else if (TitleFiles[FileIndex].AsyncState != OERS_InProgress)
	{
		// mark the file entry as pending download
		TitleFiles[FileIndex].AsyncState = OERS_InProgress;
		// tack on the filename to the base/overridden URL
		URL = GetUrlForFile(FileToRead) $ FileToRead;
		// send off web request and register for delegate for its completion
		FB = class'PlatformInterfaceBase'.static.GetFacebookIntegration();
		FB.AddDelegate(FID_WebRequestComplete, OnWebRequestComplete);
		
		`Log(`location @ "starting read for title file"
			@"url="$URL);

		FB.WebRequest(URL,"GET","",FileIndex,false,true);
	}
	return true;
}

/**
 * Delegate called on each completed web request
 *
 * @param Result data that was returned as well as the http response
 */
private function OnWebRequestComplete(const out PlatformInterfaceDelegateResult Result)
{
	local bool bSuccess;
	local int FileIndex,Idx;
	local string Filename;
	local PlatformInterfaceWebResponse Response;

	Response = PlatformInterfaceWebResponse(Result.Data.ObjectValue);
	if (Response != None &&
		Result.Data.Type == PIDT_Object)
	{
		FileIndex = INDEX_NONE;
		// find file entry for this request based on what was passed on the URL
		for (Idx=0; Idx < TitleFiles.Length; Idx++)
		{
			if (InStr(Response.OriginalURL,TitleFiles[Idx].Filename,true,false) != INDEX_NONE)
			{
				FileIndex = Idx;
				break;
			}
		}

		`Log(`location @ ""
			@"FileIndex="$FileIndex
			@"OriginalURL="$Response.OriginalURL
			@"ResponseCode="$Response.ResponseCode
			@"Tag="$Response.Tag
			@"BinaryResponse="$Response.BinaryResponse.Length
			@"StringResponse="$Len(Response.StringResponse));

		if (FileIndex != INDEX_NONE)
		{
			Filename = TitleFiles[FileIndex].Filename;
			TitleFiles[FileIndex].AsyncState = OERS_Failed;
			if (Result.bSuccessful)
			{
				// only successful response code as we're not handling any redirects
				if (Response.ResponseCode == 200)
				{
					bSuccess = true;
					// copy the payload data from the web request
					TitleFiles[FileIndex].Data = Response.BinaryResponse;
					// mark as successfully done
					TitleFiles[FileIndex].AsyncState = OERS_Done;
				}
				// string response can contain info about a failed request
				TitleFiles[FileIndex].StringData = Response.StringResponse;
			}
			if (!bSuccess)
			{
				// clear failed data
				TitleFiles[FileIndex].AsyncState = OERS_Failed;
				TitleFiles[FileIndex].Data.Length = 0;
			}
		}
		else
		{
			`Log(`location @ "No entry found for"
				@"FileIndex="$FileIndex);
		}
	}
	else
	{
		`Log(`location @ "Invalid web response");
	}
	// web request is complete and delegate is triggered for success/failure 
	TriggerDelegates(bSuccess,Filename);
}

/**
 * Runs the delegates registered on this interface for each file download request
 *
 * @param bSuccess true if the request was successful
 * @param FileRead name of the file that was read
 */
private native function TriggerDelegates(bool bSuccess,string FileRead);

/**
 * Copies the file data into the specified buffer for the specified file
 *
 * @param FileName the name of the file to read
 * @param FileContents the out buffer to copy the data into
 *
 * @return true if the data was copied, false otherwise
 */
native function bool GetTitleFileContents(string FileName,out array<byte> FileContents);

/**
 * Determines the async state of the tile file read operation
 *
 * @param FileName the name of the file to check on
 *
 * @return the async state of the file read
 */
function EOnlineEnumerationReadState GetTitleFileState(string FileName)
{
	local int FileIndex;

	FileIndex = TitleFiles.Find('FileName',FileName);
	if (FileIndex != INDEX_NONE)
	{
		return TitleFiles[FileIndex].AsyncState;
	}
	return OERS_Failed;
}

/**
 * Empties the set of downloaded files if possible (no async tasks outstanding)
 *
 * @return true if they could be deleted, false if they could not
 */
native function bool ClearDownloadedFiles();

/**
 * Empties the cached data for this file if it is not being downloaded currently
 *
 * @param FileName the name of the file to remove from the cache
 *
 * @return true if it could be deleted, false if it could not
 */
native function bool ClearDownloadedFile(string FileName);

cpptext
{
	/**
	 * Ticks any outstanding async tasks that need processing
	 *
	 * @param DeltaTime the amount of time that has passed since the last tick
	 */
	virtual void Tick(FLOAT DeltaTime);

	/**
	 * Searches the list of files for the one that matches the filename
	 *
	 * @param FileName the file to search for
	 *
	 * @return the file details
	 */
	FTitleFileWeb* GetTitleFile(const FString& FileName);
}