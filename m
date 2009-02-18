From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: shash - Handle failures in
	crypto_alloc_shash() correctly
Date: Wed, 18 Feb 2009 19:06:41 +0800
Message-ID: <20090218110641.GA28781@gondor.apana.org.au>
References: <alpine.LRH.2.00.0902171845420.13163@vixen.sonytel.be> <20090218085842.GA28120@gondor.apana.org.au> <alpine.LRH.2.00.0902181005570.28815@vixen.sonytel.be> <20090218094548.GA28420@gondor.apana.org.au> <alpine.LRH.2.00.0902181057490.29726@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:51294 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752076AbZBRLGp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 06:06:45 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902181057490.29726@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 18, 2009 at 10:59:13AM +0100, Geert Uytterhoeven wrote:
> 
> But if you put stuff in your crypto_* before base, you still need the special
> translation (and check for IS_ERR()).

You've lost me.  With my patch crypto_create_tfm will either
return the pointer to the start of the area allocated or an error.

Why would you need any special translation?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
