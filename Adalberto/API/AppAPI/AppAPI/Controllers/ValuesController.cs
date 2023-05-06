using AppAPI.Data;
using AppAPI.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace AppAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ValuesController : ControllerBase
    {
        // GET api/<controller>
        public List<Usuario> Get()
        {
            return UsuarioData.Listar();
        }
        // GET api/<controller>/5
        public List<Usuario> Get(string id)
        {
            return UsuarioData.Obtener(id);
        }
        // POST api/<controller>
        public bool Post([FromBody] Usuario oUsuario)
        {
            return UsuarioData.registrarUsuario(oUsuario);
        }
        // PUT api/<controller>/5
        public bool Put([FromBody] Usuario oUsuario)
        {
            return UsuarioData.actualizarUsuario(oUsuario);
        }
        // DELETE api/<controller>/5
        public bool Delete(string id)
        {
            return UsuarioData.eliminarUsuario(id);
        }
    }
}
