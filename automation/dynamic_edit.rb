module Automation
  class DynamicEdit < Thor
    include ::Automation::InputUtils
    include ::Automation::Compile::CompileUnitResolution
    namespace :edit

    method_option :compile_file, default: nil

    desc 'edit', 'edit files in a compile unit'
    def edit
      unit = pick_item_from(settings.compile_units, "Pick a compile unit to edit")
      edit_unit(unit)
    end

    desc 'unit', 'edit specific compile unit'
    def edit_unit(unit)
      FileUtils.cp(settings.edit_project_template, edit_file)
      unit = get_compile_unit(unit)
      configure(compile_unit: unit)
      invoke 'automation:expand', []
      FileUtils.rm edit_file
    end

    no_commands do
      def edit_file
        original_name = settings.edit_project_template
        folder = File.dirname(original_name)
        base_name = File.basename(original_name, File.extname(original_name))
        file_name = File.join(folder, "#{base_name}.erb")
      end
    end
  end
end
