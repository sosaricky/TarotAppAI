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

READINGS_COUNT = 5
CARDS_PER_READING = 3

READINGS_COUNT.times do
  reading = Reading.create!(
    name: names.sample,
    conclusion: conclusions.sample,
    user: User.all.sample
  )

  # Sample distinct cards so the reading never repeats a card or a position,
  # keeping the unique indexes on reading_cards satisfied.
  Card.all.sample(CARDS_PER_READING).each_with_index do |card, index|
    ReadingCard.create!(
      reading: reading,
      card: card,
      position: index,
      reversed: [ false, true ].sample
    )
  end
end
