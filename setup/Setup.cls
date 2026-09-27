Include %occStatus

/// First-start setup for the D1 claims API training environment.
///
/// Called from setup/setup.script, which the container runs through the -a
/// hook after IRIS is live. By then the CPF merge has already created the
/// D1DEV namespace and cleared the forced password change.
///
/// Everything here is guarded by the ^D1Training.Setup sentinel, so a restart
/// is a no-op. That matters for two reasons: re-seeding would wipe any rows an
/// attendee had added, and re-loading /opt/d1/src would overwrite the routes
/// and Impl classes they wrote on Day 2.
Class D1.Training.Setup
{

/// Where the shipped classes live inside the image.
Parameter SRCDIR = "/opt/d1/src";

/// The web application the Router is served from.
Parameter APPPATH = "/api/d1claims";

/// Load the shipped classes, create the web application and seed the data --
/// once. Safe to call again; it detects the sentinel and returns.
ClassMethod Run() As %Status
{
	If $Data(^D1Training.Setup) {
		Write "[d1-setup] already set up on ", ^D1Training.Setup, " -- nothing to do.", !
		Return $$$OK
	}
	Set tSC = $$$OK
	Try {
		Write "[d1-setup] loading shipped classes into ", $Namespace, " ...", !
		$$$THROWONERROR(tSC, $SYSTEM.OBJ.LoadDir(..#SRCDIR, "ck", , 1))

		$$$THROWONERROR(tSC, ..CreateWebApp())

		Write "[d1-setup] seeding demo data ...", !
		$$$THROWONERROR(tSC, ##class(D1.Mock.Data.ClaimLoader).Reset())

		Set ^D1Training.Setup = $ZDateTime($Horolog, 3)
		Write "[d1-setup] complete.", !
	}
	Catch ex {
		Set tSC = ex.AsStatus()
		Write "[d1-setup] FAILED: ", $System.Status.GetErrorText(tSC), !
	}
	Quit tSC
}

/// Create the REST web application, unless it already exists.
/// Password authentication only (AutheEnabled 32).
ClassMethod CreateWebApp(pUrl As %String = {..#APPPATH}) As %Status
{
	Set tNamespace = $Namespace
	New $Namespace
	Set $Namespace = "%SYS"
	If ##class(Security.Applications).Exists(pUrl) {
		Write "[d1-setup] web application ", pUrl, " already exists.", !
		Return $$$OK
	}
	Set tProps("NameSpace") = tNamespace
	Set tProps("DispatchClass") = "D1.REST.Router"
	Set tProps("Enabled") = 1
	Set tProps("AutheEnabled") = 32
	Set tProps("Description") = "D1 claims API training environment"
	Write "[d1-setup] creating web application ", pUrl, " ...", !
	Return ##class(Security.Applications).Create(pUrl, .tProps)
}

/// Facilitator only: re-load the shipped classes over whatever is in the
/// namespace, after rebuilding the image with changed source.
///
/// This OVERWRITES attendee edits to shipped classes -- in particular the
/// routes they added to D1.REST.Router. Warn the room before running it.
ClassMethod ReloadShipped() As %Status
{
	Write "[d1-setup] reloading ", ..#SRCDIR, " -- this overwrites local edits to shipped classes.", !
	Return $SYSTEM.OBJ.LoadDir(..#SRCDIR, "ck", , 1)
}

}
