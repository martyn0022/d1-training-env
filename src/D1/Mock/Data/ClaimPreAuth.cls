/// preauth_info table: one pre-authorization per claim, read by
/// /local/preauth-info. Auto ID + ClaimId indexed.
///
/// claim_case_number stays empty until the insurer supplies it.
///
/// ClaimStatus uses the API spec's enum spelling ("Pre-Authorize
/// Submitted").
Class D1.Mock.Data.ClaimPreAuth Extends %Persistent
{

/// Authorization ID, e.g. "REQ000000P1"
Property ClaimId As %String(MAXLEN = 50) [ Required ];

Index ClaimIdIdx On ClaimId [ Unique ];

Property HospitalNumber As %String(MAXLEN = 50);

Index HospitalIdx On HospitalNumber;

Property AdmissionNumber As %String(MAXLEN = 50);

Index AdmissionIdx On AdmissionNumber;

/// Case number, e.g. "PA-2026-071122"
Property ClaimCaseNumber As %String(MAXLEN = 50);

/// "Waiting for Medical" / "Pre-Accepted" / "Rejected" / "Pre-Authorize
/// Submitted" at the pre-auth stage; later discharge statuses ("Approved",
/// "Discharge Requested", ...) may overwrite it. It reflects the claim's
/// OVERALL current status, not just its pre-auth stage.
Property ClaimStatus As %String(MAXLEN = 50);

/// Wire format yyyy-MM-dd HH:mm:ss, stored verbatim
Property SubmitDate As %String(MAXLEN = 30);

Property EstimatedCost As %Numeric(SCALE = 2);

Storage Default
{
<Data name="ClaimPreAuthDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClaimId</Value>
</Value>
<Value name="3">
<Value>HospitalNumber</Value>
</Value>
<Value name="4">
<Value>AdmissionNumber</Value>
</Value>
<Value name="5">
<Value>ClaimCaseNumber</Value>
</Value>
<Value name="6">
<Value>ClaimStatus</Value>
</Value>
<Value name="7">
<Value>SubmitDate</Value>
</Value>
<Value name="8">
<Value>EstimatedCost</Value>
</Value>
</Data>
<DataLocation>^D1.Mock.Data.ClaimPreAuthD</DataLocation>
<DefaultData>ClaimPreAuthDefaultData</DefaultData>
<IdLocation>^D1.Mock.Data.ClaimPreAuthD</IdLocation>
<IndexLocation>^D1.Mock.Data.ClaimPreAuthI</IndexLocation>
<StreamLocation>^D1.Mock.Data.ClaimPreAuthS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
