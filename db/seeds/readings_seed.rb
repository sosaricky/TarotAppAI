require 'faker'

names = [
  "Camino del Amor",
  "Decisiones de Vida",
  "Destino y Fortuna",
  "Autoconocimiento",
  "Relaciones Kármicas",
  "Carrera y Éxito",
  "Salud y Bienestar",
  "Transformación Personal"
]



conclusions = [
  "Esta tirada indica que el cambio es inminente pero positivo.",
  "Debes mantener la calma y confiar en tu camino.",
  "Se avecina una etapa de grandes logros personales.",
  "Necesitas sanar heridas pasadas para avanzar.",
  "El destino está de tu lado en este momento crucial.",
  "Tu fortaleza interna será la clave del éxito.",
  "Una decisión importante determinará tu futuro cercano.",
  "Es tiempo de actuar con determinación y claridad."
]

5.times do
  Reading.create!(

    name: names.sample,
    conclusion: conclusions.sample,
    user_id: User.all.sample.id
  )
end

# Reading_cards
# Necesito para una tirada lo siguiente
# 1 - Quien es el user que está por hacer la tirada.
# 2 - Las 3 cartas que salieron
# 3 - El órden en que salieron las cartas
# 4 - La conclusion de la tirada.
#
# Vamos a generar 3 tiradas.
# El user será uno aleatorio de los que hay en User.all
# En el caso de las cartas también será una aletoria de las que hay
# Mismo que para el caso de los messages y la conclusion

# Ojo que las cartas no se pueden repetir en una tirada.
#
3.times do
  reading_id = Reading.all.sample.id
  (0..2).each do
    |i|
    ReadingCard.create!(position: i, reading_id: reading_id, card_id: Card.all.sample.id)
  end
end
