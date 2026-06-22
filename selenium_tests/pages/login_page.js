const { By, until } = require('selenium-webdriver');

class LoginPage {
    constructor(driver) {
        this.driver = driver;
        this.emailInput = By.id('email');
        this.passwordInput = By.id('password');
        this.loginButton = By.id('login-button');
    }

    async login(email, password) {
        await this.driver.wait(until.elementLocated(this.emailInput), 10000);
        await this.driver.findElement(this.emailInput).sendKeys(email);
        await this.driver.findElement(this.passwordInput).sendKeys(password);
        await this.driver.findElement(this.loginButton).click();
    }

    async getSuccessMessage() {
        await this.driver.wait(until.elementLocated(By.id('success-msg')), 10000);
        return await this.driver.findElement(By.id('success-msg')).getText();
    }
}

module.exports = LoginPage;
