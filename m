From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v3 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Sun, 26 Mar 2017 23:25:24 +0200
Message-ID: <4479175.Jfq03yCxQW@tauon.atsec.com>
References: <20170325162654.3827-1-krzk@kernel.org> <2736911.EcZSki4vB1@positron.chronox.de> <20170326180012.3eic4bt2p6h6u3nh@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58582 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751609AbdCZV0Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 17:26:24 -0400
In-Reply-To: <20170326180012.3eic4bt2p6h6u3nh@kozik-lap>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 26. März 2017, 20:00:12 CEST schrieb Krzysztof Kozlowski:

Hi Krzysztof,

> > Would it make sense to add another outer loop here to allow all of slen to
> > be injected into the DRNG? Note, in some cases, a user wants to add more
> > seed into the DRNG than the actual seed size. In this case, the DRNG acts
> > as a compression operation of entropy. This is used when the
> > entropy-to-data ratio is not 1:1. In a lot of cases, users have a seed
> > which has less entropy in bits per data bit.
> 
> Hi,
> 
> I do not know whether this would have any benefit on hardware. The
> datasheet is not describing too much here. It is actually saying only:
> 1. Write SEED to each register (five in total).
> 2. Confirm that STATUS register says seeding done.
> 3. Start RNG engine.
> 4. Wait for engine finish (another bit in STATUS - clear it then).
> 5. Read the randoms.
> 
> I would guess that the hardware will ignore all previously written seeds
> and use the last one. Maybe the hardware will use all of the seeds
> written as you imply. It is just a guessing.

Oh my, if you are right with your first guess, this is a bad DRNG design.

Just out of curiousity: what happens if a caller invokes the seed function 
twice or more times (each time with the sufficient amount of bits)? What is 
your guess here?

Ciao
Stephan
