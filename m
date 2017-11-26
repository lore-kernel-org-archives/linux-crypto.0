From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH 1/3] dt-bindings: hwrng: Add Samsung Exynos 5250+ True
 RNG bindings
Date: Sun, 26 Nov 2017 16:07:09 -0600
Message-ID: <20171126220709.3wmbndorzny2okar@rob-hp-laptop>
References: <20171123150914.31462-1-l.stelmach@samsung.com>
 <CGME20171123151002eucas1p207b8eb77fce5a2977a9f520e05dfe9f5@eucas1p2.samsung.com>
 <20171123150914.31462-2-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34291 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751816AbdKZWHN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Nov 2017 17:07:13 -0500
Content-Disposition: inline
In-Reply-To: <20171123150914.31462-2-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 23, 2017 at 04:09:12PM +0100, Łukasz Stelmach wrote:
> Add binding documentation for the True Random Number Generator
> found on Samsung Exynos 5250+ SoCs.
> 
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  .../devicetree/bindings/rng/samsung,exynos5250-trng.txt | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/samsung,exynos5250-trng.txt

Acked-by: Rob Herring <robh@kernel.org>
