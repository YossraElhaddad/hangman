module Serializable
  def serialize_variables
    variables = {}
    for variable in instance_variables
      variables[variable] = instance_variable_get(variable)
        end
    variables
  end

  def unserialize_variables(hashed_variables)
    hashed_variables.each do |key, value|
      instance_variable_set(key, value)
    end
  end
end
