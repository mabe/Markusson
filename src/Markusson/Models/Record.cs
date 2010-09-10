using System.Collections.Generic;
public class Record
{
    public Record()
    {
        Tracks = new List<Track>();
    }

    public string Id { get; set; }
    public string Name { get; set; }

    public ICollection<Track> Tracks { get; set; }
}

public class Track 
{
    public string Name { get; set; }
}