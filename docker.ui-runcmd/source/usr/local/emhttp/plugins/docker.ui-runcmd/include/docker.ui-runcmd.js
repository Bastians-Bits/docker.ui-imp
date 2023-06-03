$('<input/>', {
    type: 'button',
    onclick: 'addFolder("docker")',
    value: 'Test',
    style: 'display:none'
}).insertBefore('div.content > input:first-of-type');