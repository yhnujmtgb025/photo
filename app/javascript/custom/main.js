
$(document).ready(function () {

  uploadImage();  
  function uploadImage() {
    var count = 0
    var button = $('.images .pic')
    var uploader = $('<input type="file" accept="image/*" />')
    var images = $('.images')
    
    button.on('click', function () {
      uploader.click()
    })
    
    uploader.on('change', function () {
        var reader = new FileReader()
        reader.onload = function(event) {
          if(images.hasClass('one-photo') && !images.hasClass('img') && count < 1)
          {
            images.prepend('<div class="img" style="background-image: url(\'' + event.target.result + '\');" rel="'+ event.target.result  +'"><span>remove</span></div>')
            $('.images .pic').css('display','none')
            count+=1;
          }
          else if(images.hasClass('one-album'))
          {
            images.prepend('<div class="img" style="background-image: url(\'' + event.target.result + '\');" rel="'+ event.target.result  +'"><span>remove</span></div>')
          }
      
        }
        reader.readAsDataURL(uploader[0].files[0])
      
    })
    
    images.on('click', '.img', function () {
      if(images.hasClass('one-photo'))
      {
        count=0;
        $('.images .pic').css('display','block')
      }
      $(this).remove()
    })
  
  }
})
