using System;
using System.Collections.Generic;
using System.Linq;
using Umbraco.Core.Models;
using Umbraco.Web;

namespace DynamicLoop.Components.Extensions
{
    public static class NodeExtensions
    {
        public static string GetTitle(this IPublishedContent content)
        {
            var heading = content.GetPropertyValue<string>("heading");
            if (!string.IsNullOrEmpty(heading))
                return heading;
            return content.Name;
        }

        public static IPublishedContent GetChildNode(this IPublishedContent content, string documentTypeAlias)
        {
            return content.Children.FirstOrDefault(node =>node.DocumentTypeAlias.Equals(documentTypeAlias, StringComparison.OrdinalIgnoreCase));
        }

        public static IEnumerable<IPublishedContent> GetChildNodes(this IPublishedContent content, string documentTypeAlias)
        {
            return content.Children.Where(node => node.DocumentTypeAlias.Equals(documentTypeAlias, StringComparison.OrdinalIgnoreCase));
        }
    }
}
