using System.Collections.Generic;

namespace DynamicLoop.Components.Models.Master
{
    public class TopContentModel
    {
        public PersonalInformationModel PersonalInformation { get; set; }
        public List<MenuItemModel> MenuItems { get; set; }
    }
}