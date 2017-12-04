From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v3 2/3] hwrng: exynos - add Samsung Exynos True RNG driver
Date: Mon, 4 Dec 2017 14:19:16 +0100
Message-ID: <CAJKOXPcbyMV7n2TEWn9QzPLbwGor1R6ReyT+tY=MVUVt=_WL=g@mail.gmail.com>
References: <CGME20171204125415eucas1p1f94e6996f08938f686c08c00247c62ce@eucas1p1.samsung.com>
 <20171204125351.26805-1-l.stelmach@samsung.com> <20171204125351.26805-3-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: "Andrew F . Davis" <afd@ti.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751205AbdLDNTT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Dec 2017 08:19:19 -0500
In-Reply-To: <20171204125351.26805-3-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 4, 2017 at 1:53 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> Add support for True Random Number Generator found in Samsung Exynos
> 5250+ SoCs.
>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  MAINTAINERS                          |   7 +
>  drivers/char/hw_random/Kconfig       |  12 ++
>  drivers/char/hw_random/Makefile      |   1 +
>  drivers/char/hw_random/exynos-trng.c | 245 +++++++++++++++++++++++++++++++++++
>  4 files changed, 265 insertions(+)
>  create mode 100644 drivers/char/hw_random/exynos-trng.c

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
