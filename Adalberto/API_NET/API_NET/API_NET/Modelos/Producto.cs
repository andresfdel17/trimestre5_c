namespace API_NET.Modelos
{
    public class Producto
    {
        public int Id_producto { get; set; }
        public string Codigo_barra { get; set; }
        public string Nombre { get; set; }
        public string Marca { get; set; }
        public string Categoria { get; set; }
        public decimal Precio { get; set; }
    }
}
