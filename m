From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: talitos - add support for sha224
Date: Wed, 19 May 2010 19:22:24 +1000
Message-ID: <20100519092224.GB24964@gondor.apana.org.au>
References: <20100430222759.c116410a.kim.phillips@freescale.com> <4BDCD549.1020709@gmail.com> <20100503134321.6d0f8ad1.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lee Nipper <lee.nipper@gmail.com>, linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:34647 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754123Ab0ESJWa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 05:22:30 -0400
Content-Disposition: inline
In-Reply-To: <20100503134321.6d0f8ad1.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 03, 2010 at 06:43:21PM +0000, Kim Phillips wrote:
> SEC h/w versions 2.1 and above support sha224 via explicit instruction.
> 
> Performing sha224 ahashes on earlier versions is still possible because
> they support sha256 (sha224 is sha256 with different initial constants
> and a different truncation length).  We do this by overriding hardware
> context self-initialization, and perform it manually in s/w instead.
> 
> Thanks to Lee for his fixes for correct execution on actual sec2.0 h/w.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Signed-off by: Lee Nipper <lee.nipper@gmail.com>

Also applied.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
