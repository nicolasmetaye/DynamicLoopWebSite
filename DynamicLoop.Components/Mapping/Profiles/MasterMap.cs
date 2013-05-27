using System;
using System.Collections.Generic;
using System.Linq;
using DynamicLoop.Components.Extensions;
using DynamicLoop.Components.Helpers;
using DynamicLoop.Components.Models.Master;
using AutoMapper;
using Umbraco.Core.Models;
using Umbraco.Web;

namespace DynamicLoop.Components.Mapping.Profiles
{
    public class MasterMap : Profile
    {
        protected override void Configure()
        {
            Mapper.CreateMap<IPublishedContent, MetaTagsModel>()
                .ForMember(model => model.Title, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("title")))
                .ForMember(model => model.Keywords, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("metaKeywords")))
                .ForMember(model => model.Description, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("metaDescription")));

             Mapper.CreateMap<IPublishedContent, PersonalInformationModel>()
                .ForMember(model => model.Address, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("address")))
                .ForMember(model => model.Email, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("email")))
                .ForMember(model => model.FullName, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("fullName")))
                .ForMember(model => model.Introduction, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("introduction")))
                .ForMember(model => model.JobTitle, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("jobTitle")))
                .ForMember(model => model.ResumePDFUrl, expression => expression.ResolveUsing(node => new MediaPropertyManager(new UmbracoHelper(UmbracoContext.Current)).GetMediaUrl(node, "resumePDF")));

            Mapper.CreateMap<IPublishedContent, TopContentModel>()
                .ForMember(model => model.PersonalInformation, expression => expression.ResolveUsing(node => node.AncestorOrSelf(1)))
                .ForMember(model => model.MenuItems, expression => expression.ResolveUsing(node =>
                    {
                        var rootNode = node.AncestorOrSelf(1);
                        var menuNode = node.AncestorOrSelf(2);
                        var personalProjectsNode = rootNode.GetChildNode("PersonalProjects");
                        return new List<MenuItemModel>
                            {
                                new MenuItemModel
                                    {
                                        IsSelected = node.Id == rootNode.Id,
                                        Title = rootNode.GetTitle(),
                                        Url = rootNode.Url
                                    },
                                new MenuItemModel
                                    {
                                        IsSelected = menuNode != null && menuNode.Id == personalProjectsNode.Id,
                                        Title = personalProjectsNode.GetTitle(),
                                        Url = personalProjectsNode.Url
                                    }
                            };

                    }));

            Mapper.CreateMap<IPublishedContent, FooterModel>()
                .ForMember(model => model.GitHubUrl, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("gitHubLink")))
                .ForMember(model => model.Email, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("email")))
                .ForMember(model => model.LinkedInUrl, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("linkedInLink")));

            Mapper.CreateMap<IPublishedContent, BottomContentModel>()
                .ForMember(model => model.Footer, expression => expression.ResolveUsing(node => node.AncestorOrSelf(1)));
        }
    }
}
