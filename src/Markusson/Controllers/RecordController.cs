using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Raven.Client;

namespace Markusson.Controllers
{
    public class RecordController : Controller
    {
        //
        // GET: /Record/

        public ActionResult Index()
        {
            var session = MvcApplication.CurrentSession;

            return View(session.LuceneQuery<Record>().ToList());
        }

        //
        // GET: /Record/Details/5

        public ActionResult Details(string id)
        {
            var session = MvcApplication.CurrentSession;

            return View(session.Load<Record>(id));
        }

        //
        // GET: /Record/Create

        public ActionResult Create()
        {
            return View(new Record());
        } 

        //
        // POST: /Record/Create

        [HttpPost]
        public ActionResult Create(Record record)
        {
            if (!ModelState.IsValid)
                return View();

            var session = MvcApplication.CurrentSession;

            session.Store(record);
            session.SaveChanges();

            return RedirectToAction("Index");
        }

        //
        // GET: /Record/Delete/5
        [HttpPost]
        public ActionResult Delete(string id)
        {
            return View();
        }

        //
        // GET: /Record/Edit/5
 
        public ViewResult Edit(string id)
        {
            var session = MvcApplication.CurrentSession;

            return View(session.Load<Record>(id));
        }

        //
        // POST: /Record/Edit/5

        [HttpPost]
        public ActionResult Edit(Record recordInput)
        {
            if (!ModelState.IsValid)
                return View();

            var session = MvcApplication.CurrentSession;

            //session.Refresh(record);
            var record = session.Load<Record>(recordInput.Id);

            record.Name = recordInput.Name;
            record.Tracks = recordInput.Tracks;
            
            session.SaveChanges();

            return RedirectToAction("Index");
        }
    }
}
