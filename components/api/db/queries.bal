// ------------------------------------------------------------------------
//
// Copyright 2019 WSO2, Inc. (http://wso2.com)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License
//
// ------------------------------------------------------------------------

public const string GET_ORG_QUERY = "SELECT DESCRIPTION, SUMMARY, WEBSITE_URL, FIRST_AUTHOR, CREATED_DATE, IFNULL((SELECT USER_ROLE FROM 
                                    REGISTRY_ORG_USER_MAPPING WHERE ORG_NAME = ? AND USER_UUID = ?), \"\") AS USER_ROLE
                                    FROM REGISTRY_ORGANIZATION WHERE ORG_NAME = ?";

public const string GET_ORG_AVAILABILITY_QUERY = "SELECT 1 FROM REGISTRY_ORGANIZATION WHERE ORG_NAME = ?";

public const string ADD_ORG_QUERY = "INSERT INTO REGISTRY_ORGANIZATION ( ORG_NAME, DESCRIPTION, WEBSITE_URL,
                                    DEFAULT_IMAGE_VISIBILITY, FIRST_AUTHOR ) VALUES ( ?,?,?,?,? )";

public const string ADD_ORG_USER_MAPPING_QUERY = "INSERT INTO REGISTRY_ORG_USER_MAPPING ( USER_UUID, ORG_NAME, USER_ROLE)
                                    VALUES (?,?,?)";

public const string GET_ORG_COUNT_FOR_USER = "SELECT COUNT(ORG_NAME) FROM REGISTRY_ORGANIZATION WHERE FIRST_AUTHOR=?";

