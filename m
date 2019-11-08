Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC9BFA372C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 15:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 707DF2178F
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 15:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfKHPT6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 10:19:58 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57938 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726036AbfKHPT5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 10:19:57 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iT63D-0007HK-B7; Fri, 08 Nov 2019 23:19:51 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iT63A-00078c-Kq; Fri, 08 Nov 2019 23:19:48 +0800
Date:   Fri, 8 Nov 2019 23:19:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Andrey Smirnov <andrew.smirnov@gmail.com>
Cc:     Lucas Stach <l.stach@pengutronix.de>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] enable CAAM's HWRNG as default
Message-ID: <20191108151948.ojn6ga3preh66utl@gondor.apana.org.au>
References: <20191029162916.26579-1-andrew.smirnov@gmail.com>
 <226f5a669c2199408abcdec0ccddc9ff05672631.camel@pengutronix.de>
 <CAHQ1cqF3BgberQMMY3sKH5iabG3oN6-H=o-y00Q710zrB7KNgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqF3BgberQMMY3sKH5iabG3oN6-H=o-y00Q710zrB7KNgw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 29, 2019 at 12:58:24PM -0700, Andrey Smirnov wrote:
>
> > I'm not sure if we can ever use the job based RNG interface to hook it
> > up to the Linux HWRNG interface. After all the job based RNG interface
> > is always a DRNG, which only gets seeded by the TRNG. The reseed
> > interval is given in number of clock cycles, so there is no clear
> > correlation between really true random input bits and the number of
> > DRNG output bits.
> 
> Doesn't enabling prediction resistance gives us that correlation? E.g.
> that every time new random data is generated, DRNG is reseeded? I am
> assuming even if this is true we'd have to significantly limit
> generated data length (< seed length?), so maybe what you propose
> below is still simpler.

Prediction resistance should be sufficient in general.  However,
is the prediction resistance reseeding done in real time?

> > I've hacked up some proof of concept code which uses the TRNG access in
> > the control interface to get the raw TRNG random bits. This seems to
> > yield about 6400 bit/s of true entropy. It may be better to use this
> > interface to hook up to the Linux HWRNG framework.
> 
> OK, I'll take a look into that and send out a v2 with results.

I've backed out the patch-set for now but if we can clarify the
prediction resistance implementation details then I'm happy to
put it back in.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
