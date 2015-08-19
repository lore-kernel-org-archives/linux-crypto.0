From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Recent AEAD change: testmgr.c change needed?
Date: Wed, 19 Aug 2015 20:45:50 +0800
Message-ID: <20150819124550.GA18321@gondor.apana.org.au>
References: <1732898.70JpgbIL8N@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51664 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbbHSMpz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2015 08:45:55 -0400
Content-Disposition: inline
In-Reply-To: <1732898.70JpgbIL8N@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Staphan:

On Wed, Aug 19, 2015 at 11:48:05AM +0200, Stephan Mueller wrote:
> 
> The recent AEAD change seems to trigger a need to change something in 
> testmgr.c. I ran my test tool trying to invoke all possible permutations of 
> cra_name and cra_driver_name ciphers and got the following:
> 
> [11152.816179] alg: No test for gcm_base(ctr(aes-asm),ghash-generic) 
> (gcm_base(ctr(aes-asm),ghash-generic))

This is a bug in gcm_base.  It should not use the driver name as
its cra_name.  I'll try to fix this.

> [11154.278466] alg: No test for ccm_base(ctr(aes-asm),aes-asm) 
> (ccm_base(ctr(aes-asm),aes-asm))
> [11174.819535] alg: No test for gcm(aes-asm) (gcm_base(ctr(aes-asm),ghash-
> clmulni))
> [11174.819610] alg: No test for rfc4106(gcm(aes-asm)) 
> (rfc4106(gcm_base(ctr(aes-asm),ghash-clmulni)))

Ditto.  gcm should also canonicalise aes-asm in its cra_name.

> [11174.819654] alg: No test for seqiv(rfc4106(gcm(aes-asm))) 
> (seqiv(rfc4106(gcm_base(ctr(aes-asm),ghash-clmulni))))

This is different.  We should definitely add tests for the IV
generators.  Obviously we can't test the randomness but we can
certainly test for correctness.  What we can do is reuse the
test vectors for the underlying algorithms.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
