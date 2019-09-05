OSCAR.UsersIndex = do ->
  _init = ->
    _initDataTable()

  _initDataTable = ->
    $('table.users thead tr').clone(true).appendTo 'table.users thead'
    search   = $('#search-translate').text()
    next     = $('#next-translate').text()
    previous = $('#previous-translate').text()
    $('table.users thead tr:eq(1) th').each (i) ->
      title = $(@).text()
      $(@).html '<input type="text" />'
      $('input', @).on 'keyup change', ->
        if table.column(i).search() != @value
          table.column(i).search(@value).draw()
        return
      return

    # $('table.users thead tr th:last-child input').hide()

    table = $('table.users').DataTable(
      'dom': 'irtp'
      'bLengthChange': false
      'sAjaxSource': $('#users').data('source')
      'bAutoWidth': true
      'datawidth': '*'
      'orderCellsTop': true
      'fixedHeader': true
      'pageLength': 20

      'language':
          'search': search,
          'paginate': {
              previous: previous,
              next:     next
          },

    )
    setTimeout (->
      rows = $('#users-body > tr')
      $('td.manage-column').attr('align', 'center')
      $.each rows, (index, item) ->
        href = $($(item).find('td a')).attr('href')
        href = href.replace('?locale=en', '')
        $(item).attr('data-href', href)
        $($(item).find('a.edit-user-button')).attr('href', href + '/edit')
        $($(item).find('a.delete-user-button')).attr('href', href)
      ), 100


  {init: _init}
