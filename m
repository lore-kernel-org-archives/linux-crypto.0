From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/2] talitos: Freescale integrated security engine (SEC)
 driver
Date: Fri, 30 May 2008 14:36:14 -0500
Message-ID: <20080530143614.1e675228.kim.phillips@freescale.com>
References: <20080529141250.0946b02c.kim.phillips@freescale.com>
	<20080530180904.GA18945@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org,
	herbert@gondor.apana.org.au, mr.scada@gmail.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from de01egw01.freescale.net ([192.88.165.102]:61726 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYE3TiQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2008 15:38:16 -0400
In-Reply-To: <20080530180904.GA18945@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 30 May 2008 22:09:04 +0400
Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:

> Hi.
> 
> On Thu, May 29, 2008 at 02:12:50PM -0500, Kim Phillips (kim.phillips@freescale.com) wrote:
> 
> > +static irqreturn_t talitos_interrupt(int irq, void *data)
> > +{
> > +	struct device *dev = data;
> > +	struct talitos_private *priv = dev_get_drvdata(dev);
> > +
> > +	priv->status = in_be32(priv->reg + TALITOS_ISR);
> > +	priv->status_lo = in_be32(priv->reg + TALITOS_ISR_LO);
> > +
> > +	if (unlikely(priv->status & ~TALITOS_ISR_CHDONE)) {
> > +		talitos_error((unsigned long)data);
> > +		/* ack */
> > +		out_be32(priv->reg + TALITOS_ICR, priv->status);
> > +		out_be32(priv->reg + TALITOS_ICR_LO, priv->status_lo);
> > +	}
> > +	else
> > +	{
> > +		/* ack */
> > +		out_be32(priv->reg + TALITOS_ICR, priv->status);
> > +		out_be32(priv->reg + TALITOS_ICR_LO, priv->status_lo);
> > +
> > +		if (likely(priv->status & TALITOS_ISR_CHDONE))
> > +			tasklet_schedule(&priv->done_task);
> > +	}
> > +
> > +	return (priv->status || priv->status_lo) ? IRQ_HANDLED : IRQ_NONE;
> > +}
> 
> Don't you want to protect against simultaneous access to register space
> from different CPUs? Or it is single processor board only?

Doesn't linux mask the IRQ line for the interrupt currently being
serviced, and on all processors?

Kim
