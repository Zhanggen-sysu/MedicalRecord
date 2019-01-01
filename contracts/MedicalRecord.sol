pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

 
contract MedicalRecord{
	
	//Define disease strcut

	struct Disease{
		
		string diseasetype;
		string diseasename;
		string symptom;
		string treatment;
		string doctorname;
		string date;
	
	}
	
	struct Owner{ 
	    
	    string name;
	    string birthday;
	    uint sex;
	    string phone;
	    string homeaddress;
	    string email;
	    address accountaddress;
	 
	}
	
	//MedicalRecord
	
	Disease[] records;
	
	//Get return records
	
	Disease[] ret;
	
	//Define doctor
	
	struct Doctor{
		
		uint operatetime;
		string name;
		
	}
	
	//MedicalRecord's owner
	
	Owner owner;
	
	//doctor who has right to operate this MedicalRecord
	
	mapping(address => Doctor) authorizedoctor;
	
	//Owner's information
	
	constructor(string memory name, string memory birthday, uint sex, string memory phone, string memory homeaddress, string memory email) public{
		
		owner.accountaddress = msg.sender;
		owner.name = name;
		owner.birthday = birthday;
		owner.sex = sex;
		owner.phone = phone;
		owner.homeaddress = homeaddress;
		owner.email = email;
		
	
	}
	
	function strConcat(string memory _a, string memory _b) public returns (string memory){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory str = new string (_ba.length + _bb.length);
        bytes memory bret = bytes(str);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++)bret[k++] = _ba[i];
        for (uint i = 0; i < _bb.length; i++) bret[k++] = _bb[i];
        return string(str);
   }
	
	//give right to a doctor to operate this MedicalRecord
	
	function giveRightToOperate(address doctor,string memory name, uint times) public {
	    
		require(msg.sender == owner.accountaddress,"Only owner can give right to operate this Medical Record.");
		require(times > 0, "Operate times should larger than 0");
		authorizedoctor[doctor].operatetime = times;
		authorizedoctor[doctor].name = name;
		
	}
	
	event returnValue(
	        address indexed _from,
		    string _value
	);
	
	function getRecord(string memory diseasetype) public{
		Doctor storage doctor = authorizedoctor[msg.sender];
		require(doctor.operatetime > 0 || msg.sender == owner.accountaddress, "You don't have right to operate this Medical Record");
	    if(ret.length > 0)delete ret;
		
		for(uint i = 0; i < records.length; i ++){
		    if(bytes(diseasetype).length == bytes(records[i].diseasetype).length){
		        uint j = 0;
		        for (; j < bytes(diseasetype).length; j ++) {
                    if(bytes(records[i].diseasetype)[j] != bytes(diseasetype)[j]) {
                        break;
                    }
                }
                if(j >= bytes(diseasetype).length){
                    ret.push(records[i]);
                }
		    }
		}
		doctor.operatetime = doctor.operatetime - 1;
		
		string memory result = "";
		result = strConcat(result, "Personal information:\n");
		result = strConcat(result, "\nname: ");
		result = strConcat(result, owner.name);
		result = strConcat(result, "\nbirthday: ");
		result = strConcat(result, owner.birthday);
		result = strConcat(result, "\ngender: ");
		if(owner.sex == 1){
		    result = strConcat(result, "male");
		}
		else{
		    result = strConcat(result, "female");
		}
		result = strConcat(result, "\nphone: ");
		result = strConcat(result, owner.phone);
		result = strConcat(result, "\nhome address: ");
		result = strConcat(result, owner.homeaddress);
		result = strConcat(result, "\nemail: ");
		result = strConcat(result, owner.email);
		result = strConcat(result, "\n\n\n\nMedical Record:");
        
        
        for(uint i = 0; i < ret.length; i ++){
            result = strConcat(result, "\n\ndiseasetype: ");
            result = strConcat(result, ret[i].diseasetype);
            result = strConcat(result, "\ndiseasename: ");
            result = strConcat(result, ret[i].diseasename);
            result = strConcat(result, "\nsymptom: ");
            result = strConcat(result, ret[i].symptom);
            result = strConcat(result, "\ntreatment: ");
            result = strConcat(result, ret[i].treatment);
            result = strConcat(result, "\ndoctorname: ");
            result = strConcat(result, ret[i].doctorname);
            result = strConcat(result, "\ndate: ");
            result = strConcat(result, ret[i].date);
        }
		
		emit returnValue(msg.sender,  result);
		
	}
	
	function addRecord(string memory _diseasetype, string memory _diseasename,string memory _symptom,string memory _treatment, string memory _date) public {

	    Doctor storage doctor = authorizedoctor[msg.sender];
	    require(doctor.operatetime > 0 || msg.sender == owner.accountaddress, "You don't have right to operate this Medical Record");
	    records.push(Disease({diseasetype:_diseasetype,diseasename:_diseasename,symptom:_symptom,treatment:_treatment,doctorname:doctor.name, date:_date
	    }));
	    doctor.operatetime = doctor.operatetime - 1;
	    
	}
	
}