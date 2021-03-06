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

import AccountCircle from "@material-ui/icons/AccountCircle";
import AppBar from "@material-ui/core/AppBar";
import AuthUtils from "../../../utils/api/authUtils";
import Avatar from "@material-ui/core/Avatar";
import Button from "@material-ui/core/Button";
import CelleryLogo from "../../../img/celleryLogo.svg";
import Container from "@material-ui/core/Container";
import Divider from "@material-ui/core/Divider";
import ListItem from "@material-ui/core/ListItem";
import ListItemAvatar from "@material-ui/core/ListItemAvatar";
import ListItemText from "@material-ui/core/ListItemText";
import Menu from "@material-ui/core/Menu";
import MenuItem from "@material-ui/core/MenuItem";
import React from "react";
import Toolbar from "@material-ui/core/Toolbar";
import Typography from "@material-ui/core/Typography";
import classNames from "classnames";
import {withRouter} from "react-router-dom";
import {withStyles} from "@material-ui/core/styles";
import withGlobalState, {StateHolder} from "../../common/state";
import * as PropTypes from "prop-types";

const styles = (theme) => ({
    appbar: {
        backgroundColor: "#ffffff",
        color: theme.palette.primary.main,
        boxShadow: "none"
    },
    headerLogo: {
        flexGrow: 1
    },
    logo: {
        cursor: "pointer"
    },
    hubText: {
        fontSize: 32,
        fontWeight: 400,
        color: "#43AB00",
        display: "inline-block",
        verticalAlign: "middle",
        marginTop: -7
    },
    sdkText: {
        fontSize: 22,
        fontWeight: 400,
        color: "#444",
        display: "inline-block",
        verticalAlign: "middle",
        marginLeft: theme.spacing(1)
    },
    celleryLogo: {
        height: 40,
        verticalAlign: "middle",
        paddingRight: 2
    },
    toolbar: {
        paddingLeft: 0,
        paddingRight: 0
    },
    headerContent: {
        borderBottom: "1px solid",
        borderBottomColor: theme.palette.primary.main
    },
    leftIcon: {
        marginRight: theme.spacing(1)
    },
    usernameBtn: {
        textTransform: "none",
        color: "#57595d"
    },
    userMenuItem: {
        pointerEvents: "none"
    },
    logoutMenuItem: {
        paddingLeft: theme.spacing(4)
    }
});

class Header extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            accountPopoverElement: null,
            user: props.globalState.get(StateHolder.USER)
        };
        props.globalState.addListener(StateHolder.USER, this.handleUserChange);
    }

    handleUserChange = (key, oldValue, newValue) => {
        this.setState({
            user: newValue
        });
    };

    handleAccountPopoverOpen = (event) => {
        this.setState({
            accountPopoverElement: event.currentTarget
        });
    };

    handleAccountPopoverClose = () => {
        this.setState({
            accountPopoverElement: null
        });
    };

    render = () => {
        const {classes, globalState, history} = this.props;
        const {accountPopoverElement, user} = this.state;

        const isAccountPopoverOpen = Boolean(accountPopoverElement);
        return (
            <header>
                <div className={classes.headerContent}>
                    <Container maxWidth={"md"}>
                        <AppBar position={"static"} className={classes.appbar}>
                            <Toolbar className={classes.toolbar}>
                                <div className={classes.headerLogo}>
                                    <div className={classes.logo} onClick={() => history.push("/")}>
                                        <img src={CelleryLogo} className={classes.celleryLogo} alt={"Cellery logo"}/>
                                        <Typography className={classes.hubText}>
                                            hub
                                        </Typography>
                                    </div>
                                </div>
                                {
                                    user
                                        ? (
                                            <div>
                                                <Button disableTouchRipple={true} color={"inherit"}
                                                    className={classNames(classes.usernameBtn, classes.navButton)}
                                                    aria-haspopup={"true"}
                                                    onClick={this.handleAccountPopoverOpen}>
                                                    {
                                                        user.avatarUrl
                                                            ? (
                                                                <Avatar alt={user.username} src={user.avatarUrl}
                                                                    className={classes.leftIcon} />
                                                            )
                                                            : <AccountCircle className={classes.leftIcon}/>
                                                    }
                                                    {user.username.split(" ")[0]}
                                                </Button>
                                                <Menu id={"user-info"} anchorEl={accountPopoverElement}
                                                    anchorOrigin={{
                                                        vertical: "top",
                                                        horizontal: "right"
                                                    }}
                                                    transformOrigin={{
                                                        vertical: "top",
                                                        horizontal: "right"
                                                    }}
                                                    open={isAccountPopoverOpen}
                                                    onClose={this.handleAccountPopoverClose}>
                                                    <MenuItem onClick={(e) => e.stopPropagation()}
                                                        className={classes.userMenuItem}>
                                                        <ListItem alignItems={"flex-start"}>
                                                            <ListItemAvatar>
                                                                <Avatar alt={user.username} src={user.avatarUrl} />
                                                            </ListItemAvatar>
                                                            <ListItemText
                                                                primary={user.username}
                                                                secondary={
                                                                    <React.Fragment>
                                                                        <Typography component={"div"} variant={"body2"}
                                                                            color={"textSecondary"}>
                                                                            {user.email}
                                                                        </Typography>
                                                                    </React.Fragment>
                                                                }
                                                            />
                                                        </ListItem>
                                                    </MenuItem>
                                                    <Divider/>
                                                    <MenuItem onClick={() => AuthUtils.signOut(globalState)}
                                                        className={classes.logoutMenuItem}>
                                                        Logout
                                                    </MenuItem>
                                                </Menu>
                                            </div>
                                        )
                                        : null
                                }
                            </Toolbar>
                        </AppBar>
                    </Container>
                </div>
            </header>
        );
    };

}

Header.propTypes = {
    classes: PropTypes.object.isRequired,
    history: PropTypes.shape({
        push: PropTypes.func.isRequired
    }).isRequired,
    globalState: PropTypes.instanceOf(StateHolder).isRequired
};

export default withStyles(styles)(withRouter(withGlobalState(Header)));

