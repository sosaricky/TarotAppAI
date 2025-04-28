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
