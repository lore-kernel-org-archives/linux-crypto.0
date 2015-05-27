From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: algif_aead - Switch to new AEAD interface
Date: Wed, 27 May 2015 18:14:33 +0800
Message-ID: <20150527101433.GA28479@gondor.apana.org.au>
References: <20150527092441.GA27913@gondor.apana.org.au>
 <1517596.JekxWSB2Qc@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54885 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbbE0KOh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 06:14:37 -0400
Content-Disposition: inline
In-Reply-To: <1517596.JekxWSB2Qc@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 27, 2015 at 12:10:03PM +0200, Stephan Mueller wrote:
> 
> >-
> >-	if (ctx->enc) {
> >-		/* round up output buffer to multiple of block size */
> >-		outlen = ((used + bs - 1) / bs * bs);
> 
> Why wouldn't the round up for the output not be needed any more? If the caller 
> provides input data that is not multiple of block sizes and the output buffer 
> is also not multiple of block sizes, wouldn't an encrypt overstep boundaries?

No the AEAD algorithm should fail them instead.  We do the same
thing in algif_skcipher where it's up to the underlying algorithm
to fail requests that do not contain full blocks.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
