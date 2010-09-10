<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Default.Master" Inherits="System.Web.Mvc.ViewPage<Record>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Edit</h2>

    <% using (Html.BeginForm()) {%>
        <%= Html.ValidationSummary(true) %>
        
        <fieldset>
            <legend>Fields</legend>
            
            <div class="editor-label">
                <%= Html.LabelFor(model => model.Name) %>
            </div>
            <div class="editor-field">
                <input name="Name" data-bind="value: Name" />
                <%= Html.ValidationMessageFor(model => model.Name) %>
            </div>
            <div class="editor-label">
                <%= Html.LabelFor(model => model.Tracks) %>
            </div>
            <div class="editor-field" data-bind="template: 'recordForm'">
            </div>
            <a href="#" data-bind="click: addTrack">Add new track</a>
            
            <script id="recordForm" type="text/html">
             {{each(i, track) Tracks()}}
                <div class="editor-label">
                    Track ${i + 1}
                </div>        
                <div class="editor-field">
                    <input name="Tracks[${i}].Name" data-bind="value: Name"/>
                </div>
             {{/each}}
            </script>
            
            <p>
                <input type="submit" value="Save" />
            </p>
        </fieldset>

    <% } %>

    <div>
        <%= Html.ActionLink("Back to List", "Index") %>
    </div>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Script" runat="server">

    <script type="text/javascript">

        var viewModel = {
            Name: ko.observable("<%= Model.Name %>"),
            Tracks: new ko.observableArray(<%= Model.Tracks.ToJson() %>),
            addTrack: function() {
                viewModel.Tracks.push({ Name : "" });
            }
        };
        
        ko.applyBindings(document.body, viewModel);
        
    </script>

</asp:Content>

