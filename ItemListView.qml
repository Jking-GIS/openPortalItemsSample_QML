import QtQuick 2.7
import QtQuick.Controls 2.4
import QtPositioning 5.3
import QtSensors 5.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Material 2.1
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.2

Rectangle {
    property var itemType: null
    property string itemUrl: "http://ps-dbs.maps.arcgis.com/home/item.html?id=" //default item url
    property PortalItemListModel portalItemModel: null
    color: "#323232"

    //search bar
    Rectangle {
        id: rectSearch
        anchors.top: parent.top
        height: 50 * app.scaleFactor
        width: parent.width
        color: "#323232"

        Image {
            id: searchIcon
            height: parent.height/2
            width: height
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10 * app.scaleFactor

            source: "./images/search.png"
            mipmap: true
            fillMode: Image.PreserveAspectFit
        }

        TextField {
            id: txtSearch
            //height: parent.height - 10 * app.scaleFactor
            width: parent.width - imgClear.width - searchIcon.width - (43 * app.scaleFactor)
            font.pixelSize: 20 * app.scaleFactor
            placeholderText: "Search"
            Material.accent: "#8A000000"
            verticalAlignment: TextInput.AlignVCenter
            horizontalAlignment: TextInput.AlignLeft
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: searchIcon.right
            anchors.leftMargin: 10 * app.scaleFactor
            padding: 10 * app.scaleFactor

            background: Rectangle {
                anchors.fill: parent
                anchors.topMargin: 2 * app.scaleFactor
                anchors.bottomMargin: 4 * app.scaleFactor
                radius: 5 * app.scaleFactor
            }

            onLengthChanged: {
                if (length > 0) {

                } else {

                }
            }
        }

        Image {
            id: imgClear
            source: "./images/clear_text.png"
            mipmap: true
            width: 25 * app.scaleFactor
            height: 25 * app.scaleFactor
            visible: txtSearch.length > 0
            anchors {
                right: parent.right
                rightMargin: 10 * app.scaleFactor
                verticalCenter: parent.verticalCenter
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    txtSearch.text = ""
                }
            }
        }
    }

    //list view for tabs of portal items
    ListView {
        id: portalItemsList

        anchors.topMargin: 50 * app.scaleFactor
        anchors.top: rectSearch.bottom
        anchors.bottom: parent.bottom
        width: parent.width

        ScrollBar.vertical: ScrollBar {
            active: true
        }

        spacing: 5 * app.scaleFactor

        model: portalItemModel

        //represents the UI for EACH item in the list
        delegate: Rectangle {
            color: "white"
            border.color: "darkgrey"
            height: 50 * app.scaleFactor
            width: parent.width
            radius: 2 * app.scaleFactor


            Text {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20 * app.scaleFactor
                width: parent.width - anchors.leftMargin*2
                text: title ? title : itemType
                font.pixelSize: 20 * app.scaleFactor
                elide: Text.ElideRight
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    color = "darkgrey"
                }
                onReleased: {
                    color = "white"
                    Qt.openUrlExternally(itemUrl + itemId) //open the URL in your default browser
                }
            }
        }

        //change parameters for the query on portal items
        PortalQueryParametersForItems {
            id: portalQuery
            types: [itemType]
            limit: 100

            searchString: txtSearch.text

            onSearchStringChanged: {
                myPortal.findItems(portalQuery)
            }
        }

        Connections {
            target: myPortal

            //fill default tab when portal is loaded
            onLoadStatusChanged: {
                myPortal.findItems(portalQuery)
            }

            onFindItemsResultChanged: {
                var loadStatus = myPortal.loadStatus
                var result = myPortal.findItemsResult
                if(loadStatus === Enums.LoadStatusLoaded && //if portal is loaded
                        result && //and we have a valid query result
                        result.queryParameters.types[0] === itemType) { //and this is the valid list
                    portalItemModel = result.itemResults //fill the model with results
                }
            }
        }

        Component.onCompleted: { //When we move to the tab for the first time, fill the tab
            myPortal.findItems(portalQuery);
        }
    }

}
