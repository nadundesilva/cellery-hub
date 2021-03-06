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

const string LOCK_QUERY = "INSERT INTO REGISTRY_ARTIFACT_LOCK(ARTIFACT_NAME, LOCK_COUNT) VALUES (?, 1)
                           ON DUPLICATE KEY UPDATE LOCK_COUNT = LOCK_COUNT + 1";
const string DELETE_LOCK_ENTRIES_QUERY = "DELETE FROM REGISTRY_ARTIFACT_LOCK WHERE ARTIFACT_NAME = ?";

const string GET_ARTIFACT_IMAGE_ID_QUERY = "SELECT ARTIFACT_IMAGE_ID FROM REGISTRY_ARTIFACT_IMAGE
                                            WHERE ORG_NAME = ? AND IMAGE_NAME = ? FOR UPDATE";
const string UPDATE_PULL_COUNT_QUERY = "UPDATE REGISTRY_ARTIFACT SET PULL_COUNT = PULL_COUNT + 1,
                                        UPDATED_DATE = UPDATED_DATE WHERE ARTIFACT_IMAGE_ID = ? AND VERSION = ?";
const string INSERT_ARTIFACT_IMAGE_QUERY = "INSERT INTO REGISTRY_ARTIFACT_IMAGE(ARTIFACT_IMAGE_ID, ORG_NAME,
                                            IMAGE_NAME, FIRST_AUTHOR, VISIBILITY) VALUES (?, ?, ?, ?, ?)";

const string GET_ORG_DEFAULT_IMAGE_VISIBILITY_QUERY = "SELECT DEFAULT_IMAGE_VISIBILITY
                                                       FROM REGISTRY_ORGANIZATION WHERE ORG_NAME = ? FOR UPDATE";

const string GET_ARTIFACT_ID_QUERY = "SELECT ARTIFACT_ID FROM REGISTRY_ARTIFACT
                                      WHERE ARTIFACT_IMAGE_ID = ? AND VERSION = ? FOR UPDATE";
const string INSERT_REGISTRY_ARTIFACT_QUERY = "INSERT INTO REGISTRY_ARTIFACT(ARTIFACT_ID, ARTIFACT_IMAGE_ID, VERSION,
                                               PUSH_COUNT, LAST_AUTHOR, FIRST_AUTHOR, METADATA, STATEFUL)
                                               VALUES (?, ?, ?, 1, ?, ?, ?, ?)";
const string UPDATE_REGISTRY_ARTIFACT_QUERY = "UPDATE REGISTRY_ARTIFACT SET PUSH_COUNT = PUSH_COUNT + 1,
                                               LAST_AUTHOR = ?, METADATA = ?, STATEFUL = ? WHERE ARTIFACT_ID = ?
                                               AND VERSION = ?";

const string INSERT_REGISTRY_ARTIFACT_LABELS_QUERY = "INSERT INTO REGISTRY_ARTIFACT_LABEL(ARTIFACT_ID, LABEL_KEY,
                                                      LABEL_VALUE) VALUES (?, ?, ?)";
const string DELETE_REGISTRY_ARTIFACT_LABELS_QUERY = "DELETE FROM REGISTRY_ARTIFACT_LABEL WHERE ARTIFACT_ID = ?";

const string INSERT_REGISTRY_ARTIFACT_INGRESSES_QUERY = "INSERT INTO REGISTRY_ARTIFACT_INGRESS(ARTIFACT_ID,
                                                         INGRESS_TYPE) VALUES (?, ?)";
const string DELETE_REGISTRY_ARTIFACT_INGRESSES_QUERY = "DELETE FROM REGISTRY_ARTIFACT_INGRESS WHERE ARTIFACT_ID = ?";
