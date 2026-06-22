class AuthPage {
    constructor(driver) {
        this.driver = driver;
    }

    // Use driver.$ instead of global $
    get emailField() { return this.driver.$('//android.widget.EditText[@content-desc="Email"]') }
    get passwordField() { return this.driver.$('//android.widget.EditText[@content-desc="Password"]') }
    get loginBtn() { return this.driver.$('//android.view.View[@content-desc="LOGIN"]') }

    async login(email, password) {
        await this.emailField.setValue(email);
        await this.passwordField.setValue(password);
        await this.loginBtn.click();
    }
}

module.exports = AuthPage;
