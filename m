From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/2] talitos: Freescale integrated security engine (SEC)
 driver
Date: Mon, 2 Jun 2008 09:27:01 -0500
Message-ID: <20080602092701.9d0d56e8.kim.phillips@freescale.com>
References: <20080530180904.GA18945@2ka.mipt.ru>
	<20080530143614.1e675228.kim.phillips@freescale.com>
	<4840585D.8050805@freescale.com>
	<20080530151638.087970ab.kim.phillips@freescale.com>
	<4840615F.4070103@freescale.com>
	<20080530153505.21eb1ec4.kim.phillips@freescale.com>
	<48406562.4010306@freescale.com>
	<20080530154820.6e56b625.kim.phillips@freescale.com>
	<20080530211204.GA15768@2ka.mipt.ru>
	<20080530171930.61965d59.kim.phillips@freescale.com>
	<20080531095901.GA16281@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Scott Wood <scottwood@freescale.com>, linuxppc-dev@ozlabs.org,
	mr.scada@gmail.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:37915 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbYFBO3E (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 10:29:04 -0400
In-Reply-To: <20080531095901.GA16281@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 31 May 2008 13:59:02 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Hi.
> 
> On Fri, May 30, 2008 at 05:19:30PM -0500, Kim Phillips (kim.phillips@freescale.com) wrote:
> > ok, I see what you are saying now; if a channel gets done during
> > talitos_done processing, it'll trigger an interrupt and reset
> > priv->status, leaving the tasklet in the dark as to which channel has
> > done status, depending on how many channel dones it has already
> > processed.  I think the only solution here is to call flush_channel on
> > each channel, regardless of the bits in the interrupt status - I'll
> > send out a patch shortly.
> 
> Out of curiosity, what is number of channels? I had simialar issue with

typically four but some parts only have one.

> HIFN crypto driver and limited number of descriptor to 80 iirc, since
> with that number HIFN traversal did not show perfromance degradataion on
> Ghz x86.

ok, I've been focusing on correctness for the time being.

> > > callback, during that time cached status and priv itself (and tail like
> > > in two simultaneous flushes) could change (or not?)
> > 
> > I think you're talking about a different 'status' here; flush_channel's
> > local 'status' doesn't resemble priv->status bits in any way, it looks
> > at the descriptor header writeback bits for done status, on a per
> > descriptor basis.  It forwards this descriptor done vs. error status to
> > the callback.
> > 
> > priv itself won't change; it's uniquely associated to the device.
> 
> I meant descriptor hdr value accessed via it - can it be checked in
> tasklet under the lock and in submit path without? Can they correlate
> somehow?

I believe the check for a non-null request->desc (under lock) before
the hdr value is accessed ensures this doesn't happen.

Kim
