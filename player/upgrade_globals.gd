extends Node


const UPGRADE_LIST =  {
	"health" : {
		"hp_up_1" : {
			"icon" : '',
			"display_name": 'Upgraded Hull I',
			"details" : 'Makes your ship tougher to sink',
			"prerequisite" : [],
			"stat_changes" : {'health' : 50},
			"cost" : 500
		},
		"hp_up_2" : {
			"icon" : '',
			"display_name": 'Upgraded Hull II',
			"details" : 'Makes your ship tougher to sink',
			"prerequisite" : ["hp_up_1"],
			"stat_changes" : {'health' : 50},
			"cost" : 1000
		},
		"hp_up_3" : {
			"icon" : '',
			"display_name": 'Upgraded Hull III',
			"details" : 'Makes your ship tougher to sink',
			"prerequisite" : ["hp_up_2"],
			"stat_changes" : {'health' : 50},
			"cost" : 2000
		},
	},
	"cargo" : {
		"cargo_up_1" : {
			"icon" : '',
			"display_name": 'Larger Cargo Hold I',
			"details" : 'Hold more booty',
			"prerequisite" : [],
			"stat_changes" : {'cargo' : 20},
			"cost" : 500
		},
		"cargo_up_2" : {
			"icon" : '',
			"display_name": 'Larger Cargo Hold II',
			"details" : 'Hold more booty',
			"prerequisite" : ["cargo_up_1"],
			"stat_changes" : {'cargo' : 20},
			"cost" : 1000
		},
		"cargo_up_3" : {
			"icon" : '',
			"display_name": 'Larger Cargo Hold III',
			"details" : 'Hold more booty',
			"prerequisite" : ["cargo_up_2"],
			"stat_changes" : {'cargo' : 20},
			"cost" : 2000
		},
	},
	"speed" : {
		"speed_up_1" : {
			"icon" : '',
			"display_name": 'Faster Sails I',
			"details" : '',
			"prerequisite" : [],
			"stat_changes" : {'speed' : 200},
			"cost" : 500
		},
		"speed_up_2" : {
			"icon" : '',
			"display_name": 'Faster Sails II',
			"details" : '',
			"prerequisite" : ["speed_up_1"],
			"stat_changes" : {'speed' : 200},
			"cost" : 1000
		},
		"speed_up_3" : {
			"icon" : '',
			"display_name": 'Faster Sails III',
			"details" : '',
			"prerequisite" : ["speed_up_2"],
			"stat_changes" : {'speed' : 200},
			"cost" : 2000
		},
	},
	"steering" : {
		"steering_up_1" : {
			"icon" : '',
			"display_name": 'Better Rudder I',
			"details" : 'This thing handles like a boat!',
			"prerequisite" : [],
			"stat_changes" : {'steering' : 1},
			"cost" : 500
		},
		"steering_up_2" : {
			"icon" : '',
			"display_name": 'Better Rudder II',
			"details" : 'This thing handles like a boat!',
			"prerequisite" : ["steering_up_1"],
			"stat_changes" : {'steering' : 1},
			"cost" : 1000
		},
		"steering_up_3" : {
			"icon" : '',
			"display_name": 'Better Rudder III',
			"details" : 'This thing handles like a boat!',
			"prerequisite" : ["steering_up_2"],
			"stat_changes" : {'steering' : 1},
			"cost" : 2000
		},
	}
}
