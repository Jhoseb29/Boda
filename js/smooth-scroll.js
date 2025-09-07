document.addEventListener('DOMContentLoaded', function() {
    // Configuración del scroll suave para enlaces internos
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        // Verifica que el enlace no sea solo '#'
        if (anchor.getAttribute('href') !== '#') {
            anchor.addEventListener('click', function(e) {
                e.preventDefault();
                const targetId = this.getAttribute('href');
                const targetElement = document.querySelector(targetId);
                
                if (targetElement) {
                    // Calcula la posición del elemento objetivo
                    const headerOffset = 80; // Ajusta según la altura de tu header
                    const elementPosition = targetElement.getBoundingClientRect().top;
                    const offsetPosition = elementPosition + window.pageYOffset - headerOffset;

                    // Efecto de scroll suave
                    window.scrollTo({
                        top: offsetPosition,
                        behavior: 'smooth'
                    });
                }
            });
        }
    });

    // Efecto de revelación al hacer scroll
    const revealElements = document.querySelectorAll('.reveal');
    
    function checkIfInView() {
        const windowHeight = window.innerHeight;
        const revealPoint = 150; // Píxeles desde la parte superior para activar la animación

        revealElements.forEach(element => {
            const elementTop = element.getBoundingClientRect().top;
            
            if (elementTop < windowHeight - revealPoint) {
                element.classList.add('active');
            }
        });
    }

    // Verificar elementos al cargar la página
    window.addEventListener('load', checkIfInView);
    // Verificar elementos al hacer scroll
    window.addEventListener('scroll', checkIfInView);
});
