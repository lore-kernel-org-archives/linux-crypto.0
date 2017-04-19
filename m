From: "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
Subject: RE: [PATCH 4/8] crypto: KPP - add API crypto_kpp_set_params
Date: Wed, 19 Apr 2017 14:51:54 +0000
Message-ID: <309B30E91F5E2846B79BD9AA9711D031AC232A@IRSMSX102.ger.corp.intel.com>
References: <2715753.J0rCo2lbig@positron.chronox.de>
 <4927943.K0bBmtyjOX@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "Benedetto, Salvatore" <salvatore.benedetto@intel.com>
To: =?iso-8859-1?Q?Stephan_M=FCller?= <smueller@chronox.de>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:17354 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935777AbdDSOwG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 10:52:06 -0400
In-Reply-To: <4927943.K0bBmtyjOX@positron.chronox.de>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

> -----Original Message-----
> From: keyrings-owner@vger.kernel.org [mailto:keyrings-
> owner@vger.kernel.org] On Behalf Of Stephan Müller
> Sent: Wednesday, April 19, 2017 12:06 AM
> To: linux-crypto@vger.kernel.org
> Cc: keyrings@vger.kernel.org
> Subject: [PATCH 4/8] crypto: KPP - add API crypto_kpp_set_params
> 
> KPP mechanisms like DH require a parameter set to be provided by the caller.
> That parameter set may be provided by the crypto_kpp_set_secret function.
> Yet, the parameters hare handled independently from the secret key which
> implies that they should be able to be set independently from the key.
> 
> The new API allows KPP mechanisms to register a callback allowing to set
> such parameters.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  Documentation/crypto/api-kpp.rst |  2 +-
>  include/crypto/kpp.h             | 28 ++++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/crypto/api-kpp.rst b/Documentation/crypto/api-
> kpp.rst
> index 7d86ab9..7b2c0d4 100644
> --- a/Documentation/crypto/api-kpp.rst
> +++ b/Documentation/crypto/api-kpp.rst
> @@ -11,7 +11,7 @@ Key-agreement Protocol Primitives (KPP) Cipher API
>     :doc: Generic Key-agreement Protocol Primitives API
> 
>  .. kernel-doc:: include/crypto/kpp.h
> -   :functions: crypto_alloc_kpp crypto_free_kpp crypto_kpp_set_secret
> crypto_kpp_generate_public_key crypto_kpp_compute_shared_secret
> crypto_kpp_maxsize
> +   :functions: crypto_alloc_kpp crypto_free_kpp crypto_kpp_set_params
> + crypto_kpp_set_secret crypto_kpp_generate_public_key
> + crypto_kpp_compute_shared_secret crypto_kpp_maxsize
> 
>  Key-agreement Protocol Primitives (KPP) Cipher Request Handle
>  -------------------------------------------------------------
> diff --git a/include/crypto/kpp.h b/include/crypto/kpp.h index
> ce8e1f7..5931364 100644
> --- a/include/crypto/kpp.h
> +++ b/include/crypto/kpp.h
> @@ -51,6 +51,9 @@ struct crypto_kpp {
>  /**
>   * struct kpp_alg - generic key-agreement protocol primitives
>   *
> + * @set_params:	Function allows the caller to set the parameters
> + *			separately from the key. The format of the
> parameters
> + *			is protocol specific.
>   * @set_secret:		Function invokes the protocol specific
> function to
>   *			store the secret private key along with parameters.
>   *			The implementation knows how to decode thie
> buffer
> @@ -74,6 +77,8 @@ struct crypto_kpp {
>   * @base:		Common crypto API algorithm data structure
>   */
>  struct kpp_alg {
> +	int (*set_params)(struct crypto_kpp *tfm, const void *buffer,
> +			  unsigned int len);
>  	int (*set_secret)(struct crypto_kpp *tfm, const void *buffer,
>  			  unsigned int len);
>  	int (*generate_public_key)(struct kpp_request *req); @@ -259,6
> +264,29 @@ struct kpp_secret {  };
> 
>  /**
> + * crypto_kpp_set_params() - Set parameters needed for kpp operation
> + *
> + * Function invokes the specific kpp operation for a given alg.
> + *
> + * @tfm:	tfm handle
> + * @buffer:	Buffer holding the protocol specific representation of the
> + *		parameters (e.g. PKCS#3 DER for DH)
> + * @len:	Length of the parameter buffer.
> + *
> + * Return: zero on success; error code in case of error  */ static
> +inline int crypto_kpp_set_params(struct crypto_kpp *tfm,
> +				        const void *buffer, unsigned int len) {
> +	struct kpp_alg *alg = crypto_kpp_alg(tfm);
> +
> +	if (alg->set_params)
> +		return alg->set_params(tfm, buffer, len);
> +	else
> +		return -EOPNOTSUPP;
> +}
> +
> +/**
>   * crypto_kpp_set_secret() - Invoke kpp operation
>   *
>   * Function invokes the specific kpp operation for a given alg.
> --
> 2.9.3

I'm not really in favor of having two ways for setting the params.
As you are probably aware, PKCS3 and set_params was my intial
approach, but then Herbert suggested a lighter approach like rtnetlink
which I actually prefer.

Can't you expose that through AF_ALG?

Regards,
Salvatore
