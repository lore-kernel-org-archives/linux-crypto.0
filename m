From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Sat, 23 May 2015 13:47:35 +0800
Message-ID: <20150523054734.GA14239@gondor.apana.org.au>
References: <20150506193643.9329.75351.stgit@tstruk-mobl1>
 <20150506193648.9329.27232.stgit@tstruk-mobl1>
 <20150511063222.GB2316@gondor.apana.org.au>
 <555F777D.1030509@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	keescook@chromium.org, jwboyer@redhat.com, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40924 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbbEWFr5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 May 2015 01:47:57 -0400
Content-Disposition: inline
In-Reply-To: <555F777D.1030509@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 22, 2015 at 11:37:49AM -0700, Tadeusz Struk wrote:
>
> /**
>  * struct akcipher_request - public key request
>  *
>  * @base:	Common attributes for async crypto requests
>  * @inparams:	scatterlist of input parameters (one ent per parameter)
>  *		for the operation as defined in RFC.
>  *		For instance for rsa encrypt only one input param is required,
>  *		(i.e. 'm' - message) as specified in RFC3447 sec 5.1.1
>  *		(Note: the key belongs to the tfm)
>  * @outparams:	scatterlist of output parameters (one ent per parameter)
>  *		for the operation as defined in RFC.
>  *		For instance for rsa encrypt only one output param will be
>  *		produced (i.e. 'c' - cipher text) as specified in
>  *		RFC3447 sec 5.1.1
>  *
>  * @__ctx:	Start of private context data
>  */
> struct akcipher_request {
> 	struct crypto_async_request base;
> 	struct scatterlist *inparams;
> 	struct scatterlist *outparams;
> 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
> };

I think you should rename them to src/dst and add a length argument.
Limiting them to one entry also seems strange.  When do you need more
one parameter?

> /**
>  * struct akcipher_alg - generic public key algorithm
>  *
>  * @sign:	Function performs a sign operation as defined by public key
>  *		algorithm
>  * @verify:	Function performs a sign operation as defined by public key
>  *		algorithm
>  * @encrypt:	Function performs an encrypt operation as defined by public key
>  *		algorithm
>  * @decrypt:	Function performs a decrypt operation as defined by public key
>  *		algorithm
>  * @reqsize:	Request context size required by algorithm implementation
>  *
>  * @base:	Common crypto API algorithm data structure
>  */
> struct akcipher_alg {
> 	int (*sign)(struct akcipher_request *req);
> 	int (*verify)(struct akcipher_request *req);
> 	int (*encrypt)(struct akcipher_request *req);
> 	int (*decrypt)(struct akcipher_request *req);

Looks good.  You'll also need a setkey (or perhaps two) function.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
