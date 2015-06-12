From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v4 2/4] crypto: add PKE API
Date: Fri, 12 Jun 2015 10:59:40 +0800
Message-ID: <20150612025940.GC30982@gondor.apana.org.au>
References: <20150611190533.31826.13956.stgit@tstruk-mobl1>
 <20150611190543.31826.357.stgit@tstruk-mobl1>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:38205 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbbFLC7y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2015 22:59:54 -0400
Content-Disposition: inline
In-Reply-To: <20150611190543.31826.357.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 11, 2015 at 12:05:44PM -0700, Tadeusz Struk wrote:
>
> +int crypto_akcipher_setkey(struct crypto_akcipher *tfm,
> +			   const struct public_key *pkey)
> +{
> +	if (tfm->pkey)
> +		akcipher_free_key(tfm->pkey);
> +
> +	return akcipher_clone_key(tfm, pkey);
> +}

No please do not expose the struct public_key crap to the new
API.  The key should be completely opaque to entities outside
of the algorithm.  So make it raw and read out the MPIs from
it.

The contents of the function must go into the algorithm setkey
function, not the crypto API.  So RSA would read out however
many MPIs it needs and verify it, and so on.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
