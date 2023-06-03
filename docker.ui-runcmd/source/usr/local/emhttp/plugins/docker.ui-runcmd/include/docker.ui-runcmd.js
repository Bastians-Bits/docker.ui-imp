$('<input/>', {
    type: 'button',
    onclick: 'void',
    value: 'Test',
    style: 'display:none'
}).insertAfter('div.content > input:last');