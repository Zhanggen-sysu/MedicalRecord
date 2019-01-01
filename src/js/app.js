App = {
  web3Provider: null,
  contracts: {},

  init: async function() {

    return await App.initWeb3();
  },

  initWeb3: async function() {

	 // Is there an injected web3 instance?
	  if (typeof web3 !== 'undefined') {
		App.web3Provider = web3.currentProvider;
	  } else {
		// If no injected web3 instance is detected, fall back to Ganache
		App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
	  }
	  web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    /*
     * Replace me...
     */
	// 加载MedicalRecord.json，保存了MedicalRecord的ABI（接口说明）信息及部署后的网络(地址)信息，它在编译合约的时候生成ABI，在部署的时候追加网络信息
	  $.getJSON('MedicalRecord.json', function(data) {
		// 用MedicalRecord.json数据创建一个可交互的TruffleContract合约实例。
		var MedicalRecordArtifact = data;
		App.contracts.MedicalRecord = TruffleContract(MedicalRecordArtifact);

		// Set the provider for our contract
		App.contracts.MedicalRecord.setProvider(App.web3Provider);

		// Use our contract to retrieve and mark the adopted pets
		//return App.markAdopted();
	  });
	  return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '#give', App.handleGive);
	$(document).on('click', '#add', App.handleAdd);
	$(document).on('click', '#get', App.handleGet);
  },

  handleGive: function(){

	  var MedicalRecordInstance;
	  var address = document.getElementById("address").value;
	  var name = document.getElementById("name").value;
	  var times = document.getElementById("times").value;
	  tiems = parseInt(times);
	  if(address == "" || name == "" || times == ""){
		alert("Input cannot be empty");
	  }
	  else if(!/^\+?[1-9][0-9]*$/.test(times)){
		alert("Operation tiems should be Positive integer");
	  }
	  else{

		var account = web3.eth.getCoinbase();

		App.contracts.MedicalRecord.deployed()
		.then(function(instance){
			MedicalRecordInstance = instance;
			return MedicalRecordInstance.giveRightToOperate(address, name, times, {from: account});
		}).then(function(result) {
			console.log(result);
		}).catch(function(err) {
			alert(err.message);
		});
	  }

  },

  handleAdd: function(){

	var MedicalRecordInstance;
	var diseasetypes = document.getElementsByName("diseasetype");
	var diseasetype;
	var diseasename = document.getElementById("diseasename").value;
	var diseasesymptom = document.getElementById("diseasesymptom").value;
	var diseasetreatment = document.getElementById("diseasetreatment").value;
	var date = document.getElementById("date").value;
	for(var i = 0; i < diseasetypes.length; i ++){
		if(diseasetypes[i].checked){
			diseasetype = diseasetypes[i].value;
		}
	}
	if(diseasename == "" || diseasesymptom == "" || diseasetreatment == "" || date == ""){
		alert("Input cannot be empty");
	}
	else{

		var account = web3.eth.getCoinbase();

		App.contracts.MedicalRecord.deployed()
		.then(function(instance){
			MedicalRecordInstance = instance;
			return MedicalRecordInstance.addRecord(diseasetype, diseasename, diseasesymptom, diseasetreatment, date, {from: account});
		}).then(function(result) {
			console.log(result);
		}).catch(function(err) {
			alert(err.message);
		});

	}

  },

  eventCallBack:function(error, result){
		if(!error){

			var t = document.getElementById("result");
			t.value = result.args._value;

		}
	},

  handleGet: function(){
	var MedicalRecordInstance;
	var diseasetypes = document.getElementsByName("diseasetype");
	var diseasetype;
	var result = document.getElementById("result");
	result.value = "  ";
	var owner;
	var ret;
	for(var i = 0; i < diseasetypes.length; i ++){
		if(diseasetypes[i].checked){
			diseasetype = diseasetypes[i].value;
		}
	}
	var account = web3.eth.getCoinbase();

		App.contracts.MedicalRecord.deployed()
		.then(function(instance){
			MedicalRecordInstance = instance;
			event = MedicalRecordInstance.returnValue();
			event.watch(App.eventCallBack);
			return MedicalRecordInstance.getRecord(diseasetype,{from: account});
		}).then(function(ret) {
			console.log(ret);
		}).catch(function(err) {
			alert(err.message);
		});
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
