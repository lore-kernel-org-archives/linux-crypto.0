From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: exynos - Icrease the priority of the driver
Date: Tue, 05 Dec 2017 17:31:43 +0100
Message-ID: <9231403.yDZly3VKsd@tauon.chronox.de>
References: <CGME20171205162048eucas1p241590a1f62f8c49af8a7fb9282daed80@eucas1p2.samsung.com> <20171205162046.11621-1-l.stelmach@samsung.com>
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
Received: from mail.eperm.de ([89.247.134.16]:42802 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751062AbdLEQbq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Dec 2017 11:31:46 -0500
In-Reply-To: <20171205162046.11621-1-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 5. Dezember 2017, 17:20:46 CET schrieb Łukasz Stelmach:

Hi Łukasz,

> exynos-rng is one of many implementations of stdrng. With priority as
> low as 100 it isn't selected, if software implementations (DRBG) are
> available. The value 300 was selected to give the PRNG priority before
> software implementations, but allow them to be selected in FIPS-mode
> (fips=1 in the kernel command line).
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>

Reviewed-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
