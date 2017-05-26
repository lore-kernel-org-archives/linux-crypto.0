From: Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH 2/2] crypto: mediatek - update DT binding documentation
Date: Fri, 26 May 2017 16:15:23 +0200
Message-ID: <a16ecc4c-2d82-1239-ec57-94dd3b24efb0@gmail.com>
References: <1495791789-19230-1-git-send-email-ryder.lee@mediatek.com>
 <1495791789-19230-2-git-send-email-ryder.lee@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        linux-mediatek@lists.infradead.org, linux-crypto@vger.kernel.org
To: Ryder Lee <ryder.lee@mediatek.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34790 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940721AbdEZOP1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2017 10:15:27 -0400
In-Reply-To: <1495791789-19230-2-git-send-email-ryder.lee@mediatek.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 26/05/17 11:43, Ryder Lee wrote:
> This patch removes unnecessary clock in binding file.
> 
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
> ---

In the driver clocks are get by name, so this change does not break 
backwards compatibility.

Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>

>   Documentation/devicetree/bindings/crypto/mediatek-crypto.txt | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
> index c204725..450da36 100644
> --- a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
> +++ b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
> @@ -6,8 +6,7 @@ Required properties:
>   - interrupts: Should contain the five crypto engines interrupts in numeric
>   	order. These are global system and four descriptor rings.
>   - clocks: the clock used by the core
> -- clock-names: the names of the clock listed in the clocks property. These are
> -	"ethif", "cryp"
> +- clock-names: Must contain "cryp".
>   - power-domains: Must contain a reference to the PM domain.
>   
>   
> @@ -20,8 +19,7 @@ Example:
>   			     <GIC_SPI 84 IRQ_TYPE_LEVEL_LOW>,
>   			     <GIC_SPI 91 IRQ_TYPE_LEVEL_LOW>,
>   			     <GIC_SPI 97 IRQ_TYPE_LEVEL_LOW>;
> -		clocks = <&topckgen CLK_TOP_ETHIF_SEL>,
> -			 <&ethsys CLK_ETHSYS_CRYPTO>;
> -		clock-names = "ethif","cryp";
> +		clocks = <&ethsys CLK_ETHSYS_CRYPTO>;
> +		clock-names = "cryp";
>   		power-domains = <&scpsys MT2701_POWER_DOMAIN_ETH>;
>   	};
> 
