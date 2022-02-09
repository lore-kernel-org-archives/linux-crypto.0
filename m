Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D90A0C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Feb 2022 12:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbiBIMHU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Feb 2022 07:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbiBIMGJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Feb 2022 07:06:09 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 03:05:25 PST
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D0EC094C89;
        Wed,  9 Feb 2022 03:05:25 -0800 (PST)
Received: from [91.65.34.88] (helo=diego.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1nHk4p-0000GB-Gs; Wed, 09 Feb 2022 11:19:55 +0100
From:   Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: Re: [PATCH] dt-bindings: crypto: rockchip: fix a typo on crypto-controller
Date:   Wed, 09 Feb 2022 11:19:54 +0100
Message-ID: <4940101.4UnPYNKMnq@diego>
In-Reply-To: <20220209101721.1659574-1-clabbe@baylibre.com>
References: <20220209101721.1659574-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Corentin,

Am Mittwoch, 9. Februar 2022, 11:17:21 CET schrieb Corentin Labbe:
> crypto-controller had a typo, fix it.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

the binding for the crypto-accelerator is pretty standard
without any crazy stuff, so you could also try to convert it
to the yaml format ;-)


Heiko

> ---
>  Documentation/devicetree/bindings/crypto/rockchip-crypto.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> index 5e2ba385b8c9..53e39d5f94e7 100644
> --- a/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> +++ b/Documentation/devicetree/bindings/crypto/rockchip-crypto.txt
> @@ -16,7 +16,7 @@ Required properties:
>  
>  Examples:
>  
> -	crypto: cypto-controller@ff8a0000 {
> +	crypto: crypto-controller@ff8a0000 {
>  		compatible = "rockchip,rk3288-crypto";
>  		reg = <0xff8a0000 0x4000>;
>  		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
> 




