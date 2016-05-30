/*
 * Copyright (C) 2016 Jens Drescher, Germany
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "OBDDataObject.js" as OBDDataObject
import "SettingsDataObject.js" as SettingsDataObject

Page
{
    allowedOrientations: Orientation.All
    property bool bPushSettingsPage: true
    property bool bInitPage: true
    property bool bPageInitialized: false
    property variant arComboboxStringArray : []    

    function fncOnComboboxCompleted()
    {
        bPageInitialized = true;

        //Here we collect all PID labels in one string array.
        //This is then the data model for the comboboxes.
        var arComboarray = ["None"];
        for (var i = 0; i < OBDDataObject.arrayPIDs.length; i++)
        {
            if (OBDDataObject.arrayPIDs[i].labeltext !== null)
            {
                arComboarray.push(OBDDataObject.arrayPIDs[i].labeltext);
                SettingsDataObject.arPIDarray.push({text: OBDDataObject.arrayPIDs[i].labeltext, pid: OBDDataObject.arrayPIDs[i].pid, index: (i + 1)});
            }
        }

        //Fill lookup arrays. Can find entrys based on PID or INDEX as key.       
        for (var j = 0; j < SettingsDataObject.arPIDarray.length; j++)
        {
            SettingsDataObject.arLookupPID[SettingsDataObject.arPIDarray[j].pid] = SettingsDataObject.arPIDarray[j];
            SettingsDataObject.arLookupINDEX[SettingsDataObject.arPIDarray[j].index] = SettingsDataObject.arPIDarray[j];
        }            

        arComboboxStringArray = arComboarray;
    } 

    onStatusChanged:
    {
        if (status === PageStatus.Active && bPushSettingsPage)
        {
            bInitPage = true;
            bPushSettingsPage = false;

            //Generate array for the start index of the copmboboxes
            var arPIDsPage1 = sPIDsPage1.split(",");

            //Set start indexes of comboboxes.
            //This has to be done here, because the boxes first have to be filled with the models. That is a timing issue.
            id_CMB_page1_1.currentIndex = SettingsDataObject.arLookupPID[arPIDsPage1[0]].index;
            id_CMB_page1_2.currentIndex = SettingsDataObject.arLookupPID[arPIDsPage1[1]].index;
            id_CMB_page1_3.currentIndex = SettingsDataObject.arLookupPID[arPIDsPage1[2]].index;
            id_CMB_page1_4.currentIndex = SettingsDataObject.arLookupPID[arPIDsPage1[3]].index;
            id_CMB_page1_5.currentIndex = SettingsDataObject.arLookupPID[arPIDsPage1[4]].index;
            id_CMB_page1_6.currentIndex = SettingsDataObject.arLookupPID[arPIDsPage1[5]].index;

            bInitPage = false;
        }

        //Save values to project data when page is closed
        if (status === PageStatus.Deactivating && !bInitPage)
        {
            var sPIDsPage1FromPage = "";

            //Check if fields are valid and have changed. Save values.
            //Generate PID strings from comboboxe indexes
            sPIDsPage1FromPage = SettingsDataObject.arLookupINDEX[id_CMB_page1_1.currentIndex].pid + "," +
                    SettingsDataObject.arLookupINDEX[id_CMB_page1_2.currentIndex].pid + "," +
                    SettingsDataObject.arLookupINDEX[id_CMB_page1_3.currentIndex].pid + "," +
                    SettingsDataObject.arLookupINDEX[id_CMB_page1_4.currentIndex].pid + "," +
                    SettingsDataObject.arLookupINDEX[id_CMB_page1_5.currentIndex].pid + "," +
                    SettingsDataObject.arLookupINDEX[id_CMB_page1_6.currentIndex].pid;

            //Check if settings changed.
            if (sPIDsPage1FromPage !== sPIDsPage1)
            {
                console.log("sPIDsPage1: " + sPIDsPage1);
                console.log("sPIDsPage1FromPage: " + sPIDsPage1FromPage);

                //Save new configuration to global variable
                sPIDsPage1 = sPIDsPage1FromPage;
                //Save new configuration to project settings
                id_ProjectSettings.vSaveProjectData("PIDsPage1", sPIDsPage1FromPage);
            }
        }
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: id_Column_Main.height

        VerticalScrollDecorator {}

        Column
        {
            id: id_Column_Main

            spacing: Theme.paddingMedium
            width: parent.width

            PageHeader { title: qsTr("Settings") }

            SectionHeader
            {
                text: qsTr("Dynamic Parameters Page 1")
            }

            ComboBox
            {
                id: id_CMB_page1_1
                width: parent.width
                label: 'Parameter1:'                
                menu: ContextMenu { Repeater { model: arComboboxStringArray; MenuItem { text: modelData }}}
                Component.onCompleted: { if (bPageInitialized===false) fncOnComboboxCompleted(); }
            }
            ComboBox
            {
                id: id_CMB_page1_2
                width: parent.width
                label: 'Parameter2:'
                menu: ContextMenu { Repeater { model: arComboboxStringArray; MenuItem { text: modelData } }}
                Component.onCompleted: { if (bPageInitialized===false) fncOnComboboxCompleted(); }
            }            
            ComboBox
            {
                id: id_CMB_page1_3
                width: parent.width
                label: 'Parameter2:'
                menu: ContextMenu { Repeater { model: arComboboxStringArray; MenuItem { text: modelData } }}
                Component.onCompleted: { if (bPageInitialized===false) fncOnComboboxCompleted(); }
            }
            ComboBox
            {
                id: id_CMB_page1_4
                width: parent.width
                label: 'Parameter2:'
                menu: ContextMenu { Repeater { model: arComboboxStringArray; MenuItem { text: modelData } }}
                Component.onCompleted: { if (bPageInitialized===false) fncOnComboboxCompleted(); }
            }
            ComboBox
            {
                id: id_CMB_page1_5
                width: parent.width
                label: 'Parameter2:'
                menu: ContextMenu { Repeater { model: arComboboxStringArray; MenuItem { text: modelData } }}
                Component.onCompleted: { if (bPageInitialized===false) fncOnComboboxCompleted(); }
            }
            ComboBox
            {
                id: id_CMB_page1_6
                width: parent.width
                label: 'Parameter2:'
                menu: ContextMenu { Repeater { model: arComboboxStringArray; MenuItem { text: modelData } }}
                Component.onCompleted: { if (bPageInitialized===false) fncOnComboboxCompleted(); }
            }

            /*
            SectionHeader
            {
                text: qsTr("Dynamic Parameters Page 2")
            }
            */
        }
    }
}