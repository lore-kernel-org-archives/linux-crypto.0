From: Martin Kaiser <martin@kaiser.cx>
Subject: Re: [PATCH v2 3/3] hwrng: mxc-fsl - add support for Freescale RNGC
Date: Mon, 17 Jul 2017 23:01:44 +0200
Message-ID: <20170717210144.GA15429@reykholt.kaiser.cx>
References: <1457705200-16951-1-git-send-email-s.trumtrar@pengutronix.de>
 <1457705200-16951-3-git-send-email-s.trumtrar@pengutronix.de>
 <56E2E7F1.6020501@mentor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, Pawel Moll <pawel.moll@arm.com>,
 Ian Campbell <ijc+devicetree@hellion.org.uk>, martin@kaiser.cx,
 Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
 linux-crypto@vger.kernel.org, kernel@pengutronix.de,
 Matt Mackall <mpm@selenic.com>, Steffen Trumtrar <s.trumtrar@pengutronix.de>,
 Shawn Guo <shawnguo@kernel.org>, linux-arm-kernel@lists.infradead.org
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <56E2E7F1.6020501@mentor.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Dear all,

looking for a Freescale RNGB/C driver, I came across this old mail
thread. It seems the review got stuck and the driver was never merged.
This mail is the latest conversation I could find.

I would like to pick up this work and prepare the RNGC driver for
merging into the mailine kernel.

Thus wrote Vladimir Zapolskiy (vladimir_zapolskiy@mentor.com):

> > +#define RNGC_VERID_VERSION_MAJOR_MASK		0x0000ff00
> > +#define RNGC_VERID_VERSION_MAJOR_SHIFT		8
> > +#define RNGC_VERID_VERSION_MINOR_MASK		0x000000ff
> > +#define RNGC_VERID_VERSION_MINOR_SHIFT		0

> All RNGC_VERID_* are not used. And actually quite many other
> defined values are not used, e.g. all *_ZEROS_MASK etc.

I removed unused defines.

> > +	struct mxc_rngc *rngc = (struct mxc_rngc *)priv;
> > +	int handled = IRQ_NONE;
> > +
> > +	/* is the seed creation done? */
> > +	if (__raw_readl(rngc->base + RNGC_STATUS) & RNGC_STATUS_SEED_DONE) {
> > +		complete(&rngc->rng_seed_done);
> > +		__raw_writel(RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR,
> > +			     rngc->base + RNGC_COMMAND);
> > +		handled = IRQ_HANDLED;
> > +	}
> > +
> > +	/* is the self test done? */
> > +	if (__raw_readl(rngc->base + RNGC_STATUS) & RNGC_STATUS_ST_DONE) {
> > +		complete(&rngc->rng_self_testing);
> > +		__raw_writel(RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR,
> > +			     rngc->base + RNGC_COMMAND);
> > +		handled = IRQ_HANDLED;
> > +	}
> > +
> > +	/* is there any error? */
> > +	if (__raw_readl(rngc->base + RNGC_STATUS) & RNGC_STATUS_ERROR) {
> > +		/* clear interrupt */
> > +		__raw_writel(RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR,
> > +			     rngc->base + RNGC_COMMAND);
> > +		handled = IRQ_HANDLED;

> For the code errors seem to be harmless, is it so? Does it make
> sense to inform a user about errors?

Either one of the completions is triggered or we time out when we wait
on a wait queue, see below. In any case, we read the error register and
abort the operation if there's an error.

> > +		wait_for_completion(&rngc->rng_self_testing);

> I would suggest to use wait_for_completion_timeout().

I fixed this.

> > +
> > +	} while (__raw_readl(rngc->base + RNGC_ERROR) &
> > +		 RNGC_ERROR_STATUS_ST_ERR);

> Logic of running a self test until error condition is gone looks strange.

Agreed. I don't see why the self test should fail in the first run and
complete successfully when we retry without a reset. I changed the code
to run the self test only once.

> > +
> > +	/* clear interrupt. Is it really necessary here? */
> > +	__raw_writel(RNGC_CMD_CLR_INT | RNGC_CMD_CLR_ERR,
> > +		     rngc->base + RNGC_COMMAND);

> Answering the question above I believe it is not needed here.

True. The irq handler clears the error status and interrupt bits.

> > +		wait_for_completion(&rngc->rng_seed_done);

> I would suggest to use wait_for_completion_timeout().

Done.

> > +
> > +	} while (__raw_readl(rngc->base + RNGC_ERROR) &
> > +		 RNGC_ERROR_STATUS_STAT_ERR);

> Any chance to loop forever?

I exit the loop now for all errors except the "statistical error". This
+ the timeout on the wait queue should prevent us from looping forever.

> > +	if (ret) {
> > +		dev_err(rngc->dev, "Can't get interrupt working.\n");
> > +		return -EIO;

> Leaked enabled rngc->clk clock on error path.

I restructured the probe function such that the clock is disabled when
there's an error after it was enabled.


Best regards,

   Martin
