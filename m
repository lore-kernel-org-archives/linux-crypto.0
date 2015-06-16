From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v6 1/3] crypto: add PKE API
Date: Tue, 16 Jun 2015 16:19:25 +0800
Message-ID: <20150616081925.GA23347@gondor.apana.org.au>
References: <20150616080153.447.83834.stgit@tstruk-mobl1>
 <20150616080159.447.30041.stgit@tstruk-mobl1>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:54993 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbbFPIUF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 04:20:05 -0400
Content-Disposition: inline
In-Reply-To: <20150616080159.447.30041.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 16, 2015 at 01:01:59AM -0700, Tadeusz Struk wrote:
>
> @@ -28,6 +28,7 @@ crypto_hash-y += shash.o
>  obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
>  
>  obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
> +obj-$(CONFIG_CRYPTO_AKCIPHER) += akcipher.o

s/AKCIPHER/AKCIPHER2/

> +/**
> + * struct akcipher_request - public key request
> + *
> + * @base:	Common attributes for async crypto requests
> + * @src:	Pointer to memory containing the input parameters
> + *		The format of the parameter(s) is expeted to be Octet String
> + * @dst:	Pointer to memory whare the result will be stored
> + * @src_len:	Size of the input parameter
> + * @dst_len:	Size of the output buffer. It needs to be at leaset
> + *		as big as the expected result depending	on the operation
> + *		After operation it will be updated with the acctual size of the
> + *		result. In case of error, where the dst_len was insufficient,
> + *		it will be updated to the size required for the operation.
> + * @result_len: If not NULL this will be updated by the implementation to
> + *		reflect the acctual size of the result

result_len is still here.

> + * @__ctx:	Start of private context data
> + */
> +struct akcipher_request {
> +	struct crypto_async_request base;
> +	void *src;
> +	void *dst;
> +	unsigned int src_len;
> +	unsigned int *dst_len;

dst_len doesn't need to be a pointer.  A simple int will do.

> +static inline int crypto_akcipher_encrypt(struct akcipher_request *req)
> +{
> +	struct crypto_akcipher *tfm = __crypto_akcipher_tfm(req->base.tfm);

You should add a reqtfm helper like crypto_aead_reqtfm so that
implementors don't need to do this ugly __crypto_akcipher_tfm.

In fact you already have that helper so you just need to use it.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
