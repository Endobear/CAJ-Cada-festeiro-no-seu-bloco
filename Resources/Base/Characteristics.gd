class_name Charactersistics
extends Resource

enum BODY_TYPE {SLIM,FAT}

@export var body : BODY_TYPE = BODY_TYPE.SLIM

# Aqui vão conter as informações sobre roupa do personagem que vão ser geradas assim que o mesmo entrar na cena
# Talvez seja melhor mudar isso para ser uma variável da cena do personagem
@export var block : Blocks = Blocks.new()
