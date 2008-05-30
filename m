From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/2] talitos: Freescale integrated security engine (SEC)
 driver
Date: Fri, 30 May 2008 15:35:05 -0500
Message-ID: <20080530153505.21eb1ec4.kim.phillips@freescale.com>
References: <20080529141250.0946b02c.kim.phillips@freescale.com>
	<20080530180904.GA18945@2ka.mipt.ru>
	<20080530143614.1e675228.kim.phillips@freescale.com>
	<4840585D.8050805@freescale.com>
	<20080530151638.087970ab.kim.phillips@freescale.com>
	<4840615F.4070103@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linuxppc-dev@ozlabs.org,
	mr.scada@gmail.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Scott Wood <scottwood@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw02.freescale.net ([192.88.165.103]:36734 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbYE3UuS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2008 16:50:18 -0400
In-Reply-To: <4840615F.4070103@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 30 May 2008 15:19:43 -0500
Scott Wood <scottwood@freescale.com> wrote:

> Kim Phillips wrote:
> > On Fri, 30 May 2008 14:41:17 -0500
> > Scott Wood <scottwood@freescale.com> wrote:
> > 
> >> Kim Phillips wrote:
> >>> On Fri, 30 May 2008 22:09:04 +0400
> >>> Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> >>>> Don't you want to protect against simultaneous access to register space
> >>>> from different CPUs? Or it is single processor board only?
> >>> Doesn't linux mask the IRQ line for the interrupt currently being
> >>> serviced, and on all processors?
> >> Yes.  Could there be interference from non-interrupt driver code on 
> >> another cpu (or interrupted code), though?
> > 
> > not that I can see - the fetch fifo register writes are protected with
> > per-channel spinlocks.
> 
> But you don't take the spinlocks from the interrupt handler.

why can't fetch fifo registers be written the same time the ISR is
being accessed?

Kim
