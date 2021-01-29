RuboCop GitHub CI
Este repositorio proporciona la configuración RuboCop recomendada y Cops adicionales para su uso en proyectos Ruby internos y de código abierto de GitHub.

Uso
Rubocop 0.68 eliminó a los policías de rendimiento y 0.72 eliminó a los policías de Rails. Sin embargo, la actualización rubocop-githubsin modificaciones creará casi definitivamente muchos nuevos delitos. La versión actual de esta gema expone la configuración "heredada" en config/default.ymly config/rails.ymlque debería usarse si y solo si la versión de rubocop está bloqueada < 0.68en su proyecto (que debería ser a menos que usted bundle update rubocop). También expone una configuración de "borde" debajo config/default_edge.ymly config/rails_edge.ymlpara que los cambios se puedan probar sin introducir cambios importantes.

Uso heredado
Gemfile

gema  "rubocop" ,  "<0,68" 
gema  "rubocop-github"
.rubocop.yml

herencia_gema :
   rubocop-github :
    - config / default.yml 
    - config / rails.yml
Uso de borde
Gemfile

gem  "rubocop-github" 
gem  "rubocop-performance" ,  requiere : false 
gem  "rubocop-rails" ,  requiere : false
.rubocop.yml

herencia_gema :
   rubocop-github :
    - config / default_edge.yml 
    - config / rails_edge.yml
Pruebas
bundle install bundle exec rake test

Los policías
Todos los policías se encuentran debajo lib/rubocop/cop/githuby contienen ejemplos / documentación.
