From: Aaron Sierra <asierra@xes-inc.com>
Subject: Re: [PATCH] crypto: talitos: Prevent panic in probe error path
Date: Tue, 4 Aug 2015 09:43:50 -0500 (CDT)
Message-ID: <1540044765.55441.1438699430229.JavaMail.zimbra@xes-inc.com>
References: <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com> <296998949.155413.1438375938630.JavaMail.zimbra@xes-inc.com> <20150804071805.GA29697@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:19070 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbbHDOpB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Aug 2015 10:45:01 -0400
In-Reply-To: <20150804071805.GA29697@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- Original Message -----
> From: "Herbert Xu" <herbert@gondor.apana.org.au>
> Sent: Tuesday, August 4, 2015 2:18:05 AM
> 
> On Fri, Jul 31, 2015 at 03:52:18PM -0500, Aaron Sierra wrote:
> >
> > @@ -2905,8 +2919,7 @@ static int talitos_probe(struct platform_device
> > *ofdev)
> >  	priv->reg = of_iomap(np, 0);
> >  	if (!priv->reg) {
> >  		dev_err(dev, "failed to of_iomap\n");
> > -		err = -ENOMEM;
> > -		goto err_out;
> > +		return -ENOMEM;
> >  	}
> 
> This is the only bit that seems remotely related to your change
> description.  Please ensure that your patch actually corresponds
> to your changelog and do not include unrelated changes without
> documenting them.
> 
> And even this bit is wrong because you're leaking priv.

Herbert,

You are correct about the leak and I regret introducing that (I am
also leaking priv->rng), but I disagree with your dismissal of the
rest of the changes as unrelated to the changelog.

The probe error path for this driver, for all intents and purposes,
is the talitos_remove() function due to the common "goto err_out".

Without my patch applied, talitos_remove() will panic under the
two conditions that I outlined in the changelog:

1. If the RNG device hasn't been registered via
   talitos_register_rng() prior to entry into talitos_remove(),
   then the attempt to unregister the RNG "device" will cause a panic.

2. If the priv->chan array has not been allocated prior to entry
   into talitos_remove(), then the per-channel FIFO cleanup will panic
   because of the dereference of that NULL "array".

Both of the above scenarios occur if talitos_probe_irq() fails.

The patch that I submitted resolves issue #1 by changing priv->rng
to a struct hwrng pointer, which allows talitos_unregister_rng() to
know whether an RNG device has been registered (or at least prepared
for registration). As an alternative, I considered introducing a
boolean to serve the same purpose.

It resolves issue #2 by checking that priv->chan is not NULL in the
per-channel FIFO cleanup for loop.

-Aaron
