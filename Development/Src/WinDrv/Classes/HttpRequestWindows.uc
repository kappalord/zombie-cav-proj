/** 
 * Default Windows implementation for HttpRequest.
 * See HttpRequestInterface for documentation details.
 * 
 * Copyright 1998-2012 Epic Games, Inc. All Rights Reserved.
 */
class HttpRequestWindows extends HttpRequestInterface
	native;

/** Struct to hold the pimpl idiom so it will get cleaned up when the
  * class is garbage collected.
  */
struct native HttpRequestWindowsImplContainer
{
	/** pImpl idiom. This class contains the real implementation. */
	var native private{private} pointer Impl{class FHttpRequestWindowsImpl};

	/** Define a ctor/dtor to make sure the pImpl is cleaned up. */
	structcpptext
	{
		friend class UHttpRequestWindows;
		public: FHttpRequestWindowsImplContainer();
		public: ~FHttpRequestWindowsImplContainer();
	}
};

/** Container using the above struct to manage the pImpl's lifetime. */
var HttpRequestWindowsImplContainer ImplContainer;

native function String GetHeader(String HeaderName);
native function array<String> GetHeaders();
native function String GetURLParameter(String ParameterName);
native function String GetContentType();
native function int GetContentLength();
native function String GetURL();
native function GetContent(out array<byte> Content);
native function String GetVerb();
native function HttpRequestInterface SetVerb(String Verb);
native function HttpRequestInterface SetURL(String URL);
native function HttpRequestInterface SetContent(const out array<byte> ContentPayload);
native function HttpRequestInterface SetContentAsString(String ContentString);
native function HttpRequestInterface SetHeader(String HeaderName, String HeaderValue);
native function bool ProcessRequest();
