/* Copyright 2018 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */


// You can run your app in Qt Creator by pressing Alt+Shift+R.
// Alternatively, you can run apps through UI using Tools > External > AppStudio > Run.
// AppStudio users frequently use the Ctrl+A and Ctrl+I commands to
// automatically indent the entirety of the .qml file.


import QtQuick 2.7
import QtQuick.Controls 1.4
import QtPositioning 5.3
import QtSensors 5.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.1
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.2


//------------------------------------------------------------------------------

App {
    id: app
    width: 414
    height: 736

    property real scaleFactor: AppFramework.displayScaleFactor

    readonly property string portalUrl: "http://ps-dbs.maps.arcgis.com/"
    readonly property string webMapUrlExtend: "home/webmap/viewer.html?webmap="
    readonly property string generalUrlExtend: "home/item.html?id="
    readonly property string surveyUrl: "https://survey123.arcgis.com/share/"

    //header bar
    Rectangle {
        id: titleRect

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: 50 * app.scaleFactor
        color: app.info.propertyValue("titleBackgroundColor", "purple")

        Text {
            id: titleText

            anchors.centerIn: parent

            text: app.info.title
            color: app.info.propertyValue("titleTextColor", "white")
            font {
                pointSize: 18
            }
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 2
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }
    }

    //portal object
    Portal {
        id: myPortal
        url: portalUrl

        Component.onCompleted: {
            load(); //load it when created
        }

        onLoadStatusChanged: {
            if(loadStatus == Enums.LoadStatusLoaded) {
                titleText.text = app.info.title + " for %1".arg(myPortal.portalInfo.portalName)
            }
        }
    }

    //set up tab view for different item sections
    TabView {
        id: tabView
        anchors.top: titleRect.bottom
        anchors.bottom: parent.bottom
        width: parent.width

        //web map tab
        Tab {
            title: "Web Map"
            ItemListView {
                itemType: Enums.PortalItemTypeWebMap
                itemUrl: portalUrl + webMapUrlExtend //go to web map view on portal
            }
        }

        //operations dashboard tab
        Tab {
            title: "Operation View"
            ItemListView {
                itemType: Enums.PortalItemTypeOperationView
                itemUrl: portalUrl + generalUrlExtend //go to item page on portal
            }
        }

        //layer tab
        Tab {
            title: "Survey"
            ItemListView {
                itemType: Enums.PortalItemTypeForm
                itemUrl: surveyUrl //go to item page on portal
            }
        }

        //change styling of the tab view
        style: TabViewStyle {
            frameOverlap: 1 * app.scaleFactor
            tab: Rectangle {
                color: styleData.selected ? "darkgrey" : "#323232"
                border.color: "black"
                border.width: 2 * app.scaleFactor
                implicitWidth: tabView.width/tabView.count + 1 * app.scaleFactor
                implicitHeight: 50 * app.scaleFactor
                radius: 2 * app.scaleFactor
                Text {
                    id: text
                    anchors.centerIn: parent
                    text: styleData.title
                    color: styleData.selected ? "black" : "white"
                }
            }
            frame: Rectangle { color: "#323232" }
        }
    }
}

//------------------------------------------------------------------------------
