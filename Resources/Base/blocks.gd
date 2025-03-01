class_name Blocks
extends Resource

# Nome do bloco, por conveniência e para checagem
@export var name : String = "mamamia"

# Cor que será exibida na camisa/acessórios das pessoas e também no frame do bloco
@export var cor : Color = Color.WHITE

# Estilos de cabelo e/ou chapeus que podem ser usados pelos personagens
@export var cabelos_chapeus : Array[SpriteFrames]
