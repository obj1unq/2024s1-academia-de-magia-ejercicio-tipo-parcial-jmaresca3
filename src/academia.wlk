///COSAS
class Cosa {
	const property marca
	const property volumen
	const property esMagica //Boolean	
	const property esReliquia //Boolean
	
	method utilidad() = volumen + self.utilidadSiEsMagica() + self.utilidadSiEsReliquia() + self.utilidadPorMarca()
	
	method utilidadSiEsMagica() = if(esMagica) 3 else 0
	
	method utilidadSiEsReliquia() = if(esReliquia) 5 else 0
	
	method utilidadPorMarca() = marca.utilidad(self)
}

///MARCAS
object acme{
	method utilidad(cosa) = cosa.volumen()/2
}

object fenix{
	method utilidad(cosa) = if(cosa.esReliquia()) 3 else 0
}

object cuchuflito{
	method utilidad(cosa) = 0
}

///MUEBLES
class Mueble {
	const cosas = #{} 
	
	method tiene(cosa) = cosas.contains(cosa)
	
	method puedeGuardar(cosa){
		return not self.tiene(cosa)
	}
	
	method guardar(cosa){
		self.validarGuardar(cosa)
		cosas.add(cosa)
	}
	
	method validarGuardar(cosa){
		if(not self.puedeGuardar(cosa)){
			self.error("No se puede guardar la cosa")
		}
	}
	
	method utilidad(){
		return self.utilidadDeLasCosas()/self.precio()
	}
	
	method utilidadDeLasCosas() = cosas.sum( { cosa => cosa.utilidad() } )
	
	method precio()
	
	method cosaMenosUtil() = cosas.min( { cosa => cosa.utilidad() } )
	
	method remover(cosa){
		cosas.remove(cosa)
	}
}

class Baul inherits Mueble {
	const volumenMax
	
	override method puedeGuardar(cosa){
		return  super(cosa) and self.volumenActual() + cosa.volumen() <= volumenMax
	}
	
	method volumenActual() = cosas.sum( { cosa => cosa.volumen() } )
	
	override method precio() = volumenMax + 2
	
	override method utilidad(){
		return super() + self.utilidadSiSonReliquias()
	}
	
	method utilidadSiSonReliquias() = if(cosas.all({ cosa => cosa.esReliquia()})) 2 else 0
}

class BaulMagico inherits Baul{
	override method precio() = super() * 2
	override method utilidad() = super() + self.cantidadDeElementosMagicos()
	method cantidadDeElementosMagicos(){
		return cosas.count({cosa=>cosa.esMagica()})
	}
}

class GabineteMagico inherits Mueble {
	const precio
	override method puedeGuardar(cosa){
		return super(cosa) and cosa.esMagica()
	}
	
	override method precio() = precio
}

class Armario inherits Mueble {
	var property cantMax
	
	override method puedeGuardar(cosa){
		return super(cosa) and cantMax > cosas.size()
	}
	
	override method precio() = 5 * cantMax
}

///ACADEMIAS
class Academia {
	const property muebles = #{}
	
	method tiene(cosa) {
		return muebles.any( { mueble => mueble.tiene(cosa) } )
	}
	
	method muebleQueTiene(cosa) {
		return muebles.find( { mueble => mueble.tiene(cosa) } )
	}
	
	method puedeGuardar(cosa) {
		return not self.tiene(cosa) and self.hayLugarPara(cosa)
	}
	
	method hayLugarPara(cosa) {
		return muebles.any({mueble=>mueble.puedeGuardar(cosa)})
	}
	
	method dondeGuardar(cosa) {
		return muebles.filter( { mueble => mueble.puedeGuardar(cosa) } )
	}
	
	method guardar(cosa) {
		self.validarGuardar(cosa)
		self.dondeGuardar(cosa).anyOne().guardar(cosa)
	}
	
	method validarGuardar(cosa) {
		if(not self.puedeGuardar(cosa)){
			self.error("No se puede guardar la cosa en la academia")
		}
	}
	
	method cosasMenosUtiles(){
		return muebles.map({ mueble => mueble.cosaMenosUtil() }).asSet()
	}
	
	method marcaMenosUtil() = self.cosaMenosUtil().marca()
	
	method cosaMenosUtil() = self.cosasMenosUtiles().min({cosa=>cosa.utilidad()})
	
	method removerCosasMenosUtilesNoMagicas(){
		self.validarRemoverUtilesNoMagicas()
		self.cosasMenosUtilesNoMagicas().forEach({
			cosa => self.remover(cosa)
		})
	}
	
	method remover(cosa){
		self.muebleQueTiene(cosa).remover(cosa)
	}
	
	method validarRemoverUtilesNoMagicas(){
		if(muebles.size()<3){
			self.error("No hay muebles suficientes")
		}
	}
	
	method cosasMenosUtilesNoMagicas(){
		return self.cosasMenosUtiles().filter( { cosa=> not cosa.esMagica() } )
	}
}