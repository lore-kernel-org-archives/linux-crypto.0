From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: caam - handle interrupt lines shared
	across rings
Date: Fri, 15 Apr 2011 17:50:49 +0800
Message-ID: <20110415095049.GA2129@gondor.apana.org.au>
References: <20110411191516.bae0454e.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	Steve Cornelius <sec@pobox.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52502 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1DOJu4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2011 05:50:56 -0400
Content-Disposition: inline
In-Reply-To: <20110411191516.bae0454e.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 11, 2011 at 07:15:16PM -0500, Kim Phillips wrote:
> - add IRQF_SHARED to request_irq flags to support parts such as
> the p1023 that has one IRQ line per couple of rings.
> 
> - resetting a job ring triggers an interrupt, so move request_irq
> prior to jr_reset to avoid 'got IRQ but nobody cared' messages.
> 
> - disable IRQs in h/w to avoid contention between reset and
> interrupt status
> 
> - delete invalid comment - if there were incomplete jobs,
> module would be in use, preventing an unload.
> 
> Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> ---
> this, and the remaining patches in this series, tested on p1023, p3041,
> p4080, and 32- and 64-bit p5020.

All four patches applied.  Thanks Kim!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
