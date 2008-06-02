From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] [XFRM] xfrm_algo: correct usage of RIPEMD-160
Date: Mon, 2 Jun 2008 17:04:56 +1000
Message-ID: <20080602070456.GA21479@gondor.apana.org.au>
References: <1212340578-15574-1-git-send-email-rueegsegger@swiss-it.ch> <1212340578-15574-2-git-send-email-rueegsegger@swiss-it.ch> <20080602065132.GA11128@Chamillionaire.breakpoint.cc> <48439AF0.30508@swiss-it.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-crypto@vger.kernel.org
To: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57101 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755347AbYFBHFE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 03:05:04 -0400
Content-Disposition: inline
In-Reply-To: <48439AF0.30508@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 02, 2008 at 09:02:08AM +0200, Adrian-Ken Rueegsegger wrote:
>
> Yes, that would be the other way to do it. Is there a preference or specific reason
> for renaming the hash algorithm than changing the reference to the algorithm?

I think the rmd name is fine.  The existing entry in IPsec has
never worked (since we didn't have the implementation) so it
isn't an issue.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
