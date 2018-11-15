Return-Path: <SRS0=OCay=N2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725741AbeKPFM2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 00:12:28 -0500
MIME-Version: 1.0
References: <0f5fe0d5b6a9c81b3f4395a1007ed0ba2239ae45.1541574485.git.ryder.lee@mediatek.com>
In-Reply-To: <0f5fe0d5b6a9c81b3f4395a1007ed0ba2239ae45.1541574485.git.ryder.lee@mediatek.com>
From: Sean Wang <sean.wang@kernel.org>
Date: Thu, 15 Nov 2018 11:03:16 -0800
Message-ID: <CAGp9LzofO3SPXcXsqj2pheKAP-fNSDupiR3WzW5_0_LDesLzdg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: rng: update bindings for MT7629 SoC
To: ryder.lee@mediatek.com
Cc: herbert@gondor.apana.org.au, robh+dt@kernel.org,
        devicetree@vger.kernel.org, weijie.gao@mediatek.com,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-crypto@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 6, 2018 at 11:11 PM Ryder Lee <ryder.lee@mediatek.com> wrote:
>
> This updates bindings for MT7629 RNG driver.
>
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>

Acked-by: Sean Wang <sean.wang@kernel.org>

> ---
>  Documentation/devicetree/bindings/rng/mtk-rng.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/devicetree/bindings/rng/mtk-rng.txt b/Documentation/devicetree/bindings/rng/mtk-rng.txt
> index 366b99b..ffa6a66 100644
> --- a/Documentation/devicetree/bindings/rng/mtk-rng.txt
> +++ b/Documentation/devicetree/bindings/rng/mtk-rng.txt
> @@ -1,9 +1,10 @@
>  Device-Tree bindings for Mediatek random number generator
> -found in Mediatek SoC family
> +found in MediaTek SoC family
>
>  Required properties:
>  - compatible       : Should be
>                         "mediatek,mt7622-rng",  "mediatek,mt7623-rng" : for MT7622
> +                       "mediatek,mt7629-rng",  "mediatek,mt7623-rng" : for MT7629
>                         "mediatek,mt7623-rng" : for MT7623
>  - clocks           : list of clock specifiers, corresponding to
>                       entries in clock-names property;
> --
> 1.9.1
>
>
> _______________________________________________
> Linux-mediatek mailing list
> Linux-mediatek@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-mediatek
