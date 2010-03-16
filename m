From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: ABLKCIPHER
Date: Tue, 16 Mar 2010 08:18:19 +0800
Message-ID: <20100316001819.GB16253@gondor.apana.org.au>
References: <20100313123146.GA26376@gondor.apana.org.au> <4B9E50F8.9030109@siganos.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dimitrios Siganos <dimitris@siganos.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55492 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932779Ab0CPASX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Mar 2010 20:18:23 -0400
Content-Disposition: inline
In-Reply-To: <4B9E50F8.9030109@siganos.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 15, 2010 at 03:23:36PM +0000, Dimitrios Siganos wrote:
>
> Let's say I want to do the classic cbc(aes). The steps are:
> 1) allocate a tfm object
> 2) set the key
> 3) set the iv
> 4) encrypt as many times as needed
> 5) cleanup
>
> I can do this without the giv functions. Do the giv apply in this case?

Why don't you just do it without givencrypt?

You can always add it alter if you wish.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
