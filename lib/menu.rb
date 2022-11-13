# frozen_string_literal: true

require 'json'
require_relative 'version'
require_relative 'helpers'

module SpecRefLib
    # Class to build the selection menu
    class Menu
        attr_reader :status

        FILEPATH = ENV.fetch('SPEC_REF_LIB')
        # rubocop:disable Metrics/MethodLength
        def initialize
            SpecRefLib::Helpers.clear
            if FILEPATH.nil?
                SpecRefLib::Helpers.log 'file path not set'
                SpecRefLib::Helpers.leave
                @status = 'no path set'
            else
                begin
                    @json = JSON.parse(File.read(FILEPATH))
                    @status = 'active'
                    show_menu
                rescue StandardError
                    SpecRefLib::Helpers.log 'Invalid file path'
                    SpecRefLib::Helpers.leave
                    @status = 'invalid path'
                end
            end
        end
        # rubocop:enable Metrics/MethodLength

        def show_menu
            SpecRefLib::Helpers.log "Spec-ref-lib version #{SpecRefLib::Version.version}"
            SpecRefLib::Helpers.log ''

            @json['categories'].each_with_index do |category, index|
                SpecRefLib::Helpers.log "\t#{index + 1}. #{category['name']}"
            end

            get_input('list_selector', @json)
        end

        def show_sub_menu(menu, name)
            SpecRefLib::Helpers.log name
            SpecRefLib::Helpers.log ''

            menu.each_with_index do |category, index|
                SpecRefLib::Helpers.log "\t#{index + 1}. #{category['name']}"
            end

            get_input('sub_list_selector', menu)
        end

        def show_example(example)
            SpecRefLib::Helpers.log example
            get_input('end_list_selector', nil)
        end

        # rubocop:disable Metrics/MethodLength
        def get_input(type, category)
            case type
            when 'list_selector'
                value = list_validator(SpecRefLib::Helpers.ret_value, category['categories'], type, category)
                menu = category['categories'][value - 1]
                sub_name = menu['name']
                sub_menu = menu['categories']
                SpecRefLib::Helpers.clear
                show_sub_menu(sub_menu, sub_name)
            when 'sub_list_selector'
                value = list_validator(SpecRefLib::Helpers.ret_value, category, type, category)
                menu = category[value - 1]
                sub_example = menu['example']
                SpecRefLib::Helpers.clear
                show_example(sub_example)
            when 'end_list_selector'
                list_validator(SpecRefLib::Helpers.ret_value, nil, type, category)
                SpecRefLib::Helpers.clear
                show_menu
            end
        end
        # rubocop:enable Metrics/MethodLength

        # rubocop:disable Metrics/MethodLength
        def list_validator(value, array, type, category)
            if value == 'q'
                SpecRefLib::Helpers.clear
                SpecRefLib::Helpers.log 'Good Bye'
                return SpecRefLib::Helpers.leave
            end

            # rubocop:disable Style/SoleNestedConditional
            if array && value.to_i < array.length + 1
                return value.to_i unless value.to_i.zero?
            end
            # rubocop:enable Style/SoleNestedConditional

            return false unless array

            SpecRefLib::Helpers.log 'Wrong value'
            get_input(type, category)
        end
        # rubocop:enable Metrics/MethodLength
    end
end
