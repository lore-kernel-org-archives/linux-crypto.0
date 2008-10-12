From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: talitos - pass correct interrupt status to	error handler
Date: Sun, 12 Oct 2008 20:34:40 +0800
Message-ID: <E1Kp09g-0003in-8T@gondolin.me.apana.org.au>
References: <1223323740.24986.12.camel@al08linux99>
Cc: linux-crypto@vger.kernel.org
To: lee.nipper@freescale.com (Lee Nipper)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50957 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752011AbYJLMe6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 12 Oct 2008 08:34:58 -0400
In-Reply-To: <1223323740.24986.12.camel@al08linux99>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Lee Nipper <lee.nipper@freescale.com> wrote:
> From: Kim Phillips <kim.phillips@freescale.com>
> 
> since we ack early, the re-read interrupt status in talitos_error
> may be already updated with a new value.  Pass the error ISR value
> directly in order to report and handle the error based on the correct
> error status.
> 
> Also remove unused error tasklet.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> Signed-off-by: Lee Nipper <lee.nipper@freescale.com>

I've applied all three patches.  However, I had to fix up the
bits around INIT_LIST_HEAD in 1 and 3.  So please check the
cryptodev-2.6 tree and let me know if it's wrong.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
