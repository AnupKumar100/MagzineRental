using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(MagzineRental.Startup))]
namespace MagzineRental
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
