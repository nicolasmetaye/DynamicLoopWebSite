using System;
using DynamicLoop.Components.Mapping;

namespace DynamicLoop.Components
{
    public class GlobalApplication : Umbraco.Web.UmbracoApplication
    {
        protected override void OnApplicationStarted(object sender, EventArgs e)
        {
            base.OnApplicationStarted(sender, e);

            AutoMapperConfiguration.Configure();
        }
    }
}
