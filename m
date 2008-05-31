From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 2/2] talitos: Freescale integrated security engine (SEC) driver
Date: Sat, 31 May 2008 13:59:02 +0400
Message-ID: <20080531095901.GA16281@2ka.mipt.ru>
References: <20080530180904.GA18945@2ka.mipt.ru> <20080530143614.1e675228.kim.phillips@freescale.com> <4840585D.8050805@freescale.com> <20080530151638.087970ab.kim.phillips@freescale.com> <4840615F.4070103@freescale.com> <20080530153505.21eb1ec4.kim.phillips@freescale.com> <48406562.4010306@freescale.com> <20080530154820.6e56b625.kim.phillips@freescale.com> <20080530211204.GA15768@2ka.mipt.ru> <20080530171930.61965d59.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
	mr.scada@gmail.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56366 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbYEaJ7R (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 31 May 2008 05:59:17 -0400
Content-Disposition: inline
In-Reply-To: <20080530171930.61965d59.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Fri, May 30, 2008 at 05:19:30PM -0500, Kim Phillips (kim.phillips@freescale.com) wrote:
> ok, I see what you are saying now; if a channel gets done during
> talitos_done processing, it'll trigger an interrupt and reset
> priv->status, leaving the tasklet in the dark as to which channel has
> done status, depending on how many channel dones it has already
> processed.  I think the only solution here is to call flush_channel on
> each channel, regardless of the bits in the interrupt status - I'll
> send out a patch shortly.

Out of curiosity, what is number of channels? I had simialar issue with
HIFN crypto driver and limited number of descriptor to 80 iirc, since
with that number HIFN traversal did not show perfromance degradataion on
Ghz x86.

> > callback, during that time cached status and priv itself (and tail like
> > in two simultaneous flushes) could change (or not?)
> 
> I think you're talking about a different 'status' here; flush_channel's
> local 'status' doesn't resemble priv->status bits in any way, it looks
> at the descriptor header writeback bits for done status, on a per
> descriptor basis.  It forwards this descriptor done vs. error status to
> the callback.
> 
> priv itself won't change; it's uniquely associated to the device.

I meant descriptor hdr value accessed via it - can it be checked in
tasklet under the lock and in submit path without? Can they correlate
somehow?

-- 
	Evgeniy Polyakov
