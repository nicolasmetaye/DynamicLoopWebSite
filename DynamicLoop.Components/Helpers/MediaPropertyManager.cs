using Umbraco.Core.Models;
using Umbraco.Web;

namespace DynamicLoop.Components.Helpers
{
    public class MediaPropertyManager
    {
        private const string MEDIA_FILE_PROPERTY = "umbracoFile";

        private readonly UmbracoHelper _umbracoHelper;

        public MediaPropertyManager(UmbracoHelper umbracoHelper)
        {
            _umbracoHelper = umbracoHelper;
        }

        public string GetMediaUrl(IPublishedContent node, string mediaProperty)
        {
            var linkMedia = _umbracoHelper.TypedMedia(node.GetPropertyValue<int>(mediaProperty));
            if (linkMedia != null)
                return linkMedia.GetPropertyValue<string>(MEDIA_FILE_PROPERTY);
            return string.Empty;
        }
    }
}
