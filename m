From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 1/3] dt-bindings: hwrng: Add Samsung Exynos 5250+ True
 RNG bindings
Date: Mon, 4 Dec 2017 14:27:58 -0600
Message-ID: <20171204202758.uw4prqbnuvwt6qls@rob-hp-laptop>
References: <20171204125351.26805-1-l.stelmach@samsung.com>
 <CGME20171204125414eucas1p1233c2c8ef5b637c3a4565af875515524@eucas1p1.samsung.com>
 <20171204125351.26805-2-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "Andrew F . Davis" <afd@ti.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>, devicetree@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:46008 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752160AbdLDU2B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Dec 2017 15:28:01 -0500
Content-Disposition: inline
In-Reply-To: <20171204125351.26805-2-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 04, 2017 at 01:53:49PM +0100, Łukasz Stelmach wrote:
> Add binding documentation for the True Random Number Generator
> found on Samsung Exynos 5250+ SoCs.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../devicetree/bindings/rng/samsung,exynos5250-trng.txt | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt

I acked v1 (and so did Krzysztof). You added them in v2, but 
dropped here? 
