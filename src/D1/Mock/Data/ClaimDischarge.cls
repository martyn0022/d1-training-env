/// discharge_info table: the discharge claim for an admission and the
/// insurer's decision on it. Auto ID + DischargeId indexed.
Class D1.Mock.Data.ClaimDischarge Extends %Persistent
{

/// Discharge ID, e.g. "REQ000000D1" (the request's claim_id)
Property DischargeId As %String(MAXLEN = 50) [ Required ];

Index DischargeIdIdx On DischargeId [ Unique ];

Property HospitalNumber As %String(MAXLEN = 50);

Index HospitalIdx On HospitalNumber;

Property AdmissionNumber As %String(MAXLEN = 50);

Index AdmissionIdx On AdmissionNumber;

/// Guarantee letter number, e.g. "GCL-12345"
Property GlNumber As %String(MAXLEN = 50);

/// "Waiting for Medical" / "Approved" / "Rejected" / "Discharge Requested"
Property DischargeStatus As %String(MAXLEN = 50);

/// Wire format yyyy-MM-dd HH:mm:ss, stored verbatim
Property AuthorizationDate As %String(MAXLEN = 30);

Property AuthorizationAmount As %Numeric(SCALE = 2);

/// Guarantee letter issue date
Property DischargeGlDate As %String(MAXLEN = 30);

/// --- The insurer's decision. Empty until the insurer responds, so the
/// authorization fields are nullable.
/// When the patient was actually discharged, distinct from the
/// authorization_date on which the insurer decided.
Property DischargeDate As %String(MAXLEN = 30);

Property AuthorizationTitle As %String(MAXLEN = 20);

Property AuthorizationFirstName As %String(MAXLEN = 255);

Property AuthorizationLastName As %String(MAXLEN = 255);

Property Remark As %String(MAXLEN = 255);

Storage Default
{
<Data name="ClaimDischargeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DischargeId</Value>
</Value>
<Value name="3">
<Value>HospitalNumber</Value>
</Value>
<Value name="4">
<Value>AdmissionNumber</Value>
</Value>
<Value name="5">
<Value>GlNumber</Value>
</Value>
<Value name="6">
<Value>DischargeStatus</Value>
</Value>
<Value name="7">
<Value>AuthorizationDate</Value>
</Value>
<Value name="8">
<Value>AuthorizationAmount</Value>
</Value>
<Value name="9">
<Value>DischargeGlDate</Value>
</Value>
<Value name="10">
<Value>DischargeDate</Value>
</Value>
<Value name="11">
<Value>AuthorizationTitle</Value>
</Value>
<Value name="12">
<Value>AuthorizationFirstName</Value>
</Value>
<Value name="13">
<Value>AuthorizationLastName</Value>
</Value>
<Value name="14">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^D1.Mock.Data.ClaimDischargeD</DataLocation>
<DefaultData>ClaimDischargeDefaultData</DefaultData>
<IdLocation>^D1.Mock.Data.ClaimDischargeD</IdLocation>
<IndexLocation>^D1.Mock.Data.ClaimDischargeI</IndexLocation>
<StreamLocation>^D1.Mock.Data.ClaimDischargeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
