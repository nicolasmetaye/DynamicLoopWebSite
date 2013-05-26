using AutoMapper;
using DynamicLoop.Components.Extensions;
using DynamicLoop.Components.Models.Projects;
using Umbraco.Core.Models;
using Umbraco.Web;

namespace DynamicLoop.Components.Mapping.Profiles
{
    public class ProjectsMap : Profile
    {
        protected override void Configure()
        {
            ConfigureProjects();
        }

        private void ConfigureProjects()
        {
            Mapper.CreateMap<IPublishedContent, ProjectsModel>()
              .ForMember(model => model.Title, expression => expression.ResolveUsing(node => node.GetTitle()))
              .ForMember(model => model.Projects,
              expression => expression.ResolveUsing(node => node.GetChildNodes("Project")));

            Mapper.CreateMap<IPublishedContent, ProjectModel>()
               .ForMember(model => model.Name, expression => expression.ResolveUsing(node => node.GetTitle()))
               .ForMember(model => model.Description, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("bodyText")))
               .ForMember(model => model.PageUrl, expression => expression.ResolveUsing(node => node.Url))
               .ForMember(model => model.Preview, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("previewText")))
               .ForMember(model => model.SourceUrl, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("sourceGitLink")))
               .ForMember(model => model.ProjectUrl, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("projectLink")));
        }
    }
}
