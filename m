From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/5 RESEND] crypto: talitos - scaffolding for new
	algorithm types
Date: Sun, 29 Mar 2009 15:55:18 +0800
Message-ID: <20090329075518.GE11735@gondor.apana.org.au>
References: <20090327224854.cdf51c5e.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Lee Nipper <lee.nipper@gmail.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48562 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752046AbZC2HzZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Mar 2009 03:55:25 -0400
Content-Disposition: inline
In-Reply-To: <20090327224854.cdf51c5e.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 27, 2009 at 10:48:54PM -0500, Kim Phillips wrote:
> From: Lee Nipper <lee.nipper@gmail.com>
> 
> This patch is preparation for adding new algorithm types.
> 
> Some elements which are AEAD specific were renamed.
> The algorithm template structure was changed to
> use crypto_alg, and talitos_alg_alloc was made
> more general with respect to algorithm types.
> ipsec_esp_edesc is renamed to talitos_edesc
> to use it in the upcoming ablkcipher routines.
> 
> Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

All applied to cryptodev.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
