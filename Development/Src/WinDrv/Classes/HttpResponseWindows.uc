/** 
 * Default Windows implementation for HttpResponse.
 * See HttpResponseInterface for documentation details.
 *
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 */
class HttpResponseWindows extends HttpResponseInterface
	native;

/** Struct to hold the pimpl idiom so it will get cleaned up when the
  * class is garbage collected.
  */
struct native HttpResponseWindowsImplContainer
{
	/** pImpl idiom. This class contains the real implementation. */
	var native private{private} pointer Impl{class FHttpResponseWindowsImpl};

	/** Define a ctor/dtor to make sure the pImpl is cleaned up. */
	structcpptext
	{
		friend class UHttpResponseWindows;
		friend class FHttpTickerWindows;
		public: FHttpResponseWindowsImplContainer();
		public: ~FHttpResponseWindowsImplContainer();
	}
};

/** Container using the above struct to manage the pImpl's lifetime. */
var HttpResponseWindowsImplContainer ImplContainer;

native function String GetHeader(String HeaderName);
native function array<String> GetHeaders();
native function String GetURLParameter(String ParameterName);
native function String GetContentType();
native function int GetContentLength();
native function String GetURL();
native function GetContent(out array<byte> Content);
native function String GetContentAsString();
native function int GetResponseCode();
