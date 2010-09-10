using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using Raven.Client.Document;
using Raven.Client;

namespace Markusson
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        private static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                "Default", 
                "{controller}s/", 
                new { controller = "Record", action = "Index" } 
            );

            routes.MapRoute(
             "Create",
             "{controller}s/Create",
             new { controller = "Record", action = "Create" }
            );

            routes.MapRoute(
                "Details",
                "{controller}s/{id}",
                new { controller = "Record", action = "Details", id = "0" }
            );

         

            routes.MapRoute(
                "Edit",
                "{controller}s/{id}/Edit",
                new { controller = "Record", action = "Edit", id = "0" }
            );

            routes.MapRoute(
                "Delete",
                "{controller}s/{id}/Delete",
                new { controller = "Record", action = "Delete", id = "0" }
            );

            //, id = UrlParameter.Optional
        }

        protected void Application_Start()
        {
            _documentStore = new DocumentStore() { Url = "http://localhost:8080" };
            _documentStore.Initialize();
            _documentStore.Conventions.IdentityPartsSeparator = "-";

            AreaRegistration.RegisterAllAreas();

            RegisterRoutes(RouteTable.Routes);
        }

        public MvcApplication()
        {
            RegisterSession();
        }

        private const string RavenSessionKey = "raven_session";

        protected static DocumentStore _documentStore;

        public static IDocumentSession CurrentSession
        {
            get { return (IDocumentSession)HttpContext.Current.Items[RavenSessionKey];  }
        }

        private void RegisterSession()
        {
            this.BeginRequest += (sender, e) => { this.Context.Items[RavenSessionKey] = _documentStore.OpenSession(); };
            this.EndRequest += (sender, e) => {
                var session = this.Context.Items[RavenSessionKey] as IDisposable;

                if (session != null) {
                    session.Dispose();
                }
            };
        }
    }
}