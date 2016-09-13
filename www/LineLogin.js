var exec = require('cordova/exec');

exports.login = function(success, error) {
    exec(success, error, "LineLogin", "login", []);
};

exports.logout = function(success, error) {
    exec(success, error, "LineLogin", "logout", []);
};
