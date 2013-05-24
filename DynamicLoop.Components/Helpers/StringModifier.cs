namespace DynamicLoop.Components.Helpers
{
    public class StringModifier
    {
        public string CleanJSString(string textToClean)
        {
            if (textToClean == null)
                return string.Empty;
            return textToClean.Replace("'", "\\'");
        }
    }
}
