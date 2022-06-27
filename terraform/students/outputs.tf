output "students" {
  value = [for student in var.students : {
    name      = student.name,
    subnet_id = aws_subnet.students[student.name].id
  }]
}
