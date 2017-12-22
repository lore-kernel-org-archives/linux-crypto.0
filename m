From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: exynos - Icrease the priority of the driver
Date: Fri, 22 Dec 2017 19:38:29 +1100
Message-ID: <20171222083829.GB30924@gondor.apana.org.au>
References: <CGME20171205162048eucas1p241590a1f62f8c49af8a7fb9282daed80@eucas1p2.samsung.com>
 <20171205162046.11621-1-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Krzysztof Kozlowski <krzk@kernel.org>, robh+dt@kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        m.szyprowski@samsung.com, b.zolnierkie@samsung.com
To: =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46278 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751407AbdLVIim (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 03:38:42 -0500
Content-Disposition: inline
In-Reply-To: <20171205162046.11621-1-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 05, 2017 at 05:20:46PM +0100, Łukasz Stelmach wrote:
> exynos-rng is one of many implementations of stdrng. With priority as
> low as 100 it isn't selected, if software implementations (DRBG) are
> available. The value 300 was selected to give the PRNG priority before
> software implementations, but allow them to be selected in FIPS-mode
> (fips=1 in the kernel command line).
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
