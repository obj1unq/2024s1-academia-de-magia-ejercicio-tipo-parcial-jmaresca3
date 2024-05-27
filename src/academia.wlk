///COSAS
class Cosa {
	const marca
	const property volumen
	const property esMagica //Boolean	
	var esReliquia //Boolean
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
}

class Baul inherits Mueble {
	const volumenMax
	
	override method puedeGuardar(cosa){
		return  super(cosa) and self.volumenActual() + cosa.volumen() <= volumenMax
	}
	
	method volumenActual() = cosas.sum( { cosa => cosa.volumen() } )
}

class GabineteMagico inherits Mueble {
	override method puedeGuardar(cosa){
		return super(cosa) and cosa.esMagica()
	}
}

class Armario inherits Mueble {
	var property cantMax
	
	override method puedeGuardar(cosa){
		return super(cosa) and cantMax > cosas.size()
	}
}

///ACADEMIAS
class Academia {
	const muebles = #{}
	
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
}