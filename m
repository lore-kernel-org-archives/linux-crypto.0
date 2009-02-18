From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: shash - Handle failures in
	crypto_alloc_shash() correctly
Date: Wed, 18 Feb 2009 17:45:48 +0800
Message-ID: <20090218094548.GA28420@gondor.apana.org.au>
References: <alpine.LRH.2.00.0902171845420.13163@vixen.sonytel.be> <20090218085842.GA28120@gondor.apana.org.au> <alpine.LRH.2.00.0902181005570.28815@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50090 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751310AbZBRJpv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Feb 2009 04:45:51 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902181005570.28815@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 18, 2009 at 10:07:38AM +0100, Geert Uytterhoeven wrote:
>
> Yep, I haven't tried it yet, but it looks OK.
> 
> The only caveat is that crypto_*.base must always be at offset zero now.

Why is that? We still add the size given by the frontend.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