public const string GET_IMAGE_FOR_USER_FROM_IMAGE_NAME = "SELECT REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID,ORG_NAME,
                                    IMAGE_NAME,REGISTRY_ARTIFACT_IMAGE.SUMMARY, REGISTRY_ARTIFACT_IMAGE.DESCRIPTION,
                                    REGISTRY_ARTIFACT_IMAGE.FIRST_AUTHOR, VISIBILITY, SUM(PUSH_COUNT), SUM(PULL_COUNT), IFNULL((SELECT
                                    USER_ROLE FROM REGISTRY_ORG_USER_MAPPING WHERE ORG_NAME = ? AND USER_UUID = ?), \'\') AS USER_ROLE FROM 
                                    REGISTRY_ARTIFACT_IMAGE LEFT JOIN REGISTRY_ARTIFACT ON REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID =
                                    REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID WHERE VISIBILITY = \"PUBLIC\" AND ORG_NAME = ? AND IMAGE_NAME = ?
                                    OR ORG_NAME IN (SELECT ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ? AND ORG_NAME = ?)
                                    AND IMAGE_NAME = ? GROUP BY REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID";

public const string GET_IMAGE_FROM_IMAGE_NAME = "SELECT REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID,ORG_NAME,IMAGE_NAME,
                                    REGISTRY_ARTIFACT_IMAGE.SUMMARY, REGISTRY_ARTIFACT_IMAGE.DESCRIPTION, REGISTRY_ARTIFACT_IMAGE.FIRST_AUTHOR,
                                    VISIBILITY, SUM(PUSH_COUNT), SUM(PULL_COUNT), \"\" AS USER_ROLE FROM REGISTRY_ARTIFACT_IMAGE LEFT JOIN 
                                    REGISTRY_ARTIFACT ON REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID = REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID WHERE
                                    VISIBILITY = \"PUBLIC\" AND ORG_NAME= ? AND IMAGE_NAME=? GROUP BY REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID";

public const string GET_KEYWORDS_OF_IMAGE_BY_IMAGE_ID = "SELECT KEYWORD FROM IMAGE_KEYWORDS WHERE ARTIFACT_IMAGE_ID = ?";

public const string GET_ARTIFACTS_OF_IMAGE_FOR_USER = "SELECT REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID, REGISTRY_ARTIFACT.ARTIFACT_ID,
                                    REGISTRY_ARTIFACT.DESCRIPTION, REGISTRY_ARTIFACT.PULL_COUNT,
                                    REGISTRY_ARTIFACT.LAST_AUTHOR, REGISTRY_ARTIFACT.UPDATED_DATE,
                                    REGISTRY_ARTIFACT.VERSION FROM REGISTRY_ARTIFACT_IMAGE LEFT JOIN REGISTRY_ARTIFACT ON
                                    REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID = REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID WHERE
                                    VISIBILITY = \"PUBLIC\" AND ORG_NAME = ? AND IMAGE_NAME = ?
                                    AND VERSION LIKE ? OR ORG_NAME IN (SELECT ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE
                                    USER_UUID = ? AND ORG_NAME = ?) AND IMAGE_NAME = ?
                                    AND VERSION LIKE ? ORDER BY REGISTRY_ARTIFACT.UPDATED_DATE ASC LIMIT ? OFFSET ?";

public const string GET_ARTIFACTS_OF_PUBLIC_IMAGE = "SELECT REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID, REGISTRY_ARTIFACT.ARTIFACT_ID, REGISTRY_ARTIFACT.DESCRIPTION,
                                    REGISTRY_ARTIFACT.PULL_COUNT, REGISTRY_ARTIFACT.LAST_AUTHOR, REGISTRY_ARTIFACT.UPDATED_DATE,
                                    REGISTRY_ARTIFACT.VERSION FROM REGISTRY_ARTIFACT_IMAGE INNER JOIN REGISTRY_ARTIFACT ON
                                    REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID = REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID WHERE
                                    VISIBILITY = \"PUBLIC\" AND ORG_NAME= ? AND IMAGE_NAME = ? AND VERSION
                                    LIKE ? ORDER BY REGISTRY_ARTIFACT.UPDATED_DATE ASC LIMIT ? OFFSET ?";

public const string GET_ARTIFACT_FROM_IMG_NAME_N_VERSION = "SELECT REGISTRY_ARTIFACT.DESCRIPTION, REGISTRY_ARTIFACT.PULL_COUNT,
                                    REGISTRY_ARTIFACT.LAST_AUTHOR, REGISTRY_ARTIFACT.UPDATED_DATE, REGISTRY_ARTIFACT.METADATA,
                                    \'\' AS USER_ROLE FROM REGISTRY_ARTIFACT INNER JOIN
                                    REGISTRY_ARTIFACT_IMAGE ON REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID=REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID
                                    WHERE VISIBILITY = \"PUBLIC\" AND REGISTRY_ARTIFACT_IMAGE.ORG_NAME=? AND REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME=? AND
                                    REGISTRY_ARTIFACT.VERSION=?";

public const string GET_ARTIFACT_FOR_USER_FROM_IMG_NAME_N_VERSION = "SELECT REGISTRY_ARTIFACT.DESCRIPTION, REGISTRY_ARTIFACT.PULL_COUNT,
                                    REGISTRY_ARTIFACT.LAST_AUTHOR, REGISTRY_ARTIFACT.UPDATED_DATE, REGISTRY_ARTIFACT.METADATA, IFNULL((SELECT
                                    USER_ROLE FROM REGISTRY_ORG_USER_MAPPING WHERE ORG_NAME = ? AND USER_UUID = ?), \'\') AS USER_ROLE
                                    FROM REGISTRY_ARTIFACT INNER JOIN REGISTRY_ARTIFACT_IMAGE ON REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID=
                                    REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID WHERE VISIBILITY = \"PUBLIC\" AND REGISTRY_ARTIFACT_IMAGE.ORG_NAME=?
                                    AND REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME=? AND REGISTRY_ARTIFACT.VERSION=? OR ORG_NAME IN (SELECT ORG_NAME FROM
                                    REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ? AND ORG_NAME = ?) AND IMAGE_NAME=? AND REGISTRY_ARTIFACT.VERSION=?";

public const string GET_MEMBERS_ORG_USERS = "SELECT USER_UUID, USER_ROLE FROM REGISTRY_ORG_USER_MAPPING WHERE ORG_NAME =
                                    (SELECT ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ? AND ORG_NAME = ?)
                                    LIMIT ? OFFSET ?";

public const string GET_MEMBERS_ORG_USERS_COUNT = "SELECT COUNT(USER_UUID) FROM REGISTRY_ORG_USER_MAPPING WHERE ORG_NAME = ?";

public const string SEARCH_ORGS_TOTAL_COUNT = "SELECT COUNT(ORG_NAME) FROM REGISTRY_ORGANIZATION
                                    WHERE ORG_NAME LIKE ?";

public const string SEARCH_ORGS_QUERY = "SELECT REGISTRY_ORGANIZATION.ORG_NAME, REGISTRY_ORGANIZATION.SUMMARY, REGISTRY_ORGANIZATION.DESCRIPTION,
                                    COUNT(REGISTRY_ORG_USER_MAPPING.USER_UUID) AS MEMBER_COUNT FROM REGISTRY_ORGANIZATION LEFT JOIN
                                    REGISTRY_ORG_USER_MAPPING ON REGISTRY_ORGANIZATION.ORG_NAME=REGISTRY_ORG_USER_MAPPING.ORG_NAME
                                    WHERE REGISTRY_ORGANIZATION.ORG_NAME LIKE ? GROUP BY REGISTRY_ORGANIZATION.ORG_NAME  LIMIT ? OFFSET ?";

public const string SEARCH_ORGS_QUERY_IMAGE_COUNT_FOR_UNAUTHENTICATED_USER = "SELECT REGISTRY_ORGANIZATION.ORG_NAME, 
                                    COUNT(REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID) AS IMAGE_COUNT FROM REGISTRY_ORGANIZATION LEFT JOIN REGISTRY_ARTIFACT_IMAGE
                                    ON REGISTRY_ORGANIZATION.ORG_NAME = REGISTRY_ARTIFACT_IMAGE.ORG_NAME WHERE REGISTRY_ORGANIZATION.ORG_NAME LIKE ? AND
                                    (REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\" OR REGISTRY_ARTIFACT_IMAGE.VISIBILITY is NULL)
                                    GROUP BY REGISTRY_ORGANIZATION.ORG_NAME LIMIT ? OFFSET ?";

public const string SEARCH_ORGS_QUERY_IMAGE_COUNT_FOR_AUTHENTICATED_USER = "SELECT REGISTRY_ORGANIZATION.ORG_NAME,
                                    COUNT(REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID) AS IMAGE_COUNT FROM REGISTRY_ORGANIZATION LEFT JOIN REGISTRY_ARTIFACT_IMAGE
                                    ON REGISTRY_ORGANIZATION.ORG_NAME = REGISTRY_ARTIFACT_IMAGE.ORG_NAME WHERE REGISTRY_ORGANIZATION.ORG_NAME LIKE ? AND
                                    ((REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\" OR REGISTRY_ARTIFACT_IMAGE.VISIBILITY is NULL) OR
                                    REGISTRY_ORGANIZATION.ORG_NAME IN (SELECT REGISTRY_ORG_USER_MAPPING.ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE
                                    USER_UUID = ? )) GROUP BY REGISTRY_ORGANIZATION.ORG_NAME LIMIT ? OFFSET ?";

public const string SEARCH_USER_ORGS_TOTAL_COUNT = "SELECT COUNT(ORG_NAME) FROM REGISTRY_ORG_USER_MAPPING
                                    WHERE ORG_NAME LIKE ? AND USER_UUID = ?";

public const string SEARCH_USER_ORGS_QUERY = "SELECT REGISTRY_ORGANIZATION.ORG_NAME, REGISTRY_ORGANIZATION.SUMMARY, REGISTRY_ORGANIZATION.DESCRIPTION,
                                    COUNT(REGISTRY_ORG_USER_MAPPING.USER_UUID) AS MEMBER_COUNT FROM REGISTRY_ORGANIZATION LEFT JOIN
                                    REGISTRY_ORG_USER_MAPPING ON REGISTRY_ORGANIZATION.ORG_NAME=REGISTRY_ORG_USER_MAPPING.ORG_NAME
                                    WHERE REGISTRY_ORG_USER_MAPPING.ORG_NAME LIKE ? AND REGISTRY_ORG_USER_MAPPING.ORG_NAME IN 
                                    (SELECT REGISTRY_ORG_USER_MAPPING.ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ?)
                                    GROUP BY REGISTRY_ORGANIZATION.ORG_NAME LIMIT ? OFFSET ?";

public const string SEARCH_USER_ORGS_QUERY_IMAGE_COUNT = "SELECT REGISTRY_ORGANIZATION.ORG_NAME, COUNT(REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID)
                                    as IMAGE_COUNT FROM REGISTRY_ORGANIZATION LEFT JOIN
                                    REGISTRY_ARTIFACT_IMAGE ON REGISTRY_ORGANIZATION.ORG_NAME=REGISTRY_ARTIFACT_IMAGE.ORG_NAME
                                    WHERE ((REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\" OR REGISTRY_ARTIFACT_IMAGE.VISIBILITY is NULL) OR
                                    REGISTRY_ORGANIZATION.ORG_NAME IN (SELECT REGISTRY_ORG_USER_MAPPING.ORG_NAME FROM
                                    REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ? AND REGISTRY_ORG_USER_MAPPING.ORG_NAME LIKE ?))
                                    AND (REGISTRY_ORGANIZATION.ORG_NAME IN (SELECT REGISTRY_ORG_USER_MAPPING.ORG_NAME FROM
                                    REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ? AND REGISTRY_ORG_USER_MAPPING.ORG_NAME LIKE ?)
                                    ) GROUP BY REGISTRY_ORGANIZATION.ORG_NAME LIMIT ? OFFSET ?";

public const string SEARCH_PUBLIC_ORG_IMAGES_TOTAL_COUNT = "SELECT COUNT(REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID) AS IMAGE_COUNT FROM REGISTRY_ARTIFACT_IMAGE
                                    WHERE (REGISTRY_ARTIFACT_IMAGE.ORG_NAME = ?) AND (REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\") AND
                                    (REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME LIKE ?);";

public const string SEARCH_PUBLIC_ORG_IMAGES_QUERY = "SELECT REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME, REGISTRY_ARTIFACT_IMAGE.SUMMARY,
                                    REGISTRY_ARTIFACT_IMAGE.DESCRIPTION, SUM(REGISTRY_ARTIFACT.PULL_COUNT) AS PULL_COUNT, MAX(
                                    REGISTRY_ARTIFACT.UPDATED_DATE) AS UPDATED_DATE, REGISTRY_ARTIFACT_IMAGE.VISIBILITY FROM
                                    REGISTRY_ARTIFACT_IMAGE LEFT JOIN REGISTRY_ARTIFACT ON REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID=
                                    REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID WHERE REGISTRY_ARTIFACT_IMAGE.ORG_NAME = ? AND REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME
                                    LIKE ? AND REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\" GROUP BY REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME
                                    ORDER BY $ORDER_BY DESC LIMIT ? OFFSET ?";

public const string SEARCH_ORG_IMAGES_FOR_USER_TOTAL_COUNT = "SELECT COUNT(REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID)
                                    AS IMAGE_COUNT FROM REGISTRY_ARTIFACT_IMAGE WHERE (REGISTRY_ARTIFACT_IMAGE.ORG_NAME = ?) AND
                                    (REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME LIKE ?) AND (REGISTRY_ARTIFACT_IMAGE.ORG_NAME IN
                                    (SELECT REGISTRY_ORG_USER_MAPPING.ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ?) OR
                                    (REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\" OR REGISTRY_ARTIFACT_IMAGE.VISIBILITY is NULL))";

public const string SEARCH_ORG_IMAGES_FOR_USER_QUERY = "SELECT REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME, REGISTRY_ARTIFACT_IMAGE.SUMMARY,
                                    REGISTRY_ARTIFACT_IMAGE.DESCRIPTION, SUM(REGISTRY_ARTIFACT.PULL_COUNT) AS PULL_COUNT, MAX(
                                    REGISTRY_ARTIFACT.UPDATED_DATE) AS UPDATED_DATE, REGISTRY_ARTIFACT_IMAGE.VISIBILITY FROM REGISTRY_ARTIFACT_IMAGE
                                    LEFT JOIN REGISTRY_ARTIFACT ON REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID=REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID
                                    WHERE (REGISTRY_ARTIFACT_IMAGE.ORG_NAME = ? AND REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME LIKE ?) AND (
                                    REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\" OR REGISTRY_ARTIFACT_IMAGE.ORG_NAME IN (
                                    SELECT REGISTRY_ORG_USER_MAPPING.ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ?))
                                    GROUP BY REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME ORDER BY $ORDER_BY DESC LIMIT ? OFFSET ?";

public const string SEARCH_PUBLIC_IMAGES_TOTAL_COUNT = "SELECT COUNT(REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID) AS IMAGE_COUNT FROM REGISTRY_ARTIFACT_IMAGE
                                    WHERE (REGISTRY_ARTIFACT_IMAGE.ORG_NAME LIKE ?) AND (REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\") AND
                                    (REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME LIKE ?);";

public const string SEARCH_PUBLIC_IMAGES_QUERY = "SELECT REGISTRY_ARTIFACT_IMAGE.ORG_NAME, REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME, REGISTRY_ARTIFACT_IMAGE.SUMMARY,
									REGISTRY_ARTIFACT_IMAGE.DESCRIPTION, SUM(REGISTRY_ARTIFACT.PULL_COUNT) AS PULL_COUNT, MAX(REGISTRY_ARTIFACT.UPDATED_DATE)
                                    AS UPDATED_DATE, REGISTRY_ARTIFACT_IMAGE.VISIBILITY FROM REGISTRY_ARTIFACT_IMAGE LEFT JOIN REGISTRY_ARTIFACT ON
                                    REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID=REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID WHERE REGISTRY_ARTIFACT_IMAGE.ORG_NAME
                                    LIKE ? AND REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME LIKE ? AND REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\" GROUP BY
                                    REGISTRY_ARTIFACT_IMAGE.ORG_NAME, REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME ORDER BY $ORDER_BY DESC LIMIT ? OFFSET ?";

public const string SEARCH_IMAGES_FOR_USER_TOTAL_COUNT = "SELECT COUNT(REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID)
                                    AS IMAGE_COUNT FROM REGISTRY_ARTIFACT_IMAGE WHERE (REGISTRY_ARTIFACT_IMAGE.ORG_NAME LIKE ?) AND
                                    (REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME LIKE ?) AND (REGISTRY_ARTIFACT_IMAGE.ORG_NAME IN
                                    (SELECT REGISTRY_ORG_USER_MAPPING.ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ?) OR
                                    (REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\" OR REGISTRY_ARTIFACT_IMAGE.VISIBILITY is NULL))";

public const string SEARCH_IMAGES_FOR_USER_QUERY = "SELECT REGISTRY_ARTIFACT_IMAGE.ORG_NAME, REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME,
                                    REGISTRY_ARTIFACT_IMAGE.SUMMARY, REGISTRY_ARTIFACT_IMAGE.DESCRIPTION, SUM(REGISTRY_ARTIFACT.PULL_COUNT) AS PULL_COUNT,
                                    MAX(REGISTRY_ARTIFACT.UPDATED_DATE) AS UPDATED_DATE, REGISTRY_ARTIFACT_IMAGE.VISIBILITY FROM REGISTRY_ARTIFACT_IMAGE
                                    LEFT JOIN REGISTRY_ARTIFACT ON REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID=REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID
                                    WHERE (REGISTRY_ARTIFACT_IMAGE.ORG_NAME LIKE ? AND REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME LIKE ?) AND (
                                    REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\" OR REGISTRY_ARTIFACT_IMAGE.ORG_NAME IN (
                                    SELECT REGISTRY_ORG_USER_MAPPING.ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ?))
                                    GROUP BY REGISTRY_ARTIFACT_IMAGE.ORG_NAME, REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME ORDER BY $ORDER_BY DESC LIMIT ? OFFSET ?";

public const string UPDATE_IMAGE_DESCRIPTION_N_SUMMARY_QUERY = "UPDATE REGISTRY_ARTIFACT_IMAGE SET DESCRIPTION  = ?, SUMMARY = ? WHERE IMAGE_NAME = ? AND
                                    ORG_NAME = ? AND ORG_NAME IN (SELECT ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ? AND
                                    (USER_ROLE = \"PUSH\" OR USER_ROLE = \"ADMIN\"))";

public const string UPDATE_ORG_INFO_QUERY = "UPDATE REGISTRY_ORGANIZATION SET DESCRIPTION  = ?, SUMMARY  = ?, WEBSITE_URL = ?
                                    WHERE ORG_NAME = ? AND ORG_NAME IN (SELECT ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ?
                                    AND USER_ROLE = \"ADMIN\")";

public const string UPDATE_ARTIFACT_DESCRIPTION_QUERY = "UPDATE REGISTRY_ARTIFACT SET DESCRIPTION  = ? WHERE VERSION = ? AND 
                                    ARTIFACT_IMAGE_ID IN (SELECT ARTIFACT_IMAGE_ID FROM REGISTRY_ARTIFACT_IMAGE WHERE IMAGE_NAME = ? AND ORG_NAME = ? 
                                    AND ORG_NAME IN (SELECT ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ? AND 
                                    (USER_ROLE = \"PUSH\" OR USER_ROLE = \"ADMIN\")))";

public const string DELETE_IMAGE_KEYWORDS_QUERY = "DELETE FROM IMAGE_KEYWORDS WHERE IMAGE_KEYWORDS.ARTIFACT_IMAGE_ID = ?";

public const string INSERT_IMAGE_KEYWORDS_QUERY = "INSERT INTO IMAGE_KEYWORDS (ARTIFACT_IMAGE_ID, KEYWORD) VALUES (?, ?)";

public const string SEARCH_USER_AUTHORED_IMAGES_TOTAL_COUNT_FOR_AUTHENTICATED_USER = "SELECT COUNT(REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID) AS
                                    IMAGE_COUNT FROM REGISTRY_ARTIFACT_IMAGE WHERE ((REGISTRY_ARTIFACT_IMAGE.FIRST_AUTHOR = ?) AND
                                    (REGISTRY_ARTIFACT_IMAGE.ORG_NAME LIKE ?) AND (REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME LIKE ?) AND
                                    ((REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\") OR (REGISTRY_ARTIFACT_IMAGE.ORG_NAME IN
                                    (SELECT REGISTRY_ORG_USER_MAPPING.ORG_NAME FROM REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ?))))";

public const string SEARCH_USER_AUTHORED_IMAGES_QUERY_FOR_AUTHENTICATED_USER = "SELECT REGISTRY_ARTIFACT_IMAGE.ORG_NAME, REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME,
                                    REGISTRY_ARTIFACT_IMAGE.SUMMARY, REGISTRY_ARTIFACT_IMAGE.DESCRIPTION, SUM(REGISTRY_ARTIFACT.PULL_COUNT) AS PULL_COUNT,
                                    MAX(REGISTRY_ARTIFACT.UPDATED_DATE) AS UPDATED_DATE, REGISTRY_ARTIFACT_IMAGE.VISIBILITY FROM REGISTRY_ARTIFACT_IMAGE
                                    LEFT JOIN REGISTRY_ARTIFACT ON REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID=REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID
                                    WHERE ((REGISTRY_ARTIFACT_IMAGE.FIRST_AUTHOR = ?) AND (REGISTRY_ARTIFACT_IMAGE.ORG_NAME LIKE ?) AND
                                    (REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME LIKE ?) AND ((REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\") OR
                                    (REGISTRY_ARTIFACT_IMAGE.ORG_NAME IN (SELECT REGISTRY_ORG_USER_MAPPING.ORG_NAME FROM
                                    REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ?)))) GROUP BY REGISTRY_ARTIFACT_IMAGE.ORG_NAME,
                                    REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME ORDER BY $ORDER_BY DESC LIMIT ? OFFSET ?";

public const string SEARCH_USER_AUTHORED_IMAGES_TOTAL_COUNT_FOR_UNAUTHENTICATED_USER = "SELECT COUNT(REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID) AS
                                    IMAGE_COUNT FROM REGISTRY_ARTIFACT_IMAGE WHERE ((REGISTRY_ARTIFACT_IMAGE.FIRST_AUTHOR = ?) AND
                                    (REGISTRY_ARTIFACT_IMAGE.ORG_NAME LIKE ?) AND (REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME LIKE ?) AND
                                    (REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\"))";

public const string SEARCH_USER_AUTHORED_IMAGES_QUERY_FOR_UNAUTHENTICATED_USER = "SELECT REGISTRY_ARTIFACT_IMAGE.ORG_NAME, REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME,
                                    REGISTRY_ARTIFACT_IMAGE.SUMMARY, REGISTRY_ARTIFACT_IMAGE.DESCRIPTION, SUM(REGISTRY_ARTIFACT.PULL_COUNT) AS PULL_COUNT,
                                    MAX(REGISTRY_ARTIFACT.UPDATED_DATE) AS UPDATED_DATE, REGISTRY_ARTIFACT_IMAGE.VISIBILITY FROM REGISTRY_ARTIFACT_IMAGE
                                    LEFT JOIN REGISTRY_ARTIFACT ON REGISTRY_ARTIFACT_IMAGE.ARTIFACT_IMAGE_ID=REGISTRY_ARTIFACT.ARTIFACT_IMAGE_ID
                                    WHERE ((REGISTRY_ARTIFACT_IMAGE.FIRST_AUTHOR = ?) AND (REGISTRY_ARTIFACT_IMAGE.ORG_NAME LIKE ?)
                                    AND (REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME LIKE ?) AND (REGISTRY_ARTIFACT_IMAGE.VISIBILITY = \"PUBLIC\"))
                                    GROUP BY REGISTRY_ARTIFACT_IMAGE.ORG_NAME, REGISTRY_ARTIFACT_IMAGE.IMAGE_NAME ORDER BY $ORDER_BY DESC LIMIT
                                    ? OFFSET ?";

public const string GET_ARTIFACT_IMAGE_ID = "SELECT ARTIFACT_IMAGE_ID FROM REGISTRY_ARTIFACT_IMAGE WHERE IMAGE_NAME = ? AND ORG_NAME = ?";

public const string GET_ARTIFACT_COUNT = "SELECT COUNT(ARTIFACT_ID) FROM REGISTRY_ARTIFACT WHERE ARTIFACT_IMAGE_ID = ?
                                    AND VERSION LIKE ?";

public const string DELETE_ARTIFACT_QUERY = "DELETE FROM REGISTRY_ARTIFACT WHERE ARTIFACT_IMAGE_ID = (SELECT ARTIFACT_IMAGE_ID FROM
                                    REGISTRY_ARTIFACT_IMAGE WHERE IMAGE_NAME = ?  AND ORG_NAME IN (SELECT ORG_NAME FROM
                                    REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ? AND ORG_NAME = ? AND USER_ROLE = \"ADMIN\"))
                                    AND REGISTRY_ARTIFACT.VERSION=?";

public const string DELETE_IMAGE_QUERY = "DELETE FROM REGISTRY_ARTIFACT_IMAGE WHERE IMAGE_NAME = ? AND ORG_NAME = (SELECT ORG_NAME FROM
                                    REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ? AND ORG_NAME = ? AND USER_ROLE = \"ADMIN\")";

public const string DELETE_ORGANIZATION_QUERY = "DELETE FROM REGISTRY_ORGANIZATION WHERE ORG_NAME = (SELECT ORG_NAME FROM
                                    REGISTRY_ORG_USER_MAPPING WHERE USER_UUID = ? AND ORG_NAME = ? AND USER_ROLE = \"ADMIN\");";
