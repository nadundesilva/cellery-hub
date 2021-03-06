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

import AccessTime from "@material-ui/icons/AccessTime";
import Avatar from "@material-ui/core/Avatar";
import CellImage from "../../img/CellImage";
import Constants from "../../utils/constants";
import Divider from "@material-ui/core/Divider";
import GetApp from "@material-ui/icons/GetApp";
import InfoOutlined from "@material-ui/icons/InfoOutlined";
import Language from "@material-ui/icons/Language";
import List from "@material-ui/core/List";
import ListItem from "@material-ui/core/ListItem";
import ListItemAvatar from "@material-ui/core/ListItemAvatar";
import ListItemText from "@material-ui/core/ListItemText";
import Lock from "@material-ui/icons/Lock";
import React from "react";
import SearchImages from "../../img/SearchImages.png";
import TablePagination from "@material-ui/core/TablePagination";
import Typography from "@material-ui/core/Typography";
import {withRouter} from "react-router-dom";
import {withStyles} from "@material-ui/core/styles";
import * as PropTypes from "prop-types";
import * as moment from "moment";

const styles = (theme) => ({
    avatar: {
        color: theme.palette.primary.main,
        backgroundColor: "transparent"
    },
    listItemText: {
        flexGrow: 1
    },
    elementText: {
        flex: "none",
        paddingLeft: theme.spacing(1 / 2),
        color: "#666666"
    },
    elementIcon: {
        fontSize: 20,
        marginLeft: theme.spacing(2),
        color: "#666666"
    },
    block: {
        marginTop: Number(theme.spacing(1 / 3)),
        fontStyle: "italic",
        display: "block"
    },
    updated: {
        fontSize: 14,
        verticalAlign: "text-bottom"
    },
    noImagesMsgContainer: {
        textAlign: "center",
        paddingTop: theme.spacing(8),
        paddingBottom: theme.spacing(4)
    },
    searchIcon: {
        height: 70
    },
    noResultsMsg: {
        fontWeight: 500,
        color: "#a0a0a0",
        paddingTop: theme.spacing(1)
    }
});

class ImageList extends React.Component {

    handleImageClick = (orgName, imageName) => {
        const {history} = this.props;
        history.push(`/images/${orgName}/${imageName}`);
    };

    handleChangePageNo = (event, newPageNo) => {
        const {onPageChange, rowsPerPage} = this.props;
        onPageChange(rowsPerPage, newPageNo);
    };

    handleChangeRowsPerPage = (event) => {
        const {onPageChange, pageNo, rowsPerPage} = this.props;
        const newRowsPerPage = event.target.value;
        const newPageNoCandidate = Math.trunc((pageNo * rowsPerPage) / newRowsPerPage);
        const newPageNo = newPageNoCandidate >= 0 ? newPageNoCandidate : 0;
        onPageChange(newRowsPerPage, newPageNo);
    };

    render = () => {
        const {classes, totalCount, pageNo, rowsPerPage, pageData} = this.props;
        return (
            totalCount
                ? (
                    <React.Fragment>
                        <List component={"nav"}>
                            {pageData.map((image) => (
                                <div key={`${image.orgName}/${image.imageName}`}>
                                    <ListItem button onClick={
                                        () => this.handleImageClick(image.orgName, image.imageName)}>
                                        <ListItemAvatar>
                                            <Avatar className={classes.avatar}>
                                                <CellImage/>
                                            </Avatar>
                                        </ListItemAvatar>
                                        <ListItemText primary={`${image.orgName}/${image.imageName}`}
                                            secondary={
                                                <React.Fragment>
                                                    {image.summary}
                                                    {
                                                        image.updatedTimestamp
                                                            ? (
                                                                <Typography variant={"caption"} color={"textPrimary"}
                                                                    className={classes.block}>
                                                                    <AccessTime className={classes.updated}/>
                                                                              &nbsp;Last Updated on&nbsp;
                                                                    {
                                                                        moment(image.updatedTimestamp)
                                                                            .format(Constants.Format.DATE_TIME)
                                                                    }
                                                                </Typography>
                                                            )
                                                            : <Typography variant={"caption"} color={"textPrimary"}
                                                                className={classes.block}>
                                                                <InfoOutlined className={classes.updated}/>
                                                                          &nbsp;No versions available
                                                            </Typography>
                                                    }
                                                </React.Fragment>
                                            }/>
                                        {
                                            !image.pullCount && image.pullCount !== 0
                                                ? null
                                                : (
                                                    <React.Fragment>
                                                        <GetApp className={classes.elementIcon}/>
                                                        <Typography variant={"subtitle2"} color={"inherit"}
                                                            className={classes.elementText}>
                                                            {image.pullCount}
                                                        </Typography>
                                                    </React.Fragment>
                                                )
                                        }
                                        {
                                            image.visibility.toUpperCase() === Constants.Visibility.PUBLIC
                                                ? <Language className={classes.elementIcon}/>
                                                : <Lock className={classes.elementIcon}/>
                                        }
                                    </ListItem>
                                    <Divider/>
                                </div>
                            ))}
                        </List>
                        <TablePagination component={"nav"} page={pageNo} rowsPerPage={rowsPerPage} count={totalCount}
                            onChangePage={this.handleChangePageNo} onChangeRowsPerPage={this.handleChangeRowsPerPage}
                            rowsPerPageOptions={[5, 10, 25]}/>
                    </React.Fragment>
                )
                : (
                    <div className={classes.noImagesMsgContainer}>
                        <img src={SearchImages} alt={"no results found"} className={classes.searchIcon}/>
                        <Typography component={"div"} className={classes.noResultsMsg}>
                            No Results Found
                        </Typography>
                    </div>
                )
        );
    }

}

ImageList.propTypes = {
    history: PropTypes.shape({
        goBack: PropTypes.func.isRequired
    }),
    classes: PropTypes.object.isRequired,
    pageNo: PropTypes.number.isRequired,
    rowsPerPage: PropTypes.number.isRequired,
    onPageChange: PropTypes.func.isRequired,
    totalCount: PropTypes.number.isRequired,
    pageData: PropTypes.arrayOf(PropTypes.shape({
        orgName: PropTypes.string.isRequired,
        imageName: PropTypes.string.isRequired,
        summary: PropTypes.string,
        pullCount: PropTypes.number.isRequired,
        lastAuthor: PropTypes.string.isRequired,
        updatedTimestamp: PropTypes.number.isRequired,
        visibility: PropTypes.string.isRequired
    })).isRequired
};

export default withStyles(styles)(withRouter(ImageList));
