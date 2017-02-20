require "../lib/libui/src/libui.cr"

class RiskCalculator
  def initialize
    o = UI::InitOptions.new
    err = UI.init pointerof(o)
    if !ui_nil?(err)
      puts "error initializing ui: #{err}"
      exit 1
    end

    # Main window
    top_components = CUI.inflate File.join(__DIR__, "main.yml")

    # Add scrolling log boxes manually
    atk_log = UI.multiline_entry
    UI.multiline_entry_set_read_only atk_log, 1
    UI.box_append CUI.get!("log_box").as UI::Box*, ui_control(atk_log), 1

    UI.box_append CUI.get!("log_box").as UI::Box*, ui_control(UI.new_horizontal_separator), 0

    dfn_log = UI.multiline_entry
    UI.multiline_entry_set_read_only dfn_log, 1
    UI.box_append CUI.get!("log_box").as UI::Box*, ui_control(dfn_log), 1

    # Hack to avoid flicker
    top_components.each do |component|
      UI.control_show ui_control component.component
    end

    # Callbacks
    UI.on_should_quit ->(data : Void*) {
      UI.control_destroy ui_control CUI.get_mainwindow!
      1
    },
      nil

    UI.window_on_closing CUI.get_mainwindow!,
      ->(w : UI::Window*, data : Void*) {
        UI.control_destroy ui_control CUI.get_mainwindow!
        UI.quit
        0
      },
      nil

    UI.spinbox_on_changed CUI.get!("attack_count").as UI::Spinbox*,
      ->(s: UI::Spinbox*, data: Void*) {update_tide_bar}, nil
    UI.spinbox_on_changed CUI.get!("defend_count").as UI::Spinbox*,
      ->(s: UI::Spinbox*, data: Void*) {update_tide_bar}, nil
    
    UI.button_on_clicked CUI.get!("fight_btn").as UI::Button*,
      ->(s: UI::Button*, data: Void*) {do_round data.as(Array(Pointer(UI::MultilineEntry) | Nil))}, Pointer(Void).new([atk_log, dfn_log].object_id)
    
    UI.button_on_clicked CUI.get!("clear_btn").as UI::Button*,
      ->(s: UI::Button*, data: Void*) {clear_log data.as(Array(Pointer(UI::MultilineEntry) | Nil))}, Pointer(Void).new([atk_log, dfn_log].object_id)

    UI.main
    UI.uninit
  end

  # Helper
  macro update_tide_bar
    atk = UI.spinbox_value CUI.get!("attack_count").as UI::Spinbox*
    dfn = UI.spinbox_value CUI.get!("defend_count").as UI::Spinbox*
    value = atk > 0 || dfn > 0 ? (atk * 100 / (atk + dfn)) : -1
    UI.progress_bar_set_value CUI.get!("tide_bar").as(UI::ProgressBar*), value
  end

  macro log_append(log, string)
    #NOTE# I would prefer to append to the end of the log, rather than the beginning, but the 
    #      Crystal bindings for libui don't give me a way to scroll the text box to bring the most
    #      recent log entries into view, so I'm doing this as a work around.
    UI.multiline_entry_set_text {{log}}, ("#{{{string}}}\n" + String.new(UI.multiline_entry_text {{log}})).bytes
  end

  macro do_round(data)
    _atk_log = {{data}}[0]
    _dfn_log = {{data}}[1]
    atk_box = CUI.get!("attack_count").as UI::Spinbox*
    dfn_box = CUI.get!("defend_count").as UI::Spinbox*
    atk = (Math.min (UI.spinbox_value atk_box), 4) - 1
    if atk < 1
      log_append _atk_log, "Not enough attackers"
      log_append _dfn_log, ""
      return
    end
    dfn = Math.min (UI.spinbox_value dfn_box), 2
    if dfn < 1
      log_append _atk_log, "You've already won"
      log_append _dfn_log, ""
      return
    end

    atk_roll = Array.new(atk) {|x| {(rand 6), 'a'}}.sort
    log_append _atk_log, atk_roll
    dfn_roll = Array.new(dfn) {|x| {(rand 6), 'd'}}.sort
    log_append _dfn_log, dfn_roll
    results = (atk_roll + dfn_roll).sort.last(Math.min atk, dfn).reduce({0, 0}) {|a, x| x[1] == 'a' ? {a[0] + 1, a[1]} : {a[0], a[1] + 1}}

    log_append _atk_log, "Lost #{results[1]} unit(s)"
    log_append _dfn_log, "Lost #{results[0]} unit(s)"
    UI.spinbox_set_value atk_box, (UI.spinbox_value atk_box) - results[1]
    UI.spinbox_set_value dfn_box, (UI.spinbox_value dfn_box) - results[0]

    update_tide_bar
  end

  macro clear_log(data)
    _atk_log = {{data}}[0]
    _dfn_log = {{data}}[1]

    UI.multiline_entry_set_text _atk_log, ""
    UI.multiline_entry_set_text _dfn_log, ""
  end

end

RiskCalculator.new