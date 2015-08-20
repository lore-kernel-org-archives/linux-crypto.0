From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Recent AEAD change: testmgr.c change needed?
Date: Thu, 20 Aug 2015 15:34:55 +0800
Message-ID: <20150820073455.GA27382@gondor.apana.org.au>
References: <1732898.70JpgbIL8N@myon.chronox.de>
 <20150819124550.GA18321@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41515 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbbHTHe7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2015 03:34:59 -0400
Content-Disposition: inline
In-Reply-To: <20150819124550.GA18321@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 19, 2015 at 08:45:50PM +0800, Herbert Xu wrote:
>
> > [11154.278466] alg: No test for ccm_base(ctr(aes-asm),aes-asm) 
> > (ccm_base(ctr(aes-asm),aes-asm))
> > [11174.819535] alg: No test for gcm(aes-asm) (gcm_base(ctr(aes-asm),ghash-
> > clmulni))
> > [11174.819610] alg: No test for rfc4106(gcm(aes-asm)) 
> > (rfc4106(gcm_base(ctr(aes-asm),ghash-clmulni)))
> 
> Ditto.  gcm should also canonicalise aes-asm in its cra_name.

I had a look and it seems that we need to fix ctr first to get
the canonicalised name.  So I'll revisit this after completing
the skcipher work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
