<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :edit, :update, :destroy]

  # GET <%= route_url %>
  # GET <%= route_url %>.json
  def index
    @<%= plural_table_name %> = <%= orm_class.all(class_name) %>.page(params[:page])
  end

  # GET <%= route_url %>/1
  # GET <%= route_url %>/1.json
  def show
  end

  # GET <%= route_url %>/new
  def new
    @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
  end

  # GET <%= route_url %>/1/edit
  def edit
  end

  # POST <%= route_url %>
  # POST <%= route_url %>.json
  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    respond_to do |format|
      unless @<%= singular_table_name %>.valid? 
        format.html { render :edit and return }
        format.json { render json: {status: 'VALIDATION_ERROR', keys: <%= "@#{orm_instance.errors}" %>.keys, errors: <%= "@#{orm_instance.errors}" %>.full_messages}, status: :unprocessable_entity and return}
      end

      if @<%= orm_instance.save %>
        format.html { redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully created.'" %> }
        format.json { render json: {status: 'VALIDATION_ERROR', keys: <%= "@#{orm_instance.errors}" %>.keys, errors: <%= "@#{orm_instance.errors}" %>.full_messages}, status: :unprocessable_entity and return}
      else
        format.html { render :new }
        format.json { render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT <%= route_url %>/1
  # PATCH/PUT <%= route_url %>/1.json
  def update
    respond_to do |format|
      @<%= singular_table_name %>.attributes = <%="#{singular_table_name}_params"%>
      unless @<%= singular_table_name %>.valid? 
        format.html { render :edit and return}
        format.json { render json: {status: 'VALIDATION_ERROR', keys: <%= "@#{orm_instance.errors}" %>.keys, errors: <%= "@#{orm_instance.errors}" %>.full_messages}, status: :unprocessable_entity and return}
      end

      if @<%= orm_instance.update("#{singular_table_name}_params") %>
        format.html { redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully updated.'" %> }
        format.json { render :show, status: :ok, location: <%= "@#{singular_table_name}" %> }
      else
        format.html { render :edit }
        format.json { render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity }
      end
    end
  end

  # DELETE <%= route_url %>/1
  # DELETE <%= route_url %>/1.json
  def destroy
    @<%= orm_instance.destroy %>
    respond_to do |format|
      format.html { redirect_to <%= index_helper %>_url, notice: <%= "'#{human_name} was successfully destroyed.'" %> }
      format.json { render json: {notice: <%= "'#{human_name} was successfully destroyed.'" %>}, status: :ok, location: <%= "@#{singular_table_name}" %> }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params.fetch(<%= ":#{singular_table_name}" %>, {})
      <%- else -%>
      params.require(<%= ":#{singular_table_name}" %>).permit(<%= permitted_params %>)
      <%- end -%>
    end
end
<% end -%>
