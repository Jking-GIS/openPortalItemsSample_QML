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


import QtQuick 2.6
import QtQuick.Controls 2.1
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtPositioning 5.3
import QtSensors 5.3
import QtQuick.Controls.Styles 1.4

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.2


//------------------------------------------------------------------------------

App {
    id: app
    width: 414
    height: 736

    property real scaleFactor: AppFramework.displayScaleFactor
    property string portalUrl: "http://ps-dbs.maps.arcgis.com/"

    //header bar
    Rectangle {
        id: titleRect

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: 50 * AppFramework.displayScaleFactor
        color: app.info.propertyValue("titleBackgroundColor", "lightgrey")

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
                anchors.topMargin: 50

                itemType: Enums.PortalItemTypeWebMap
                itemUrl: "http://ps-dbs.maps.arcgis.com/home/webmap/viewer.html?webmap=" //go to web map view on portal
            }
        }

        //operations dashboard tab
        Tab {
            title: "Operation View"
            ItemListView {
                anchors.topMargin: 50

                itemType: Enums.PortalItemTypeOperationView
                itemUrl: "http://ps-dbs.maps.arcgis.com/home/item.html?id=" //go to item page on portal
            }
        }

        //layer tab
        Tab {
            title: "Layer"
            ItemListView {
                anchors.topMargin: 50

                itemType: Enums.PortalItemTypeLayer
                itemUrl: "http://ps-dbs.maps.arcgis.com/home/item.html?id=" //go to item page on portal
            }
        }

        //change styling of the tab view
        style: TabViewStyle {
            frameOverlap: 1
            tab: Rectangle {
                color: styleData.selected ? "darkgrey" : "#323232"
                border.color: "black"
                border.width: 2
                implicitWidth: tabView.width/3 + 1
                implicitHeight: 50
                radius: 2
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
