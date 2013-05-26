using DynamicLoop.Components.Mapping.Profiles;
using AutoMapper;

namespace DynamicLoop.Components.Mapping
{
    public static class AutoMapperConfiguration
    {
        public static void Configure()
        {
            Mapper.Initialize(configuration =>
            {
                configuration.AddProfile(new MasterMap());
                configuration.AddProfile(new HomeMap());
                configuration.AddProfile(new ProjectsMap());
            });
        }
    }
}
