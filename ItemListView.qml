import QtQuick 2.0

import Esri.ArcGISRuntime 100.2

//list view for tabs of portal items
ListView {
    id: portalItemsList

    property var itemType: null
    property string itemUrl: "http://ps-dbs.maps.arcgis.com/home/item.html?id=" //default item url
    property PortalItemListModel portalItemModel: null

    anchors.fill: parent

    spacing: 5

    model: portalItemModel

    //represents the UI for EACH item in the list
    delegate: Rectangle {
        color: "white"
        border.color: "darkgrey"
        height: 50
        width: parent.width

        Text {
            text: title ? title : itemType
            font.pixelSize: 20
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
    }

    Connections {
        target: myPortal

        //fill default tab when portal is loaded
        onLoadStatusChanged: {
            myPortal.findItems(portalQuery)
        }

        onFindItemsResultChanged: {
            if(myPortal.loadStatus === Enums.LoadStatusLoaded && //if portal is loaded
                    myPortal.findItemsResult && //and we have a valid query result
                    myPortal.findItemsResult.queryParameters.types[0] === itemType) { //and this is the valid list
                portalItemModel = myPortal.findItemsResult.itemResults //fill the model with results
            }
        }
    }

    Component.onCompleted: { //When we move to the tab for the first time, fill the tab
        myPortal.findItems(portalQuery);
    }
}
