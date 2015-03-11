$(document).ready(function(event) {

    $('#header').scrollToFixed();
    $('#topic-livefilter-list').liveFilter('#topic-livefilter-input', 'li', {
        filterChildSelector: 'a'
    });

    $('#topic-livefilter-input').keydown(function (e){
        if ( $('#topic-livefilter-input').val().length > 0 ) {
            var href = $('#topic-livefilter-list').find('.item:visible a').attr('href');
            if( (e.keyCode == 13) && (href) ){
              window.location.replace(href);
            }
        }
    });

    $('.ui.dropdown').dropdown();
    $('.ui.radio.checkbox').checkbox();
    $('.ui.checkbox').checkbox();
    $('.ui.accordion').accordion();
    $('.ui.modal').modal('hide');
    $('.ui.menu_popup').popup({
        position: "right center",
        onVisible: function(){
          $('.nav .ui.popup.visible').css({'text-transform': 'capitalize','color':'#555'});
        }
    });


    // Timezone Setting
    var timeZone = jstz.determine();
    document.cookie = 'jstz_time_zone='+timeZone.name()+';';

    $('#archive_button .create_archive').click(function(e){
        e.preventDefault();

        var title = $('#post_form input.title').val(),
            body = $('#post_form textarea.body').val(),
            board_id = $('#post_form #post_board_id').val(),
            allow_comment = $('#post_form .allow_comment').val(),
            publication = $('#post_form input[name="post[publication]"]:checked').val(),
            tag_list = $('#post_form #post_tag_list').val(),
            attachment_token = $('#post_form .attachment_token').val();

        $.ajax({
            url: '/archives',
            method: 'POST',
            dataType: 'json',
            data: { title: title, body: body, board_id: board_id, allow_comment: allow_comment, publication: publication, tag_list: tag_list, attachment_token: attachment_token }
        })
            .success(function(result){
                $("#archive_button .archives_count").replaceWith("<span class='archives_count'>" + result.archives_count + "</span>");
                var flash = '<div class="ui blue message floating">'+ result.message +'</div>';
                $("body").append(flash);
                setTimeout(function(){
                    $('.ui.message').fadeOut(500, function(){ $(this).remove(); });
                }, 5000);

            })
            .error(function(response){
                var result = $.parseJSON(response.responseText),
                    flash = '<div class="ui red message floating">'+
                        '<ul class="list">'+
                        '<li>'+ result.message +'</li>'+
                        '</ul>'+
                        '</div>';
                $("body").append(flash);
                setTimeout(function(){
                    $('.ui.message').fadeOut(500, function(){ $(this).remove(); });
                }, 5000);
            });
    });

    $('.dropzone').click(function(e){
        $('#fileupload').trigger('click');
    });


});

$(function () {
  $('#fileupload').fileupload({

        url: '/attachments/file_upload',
        dataType: 'json',
        type: 'POST',
        paramName: 'file',
        autoUpload: false,
        formData: { attachment_token: $('.attachment_token').val() },
        dropZone: $('.dropzone'),
        // The regular expression for allowed file types, matches
        // against either file type or file name:
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png|bmp|tif|pdf|html|mp4|mkv|avi|flv|wmv|asf|mpg|mp2|mpeg|mpe|mpv|m4v|3gp|3g2|mov|ogg|ogv|webm|m3u|mp3|mmf|m4p|wma|zip|pptx|smi|srt|psb|sami|ssa|sub|smil|usf|vtt|txt)$/i,
        // The maximum allowed file size in bytes:
        maxFileSize: 20000000, // 1 MB = 1000KB * 1000Bytes = 1000000Bytes
        // The minimum allowed file size in bytes:
        minFileSize: undefined, // No minimal file size
        // The limit of files to be uploaded:
        maxNumberOfFiles: 20,
        add: function (e,data) {

            var acceptFileTypes = /(\.|\/)(gif|jpe?g|png|bmp|tif|pdf|html|mp4|mkv|avi|flv|wmv|asf|mpg|mp2|mpeg|mpe|mpv|m4v|3gp|3g2|mov|ogg|ogv|webm|m3u|mp3|mmf|m4p|wma|zip|pptx|smi|srt|psb|sami|ssa|sub|smil|usf|vtt|txt)$/i,
                maxFileSize = 20000000;
                upload_validation = true;
                file_validation_errors = {};

            $.each(data.files, function(index, file){
                if ( !(acceptFileTypes.test(file.type) || acceptFileTypes.test(file.name)) ){
                    file_validation_errors.file_size = file.size;
                    file_validation_errors.file_type = file.type;
                    file_validation_errors.file_name = file.name;
                    file_validation_errors.reason = "type";
                    upload_validation = false;
                }
                if (file.size > maxFileSize) {
                    file_validation_errors.file_size = file.size;
                    file_validation_errors.file_type = file.type;
                    file_validation_errors.file_name = file.name;
                    file_validation_errors.reason = "size";
                    upload_validation = false;
                }

                if (upload_validation === true){
                    data.submit();
                }
            });

            if (!upload_validation){
                $.ajax({
                    url: '/attachments/error_messages',
                    dataType: 'html',
                    data: { error_messages: file_validation_errors },
                    type: 'POST'
                }).done(function(result){
                    result = $.parseJSON(result);

                    var ui_message = $('.ui.message');

                    if (ui_message.length) {
                        var flash_add = '<li>'+ result.message +'</li>';
                        $('.ui.message .list').append(flash_add);
                    } else {
                        var flash_new = '<div class="ui red message floating">'+
                            '<ul class="list">'+
                            '<li>'+ result.message +'</li>'+
                            '</ul>'+
                            '</div>';
                        $("body").append(flash_new);
                    }

                });

                setTimeout(function(){
                    $('.ui.message').fadeOut(500, function(){ $(this).remove(); });
                }, 5000);
            }

        },
        error: function (e, data) {
            $('#progress .progress-bar').css('width', '0px');
            $('#progress').css('display', 'none');
        },
        done: function (e, data) {

            $.each(data.files, function(i, val){

                 $.ajax({
                    url: '/attachments/file_locale',
                    dataType: 'html',
                    data: { id: data.result.id },
                    type: 'POST'
                }).done(function(result){
                     $('.filelists .filelist .content').append(result);
                 });
            });

            $('#progress .progress-bar').css('width', '0px');
            $('#progress').css('display', 'none');

        },
        progressall: function (e, data) {
            var progress = parseInt(data.loaded / data.total * 100, 10);
            $('#progress').css('display', 'block');
            $('#progress .progress-bar').css(
                'width',
                progress + '%'
            );
        }
  }).prop('disabled', !$.support.fileInput).parent().addClass($.support.fileInput ? undefined : 'disabled');
});
