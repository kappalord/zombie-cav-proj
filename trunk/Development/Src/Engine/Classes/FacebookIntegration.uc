/**
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 *
 * This is the base class for Facebook integration (each platform has a subclass
 */
class FacebookIntegration extends PlatformInterfaceBase
	native(PlatformInterface)
	config(Engine);



enum EFacebookIntegrationDelegate
{
	FID_AuthorizationComplete,
	FID_FacebookRequestComplete,
	FID_WebRequestComplete,
	FID_DialogComplete,
	FID_FriendsListComplete,
};


/** The application ID to link to */
var config string AppID;

/** Username of the current user */
var string Username;

/** Id of the current user */
var string UserId;

/** Access token as retrieved from FB */
var string AccessToken;


/** Structure to hold a Facebook friend */
struct native FacebookFriend
{
	/** The user's display name */
	var string Name;

	/** The user's id, can be used to send messages, etc */
	var string Id;
};

/** The list of friends that is filled out as soon as the user logs on */
var array<FacebookFriend> FriendsList;


/**
 * Perform any needed initialization
 */
native event bool Init();

/**
 * Starts the process of allowing the app to use Facebook
 */
native event bool Authorize();

/**
 * @return true if the app has been authorized by the current user
 */
native event bool IsAuthorized();

/**
 * Kicks off a generic web request (response will come via delegate call)
 *
 * @param URL The URL for the request, can be http or https (if the current platform supports sending https)
 * @param Verb The action to take ("POST", "GET")
 * @param Payload An optional payload to send in the web request, as UTF-8
 * @param Tag A user-defined Tag that will be sent back in the callback
 * @param bRetrieveHeaders If TRUE, the response object will contain all the headers (using false will reduce a lot of memory churn)
 * @param bForceBinaryResponse if TRUE, then the response is never converted to a string and is stored in the binary response data
 */
native event WebRequest(string URL, string Verb, string Payload, int Tag, bool bRetrieveHeaders, bool bForceBinaryResponse);

/**
 * Kicks off a Facebook GraphAPI request (response will come via delegate)
 *
 * @param GraphRequest The request to make (like "me/groups")
 */
native event FacebookRequest(string GraphRequest);

/**
 * Shows a facebook dialog (ie, posting to wall)
 *
 * @param Action The dialog to open (like "feed")
 * @param KeysAndValues The extra parameters to pass to the dialog (dialog specific). Separate keys and values: < "key1", "value1", "key2", "value2" >
 */
native event FacebookDialog(string Action, array<string> ParamKeysAndValues);

/**
 * Call this to disconnect from Facebook. Next time authorization happens, the auth webpage
 * will be shown again
 */
native event Disconnect();
