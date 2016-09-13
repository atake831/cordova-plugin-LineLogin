var exec = require('cordova/exec');

exports.login = function(arg0, success, error) {
    exec(success, error, "LineLogin", "login", [arg0]);
};

exports.logout = function(arg0, success, error) {
    exec(success, error, "LineLogin", "logout", [arg0]);
};
