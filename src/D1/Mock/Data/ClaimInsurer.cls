/// insurer_info table.
///
/// NAME IS MISLEADING: this holds the INSURED PERSON -- the policyholder --
/// not the insurance company. Its columns are a person's identity (citizen
/// id, passport, name, gender, date of birth, address, phone), keyed by
/// insurer_id.
/// 
/// The insurance COMPANY lives on policy_info as company_code/company_name
/// (D1.Mock.Data.ClaimPolicy). Do not conflate the two.
Class D1.Mock.Data.ClaimInsurer Extends %Persistent
{

/// Insured person's id, e.g. "INS00001"
Property InsurerId As %String(MAXLEN = 20) [ Required ];

Index InsurerIdIdx On InsurerId [ Unique ];

Property CitizenId As %String(MAXLEN = 13);

Property PassportId As %String(MAXLEN = 20);

Property Title As %String(MAXLEN = 20);

Property FirstName As %String(MAXLEN = 255);

Property LastName As %String(MAXLEN = 255);

/// "male" / "female", matching ClaimPatient
Property Gender As %String(MAXLEN = 10);

/// Wire format yyyy-MM-dd HH:mm:ss, stored verbatim
Property BirthDate As %String(MAXLEN = 30);

Property Address As %String(MAXLEN = 255);

Property PhoneNumber As %String(MAXLEN = 20);

Storage Default
{
<Data name="ClaimInsurerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>InsurerId</Value>
</Value>
<Value name="3">
<Value>CitizenId</Value>
</Value>
<Value name="4">
<Value>PassportId</Value>
</Value>
<Value name="5">
<Value>Title</Value>
</Value>
<Value name="6">
<Value>FirstName</Value>
</Value>
<Value name="7">
<Value>LastName</Value>
</Value>
<Value name="8">
<Value>Gender</Value>
</Value>
<Value name="9">
<Value>BirthDate</Value>
</Value>
<Value name="10">
<Value>Address</Value>
</Value>
<Value name="11">
<Value>PhoneNumber</Value>
</Value>
</Data>
<DataLocation>^D1.Mock.Data.ClaimInsurerD</DataLocation>
<DefaultData>ClaimInsurerDefaultData</DefaultData>
<IdLocation>^D1.Mock.Data.ClaimInsurerD</IdLocation>
<IndexLocation>^D1.Mock.Data.ClaimInsurerI</IndexLocation>
<StreamLocation>^D1.Mock.Data.ClaimInsurerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
