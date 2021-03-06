$(function () {

    $(function () {
        $.ajax({
            url: '/organization_units/load_tree',
            success: function(response){
                $('#member_organization_tree').treeview({
                    data: response,
                    levels: 0,
                    onNodeSelected: function (event, data) {
                        $('#person_organization_unit_id').val(data.id)
                    }
                });
            }
        });

    });

    $.ajax({
        url: '/organization_units/load_tree',
        success: function(response){
            $('#person_tree').treeview({
                data: response,
                levels: 2,
                onNodeSelected: function (event, data) {
                    $.ajax({
                        url:'/people/load_people',
                        data: { node: data.id},
                        success: function (response) {
                            $('#people').html(response)
                            $('.js-exportable').DataTable({
                                dom: 'lrBfrtip',
                                responsive: true,
                                buttons: [
                                    'copy', 'csv', 'excel', 'pdf', 'print'
                                ]
                            });
                        }
                    })
                }
            });
        }
    });

    $.ajax({
        url: '/organization_units/load_tree',
        success: function(response){
            $('#members_paid_tree').treeview({
                data: response,
                levels: 2,
                onNodeSelected: function (event, data) {
                    $.ajax({
                        url:'/people/load_members_paid',
                        data: { node: data.id},
                        success: function (response) {
                            $('#members_paid').html(response)
                            $('.js-exportable').DataTable({
                                dom: 'lrBfrtip',
                                responsive: true,
                                buttons: [
                                    'copy', 'csv', 'excel', 'pdf', 'print'
                                ]
                            });
                        }
                    })
                }
            });
        }
    });

    $.ajax({
        url: '/organization_units/load_tree',
        success: function(response){
            $('#members_not_paid_tree').treeview({
                data: response,
                levels: 2,
                onNodeSelected: function (event, data) {
                    $.ajax({
                        url:'/people/load_members_not_paid',
                        data: { node: data.id},
                        success: function (response) {
                            $('#members_not_paid').html(response)
                            $('.js-exportable').DataTable({
                                dom: 'lrBfrtip',
                                responsive: true,
                                buttons: [
                                    'copy', 'csv', 'excel', 'pdf', 'print'
                                ]
                            });
                        }
                    })
                }
            });
        }
    });

    $("#person_profession_category_id").change(function(){
        var profession_category = $(this).val();
        $.ajax({
            url: '/people/load_professions',
            data: { profession_category: profession_category},
            cache: true,
            async: false,
            beforeSend: function(){
                $("#profession_loading_indicator").show();
            },
            error: function(){
                $("#profession_loading_indicator").hide();
            },
            success: function(response){
                $('#professions_display').html(response);
                $("#profession_loading_indicator").hide();
            }
        });
    });

    $('#profession_loading_indicator').hide();
});