Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D84C4338F
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 00:30:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 678A6600EF
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Jul 2021 00:30:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhGZXu1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 19:50:27 -0400
Received: from foss.arm.com ([217.140.110.172]:60690 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233843AbhGZXuZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 19:50:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BBD61FB;
        Mon, 26 Jul 2021 17:30:53 -0700 (PDT)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 991933F73D;
        Mon, 26 Jul 2021 17:30:51 -0700 (PDT)
Date:   Tue, 27 Jul 2021 01:30:04 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mark Rutland <mark.rutland@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Will Deacon <will@kernel.org>, Ali Saidi <alisaidi@amazon.com>,
        Jon Nettleton <jon@solid-run.com>
Subject: Re: [PATCH v3 2/2] hwrng: Add Arm SMCCC TRNG based driver
Message-ID: <20210727013004.4caca28f@slackpad.fritz.box>
In-Reply-To: <20210726223738.GM4670@sirena.org.uk>
References: <20210726175610.3311-1-andre.przywara@arm.com>
        <20210726175610.3311-3-andre.przywara@arm.com>
        <20210726223738.GM4670@sirena.org.uk>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 26 Jul 2021 23:37:38 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Mon, Jul 26, 2021 at 06:56:10PM +0100, Andre Przywara wrote:
> 
> > +static int smccc_trng_init(struct hwrng *rng)
> > +{
> > +	return 0;
> > +}  
> 
> If this can be empty (looking at the core it seems like it can) then
> best just remove it.

Ah, you are right! Actually this is explicitly mentioned in the
struct hwrng comments. Thanks for the heads up.

> 
> > +	platform_set_drvdata(pdev, trng);
> > +	ret = devm_hwrng_register(&pdev->dev, trng);
> > +	if (!ret)
> > +		dev_info(&pdev->dev,
> > +			 "ARM SMCCC TRNG firmware random number generator\n");  
> 
> Is the log message needed given that we're not announcing any version
> information here or anything?  A brief sampling of other drivers
> suggests it's not a standard thing for the subsystem.

Yeah, that was indeed more a leftover of the version print. I
thought about querying the version again explicitly, but this would
have brought back the SMCCC calls that I could so nicely delete. Plus,
the hwrng driver is just a (secondary) user of this interface, I think
announcing the version should be done in smccc.c. Which is probably
beyond the scope of this patch.

Now thinking about this, there would probably be some value in making
the TRNG UUID somehow available, as this can be used to identify flawed
implementations (general problems in the hardware or backend bugs). But
this should be some query-able interface, rather than some line in
dmesg. Any ideas? Might be beyond the scope of this series, though...

Cheers,
Andre
