/**
 * 
 */

var APIAdapter2 = (function(){
	
	return {
		LMSInitialize: function(param) {
			var result;
			$.ajax({
				type: "get",
				url: "LMSInitialize",
				data: {
					"param": param
				},
				cache: false,
				async: false,
				success: function(data) {
					result = data;
				}
			});
			return result;
		},
		LMSFinish: function(param) {
			var result;
			$.ajax({
				type: "get",
				url: "LMSFinish",
				data: {
					"param": param
				},
				cache: false,
				async: false,
				success: function(data) {
					result = data;
				}
			});
			return result;
		},
		LMSGetValue: function(element) {
			var result;
			$.ajax({
				type: "get",
				url: "LMSGetValue",
				data: {
					"element": element
				},
				cache: false,
				async: false,
				success: function(data) {
					result = data;
				}
			});
			return result;
		},
		LMSSetValue: function(element, value) {
			var result;
			$.ajax({
				type: "get",
				url: "LMSSetValue",
				data: {
					"element": element,
					"value": value
				},
				cache: false,
				async: false,
				success: function(data) {
					result = data;
				}
			});
			return result;
		},
		LMSCommit: function(param) {
			var result;
			$.ajax({
				type: "get",
				url: "LMSCommit",
				data: {
					"param": param
				},
				cache: false,
				async: false,
				success: function(data) {
					result = data;
				}
			});
			return result;
		},
		LMSGetLastError: function() {
			var result;
			$.ajax({
				type: "get",
				url: "LMSGetLastError",
				cache: false,
				async: false,
				success: function(data) {
					result = data;
				}
			});
			return result;
		},
		LMSGetErrorString: function(errorCode) {
			var result;
			$.ajax({
				type: "get",
				url: "LMSGetErrorString",
				data: {
					"errorCode": errorCode
				},
				cache: false,
				async: false,
				success: function(data) {
					result = data;
				}
			});
			return result;
		},
		LMSGetDiagnostic: function(errorCode) {
			var result;
			$.ajax({
				type: "get",
				url: "LMSGetDiagnostic",
				data: {
					"errorCode": errorCode
				},
				cache: false,
				async: false,
				success: function(data) {
					result = data;
				}
			});
			return result;
		}
	}
})();