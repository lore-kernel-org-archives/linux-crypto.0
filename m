From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH 3/3] ARM: dts: exynos: Add nodes for True Random Number Generator
Date: Thu, 23 Nov 2017 17:33:04 +0100
Message-ID: <CAJKOXPf18cX_3vy-UdSZpyX6EV8DoR9TGYmspow8M_qNhw4-4g@mail.gmail.com>
References: <CGME20171123151008eucas1p24436487b1b3f8de6d8cc768f05aea7a9@eucas1p2.samsung.com>
 <20171123150914.31462-1-l.stelmach@samsung.com> <20171123150914.31462-4-l.stelmach@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Rob Herring <robh+dt@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751807AbdKWQdH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Nov 2017 11:33:07 -0500
In-Reply-To: <20171123150914.31462-4-l.stelmach@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 23, 2017 at 4:09 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> Add nodes for the True Random Number Generator found in Samsung Exynos
> 5250+ SoCs.
>
> Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5.dtsi    | 5 +++++
>  arch/arm/boot/dts/exynos5250.dtsi | 5 +++++
>  arch/arm/boot/dts/exynos5410.dtsi | 5 +++++
>  arch/arm/boot/dts/exynos5420.dtsi | 5 +++++
>  4 files changed, 20 insertions(+)
>

Look okay, I'll take it once bindings and driver get accepted as wel.

Best regards,
Krzysztof
