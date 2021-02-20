Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF9BEC433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 19:41:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C62F64DD3
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Feb 2021 19:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhBTTla (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Feb 2021 14:41:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50886 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229796AbhBTTl3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Feb 2021 14:41:29 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lDY7O-007ZCv-KM; Sat, 20 Feb 2021 20:40:42 +0100
Date:   Sat, 20 Feb 2021 20:40:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     mpm@selenic.com, herbert@gondor.apana.org.au,
        nsaenzjulienne@suse.de, f.fainelli@gmail.com, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        rikard.falkeborn@gmail.com, linux-crypto@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stijn@linux-ipv6.be, ynezz@true.cz
Subject: Re: [PATCH] hwrng: bcm2835: set quality to 1000
Message-ID: <YDFlurbYyiphXmHb@lunn.ch>
References: <20210220174741.23665-1-noltari@gmail.com>
 <YDFeao/bOxvoXI9D@lunn.ch>
 <9b86c773-7153-1e18-472a-f66b01c83173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9b86c773-7153-1e18-472a-f66b01c83173@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 20, 2021 at 08:12:45PM +0100, Álvaro Fernández Rojas wrote:
> Hi Andrew,
> 
> I ran rngtest and this is what I got:
> root@OpenWrt:/# cat /dev/hwrng | rngtest -c 1000
> rngtest 6.10
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions.  There is NO
> warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
> 
> rngtest: starting FIPS tests...
> rngtest: bits received from input: 20000032
> rngtest: FIPS 140-2 successes: 996
> rngtest: FIPS 140-2 failures: 4
> rngtest: FIPS 140-2(2001-10-10) Monobit: 0
> rngtest: FIPS 140-2(2001-10-10) Poker: 0
> rngtest: FIPS 140-2(2001-10-10) Runs: 1
> rngtest: FIPS 140-2(2001-10-10) Long run: 3
> rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
> rngtest: input channel speed: (min=146.002; avg=349.394;
> max=1302083.333)Kibits/s
> rngtest: FIPS tests speed: (min=12.126; avg=22.750; max=23.432)Mibits/s
> rngtest: Program run time: 56826982 microseconds
> 
> 996 successes and 4 failures -> 99.6% success rate
> 1024 * 99.6% = 1019 (rounded down to 1000)
> 
> I'm not sure if I can rely on rngtest for that...

Hi Álvaro

You need some sort of justification for setting the quality
value. Please include what you have written above in the commit
message. It then becomes possible for reviewers to say if this
justification is valid or not.

	Andrew
