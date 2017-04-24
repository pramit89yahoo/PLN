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
utils.fillComboCustom = function(comboName, data, value, text, firstElmValue, firstElmText) {
    var allVal = new Array();
    var combo = document.getElementById(comboName);
    combo.innerHTML = "";

    if (firstElmValue != null && firstElmText != null) {
        var option = document.createElement('option');
        option.value = firstElmValue;
        option.text = firstElmText;
        combo.add(option, combo.options[null]);
    }

    var gList = data.data;
    var gListLen = gList.length;
    for (var i = 0; i < gListLen; i++) {
        var option = document.createElement('option');
        allVal.push(gList[i][value]);
        option.value = gList[i][value];
        option.text = gList[i][text];
        combo.add(option, combo.options[null]);
    }
    return allVal;
};