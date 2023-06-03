$('<input/>', {
    type: 'button',
    onclick: 'void',
    value: 'Test',
    style: 'display:none'
}).insertBefore('div.content > input:last-of-type');