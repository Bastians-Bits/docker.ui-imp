$('<input/>', {
    type: 'button',
    onclick: 'void',
    value: 'Test',
    style: 'display:none'
}).insertBefore('div.content > input:first-of-type');