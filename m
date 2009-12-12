From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: CRYPTO_TFM_REQ_MASK and CRYPTO_TFM_RES_MASK
Date: Sat, 12 Dec 2009 16:22:06 +0800
Message-ID: <20091212082206.GA8868@gondor.apana.org.au>
References: <4B22650C.1000505@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dimitrios Siganos <dimitris@siganos.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:52419 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751628AbZLLIWD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Dec 2009 03:22:03 -0500
Content-Disposition: inline
In-Reply-To: <4B22650C.1000505@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dimitrios Siganos <dimitris@siganos.org> wrote:
> After sending the email, I realised what's happening... 
> crypto_cipher_setkey seems to be used that way only when a child cipher 
> is used by another (parent) cipher as a way to delegate work.
> 
> It seems that crypto_cipher_setkey accepts a number of request flags 
> CRYPTO_TFM_REQ_* which must be passed to the child object and after 
> completion of crypto_cipher_setkey, it returns some results flags 
> CRYPTO_TFM_RES_* back which must be passed to the parent object.
> 
> So the flag manipulation before and after is because we are using an 
> internal cipher object to delegate the work.

You're absolutely correct.  Feel free to send patches to add
comments too.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
