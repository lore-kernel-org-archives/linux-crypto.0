From: Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: [PATCH 4/7] crypto: doc - fix separation of cipher / req API
Date: Mon, 17 Oct 2016 14:04:14 +0300
Message-ID: <87h98btexd.fsf@intel.com>
References: <2721226.4nLlHD9uQ6@positron.chronox.de> <5908263.2TLWr89bHl@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>, herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58052 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932761AbcJQLER (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Oct 2016 07:04:17 -0400
In-Reply-To: <5908263.2TLWr89bHl@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 16 Oct 2016, Stephan Mueller <smueller@chronox.de> wrote:
> Keep the cipher API and the request API function documentation in
> separate sections.
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  Documentation/crypto/api-akcipher.rst | 25 +++++++++++++------------
>  1 file changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/Documentation/crypto/api-akcipher.rst b/Documentation/crypto/api-akcipher.rst
> index 305e616..0d5899f 100644
> --- a/Documentation/crypto/api-akcipher.rst
> +++ b/Documentation/crypto/api-akcipher.rst
> @@ -25,32 +25,32 @@ Asymmetric Cipher API
>  .. kernel-doc:: include/crypto/akcipher.h
>     :functions: crypto_akcipher_set_priv_key
>  
> -Asymmetric Cipher Request Handle
> ---------------------------------
> -
>  .. kernel-doc:: include/crypto/akcipher.h
> -   :functions: akcipher_request_alloc
> +   :functions: crypto_akcipher_maxsize
>  
>  .. kernel-doc:: include/crypto/akcipher.h
> -   :functions: akcipher_request_free
> +   :functions: crypto_akcipher_encrypt
>  
>  .. kernel-doc:: include/crypto/akcipher.h
> -   :functions: akcipher_request_set_callback
> +   :functions: crypto_akcipher_decrypt
>  
>  .. kernel-doc:: include/crypto/akcipher.h
> -   :functions: akcipher_request_set_crypt
> +   :functions: crypto_akcipher_sign
>  
>  .. kernel-doc:: include/crypto/akcipher.h
> -   :functions: crypto_akcipher_maxsize
> +   :functions: crypto_akcipher_verify

The directive parameter is plural functions for a reason - you can
specify multiple functions in the same directive. Splitting this to
multiple directives causes the header file to be parsed again for each
directive.

IMO this can be fixed in a follow-up patch. Same for other patches in
this series.

BR,
Jani.


> +
> +Asymmetric Cipher Request Handle
> +--------------------------------
>  
>  .. kernel-doc:: include/crypto/akcipher.h
> -   :functions: crypto_akcipher_encrypt
> +   :functions: akcipher_request_alloc
>  
>  .. kernel-doc:: include/crypto/akcipher.h
> -   :functions: crypto_akcipher_decrypt
> +   :functions: akcipher_request_free
>  
>  .. kernel-doc:: include/crypto/akcipher.h
> -   :functions: crypto_akcipher_sign
> +   :functions: akcipher_request_set_callback
>  
>  .. kernel-doc:: include/crypto/akcipher.h
> -   :functions: crypto_akcipher_verify
> +   :functions: akcipher_request_set_crypt

-- 
Jani Nikula, Intel Open Source Technology Center
