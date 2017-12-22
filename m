From: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Subject: Re: [PATCH v3 2/3] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Fri, 22 Dec 2017 19:24:12 +1100
Message-ID: <20171222082412.GB29663@gondor.apana.org.au>
References: <20171204125351.26805-1-l.stelmach@samsung.com>
 <CGME20171204125415eucas1p1f94e6996f08938f686c08c00247c62ce@eucas1p1.samsung.com>
 <20171204125351.26805-3-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "Andrew F . Davis" <afd-l0cyMroinI0@public.gmane.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Matt Mackall <mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org>,
        Krzysztof Kozlowski <krzk-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Kukjin Kim <kgene-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-samsung-soc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Marek Szyprowski <m.szyprowski-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
To: =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171204125351.26805-3-l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Dec 04, 2017 at 01:53:50PM +0100, Łukasz Stelmach wrote:
> Add support for True Random Number Generator found in Samsung Exynos
> 5250+ SoCs.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>

This doesn't build for me:

  CC [M]  drivers/char/hw_random/exynos-trng.o
../drivers/char/hw_random/exynos-trng.c:230:1: error: \u2018exynos_rng_dt_match\u2019 undeclared here (not in a function)
../drivers/char/hw_random/exynos-trng.c:230:1: error: \u2018__mod_of__exynos_rng_dt_match_device_table\u2019 aliased to undefined symbol \u2018exynos_rng_dt_match\u2019
make[2]: *** [drivers/char/hw_random/exynos-trng.o] Error 1
make[1]: *** [_module_drivers/char/hw_random] Error 2

Cheers,
-- 
Email: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
