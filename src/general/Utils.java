package general;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.json.JSONObject;

public class Utils {

	public static String makeSafe(String s) {
		return (null == s) ? "" : s;
	}

	public static String getParamStringS(String str, String value) throws Exception {
		if ((null != str) && (str.length() > 0) && (!str.equalsIgnoreCase("null"))) {
			return str;
		} else {
			return value;
		}
	}
	
	public static String formateStringDateToStringForMySql(String date,String format) throws ParseException{
		SimpleDateFormat sdf;
		SimpleDateFormat sdf1;;
		try{
			if(format==null || format.equals("")){
				format="yyyy/MM/dd HH:mm:ss";
			}
			sdf = new SimpleDateFormat(format);
			sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			return sdf1.format(sdf.parse(date));
		}catch(Exception ee){
			ee.printStackTrace();
			return "";
		}finally{
			sdf=null;
		}
	}
	public static String formateStringDateToStringForMySql(String date,String givenformat,String resultformat){
		String result="";
		SimpleDateFormat sdf;
		SimpleDateFormat sdf1;
		try{
			sdf = new SimpleDateFormat(givenformat);
			sdf1 = new SimpleDateFormat(resultformat);
			result=sdf1.format(sdf.parse(date));
		}catch(Exception e){
			e.printStackTrace();
			return "";
		}finally{
			sdf=null;
			sdf1=null;
		}
		return result;
	}
	
	public static String getValue(String key, String value,JSONObject obj){
    	if(null == obj || obj.toString().equals("{}")){
    		return value;
    	}
		if (obj.isNull(key)) {
			return value;
	    } else{
	    	String ret=value;
	    	try{
	    		ret=obj.getString(key);
	    	}catch (Exception e) {
	    		return ret;
			}
	    	return ret;
	    }
	}
	
	public static int getValue(String key, int value,JSONObject obj){
    	if(null == obj || obj.toString().equals("{}")){
    		return value;
    	}
		if (obj.isNull(key)) {
			return value;
	    } else{
	    	int i=value;
	    	try{
	    		i=obj.getInt(key);
	    	}catch (Exception e) {
	    		return i;
			}
	    	return i;
	    }
	}
	public static double getValue(String key, double value,JSONObject obj){
    	if(null == obj || obj.toString().equals("{}")){
    		return value;
    	}
		if (obj.isNull(key)) {
			return value;
	    } else{
	    	double i=value;
	    	try{
	    		i=obj.getDouble(key);
	    	}catch (Exception e) {
	    		return i;
			}
	    	return i;
	    }
	}
	public static boolean getValue(String key, boolean value,JSONObject obj) {
    	if(null == obj || obj.toString().equals("{}")){
    		return value;
    	}
		if (obj.isNull(key)) {
			return value;
	    } else{
	    	boolean i=value;
	    	try{
	    		i=obj.getBoolean(key);
	    	}catch (Exception e) {
	    		return i;
			}
	    	return i;
	    }
    } 
	
}
