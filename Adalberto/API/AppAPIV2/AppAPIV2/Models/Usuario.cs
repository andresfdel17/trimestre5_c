namespace AppAPIV2.Models
{
    public class Usuario
    {
        public int IdU { get; set; }
        public string Nombres { get; set; }
        public string Telefono { get; set; }
        public string Correo { get; set; }
        public string Ciudad { get; set; }
        public DateTime FechaIngreso { get; set; }
    }
}
