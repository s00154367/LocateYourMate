﻿<%@ Page Title="Session" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Session.aspx.cs" Inherits="PRJ300Rep.Session" %>


<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Tangerine">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
    <%--<script type="text/javascript" src="js/bootstrap.min.js"></script>--%>    
    <%--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js%22%3E"></script>--%>
    <script src="Scripts/jquery-3.1.1.min.js"></script>
    <link href="Styles/StyleSheetSession.css" rel="stylesheet" />
    <style>
        #map {
            height: 600px;
            width: 70%;
            float: left;
        }
    </style>
    <script>

        var ipAddress = "";
        var User = '<%=CurrentUser%>';
        var Users = new Array();
        Users = JSON.parse('<%=JSArray%>');
        var pos = {};

        // Google Maps
        var map, infoWindow;
        function initMap() {
            map = new google.maps.Map(document.getElementById('map'), {
                center: { lat: -34.397, lng: 150.644 },
                zoom: 16
            });
            infoWindow = new google.maps.InfoWindow;
        }

        // Get current Location

        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {

                //get the position of the client user
                pos = {
                    lat: position.coords.latitude,
                    lng: position.coords.longitude
                };
               

                infoWindow.setPosition(pos);
                infoWindow.setContent('Your Location');
                infoWindow.open(map);
                map.setCenter(pos);

                var markericon = {
                    url: 'Images/ManIcon.png',
                    scaledSize: new google.maps.Size(40, 40),
                    origin: new google.maps.Point(0, 0),
                    anchor: new google.maps.Point(15, 40),
                    labelOrigin: new google.maps.Point(17, 50)
                }

                for (var i = 0; i < Users.length; i++) {
                    if (Users[i].Username != User) {                    
                        latLng = new google.maps.LatLng(Users[i].Lat, Users[i].Lng);
                        var marker = new google.maps.Marker({
                            position: latLng,                            
                            title: Users[i].Username,
                            animation: google.maps.Animation.DROP,
                            label: {
                                text: Users[i].Username,
                                color: '#000000',
                                fontsize: '20px',
                                fontweight: 'bold'
                            },
                            visible: true,
                            icon: markericon
                        });

                        marker.setMap(map);
                    }
                    else {

                    }
                }

            }, function () {
                handleLocationError(true, infoWindow, map.getCenter());
            });
        } else {
            // Browser doesn't support Geolocation
            handleLocationError(false, infoWindow, map.getCenter());
        }
        function handleLocationError(browserHasGeolocation, infoWindow, pos) {
            infoWindow.setPosition(pos);
            infoWindow.setContent(browserHasGeolocation ?
                'Error: The Geolocation service failed.' :
                'Error: Your browser doesn\'t support geolocation.');
            infoWindow.open(map);
        }


        $(document).ready(function () {            


            var adminID = '<%=adminID%>';
            for (var i = 0; i < Users.length; i++) {
                if (adminID == Users[i]) {
                    $(UserList).append('<li class="list-group-item"><span class="glyphicon glyphicon-asterisk"></span>' + Users[i].Username + '</li>');
                }
                else {
                    $(UserList).append('<li class="list-group-item">' + Users[i].Username + '</li>');
                }
            }


            //set timer to submit form
            setInterval(function () {
                //save location in a hidden field 
                if (pos.lat != null && pos.lng != null) {
                    $("#hdnLat").val(pos.lat);
                    $("#hdnLng").val(pos.lng);
                }
            document.getElementById("mainForm").submit();
        }, 10000);
        });

        


    </script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD9pJLBoZZ0LrasUlwgXgyXcTVepaAwPn0&callback=initMap"
        async defer></script>
    <div id="divBackground">
        <div class="container" id="content">
            <div class="row">
                <h1 class="heading">Festival Friend Finder</h1>
            </div>

            <div class="row">

                <div id="map" class="col-lg-8"></div>

                <div id="list" class="col-lg-4">
                    <div>
                        <asp:Label ID="Label1" runat="server" CssClass="textFont label" Text="Your Session Code:"></asp:Label>
                        <asp:Label ID="tbxCode" runat="server" CssClass=" label" Text=""></asp:Label>
                    </div>
                    <p class="textFont">List of Members in the Session</p>
                    <ul id="UserList" class="list-group textFont">
                        <!--List is populated in Javascript -->
                    </ul>
                    <asp:Button ID="leave" runat="server" Text="Leave Session" class="btn btn-danger" OnClick="leave_Click" />
                    <asp:Button ID="Close" runat="server" Text="Close Session" class="btn btn-danger" OnClick="Close_Click" />

                </div>
            </div>
        </div>
    </div>
    
    <asp:HiddenField ID="hdnLat"  runat="server" ClientIDMode="Static"></asp:HiddenField>
    <asp:HiddenField ID="hdnLng"  runat="server" ClientIDMode="Static"></asp:HiddenField>

    <script>
        ////https://developers.facebook.com/docs/javascript/quickstart
        //  window.fbAsyncInit = function() {
        //	FB.init({
        //	  appId            : '720598181452614',
        //	  autoLogAppEvents : true,
        //	  xfbml            : true,
        //	  version          : 'v2.9'
        //	});
        //	FB.AppEvents.logPageView();
        //	FB.ui(
        // {
        //  method: 'share',
        //  href: 'https://developers.facebook.com/docs/'
        //}, function(response){});
        //  };

        //  (function(d, s, id){
        //	 var js, fjs = d.getElementsByTagName(s)[0];
        //	 if (d.getElementById(id)) {return;}
        //	 js = d.createElement(s); js.id = id;
        //	 js.src = "//connect.facebook.net/en_US/sdk.js";
        //	 fjs.parentNode.insertBefore(js, fjs);
        //   }(document, 'script', 'facebook-jssdk'));
    </script>



    
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:AzureConnectionString %>" SelectCommand="Select UserId from userGroups as ug Inner Join Groups as g on ug.groupID = g.Id Inner Join Sessions as s on  s.groupID = g.Id Where SessionCode = @code">
        <SelectParameters>
            <asp:QueryStringParameter Name="code" QueryStringField="SessionCode" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
