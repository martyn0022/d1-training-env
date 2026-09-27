/// Response message for POST /local/preauth-info: preauth is an ARRAY of
/// self-contained rows (each carrying its own hospital/admission numbers and
/// estimated_cost), so a date range spanning several admissions answers
/// correctly -- see PreAuthDetail.
Class D1.Mock.Msg.D1GetPreAuthInfoResponse Extends (%RegisteredObject, %JSON.Adaptor)
{

Property ResponseCode As %String(%JSONFIELDNAME = "response_code", MAXLEN = 10);

Property ResponseMessage As %String(%JSONFIELDNAME = "response_message", MAXLEN = 255);

Property PreAuth As list Of D1.Mock.Msg.PreAuthDetail(%JSONFIELDNAME = "preauth");

}
