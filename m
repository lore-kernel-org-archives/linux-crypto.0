From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: xcbc - Fix alignment calculation of
	xcbc_tfm_ctx
Date: Thu, 20 Aug 2009 17:59:08 +1000
Message-ID: <20090820075908.GB30878@gondor.apana.org.au>
References: <20090819070902.GA14755@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56548 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751076AbZHTH7I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Aug 2009 03:59:08 -0400
Content-Disposition: inline
In-Reply-To: <20090819070902.GA14755@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 19, 2009 at 09:09:02AM +0200, Steffen Klassert wrote:
> The alignment calculation of xcbc_tfm_ctx uses alg->cra_alignmask
> and not alg->cra_alignmask + 1 as it should. This led to frequent
> crashes during the selftest of xcbc(aes-asm) on x86_64
> machines. This patch fixes this. Also we use the alignmask
> of xcbc and not the alignmask of the underlying algorithm
> for the alignmnent calculation in xcbc_create now.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Good catch!

I wonder why I didn't see it though as I too was testing this on
x86-64.  Must've been luck I suppose as it depends on what follows
the context in memory.  Anyway, patch applied to cryptodev-2.6.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
