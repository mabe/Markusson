<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Default.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Record>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Index</h2>

    <div data-bind="simpleGrid: gridViewModel"></div>

    <p>
        <%= Html.ActionLink("Create New", "Create") %>
    </p>

</asp:Content>

<asp:Content ContentPlaceHolderID="Script" runat="server">

<script type="text/javascript">

    (function() {
        // Private function
        function getColumnsForScaffolding(data) {
            if ((typeof data.length != 'number') || data.length == 0)
                return [];
            var columns = [];
            for (var propertyName in data[0])
                columns.push({ headerText: propertyName, rowText: propertyName });
            return columns;
        }

        ko.simpleGrid = {
            // Defines a view model class you can use to populate a grid
            viewModel: function(configuration) {
                this.data = configuration.data;
                this.currentPageIndex = ko.observable(0);
                this.pageSize = configuration.pageSize || 5;

                // If you don't specify columns configuration, we'll use scaffolding
                this.columns = configuration.columns || getColumnsForScaffolding(ko.utils.unwrapObservable(this.data));

                this.itemsOnCurrentPage = ko.dependentObservable(function() {
                    var startIndex = this.pageSize * this.currentPageIndex();
                    return this.data.slice(startIndex, startIndex + this.pageSize);
                }, this);

                this.maxPageIndex = ko.dependentObservable(function() {
                    return Math.ceil(ko.utils.unwrapObservable(this.data).length / this.pageSize);
                }, this);
            }
        };

        // Templates used to render the grid
        var templateEngine = new ko.jqueryTmplTemplateEngine();
        templateEngine.addTemplate("ko_simpleGrid_grid", "\
                    <table class=\"ko-grid\" cellspacing=\"0\">\
                        <thead>\
                            <tr>\
                                <th></th>\
                                {{each(i, columnDefinition) columns}}\
                                    <th>${ columnDefinition.headerText }</th>\
                                {{/each}}\
                            </tr>\
                        </thead>\
                        <tbody>\
                            {{each(i, row) itemsOnCurrentPage()}}\
                                <tr class=\"${ i % 2 == 0 ? 'even' : 'odd' }\">\
                                    <td><a href=\"<%= HttpUtility.UrlDecode(Url.Action("Edit", new { id = "${ row.Id }" })) %>\">Edit</a></td>\
                                    {{each(j, columnDefinition) columns}}\
                                        <td>${ typeof columnDefinition.rowText == 'function' ? columnDefinition.rowText(row) : row[columnDefinition.rowText] }</td>\
                                    {{/each}}\
                                </tr>\
                            {{/each}}\
                        </tbody>\
                    </table>");
        templateEngine.addTemplate("ko_simpleGrid_pageLinks", "\
                    <div class=\"ko-grid-pageLinks\">\
                        <span>Page:</span>\
                        {{each(i) ko.utils.range(1, maxPageIndex)}}\
                            <a href=\"#\" data-bind=\"click: function() { currentPageIndex(i) }, css: { selected: i == currentPageIndex() }\">\
                                ${ i + 1 }\
                            </a>\
                        {{/each}}\
                    </div>");

        // The "simpleGrid" binding
        ko.bindingHandlers.simpleGrid = {
            // This method is called to initialize the node, and will also be called again if you change what the grid is bound to
            update: function(element, viewModel) {
                element.innerHTML = "";
                var gridContainer = element.appendChild(document.createElement("DIV"));
                ko.renderTemplate("ko_simpleGrid_grid", viewModel, { templateEngine: templateEngine }, gridContainer, "replaceNode");

                var pageLinksContainer = element.appendChild(document.createElement("DIV"));
                ko.renderTemplate("ko_simpleGrid_pageLinks", viewModel, { templateEngine: templateEngine }, pageLinksContainer, "replaceNode");
            }
        };
    })();

</script>

<script type="text/javascript">

    var viewModel = {
        items: ko.observableArray(<%= Model.ToJson() %>)
        };
       
        viewModel.gridViewModel = new ko.simpleGrid.viewModel({
            data: viewModel.items,
            columns: [
                { headerText: "Id", rowText: "Id" },
                { headerText: "Name", rowText: "Name" }
            ]
        });
        
        

    ko.applyBindings(document.body, viewModel);

</script>


</asp:Content>

