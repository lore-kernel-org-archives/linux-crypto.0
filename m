From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/4] crypto: caam - handle interrupt lines shared across
 rings
Date: Mon, 2 May 2011 18:27:27 -0500
Message-ID: <20110502182727.366857bd.kim.phillips@freescale.com>
References: <20110411191516.bae0454e.kim.phillips@freescale.com>
	<20110415095049.GA2129@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	Steve Cornelius <sec@pobox.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:7492 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1EBX1d (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2011 19:27:33 -0400
In-Reply-To: <20110415095049.GA2129@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 15 Apr 2011 17:50:49 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Mon, Apr 11, 2011 at 07:15:16PM -0500, Kim Phillips wrote:
> > - add IRQF_SHARED to request_irq flags to support parts such as
> > the p1023 that has one IRQ line per couple of rings.
> > 
> > - resetting a job ring triggers an interrupt, so move request_irq
> > prior to jr_reset to avoid 'got IRQ but nobody cared' messages.
> > 
> > - disable IRQs in h/w to avoid contention between reset and
> > interrupt status
> > 
> > - delete invalid comment - if there were incomplete jobs,
> > module would be in use, preventing an unload.
> > 
> > Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
> > ---
> > this, and the remaining patches in this series, tested on p1023, p3041,
> > p4080, and 32- and 64-bit p5020.
> 
> All four patches applied.  Thanks Kim!

I don't see them in cryptodev-2.6 - did you forget to push them?

Thanks,

Kim
