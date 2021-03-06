/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import AuthUtils from "../../../utils/api/authUtils";
import HttpUtils, {HubApiError} from "../../../utils/api/httpUtils";
import * as axios from "axios";

/**
 * Configuration holder.
 */
class StateHolder {

    static CONFIG = "config";
    static USER = "user";
    static NOTIFICATION_STATE = "notificationState";
    static LOADING_STATE = "loadingState";

    /**
     * @type {Object}
     * @private
     */
    state = {};

    /**
     * Initialize the State Holder.
     */
    constructor() {
        const self = this;
        window.addEventListener("storage", () => {
            self.set(StateHolder.USER, AuthUtils.getAuthenticatedUser());
        });

        const rawState = {
            [StateHolder.USER]: AuthUtils.getAuthenticatedUser(),
            [StateHolder.CONFIG]: {},
            [StateHolder.LOADING_STATE]: {
                loadingOverlayCount: 0,
                message: null
            },
            [StateHolder.NOTIFICATION_STATE]: {
                isOpen: false,
                message: null,
                notificationLevel: null
            }
        };

        const initialProcessedState = {};
        for (const [stateKey, stateValue] of Object.entries(rawState)) {
            initialProcessedState[stateKey] = {
                value: stateValue
            };
        }
        self.state = initialProcessedState;
    }

    /**
     * Set the value for a particular key.
     *
     * @param {string} key The key for which the value should be added
     * @param {Object} value The new value that should be set
     */
    set = (key, value) => {
        if (key) {
            if (!this.state[key]) {
                this.state[key] = {
                    value: null
                };
            }
            const oldValue = this.state[key].value;
            this.state[key].value = value;
            this.notify(key, oldValue, value);
        }
    };

    /**
     * Unset the value for a particular key.
     *
     * @param {string} key The key for which the value should be removed
     */
    unset = (key) => {
        if (key && this.state[key]) {
            const oldValue = this.state[key].value;
            this.state[key].value = null;
            this.notify(key, oldValue, null);
        }
    };

    /**
     * Get the value for a particular key.
     *
     * @param {string} key The key for which the value should be retrieved
     * @param {Object} defaultValue The default value which should be returned if the value does not exist
     * @returns {Object} The value for the key provided
     */
    get = (key, defaultValue = null) => {
        let value = defaultValue;
        if (this.state[key]) {
            value = this.state[key].value;
        }
        return value;
    };

    /**
     * Add a listener for a particular state key.
     *
     * @param {string} key The state key for which the listener should be added
     * @param {Function} callback The callback function which should be called upon update
     */
    addListener = (key, callback) => {
        if (!this.state[key]) {
            this.state[key] = {};
        }
        if (!this.state[key].listeners) {
            this.state[key].listeners = [];
        }
        this.state[key].listeners.push(callback);
    };

    /**
     * Remove a listener previously added.
     *
     * @param {string} key The key from which the listener should be added
     * @param {Function} callback The callback which should be removed
     */
    removeListener = (key, callback) => {
        if (this.state[key]) {
            const listeners = this.state[key].listeners;
            if (listeners) {
                const removeIndex = listeners.indexOf(callback);
                listeners.splice(removeIndex, 1);
            }
        }
    };

    /**
     * Notify the listeners about a state change.
     *
     * @param {string} key The key of which the listeners should be notified
     * @param {Object} oldValue The old value of the key
     * @param {Object} newValue The new value of the key
     * @private
     */
    notify = (key, oldValue, newValue) => {
        const listeners = this.state[key].listeners;
        if (oldValue !== newValue && listeners) {
            listeners.forEach((listener) => listener(key, oldValue, newValue));
        }
    };

    /**
     * Load the state that should be used.
     *
     * @returns {Promise<Object>} Promise which resolves when the state is loaded or rejects
     */
    loadConfig = () => {
        const self = this;
        return new Promise((resolve, reject) => {
            axios({
                url: "/config",
                method: "GET",
                headers: {
                    Accept: "application/json"
                }
            }).then((response) => {
                const config = response.data;
                self.set(StateHolder.CONFIG, config);

                // Validating whether the token in valid if the user had already logged in
                if (self.get(StateHolder.USER)) {
                    const queryParams = {
                        validateUser: true
                    };
                    HttpUtils.callHubAPI(
                        {
                            url: `/${HttpUtils.generateQueryParamString(queryParams)}`,
                            method: "GET"
                        },
                        self,
                        true
                    ).then(() => {
                        resolve(config);
                    }).catch((error) => {
                        if (error instanceof HubApiError && error.getStatusCode() === 401) {
                            self.unset(StateHolder.USER);
                            AuthUtils.removeUserFromBrowser();
                            resolve(config);
                        } else {
                            reject(error);
                        }
                    });
                } else {
                    resolve(config);
                }
            }).catch((error) => {
                reject(error);
            });
        });
    };

}

export default StateHolder;
