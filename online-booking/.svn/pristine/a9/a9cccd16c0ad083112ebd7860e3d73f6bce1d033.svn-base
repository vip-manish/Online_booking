

function validEmail(email) {
    const regex = /^((?!\.)[\w\-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$/;
    return regex.test(email);
}
 Toast = Swal.mixin({
    toast: true,
    position: 'top-end',
    showConfirmButton: false,
    timer: 5000,
    timerProgressBar: true,
    didOpen: (toast) => {
        toast.addEventListener('mouseenter', Swal.stopTimer)
        toast.addEventListener('mouseleave', Swal.resumeTimer)
    }
})



function logOut() {

    $.ajax({
        url: '/api/AuthController/logOut',
        type: 'GET',
        contentType: 'application/json',
        success: function (data) {
            if (data.success) {
                window.location.replace("../Index")
            }
            else {
                ErrorMessage(data.message);
            }
        }


    })
}
   


function SuccessMessage(text) {
    Toast.fire({
        icon: 'success',
        title: 'Hurray!',
        text: text,
    })
}

function ErrorMessage( text) {
    Toast.fire({
        icon: 'error',
        title: 'oops!',
        text: text,
    })
}






