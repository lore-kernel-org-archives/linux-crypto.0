From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 2/2] talitos: Freescale integrated security engine (SEC) driver
Date: Sat, 31 May 2008 00:13:52 +0400
Message-ID: <20080530201352.GA26698@2ka.mipt.ru>
References: <20080529141250.0946b02c.kim.phillips@freescale.com> <20080530180904.GA18945@2ka.mipt.ru> <20080530143614.1e675228.kim.phillips@freescale.com> <4840585D.8050805@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kim Phillips <kim.phillips@freescale.com>, linuxppc-dev@ozlabs.org,
	mr.scada@gmail.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
To: Scott Wood <scottwood@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:41295 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbYE3UOB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2008 16:14:01 -0400
Content-Disposition: inline
In-Reply-To: <4840585D.8050805@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 30, 2008 at 02:41:17PM -0500, Scott Wood (scottwood@freescale.com) wrote:
> >>Don't you want to protect against simultaneous access to register space
> >>from different CPUs? Or it is single processor board only?
> >
> >Doesn't linux mask the IRQ line for the interrupt currently being
> >serviced, and on all processors?
> 
> Yes.  Could there be interference from non-interrupt driver code on 
> another cpu (or interrupted code), though?

Yes, that register space can be assigned from non-interrupt path on
different cpu. I saw spin_lock_irqsave() is used in some other places,
but not in interrupt handler itself.

-- 
	Evgeniy Polyakov
