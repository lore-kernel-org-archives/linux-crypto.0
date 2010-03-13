From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ABLKCIPHER
Date: Sat, 13 Mar 2010 20:31:46 +0800
Message-ID: <20100313123146.GA26376@gondor.apana.org.au>
References: <4B9A4363.1080706@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dimitrios Siganos <dimitris@siganos.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60330 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757282Ab0CMMbt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 13 Mar 2010 07:31:49 -0500
Content-Disposition: inline
In-Reply-To: <4B9A4363.1080706@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dimitrios Siganos <dimitris@siganos.org> wrote:
> Hi,
> 
> I am trying to write an ABLKCIPHER algorithm for my hardware crypto 
> engine and I have a few questions:
> 
> 1) In struct ablkcipher_alg, what do these fields do? I see some 
> implementations use them and some not. Do I need to implement them?
>    int (*givencrypt)(struct skcipher_givcrypt_request *req);
>    int (*givdecrypt)(struct skcipher_givcrypt_request *req);
>    const char *geniv;

These do not have to be implemented, unless your hardware is
capable of generating initial IVs (e.g., through a secure RNG).

> 2) What is a CRYPTO_ALG_TYPE_GIVCIPHER? What does it do and how does it 
> interface to other algorithms?

That's the type to use if you do choose to provide givencrypt
and givdecrypt.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
