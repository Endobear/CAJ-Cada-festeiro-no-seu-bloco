## Recurso que possui todas as caracteristicas dos blocos
class_name Blocks
extends Resource

signal chaged_active_state

# Se esse bloco é ativo / contabilizado na contação de pontos
@export var active : bool = true:
	set(value):
		active = value
		chaged_active_state.emit()
		

# Nome do bloco, por conveniência e para checagem
@export var name : String = "mamamia"

# Cor que será exibida na camisa/acessórios das pessoas e também no frame do bloco
@export var cor : Color = Color.WHITE

# Props para spawnar dentro do bloco
@export var props : Array[Texture2D]

# Simbolo do bloco
@export var simbol : Texture2D

@export_group("Slim body sprites")
# Estilos de cabelo e/ou chapeus que podem ser usados pelos personagens
@export var slim_head_sprites : Array[SpriteFrames]
@export var slim_body_sprites : Array[SpriteFrames]
@export var slim_legs_sprites : Array[SpriteFrames]


@export_group("Fat body sprites")
# Estilos de cabelo e/ou chapeus que podem ser usados pelos personagens
@export var fat_head_sprites : Array[SpriteFrames]
@export var fat_body_sprites : Array[SpriteFrames]
@export var fat_legs_sprites : Array[SpriteFrames]
