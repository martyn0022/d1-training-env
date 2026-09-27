Include %occStatus

/// Routing table for the D1 claims API, served under /api/d1claims.
///
/// This class holds routes and nothing else. Every Call below is one line into
/// a D1.REST.Impl class, which owns the validation and the logic.
///
/// One endpoint is provided as a worked example: /local/preauth-info. You add
/// /local/policy and /preauth/patch yourself -- a <Route> here plus a
/// one-line ClassMethod, and the D1.REST.Impl class it forwards to.
///
/// The web application (/api/d1claims) is created for you when the container
/// first starts, with this class as its dispatch class.
Class D1.REST.Router Extends %CSP.REST
{

Parameter CONTENTTYPE = "application/json";

Parameter CHARSET = "utf-8";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
  <Route Url="/local/preauth-info" Method="POST" Call="LocalPreAuthInfo" />
</Routes>
}

ClassMethod LocalPreAuthInfo() As %Status
{
	Return ##class(D1.REST.Impl.LocalPreAuthInfo).Handle()
}

}
