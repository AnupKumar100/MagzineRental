using System.Web;
using System.Web.Optimization;

namespace MagzineRental
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-2.1.1.min.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.validate*"));

            bundles.Add(new ScriptBundle("~/bundles/jquerycarousel").Include(
                        "~/Scripts/jquery.easing.1.3.js",
                        "~/Scripts/classie.js",
                        "~/Scripts/count-to.js",
                        "~/Scripts/jquery.appear.js",
                        "~/Scripts/owl.carousel.min.js",
                        "~/Scripts/script.js"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.js",
                      "~/Scripts/bootbox.min.js",
                      "~/Scripts/respond.js"
                      ));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.min.css",
                      "~/Content/font-awesome.min.css",
                      "~/Content/style.css",
                      "~/Content/animate.css",
                      "~/Content/color/green.css",
                      "~/Content/site.css"));

            bundles.Add(new ScriptBundle("~/bundles/datatabless").Include(
                      "~/Scripts/DataTables/js/jquery.dataTables.js",
                      "~/Scripts/DataTables/js/dataTables.bootstrap.js"));

            bundles.Add(new StyleBundle("~/Content/tablecss").Include(
                      "~/Scripts/DataTables/css/dataTables.bootstrap.css",
                      "~/Scripts/DataTables/css/jquery.dataTables.css"));
        }
    }
}
