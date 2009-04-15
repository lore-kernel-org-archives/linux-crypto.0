From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: eseqiv - fix IV generation for sync algorithms
Date: Wed, 15 Apr 2009 19:15:49 +0800
Message-ID: <20090415111549.GA10128@gondor.apana.org.au>
References: <20090414132351.GN6791@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35589 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753180AbZDOLPx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Apr 2009 07:15:53 -0400
Content-Disposition: inline
In-Reply-To: <20090414132351.GN6791@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 14, 2009 at 03:23:51PM +0200, Steffen Klassert wrote:
> If crypto_ablkcipher_encrypt() returns synchronous,
> eseqiv_complete2() is called even if req->giv is already the
> pointer to the generated IV. The generated IV is overwritten
> with some random data in this case. This patch fixes this by
> calling eseqiv_complete2() just in the case where an asynchronous
> algorithm would call eseqiv_complete() as the complete function.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Well caught! Clearly no one has ever tried this before :)

> diff --git a/crypto/eseqiv.c b/crypto/eseqiv.c
> index 2a342c8..2fa53b0 100644
> --- a/crypto/eseqiv.c
> +++ b/crypto/eseqiv.c
> @@ -153,7 +153,8 @@ static int eseqiv_givencrypt(struct skcipher_givcrypt_request *req)
>  	if (err)
>  		goto out;
>  
> -	eseqiv_complete2(req);
> +	if (complete == eseqiv_complete)
> +		eseqiv_complete2(req);

Being paranoid it may just be possible for our caller (or one if
its ancestors) to be eseqiv, in which case this test will give a
false positive.

So how about doing what seqiv does and check

	if (giv != req->giv)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
