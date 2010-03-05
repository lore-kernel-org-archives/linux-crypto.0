From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: hmac(sha1)
Date: Fri, 5 Mar 2010 15:32:04 +0800
Message-ID: <20100305073204.GA3745@gondor.apana.org.au>
References: <4B8DD78D.6080707@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dimitrios Siganos <dimitris@siganos.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52207 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751313Ab0CEHcJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Mar 2010 02:32:09 -0500
Content-Disposition: inline
In-Reply-To: <4B8DD78D.6080707@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dimitrios Siganos <dimitris@siganos.org> wrote:
>
> 1) Can I implement hmac(sha1) as a CRYPTO_ALG_TYPE_DIGEST algorithm 
> (i.e. use very similar code to sha1)?

DIGEST exists for compatibility only.  No new code will be accepted
that implements a DIGEST algorithms.

> 2) Do I need to create a CRYPTO_ALG_TYPE_HASH algorithm?

HASH is also obsolete.  If your hardware is synchronous, you should
use SHASH which is just as simple to use as DIGEST.  If however
you need asynchronous support, you must use AHASH.

> 3) Is it possible to implement hmac(sha1) as both CRYPTO_ALG_TYPE_DIGEST 
> and CRYPTO_ALG_TYPE_HASH?

Yes but as both types are obsolete your code will not be merged.

> 4) If I use a CRYPTO_ALG_TYPE_HASH, I need to understand the scatterwalk 
> api, is there any help on the subject?

If your hardware is synchronous, you won't need SG lists at all.
Otherwise you can look at how existing drivers under drivers/crypto
do things.

Note that we don't currently have a working asynchronous hash
driver so in a way you'll need to write things from scratch.
However, we're all happy to assist you in this process.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
