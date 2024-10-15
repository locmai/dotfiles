variable "connectors" {
  description = "List of connectors with their configurations"
  type = list(object({
    type   = string
    id     = string
    name   = string
    config = object({})}))
  default = []
}
