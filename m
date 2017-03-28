From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v3 1/3] crypto: hw_random - Add new Exynos RNG driver
Date: Tue, 28 Mar 2017 19:41:47 +0200
Message-ID: <93183073.lKE0KLq0vu@tauon.atsec.com>
References: <20170325162654.3827-1-krzk@kernel.org> <1564458.pWTRdRYEuG@positron.chronox.de> <20170328164824.3qjaojqzf2riwpqj@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Kukjin Kim <kgene@kernel.org>,
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
Received: from mail.eperm.de ([89.247.134.16]:58648 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752080AbdC1Rly (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 13:41:54 -0400
In-Reply-To: <20170328164824.3qjaojqzf2riwpqj@kozik-lap>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 28. März 2017, 18:48:24 CEST schrieb Krzysztof Kozlowski:

Hi Krzysztof,

> I tested a little bit and:
> 1. Seeding with some value
> 2. generating random,
> 3. kcapi_rng_destroy+kcrng_init, (I cannot do a hardware reset except
>    reboot of entire system)
> 4. seeding with the same value as in (1) - different random numbers.
> 
> Doing a system reboot and repeating above - different random numbers
> (all are different: step (2) and in (4)).
> 
> Your test case also produces different random values every time.

Then I would assume that simply adding an outer loop to your for() loop to 
inject seed larger than the minimum required seed size should be fine.
> 
> Best regards,
> Krzysztof



Ciao
Stephan
