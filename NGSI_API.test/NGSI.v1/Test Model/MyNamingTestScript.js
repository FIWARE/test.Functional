
function completeName(name,test) {
	var activated_aims = activatedAims(test);
	var activatedString = '';
	for (var aimIndex = 0; aimIndex < size(activated_aims); aimIndex++) {
		var aim = at(activated_aims,aimIndex)
		activatedString += aim+" ";
	}
	
	return lastOf(activated_aims) + '_'+ discriminantId(test,4);
}

function name(test) {
	var stories = reachedBpmnStories(test)
	if (isEmpty(stories)) {
		return completeName(smartName(test),test)
	}
	
	return completeName(smartName(test),test)
}
