From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 2/2] talitos: Freescale integrated security engine (SEC) driver
Date: Fri, 30 May 2008 22:09:04 +0400
Message-ID: <20080530180904.GA18945@2ka.mipt.ru>
References: <20080529141250.0946b02c.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org,
	herbert@gondor.apana.org.au, mr.scada@gmail.com
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:53523 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbYE3SJW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2008 14:09:22 -0400
Content-Disposition: inline
In-Reply-To: <20080529141250.0946b02c.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Thu, May 29, 2008 at 02:12:50PM -0500, Kim Phillips (kim.phillips@freescale.com) wrote:

> +static irqreturn_t talitos_interrupt(int irq, void *data)
> +{
> +	struct device *dev = data;
> +	struct talitos_private *priv = dev_get_drvdata(dev);
> +
> +	priv->status = in_be32(priv->reg + TALITOS_ISR);
> +	priv->status_lo = in_be32(priv->reg + TALITOS_ISR_LO);
> +
> +	if (unlikely(priv->status & ~TALITOS_ISR_CHDONE)) {
> +		talitos_error((unsigned long)data);
> +		/* ack */
> +		out_be32(priv->reg + TALITOS_ICR, priv->status);
> +		out_be32(priv->reg + TALITOS_ICR_LO, priv->status_lo);
> +	}
> +	else
> +	{
> +		/* ack */
> +		out_be32(priv->reg + TALITOS_ICR, priv->status);
> +		out_be32(priv->reg + TALITOS_ICR_LO, priv->status_lo);
> +
> +		if (likely(priv->status & TALITOS_ISR_CHDONE))
> +			tasklet_schedule(&priv->done_task);
> +	}
> +
> +	return (priv->status || priv->status_lo) ? IRQ_HANDLED : IRQ_NONE;
> +}

Don't you want to protect against simultaneous access to register space
from different CPUs? Or it is single processor board only?

-- 
	Evgeniy Polyakov
