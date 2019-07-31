Return-Path: <SRS0=mqYf=V4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED1EC433FF
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 11:08:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 126C9206A2
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Jul 2019 11:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfGaLIg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Jul 2019 07:08:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40304 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbfGaLIg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jul 2019 07:08:36 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hsmSY-0004G3-Pc; Wed, 31 Jul 2019 21:07:54 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hsmSU-0005OZ-BX; Wed, 31 Jul 2019 21:07:50 +1000
Date:   Wed, 31 Jul 2019 21:07:50 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv2 2/3] crypto: inside-secure - add support for PCI based
 FPGA development board
Message-ID: <20190731110750.GA20643@gondor.apana.org.au>
References: <1564145005-26731-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1564145005-26731-3-git-send-email-pvanleeuwen@verimatrix.com>
 <20190730090811.GF3108@kwain>
 <MN2PR20MB2973B37C90FBD6E6C97B8E09CADC0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB29734DDABC5D2812EAFEFBABCADF0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB29734DDABC5D2812EAFEFBABCADF0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 31, 2019 at 10:11:46AM +0000, Pascal Van Leeuwen wrote:
>
> > > > +static int __init crypto_is_init(void)
> > > > +{
> > > > +	int rc;
> > > > +
> > > > +	#if (IS_ENABLED(CONFIG_OF))
> > > > +		/* Register platform driver */
> > > > +		platform_driver_register(&crypto_safexcel);
> > > > +	#endif
> > >
> > > When used in the code directly, you should use:
> > >
> > >   if (IS_ENABLED(CONFIG_OF))
> > >
> > Oops, I missed that one, will fix.
> > 
> Actually, I tried that first, but it doesn't work in this particular case. 
> The #if is really necessary here to avoid compile errors due to 
> references to datastructures that are within another #if ... (which refer
> to functions with the #if etc. so it's a whole dependency chain)

If you're going to use a #if then please don't indent it as that's
not the kernel coding style.

I see why you can't use a straight "if" because you've moved
crypto_safexcel inside a #if, but what if you got rid of that
#if too? IOW what would it take to make the probe function compile
with CONFIG_OF off?

In general we want to maximise compiler coverage under all config
options so if we can make it compiler without too much effort that
would be the preferred solution.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
