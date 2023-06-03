$('<input/>', {
    type: 'button',
    onclick: 'openShowRunCommandDialog()',
    value: 'Show Run Command',
    style: 'display:none'
}).insertAfter('div.content > input:last');

function openShowRunCommandDialog() {
    alert("Works!");
}