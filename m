From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 2/3] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Fri, 22 Dec 2017 19:35:51 +1100
Message-ID: <20171222083551.GF29663@gondor.apana.org.au>
References: <20171204125351.26805-1-l.stelmach@samsung.com>
 <CGME20171204125415eucas1p1f94e6996f08938f686c08c00247c62ce@eucas1p1.samsung.com>
 <20171204125351.26805-3-l.stelmach@samsung.com>
 <20171222082412.GB29663@gondor.apana.org.au>
 <916163bb-594b-779d-700c-de9fa15239dd@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        "Andrew F . Davis" <afd@ti.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46198 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751885AbdLVIf7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 03:35:59 -0500
Content-Disposition: inline
In-Reply-To: <916163bb-594b-779d-700c-de9fa15239dd@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 22, 2017 at 09:29:38AM +0100, Marek Szyprowski wrote:
> Hi,
> 
> On 2017-12-22 09:24, Herbert Xu wrote:
> >On Mon, Dec 04, 2017 at 01:53:50PM +0100, Łukasz Stelmach wrote:
> >>Add support for True Random Number Generator found in Samsung Exynos
> >>5250+ SoCs.
> >>
> >>Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> >This doesn't build for me:
> >
> >   CC [M]  drivers/char/hw_random/exynos-trng.o
> >../drivers/char/hw_random/exynos-trng.c:230:1: error: \u2018exynos_rng_dt_match\u2019 undeclared here (not in a function)
> >../drivers/char/hw_random/exynos-trng.c:230:1: error: \u2018__mod_of__exynos_rng_dt_match_device_table\u2019 aliased to undefined symbol \u2018exynos_rng_dt_match\u2019
> >make[2]: *** [drivers/char/hw_random/exynos-trng.o] Error 1
> >make[1]: *** [_module_drivers/char/hw_random] Error 2
> 
> This looks like a missing dependency on "OF" when "COMPILE_TEST" is
> selected.

Actually it looks like a typo.  The variable is actually called
exynos_trng_dt_match as opposed to exynos_rng_dt_match.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
