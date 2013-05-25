using System.Collections.Generic;
using AutoMapper;
using DynamicLoop.Components.Extensions;
using DynamicLoop.Components.Models.Home;
using Umbraco.Core.Models;
using Umbraco.Web;

namespace DynamicLoop.Components.Mapping.Profiles
{
    public class HomeMap : Profile
    {
        protected override void Configure()
        {
            ConfigureEducation();
            ConfigureSkills();
            ConfigureWorkExperience();
        }

        private void ConfigureEducation()
        {
            Mapper.CreateMap<IPublishedContent, EducationModel>()
              .ForMember(model => model.Title, expression =>
                  expression.ResolveUsing(node =>
                  {
                      var educationNode = node.GetChildNode("Education");
                      if (educationNode == null)
                          return string.Empty;
                      return educationNode.GetTitle();
                  }))
              .ForMember(model => model.Schools,
              expression => expression.ResolveUsing(node =>
              {
                  var educationNode = node.GetChildNode("Education");
                  if (educationNode == null)
                      return new List<IPublishedContent>();
                  return educationNode.GetChildNodes("School");
              }));

            Mapper.CreateMap<IPublishedContent, SchoolModel>()
               .ForMember(model => model.Name, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("schoolName")))
               .ForMember(model => model.Period, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("period")));
        }

        private void ConfigureSkills()
        {
            Mapper.CreateMap<IPublishedContent, SkillsModel>()
               .ForMember(model => model.Title, expression =>
                   expression.ResolveUsing(node =>
                   {
                       var skillsNode = node.GetChildNode("Skills");
                       if (skillsNode == null)
                           return string.Empty;
                       return skillsNode.GetTitle();
                   }))
               .ForMember(model => model.Skills,
               expression => expression.ResolveUsing(node =>
               {
                   var skillsNode = node.GetChildNode("Skills");
                   if (skillsNode == null)
                       return new List<IPublishedContent>();
                   return skillsNode.GetChildNodes("Skill");
               }));

            Mapper.CreateMap<IPublishedContent, SkillModel>()
               .ForMember(model => model.Name, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("name")))
               .ForMember(model => model.Experience, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("experience")))
               .ForMember(model => model.Description, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("description")));
        }

        private void ConfigureWorkExperience()
        {
            Mapper.CreateMap<IPublishedContent, WorkExperienceModel>()
               .ForMember(model => model.Title, expression =>
                   expression.ResolveUsing(node =>
                   {
                       var workExperienceNode = node.GetChildNode("WorkExperience");
                       if (workExperienceNode == null)
                           return string.Empty;
                       return workExperienceNode.GetTitle();
                   }))
               .ForMember(model => model.Experiences,
               expression => expression.ResolveUsing(node =>
               {
                   var workExperienceNode = node.GetChildNode("WorkExperience");
                   if (workExperienceNode == null)
                       return new List<IPublishedContent>();
                   return workExperienceNode.GetChildNodes("Experience");
               }));

            Mapper.CreateMap<IPublishedContent, ExperienceModel>()
               .ForMember(model => model.CompanyName, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("companyName")))
               .ForMember(model => model.Location, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("location")))
               .ForMember(model => model.Period, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("period")))
               .ForMember(model => model.Position, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("position")))
               .ForMember(model => model.Description, expression => expression.ResolveUsing(node => node.GetPropertyValue<string>("description")));
        }

    }
}
