var MedicalRecord = artifacts.require("MedicalRecord");

module.exports = function(deployer) {
  deployer.deploy(MedicalRecord,"John","1990.11.11",1,"15627897895","86 Brattle Street, Cambridge, MA 02138","123@163.com");
};