From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - ack done interrupt in isr instead of
	tasklet
Date: Sat, 20 Dec 2008 17:10:01 +1100
Message-ID: <20081220061001.GA16654@gondor.apana.org.au>
References: <1229625305.26363.190.camel@al08linux99>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	Kim Phillips <kim.phillips@freescale.com>
To: Lee Nipper <lee.nipper@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42287 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751608AbYLTGKG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Dec 2008 01:10:06 -0500
Content-Disposition: inline
In-Reply-To: <1229625305.26363.190.camel@al08linux99>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 18, 2008 at 06:35:05PM +0000, Lee Nipper wrote:
> Previous commit for interrupt mitigation moved the done interrupt
> acknowlegement from the isr to the talitos_done tasklet.
> This patch moves the done interrupt acknowledgement back
> into the isr so that done interrupts will always be acknowledged.
> This covers the case for acknowledging interrupts for channel done processing
> that has actually already been completed by the tasklet prior to fielding
> a pending interrupt.
> 
> Signed-off-by: Lee Nipper <lee.nipper@freescale.com>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>

Patch applied.  Thanks Lee!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
