From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/3] crypto: exynos - Reseed PRNG after generating 2^16 random bytes
Date: Tue, 05 Dec 2017 14:52:31 +0100
Message-ID: <6915204.SlqusmoAzB@tauon.chronox.de>
References: <20171205123558.31087-1-l.stelmach@samsung.com> <CGME20171205123604eucas1p2a6a2738e3cf1f9c300e8d128362429ed@eucas1p2.samsung.com> <20171205123558.31087-4-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Krzysztof Kozlowski <krzk@kernel.org>, robh+dt@kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com
To: =?utf-8?B?xYF1a2Fzeg==?= Stelmach <l.stelmach@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42780 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751937AbdLENwe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 08:52:34 -0500
In-Reply-To: <20171205123558.31087-4-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 5. Dezember 2017, 13:35:58 CET schrieb Łukasz Stelmach:

Hi Łukasz,

> Reseed PRNG after reading 65 kB of randomness. Although this may reduce
> performance, in most casese the loss is not noticable.

Please add to the log that you also increase the timer-based reseed to 1 
second?!

Another suggestion: maybe you want to add a comment to the reseed function to 
indicate it is for enhanced backtracking resistance. Otherwise a lot of folks 
would scratch their head why such code exists in the first place. :-)

Other than that:

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
