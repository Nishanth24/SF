/*******************************************************************

*Description: Rest Callout

*Owner: AP

********************************************************************/

public class SendAccount123 {


String clientId = '3MVG9dZJodJWITStuEh_VOmxX8fMiqJZTzqgZqvHQTFJPVKpBjpQRIZsvvA1MvPbMXtgeyhv9fFnN9uNYbkGP';


String clientsecret='6749128314316670215';


String username='rednishanth@salesforce.com';

String password='Prasuna-24oGA4Flp0N92yVG0WgLxpbDJ1';

String accesstoken_url='https://login.salesforce.com/services/oauth2/token';

String authurl='https://login.salesforce.com/services/oauth2/authorize';

public class deserializeResponse {

public String id;

public String access_token;

}

public String ReturnAccessToken(SendAccount123 Acc){

String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password;

// String reqbody='{"grant_type":"password","client_id":clientId,"client_secret":clientSecret,
//"username":username,"password":password}';

Http h= new Http();

HttpRequest req= new HttpRequest();

req.setBody(reqbody);

req.setMethod('POST');


req.setEndpoint('https://na57.salesforce.com/services/oauth2/token');

HttpResponse res=h.send(req);

System.debug(res.getBody()+'By-AP-1986-Response');

deserializeResponse resp1= (deserializeResponse)JSON.deserialize(res.getBody(),deserializeResponse.class);

System.debug(resp1+'By-AP-deserializeresponse');

return resp1.access_token;

}

@future(callout=true)

public static void createAccount(String Accname, String Phone, String Website){

SendAccount123 acc1= new SendAccount123();

String accessToken=acc1.ReturnAccessToken(acc1);

System.debug(accessToken+'###AP');

if(accessToken!=null){


String endPoint='https://na57.salesforce.com/services/data/v41.0/sobjects/Account'; 

String jsonstr='{"Name":"'+ Accname +'","Phone":"'+ Phone +'","Website":"'+ Website +'"}';

Http h2= new Http();

HttpRequest req2= new HttpRequest();

req2.setHeader('Authorization','Bearer ' + accessToken);

req2.setHeader('Content-Type','application/json');

req2.setHeader('accept','application/json');

req2.setBody(jsonstr);

req2.setMethod('POST');

req2.setEndpoint(endPoint);

HttpResponse res2=h2.send(req2);

System.debug(res2+'###Akash###');

deserializeResponse deresp=(deserializeResponse)System.JSON.deserialize(res2.getBody(),deserializeResponse.class);

System.debug('### Deserialized Response ###'+deresp);

}

}

}