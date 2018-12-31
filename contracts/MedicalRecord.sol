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
	
	//give right to a doctor to operate this MedicalRecord
	
	function giveRightToOperate(address doctor,string memory name, uint times) public {
	    
		require(msg.sender == owner.accountaddress,"Only owner can give right to operate this Medical Record.");
		require(times > 0, "Operate times should larger than 0");
		authorizedoctor[doctor].operatetime = times;
		authorizedoctor[doctor].name = name;
		
	}
	
	function getRecord(string memory diseasetype) public returns(Owner memory, Disease[] memory){
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
		return (owner,ret);
		
	}
	
	function addRecord(string memory _diseasetype, string memory _diseasename,string memory _symptom,string memory _treatment, string memory _date) public {

	    Doctor storage doctor = authorizedoctor[msg.sender];
	    require(doctor.operatetime > 0 || msg.sender == owner.accountaddress, "You don't have right to operate this Medical Record");
	    records.push(Disease({diseasetype:_diseasetype,diseasename:_diseasename,symptom:_symptom,treatment:_treatment,doctorname:doctor.name, date:_date
	    }));
	    doctor.operatetime = doctor.operatetime - 1;
	    
	}
	
}