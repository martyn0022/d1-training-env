/// patient_chiefcomplain_info table: one chief complaint per admission.
///
/// ClaimVisit.ChiefComplaint holds the same value keyed by visit; this table
/// is keyed by admission.
Class D1.Mock.Data.ClaimChiefComplaint Extends %Persistent
{

Property AdmissionNumber As %String(MAXLEN = 50) [ Required ];

/// Unique: one chief complaint per admission.
Index AdmissionIdx On AdmissionNumber [ Unique ];

Property HospitalNumber As %String(MAXLEN = 50);

Index HospitalIdx On HospitalNumber;

Property ChiefComplaint As %String(MAXLEN = 255);

Storage Default
{
<Data name="ClaimChiefComplaintDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>AdmissionNumber</Value>
</Value>
<Value name="3">
<Value>HospitalNumber</Value>
</Value>
<Value name="4">
<Value>ChiefComplaint</Value>
</Value>
</Data>
<DataLocation>^D1.Mock.Data.ClaimChiefC835DD</DataLocation>
<DefaultData>ClaimChiefComplaintDefaultData</DefaultData>
<IdLocation>^D1.Mock.Data.ClaimChiefC835DD</IdLocation>
<IndexLocation>^D1.Mock.Data.ClaimChiefC835DI</IndexLocation>
<StreamLocation>^D1.Mock.Data.ClaimChiefC835DS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
