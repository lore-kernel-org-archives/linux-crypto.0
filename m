From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v3 1/3] crypto: add PKE API
Date: Thu, 4 Jun 2015 14:49:29 +0800
Message-ID: <20150604064929.GA22158@gondor.apana.org.au>
References: <20150603224403.22310.79731.stgit@tstruk-mobl1>
 <20150603224408.22310.45114.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53959 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbbFDGtx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2015 02:49:53 -0400
Content-Disposition: inline
In-Reply-To: <20150603224408.22310.45114.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 03, 2015 at 03:44:08PM -0700, Tadeusz Struk wrote:
>
> +/**
> + * struct akcipher_alg - generic public key algorithm
> + *
> + * @sign:	Function performs a sign operation as defined by public key
> + *		algorithm
> + * @verify:	Function performs a sign operation as defined by public key
> + *		algorithm
> + * @encrypt:	Function performs an encrytp operation as defined by public key
> + *		algorithm
> + * @decrypt:	Function performs a decrypt operation as defined by public key
> + *		algorithm
> + * @reqsize:	Request context size required by algorithm implementation
> + * @base:	Common crypto API algorithm data structure
> + */
> +struct akcipher_alg {
> +	int (*sign)(struct akcipher_request *req);
> +	int (*verify)(struct akcipher_request *req);
> +	int (*encrypt)(struct akcipher_request *req);
> +	int (*decrypt)(struct akcipher_request *req);
> +
> +	unsigned int reqsize;
> +	struct crypto_alg base;
> +};

Because the caller is going to be allocating memory for the output,
we need to provide a way for them to know how much memory to
allocate.

This presumably will depend on the key size.

So something like

	int (*maxsize)(struct crypto_akcipher *tfm);

is needed.

You should also provide setkey here.  You can't just save a pointer
to the key.  The transform must hold the key physically as the
original may go away.  It should also ensure that the key is
actually valid for the transform.

> +/**
> + * struct crypto_akcipher - user-instantiated objects which encapsulate
> + * algorithms and core processing logic
> + *
> + * @base:	Common crypto API algorithm data structure
> + * @pkey:	Key representation. Note: this can be both public or private
> + *		key, depending on the operation.
> + * @__ctx:	Start of private context data
> + */
> +struct crypto_akcipher {
> +	struct crypto_tfm base;
> +	const struct public_key *pkey;
> +	void *__ctx[] CRYPTO_MINALIGN_ATTR;
> +};

base already has ctx so you should get rid of ctx and move base
to the end of the struct.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
