# frozen_string_literal: true

require 'json'
require_relative './version'

module SpecRefLib
    # Class to build the selection menu
    class Menu
        def initialize
            clear
            dir = File.dirname(__FILE__)
            @json = JSON.parse(File.read("#{dir}/specr.json"))
            show_menu
        end

        def clear
            system 'clear'
        end

        def log(str)
            puts str
        end

        def ret_value
            gets.chomp
        end

        def show_menu
            log "Spec-ref-lib version #{SpecRefLib::Version.version}"
            log ''

            @json['categories'].each_with_index do |category, index|
                log "\t#{index + 1}. #{category['name']}"
            end

            get_input('list_selector', @json)
        end

        def show_sub_menu(menu, name)
            log name
            log ''

            menu.each_with_index do |category, index|
                log "\t#{index + 1}. #{category['name']}"
            end

            get_input('sub_list_selector', menu)
        end

        def show_example(example)
            log example
            get_input('end_list_selector', nil)
        end

        # rubocop:disable Metrics/MethodLength
        def get_input(type, category)
            case type
            when 'list_selector'
                value = list_validator(ret_value, category['categories'], type, category)
                menu = category['categories'][value - 1]
                sub_name = menu['name']
                sub_menu = menu['categories']
                clear
                show_sub_menu(sub_menu, sub_name)
            when 'sub_list_selector'
                value = list_validator(ret_value, category, type, category)
                menu = category[value - 1]
                sub_example = menu['example']
                clear
                show_example(sub_example)
            when 'end_list_selector'
                list_validator(ret_value, nil, type, category)
                clear
                show_menu
            end
        end
        # rubocop:enable Metrics/MethodLength

        # rubocop:disable Metrics/MethodLength
        def list_validator(value, array, type, category)
            if value == 'q'
                clear
                log 'Good Bye'
                exit
            end

            # rubocop:disable Style/SoleNestedConditional
            if array && value.to_i < array.length + 1
                return value.to_i unless value.to_i.zero?
            end
            # rubocop:enable Style/SoleNestedConditional

            return unless array

            log 'Wrong value'
            get_input(type, category)
        end
        # rubocop:enable Metrics/MethodLength
    end
end
