Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 187C3C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 08:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB409206E0
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 08:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbfG3IYD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 04:24:03 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:59749 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbfG3IYD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 04:24:03 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id BBB95E0006;
        Tue, 30 Jul 2019 08:24:00 +0000 (UTC)
Date:   Tue, 30 Jul 2019 10:24:00 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 2/3] crypto: inside-secure - added support for
 rfc3686(ctr(aes))
Message-ID: <20190730082400.GD3108@kwain>
References: <1562309364-942-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1562309364-942-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190726123305.GD3235@kwain>
 <MN2PR20MB2973C6D05EED9B878D2EC4B9CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190726134640.GD5031@kwain>
 <MN2PR20MB2973EB161252E245878473B1CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <MN2PR20MB2973EB161252E245878473B1CAC00@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 26, 2019 at 02:29:48PM +0000, Pascal Van Leeuwen wrote:
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of Antoine Tenart
> > On Fri, Jul 26, 2019 at 01:28:13PM +0000, Pascal Van Leeuwen wrote:
> > > > On Fri, Jul 05, 2019 at 08:49:23AM +0200, Pascal van Leeuwen wrote:
> > >
> > > > > @@ -62,9 +63,9 @@ static void safexcel_skcipher_token(struct safexcel_cipher_ctx *ctx, u8 *iv,
> > > > >  				    u32 length)
> > > > > -	if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC) {
> > > > > +	if (ctx->mode != CONTEXT_CONTROL_CRYPTO_MODE_ECB) {
> > > >
> > > > I think it's better for maintenance and readability to have something
> > > > like:
> > > >
> > > >   if (ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CBC ||
> > > >       ctx->mode == CONTEXT_CONTROL_CRYPTO_MODE_CTR_LOAD)
> > > >
> > > Not really. I *really* want to execute that for any mode other than ECB,
> > > ECB being the *only* mode that does not require an IV (which I know
> > > for a fact, being the architect and all :-).
> > > And I don't believe a long list of modes that *do* require an IV would
> > > be  more readable or easy to maintain than this single compare ...
> > 
> > That's where I disagree as you need extra knowledge to be aware of this.
> > Being explicit removes any possible question one may ask. But that's a
> > small point really :)
> > 
> Well, while we're disagreeing ... I disagree with your assertion that you
> would need more knowledge to know which modes do NOT need an IV
> than to know which modes DO need an IV. There's really no fundamental
> difference, it's two sides of the exact same coin ... you need that
> knowledge either way. 

The point is if you look for occurrences of, let's say
CONTEXT_CONTROL_CRYPTO_MODE_CBC, to see the code path it'll be way
easier if you have direct comparisons.

> 1) This code is executed for each individual cipher call, i.e. it's in the
> critical path. Having just 1 compare-and-branch there is better for
> performance than having many.

Not sure about what the impact really is.

> 2) Generally, all else being equal, having less code is easier to maintain
> than having more code. 

That really depends, having readable code is easier to maintain :)

> 4) If there is anything unclear about an otherwise fine code construct,
> then you clarify it by adding a comment, not by rewriting it to be inefficient
> and redundant ;-)

Fair point.

Thanks,
Antoine

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
