/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import AuthUtils from "../../utils/api/authUtils";
import Button from "@material-ui/core/Button";
import Divider from "@material-ui/core/Divider";
import GithubLogo from "../../img/GithubLogo";
import GoogleLogo from "../../img/GoogleLogo";
import Grid from "@material-ui/core/Grid";
import HttpUtils from "../../utils/api/httpUtils";
import React from "react";
import StateHolder from "../common/state/stateHolder";
import Typography from "@material-ui/core/Typography";
import withGlobalState from "../common/state";
import {withStyles} from "@material-ui/core/styles";
import * as PropTypes from "prop-types";

const styles = (theme) => ({
    content: {
        paddingTop: theme.spacing(4)
    },
    leftIcon: {
        marginRight: theme.spacing(1)
    },
    signInBtn: {
        marginTop: theme.spacing(2),
        marginBottom: theme.spacing(2),
        borderColor: theme.palette.primary.main,
        textTransform: "none"
    },
    title: {
        marginBottom: theme.spacing(2),
        textAlign: "center"
    },
    signInContainer: {
        border: "1px solid #e0e0e0",
        borderRadius: 5,
        marginTop: theme.spacing(4)
    },
    divider: {
        marginBottom: theme.spacing(2)
    }
});

const FederatedIdpSelect = (props) => {
    const {classes, globalState, location} = props;

    const params = HttpUtils.parseQueryParams(location.search);
    const redirectUrl = params.redirectUrl;
    let fidp = AuthUtils.getDefaultFIdP();
    if (!fidp) {
        fidp = params.fidp;
    }
    if (fidp) {
        AuthUtils.initiateSdkLoginFlow(globalState, fidp, redirectUrl);
        return null;
    }
    return (
        <div className={classes.content}>
            <Grid container spacing={4} direction="row" justify="center" alignItems="center">
                <Grid item xs={12} sm={4} md={4} className={classes.signInContainer}>
                    <Typography component="div" variant="h5" className={classes.title}>
                        Sign in
                    </Typography>
                    <Divider className={classes.divider}/>
                    <Button fullWidth variant="outlined" size="large" className={classes.signInBtn} onClick={() => {
                        AuthUtils.initiateSdkLoginFlow(globalState, AuthUtils.FederatedIdP.GITHUB, redirectUrl);
                    }}>
                        <GithubLogo className={classes.leftIcon}/>
                        Sign in with Github
                    </Button>
                    <Button fullWidth variant="outlined" size="large" className={classes.signInBtn} onClick={() => {
                        AuthUtils.initiateSdkLoginFlow(globalState, AuthUtils.FederatedIdP.GOOGLE, redirectUrl);
                    }}>
                        <GoogleLogo className={classes.leftIcon}/>
                        Sign in with Google
                    </Button>
                </Grid>
            </Grid>
        </div>
    );
};

FederatedIdpSelect.propTypes = {
    classes: PropTypes.object.isRequired,
    globalState: PropTypes.instanceOf(StateHolder).isRequired,
    location: PropTypes.shape({
        search: PropTypes.string.isRequired
    }).isRequired
};

export default withStyles(styles)(withGlobalState(FederatedIdpSelect));