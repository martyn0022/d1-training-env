/// One preauth[] entry in the /local/preauth-info response. Each row carries
/// its own hospital_number / admission_number, since a date-range query can
/// span several admissions.
Class D1.Mock.Msg.PreAuthDetail Extends (%SerialObject, %JSON.Adaptor, %XML.Adaptor)
{

Property HospitalNumber As %String(%JSONFIELDNAME = "hospital_number", MAXLEN = 50);

Property AdmissionNumber As %String(%JSONFIELDNAME = "admission_number", MAXLEN = 50);

/// Authorization ID, e.g. "REQ000000P1"
Property ClaimId As %String(%JSONFIELDNAME = "claim_id", MAXLEN = 50);

/// Case number, e.g. "PA-2026-071122"
Property ClaimCaseNumber As %String(%JSONFIELDNAME = "claim_case_number", MAXLEN = 50);

/// "Waiting for Medical" / "Pre-Accepted" / "Rejected" / "Pre-Authorize Submitted"
Property ClaimStatus As %String(%JSONFIELDNAME = "claim_status", MAXLEN = 50);

/// Wire format yyyy-MM-dd HH:mm:ss
Property SubmitDate As %String(%JSONFIELDNAME = "submit_date", MAXLEN = 30);

/// Per row, not on the response root: a multi-row result needs one figure
/// per pre-auth.
Property EstimatedCost As %Numeric(%JSONFIELDNAME = "estimated_cost", SCALE = 2);

Storage Default
{
<Data name="PreAuthDetailState">
<Value name="1">
<Value>HospitalNumber</Value>
</Value>
<Value name="2">
<Value>AdmissionNumber</Value>
</Value>
<Value name="3">
<Value>ClaimId</Value>
</Value>
<Value name="4">
<Value>ClaimCaseNumber</Value>
</Value>
<Value name="5">
<Value>ClaimStatus</Value>
</Value>
<Value name="6">
<Value>SubmitDate</Value>
</Value>
<Value name="7">
<Value>EstimatedCost</Value>
</Value>
</Data>
<State>PreAuthDetailState</State>
<StreamLocation>^D1.Mock.Msg.PreAuthDetailS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
