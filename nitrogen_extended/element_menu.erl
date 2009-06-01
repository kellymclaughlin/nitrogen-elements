-module (element_menu).
-compile(export_all).

-include_lib("lib/nitrogen/include/wf.inc").
-record(menu, {?ELEMENT_BASE(element_menu), trigger="click", text="", body=[]}).

% desc: Provides a collapsable menu. The menu options are specified
% as listitem elements in the body. 

reflect() -> record_info(fields, menu).

render(ControlID, Record) -> 
    Script = case Record#menu.trigger of
        "hover" ->
            wf:f("$('#~s ul').hide();~n$('#~s li a').hover(~nfunction() {~n$(this).next().slideToggle('normal');~n}~n);", [ControlID, ControlID]);
        _ ->
            wf:f("$('#~s ul').hide();~n$('#~s li a').click(~nfunction() {~n$(this).next().slideToggle('normal');~n}~n);", [ControlID, ControlID])
    end,
	wf:wire(Script),
    Title = wf:render(Record#menu.text),
	Content = wf:render(Record#menu.body),
	wf_tags:emit_tag(ul, 
        wf_tags:emit_tag(li, 
        Title++wf_tags:emit_tag(ul, Content, []),
        []),
        [
            {id, ControlID},
            {class, Record#menu.class},
            {style, Record#menu.style}
        ]
    ).
    
