From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v5 2/4] crypto: add PKE API
Date: Tue, 16 Jun 2015 07:50:47 +0800
Message-ID: <20150615235047.GA16562@gondor.apana.org.au>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1>
 <20150615201842.15697.59701.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51706 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbFOXu5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 19:50:57 -0400
Content-Disposition: inline
In-Reply-To: <20150615201842.15697.59701.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 01:18:42PM -0700, Tadeusz Struk wrote:
>
> +/**
> + * crypto_register_akcipher() -- Register public key algorithm
> + *
> + * Function registers an implementation of a public key verify algorithm
> + *
> + * @alg:	algorithm definition
> + *
> + * Return: zero on success; error code in case of error
> + */
> +int crypto_register_akcipher(struct akcipher_alg *alg);
> +
> +/**
> + * crypto_unregister_akcipher() -- Unregister public key algorithm
> + *
> + * Function unregisters an implementation of a public key verify algorithm
> + *
> + * @alg:	algorithm definition
> + */
> +void crypto_unregister_akcipher(struct akcipher_alg *alg);

These two functions and anything else that's specific to public key
implementors should go into crypto/internal.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
