using System.Web.Script.Serialization;
namespace Markusson.Helpers
{
    public static class JsonHelpers
    {
        public static string ToJson(this object obj)
        {
            var serializer = new JavaScriptSerializer();

            return serializer.Serialize(obj);
        }
    }
}