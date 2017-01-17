utils = function() {
};

utils.validateEmail=function(email) {
	var emailReg = new RegExp(/^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/);
	if (!emailReg.test(email)) {
		return false;
	} else {
		return true;
	}
};