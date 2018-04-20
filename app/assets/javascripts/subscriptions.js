document.addEventListener("turbolinks:load", function() {
  const publishableKey = document.querySelector("meta[name='stripe-key']").getAttribute('content');
  const stripe = Stripe(publishableKey);
  const elements = stripe.elements({
    fonts: [
      {
        cssSrc: "https://rsms.me/inter/inter-ui.css"
      }
    ],
    // Stripe's examples are localized to specific languages, but if
    // you wish to have Elements automatically detect your user's locale,
    // use `locale: 'auto'` instead.
    locale: window.__exampleLocale
  });

    // Custom styling can be passed to options when creating an Element.
  const style = {
      base: {
        color: "#32325D",
        fontWeight: 500,
        fontFamily: "Inter UI, Open Sans, Segoe UI, sans-serif",
        fontSize: "16px",
        fontSmoothing: "antialiased",

        "::placeholder": {
          color: "#CFD7DF"
        }
      },
      invalid: {
        color: "#E25950"
    }
  };

  // Create an instance of the card Element.
  const card = elements.create('card', {style});

  // Add an instance of the card Element into the `card-element` <div>.
  card.mount('#card-element');

  card.addEventListener('change', ({error}) => {

  const displayError = document.getElementById('card-errors');
    if (error) {
      displayError.textContent = error.message;
    } else {
      displayError.textContent = '';
    }
  });

  // Create a token or display an error when the form is submitted.
  const form = document.getElementById('payment-form');
  form.addEventListener('submit', async (event) => {
    event.preventDefault();

    const {token, error} = await stripe.createToken(card);

    if (error) {
      // Inform the customer that there was an error.
      const errorElement = document.getElementById('card-errors');
      errorElement.textContent = error.message;
    } else {
      // Send the token to your server.
      stripeTokenHandler(token);
    }
  });

  const stripeTokenHandler = (token) => {
  // Insert the token ID into the form so it gets submitted to the server
  const form = document.getElementById('payment-form');
  const hiddenInput = document.createElement('input');
  hiddenInput.setAttribute('type', 'hidden');
  hiddenInput.setAttribute('name', 'stripeToken');
  hiddenInput.setAttribute('value', token.id);
  form.appendChild(hiddenInput);

  // Submit the form
  form.submit();
}

});