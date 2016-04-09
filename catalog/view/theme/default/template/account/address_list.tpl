<?php echo $header; ?>
<script src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
<script type="text/javascript">
  $(document).ready(function(){

    /* Переменная-флаг для отслеживания того, происходит ли в данный момент ajax-запрос. В самом начале даем ей значение false, т.е. запрос не в процессе выполнения */
    var inProgress = false;
    /* С какой статьи надо делать выборку из базы при ajax-запросе */
    var startFrom = 5;

    /* Используйте вариант $('#more').click(function() для того, чтобы дать пользователю возможность управлять процессом, кликая по кнопке "Дальше" под блоком статей (см. файл index.php) */
    $(window).scroll(function() {

      /* Если высота окна + высота прокрутки больше или равны высоте всего документа и ajax-запрос в настоящий момент не выполняется, то запускаем ajax-запрос */
      if($(window).scrollTop() + $(window).height() >= $(document).height() - 200 && !inProgress) {

        var data = {
          "startFrom":startFrom
        };


        data = $(this).serialize() + "&" + $.param(data);
        //var data = startFrom;

        $.ajax({
          /* адрес файла-обработчика запроса */
          url: "http://op.com/index.php?route=account/address/index",
          /* метод отправки данных */
          method: 'POST',
          /* данные, которые мы передаем в файл-обработчик */
          data:{
            "startFrom":startFrom
          },
          /* что нужно сделать до отправки запрса */
          beforeSend: function() {
            /* меняем значение флага на true, т.е. запрос сейчас в процессе выполнения */
            inProgress = true;}
          /* что нужно сделать по факту выполнения запроса */
        }).done(function(data){



          /* Преобразуем результат, пришедший от обработчика - преобразуем json-строку обратно в массив */
          //data = jQuery.parseJSON(data);

          //data = jQuery.parseJSON(data);
          myData = JSON.parse(data, function (key,value) {
            var type;
            if (value && typeof value === 'object') {
              type = value.type;
              if (typeof type === 'string' && typeof window[type] === 'function') {
                //return new (window[type])(value);
                //alert(new (window[type])(value));
              }
            }
            //alert(value) ;
            if(key === "firstname"){
              $("#articles").append('<span class="label label-default">');
              $("#articles").append("<b>" + value + "</b> ");
            }
            if(key === "lastname"){
              $("#articles").append("<i>" + value + "</i> </br>");
                  $("#articles").append('</span>');
                }

          });


//alert(myData);



          //var o = JSON.parse(s);


          //var obj = jQuery.parseJSON(  data  );
          //alert(obj);
          //var data = JSON.parse(s);
          //var data = JSON.parse(data.toString());
//alert(obj);
          //alert(obj);

          /* Если массив не пуст (т.е. статьи там есть) */
          /*if (data.length > 0) {
            alert(data);

            /* Делаем проход по каждому результату, оказвашемуся в массиве,
             где в index попадает индекс текущего элемента массива, а в data - сама статья
            $.each(data, function(index, data){
alert(data.firstname);
              /* Отбираем по идентификатору блок со статьями и дозаполняем его новыми данными
              $("#articles").append("<p><b>" + data.firstname + "</b><br />" + data.lastname + "</p>");
            });*/

            /* По факту окончания запроса снова меняем значение флага на false */
            inProgress = false;
            // Увеличиваем на 10 порядковый номер статьи, с которой надо начинать выборку из базы
            startFrom += 5;
          });
      };
      });
    });
  //});

</script>

<div class="container">
  <ul class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
    <?php } ?>
  </ul>
  <?php if ($success) { ?>
  <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo $success; ?></div>
  <?php } ?>
  <?php if ($error_warning) { ?>
  <div class="alert alert-warning"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="row"><?php echo $column_left; ?>
    <?php if ($column_left && $column_right) { ?>
    <?php $class = 'col-sm-6'; ?>
    <?php } elseif ($column_left || $column_right) { ?>
    <?php $class = 'col-sm-9'; ?>
    <?php } else { ?>
    <?php $class = 'col-sm-12'; ?>
    <?php } ?>
    <div id="content" class="<?php echo $class; ?>"><?php echo $content_top; ?>
      <h2><?php echo $text_address_book; ?></h2>
      <?php if ($addresses) { ?>
      <table class="table table-bordered table-hover">
        <?php foreach ($addresses as $result) { ?>
        <tr>
          <td class="text-left"><?php echo $result['address']; ?></td>
          <td class="text-right"><a href="<?php echo $result['update']; ?>" class="btn btn-info"><?php echo $button_edit; ?></a> &nbsp; <a href="<?php echo $result['delete']; ?>" class="btn btn-danger"><?php echo $button_delete; ?></a></td>
        </tr>
        <?php } ?>
        <div  id="articles">
          <p><b>text</b><br />
        </div>

        <button id="more">Дальше</button>
      </table>
      <?php } else { ?>
      <p><?php echo $text_empty; ?></p>
      <?php } ?>



      <div class="buttons clearfix">
        <div class="pull-left"><a href="<?php echo $back; ?>" class="btn btn-default"><?php echo $button_back; ?></a></div>
        <div class="pull-right"><a href="<?php echo $add; ?>" class="btn btn-primary"><?php echo $button_new_address; ?></a></div>
      </div>
      <?php echo $content_bottom; ?></div>
    <?php echo $column_right; ?></div>
</div>
<?php echo $footer; ?>