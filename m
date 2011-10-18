From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] talitos: handle descriptor not found in error path
Date: Tue, 18 Oct 2011 09:36:18 +0200
Message-ID: <20111018073613.GA13923@gondor.apana.org.au>
References: <20110924191649.a42c86d2.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: svens@stackframe.org, linux-crypto@vger.kernel.org
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:48025 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab1JRHg3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Oct 2011 03:36:29 -0400
Content-Disposition: inline
In-Reply-To: <20110924191649.a42c86d2.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kim Phillips <kim.phillips@freescale.com> wrote:
> The CDPR (Current Descriptor Pointer Register) can be unreliable
> when trying to locate an offending descriptor.  Handle that case by
> (a) not OOPSing, and (b) reverting to the machine internal copy of
> the descriptor header in order to report the correct execution unit
> error.
> 
> Note: printing all execution units' ISRs is not effective because it
> results in an internal time out (ITO) error and the EU resetting its
> ISR value (at least when specifying an invalid key length on an SEC
> 2.2/MPC8313E).
> 
> Reported-by: Sven Schnelle <svens@stackframe.org>
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> ---
> please test, as it seems I cannot reproduce the descriptor not found
> case.

So what's the verdict Kim, should I take this patch or not?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
