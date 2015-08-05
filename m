From: Aaron Sierra <asierra@xes-inc.com>
Subject: Re: [PATCH] crypto: talitos: Prevent panic in probe error path
Date: Wed, 5 Aug 2015 09:24:06 -0500 (CDT)
Message-ID: <281319751.208400.1438784646381.JavaMail.zimbra@xes-inc.com>
References: <985540634.83104.1438363661992.JavaMail.zimbra@xes-inc.com> <296998949.155413.1438375938630.JavaMail.zimbra@xes-inc.com> <20150804071805.GA29697@gondor.apana.org.au> <1540044765.55441.1438699430229.JavaMail.zimbra@xes-inc.com> <20150805000813.GA2725@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Christophe Leroy <christophe.leroy@c-s.fr>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from xes-mad.com ([216.165.139.218]:31581 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbbHEOZO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 10:25:14 -0400
In-Reply-To: <20150805000813.GA2725@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

----- Original Message -----
> From: "Herbert Xu" <herbert@gondor.apana.org.au>
> Sent: Tuesday, August 4, 2015 7:08:13 PM
> 
> On Tue, Aug 04, 2015 at 09:43:50AM -0500, Aaron Sierra wrote:
> > 
> > You are correct about the leak and I regret introducing that (I am
> > also leaking priv->rng), but I disagree with your dismissal of the
> > rest of the changes as unrelated to the changelog.
> 
> I understand the problem, but your change description is way
> too vague and does not correspond to the change, especially the
> bit where you're replacing the static variable with kzalloc.  You
> should have included the following text in your description.
> 
> > The probe error path for this driver, for all intents and purposes,
> > is the talitos_remove() function due to the common "goto err_out".
> > 
> > Without my patch applied, talitos_remove() will panic under the
> > two conditions that I outlined in the changelog:
> > 
> > 1. If the RNG device hasn't been registered via
> >    talitos_register_rng() prior to entry into talitos_remove(),
> >    then the attempt to unregister the RNG "device" will cause a panic.
> > 
> > 2. If the priv->chan array has not been allocated prior to entry
> >    into talitos_remove(), then the per-channel FIFO cleanup will panic
> >    because of the dereference of that NULL "array".
> > 
> > Both of the above scenarios occur if talitos_probe_irq() fails.
> > 
> > The patch that I submitted resolves issue #1 by changing priv->rng
> > to a struct hwrng pointer, which allows talitos_unregister_rng() to
> > know whether an RNG device has been registered (or at least prepared
> > for registration). As an alternative, I considered introducing a
> > boolean to serve the same purpose.
> 
> I would prefer a boolean as that means less churn.
> 

Herbert,
Thanks for the feedback. I'll address your concerns in the next
version.

-Aaron
