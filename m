From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: Update stdrng test name so that the testmgr
	finds it properly
Date: Thu, 2 Jul 2009 06:52:05 -0400
Message-ID: <20090702105205.GA8563@hmsreliant.think-freely.org>
References: <20090701155219.GA31414@hmsreliant.think-freely.org> <20090702060255.GA18642@Chamillionaire.breakpoint.cc> <20090702083259.GA12884@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	linux-crypto@vger.kernel.org, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41568 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZGBKwR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2009 06:52:17 -0400
Content-Disposition: inline
In-Reply-To: <20090702083259.GA12884@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 02, 2009 at 04:32:59PM +0800, Herbert Xu wrote:
> On Thu, Jul 02, 2009 at 08:02:55AM +0200, Sebastian Andrzej Siewior wrote:
> >
> > >@@ -1480,7 +1480,7 @@ static int alg_test_cprng(const struct alg_test_desc *desc, const char *driver,
> > > /* Please keep this list sorted by algorithm name. */
> > > static const struct alg_test_desc alg_test_descs[] = {
> > > 	{
> > >-		.alg = "ansi_cprng",
> > >+		.alg = "stdrng",
> > > 		.test = alg_test_cprng,
> > > 		.fips_allowed = 1,
> > > 		.suite = {
> > 
> > Don't you use this vector for _all_ stdrngs now? krng for instance will
> > fail.
> 
> Good cath!
> 
Indeed, I didn't even think of that.

> What this really should do is test a specific implementation of
> stdrng.  Like this,
> 
Yeah, that looks right
Acked-by: Neil Horman <nhorman@tuxdriver.com>

