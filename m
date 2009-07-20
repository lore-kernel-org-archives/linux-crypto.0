From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: authenc - convert to ahash
Date: Mon, 20 Jul 2009 14:52:44 +0800
Message-ID: <20090720065244.GA4026@gondor.apana.org.au>
References: <20090717074709.GZ20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40630 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751020AbZGTGwq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jul 2009 02:52:46 -0400
Content-Disposition: inline
In-Reply-To: <20090717074709.GZ20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 17, 2009 at 09:47:10AM +0200, Steffen Klassert wrote:
>
> @@ -165,8 +219,16 @@ static int crypto_authenc_genicv(struct aead_request *req, u8 *iv,
>  		dst = cipher;
>  	}
>  
> -	cryptlen = req->cryptlen + ivsize;
> -	hash = crypto_authenc_hash(req, flags, dst, cryptlen);
> +	sg_init_table(asg, 2);
> +	memcpy(asg, req->assoc, sizeof(struct scatterlist));
> +	asg->page_link &= ~0x02;
> +	authenc_chain(asg, dst, 0);
> +	dst = asg;

This is not quite right.  What I had in mind was to use the digest
interface if the assoc SG list has a single entry in it.  Otherwise
it should just fall back to doing update followed by finup.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
