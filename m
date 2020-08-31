Return-Path: <SRS0=nLyl=CJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E820CC433E6
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 06:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDB3F206B5
	for <linux-crypto@archiver.kernel.org>; Mon, 31 Aug 2020 06:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJ8cF7PT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgHaGeh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 31 Aug 2020 02:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgHaGea (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Aug 2020 02:34:30 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822CAC061573;
        Sun, 30 Aug 2020 23:34:30 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q9so4279963wmj.2;
        Sun, 30 Aug 2020 23:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZP1iGX70R6WBiUNO1tOXFyMcuHcjl1P18JgeTI2dD4c=;
        b=GJ8cF7PTYPGqReRtR4re5LgMZeUffjNB2POodeR5VWXtozhKn1QnVm9UGIGIV/YDGn
         ECBu6Ltxw/XVa/OG3q/hSDF/cr+L26H5usMZQW7NC4tHUeoVUH+X5a1csICElBJWDXWD
         xjJoW/3lKtyLLjDx/53+ZgW9pPYDJ2allVLRY4aWJTfTiE0VNdODR2Lh/Zbx5X+3RsxJ
         A7+Hlzv1lQfF/H3InZltg1ePkJcbEfF1a8y7DgL2xCLAzfhhuyA5Hr+C5cJQEjq6gaZb
         pIYQhjUPMmOKyYSlJMNT9+jSpvpgwLjjEgiBWOjhEQ9O04H1IVlg36iBUqoe83jl+ipQ
         stxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZP1iGX70R6WBiUNO1tOXFyMcuHcjl1P18JgeTI2dD4c=;
        b=jVTJk/xFmklqWLoqimhCS7bcDdCI4jDS89LAXA5q8v9lkDokOEaoogjOAOY8CxgAJB
         wqN5yQYZc0hDKbZK7e6wxKJfHX8U0M3taJHXVVZCjnyGYZT2benlJAYBgHtDl3hiDeop
         BiWrwxlAqnAhJBG+aqr57xLC48PaeENzzM5DWpFajXLl5ET5AMqBNminSeqVgQIDddg2
         dqi//gaK5YWbqvGtMR6ALTwaUoxAzbDfAl+ETMxetnbbiXXDNtPeQuOY7KIil/ZxxeFX
         rISlSXYfDJ76uAV81FOzW9rFnoz46tJfH4AY5Q2waREmCzpH9bwfG9jYjONrJby88mpY
         M6vw==
X-Gm-Message-State: AOAM530BwpQF6d4rx9epPvvxnast+hh088eiuBhDiLhuy2asZjZlnlNV
        gu8LhPwVzGgE1SfeMMXfvr5z94Q4fvE=
X-Google-Smtp-Source: ABdhPJzF0UppAc4MASa721wAZz4ZjrCxQwb20+xfqZzysOU4TggFFq5EbI81tQEF4nDVs7iIdOjAQQ==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr269837wma.81.1598855668861;
        Sun, 30 Aug 2020 23:34:28 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id f6sm11682451wme.32.2020.08.30.23.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2020 23:34:28 -0700 (PDT)
Date:   Mon, 31 Aug 2020 08:34:26 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Martin Cerveny <m.cerveny@computer.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        robh+dt@kernel.org, mripard@kernel.org, wens@csie.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: sun8i: v3s: Enable crypto engine
Message-ID: <20200831063426.GA18853@Red>
References: <20200827180027.6254-1-m.cerveny@computer.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827180027.6254-1-m.cerveny@computer.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 08:00:27PM +0200, Martin Cerveny wrote:
> V3S contains crypto engine that is compatible with "sun4i-ss".
> 
> Tested-by: Martin Cerveny <m.cerveny@computer.org>
> Signed-off-by: Martin Cerveny <m.cerveny@computer.org>
> ---
>  .../bindings/crypto/allwinner,sun4i-a10-crypto.yaml    |  5 ++++-
>  arch/arm/boot/dts/sun8i-v3s.dtsi                       | 10 ++++++++++
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c      |  7 +++++++
>  3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> index fc823572b..180efd13a 100644
> --- a/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun4i-a10-crypto.yaml
> @@ -25,6 +25,7 @@ properties:
>            - const: allwinner,sun4i-a10-crypto
>        - items:
>            - const: allwinner,sun8i-a33-crypto
> +      - const: allwinner,sun8i-v3s-crypto
>  
>    reg:
>      maxItems: 1
> @@ -59,7 +60,9 @@ if:
>    properties:
>      compatible:
>        contains:
> -        const: allwinner,sun6i-a31-crypto
> +        oneOf:
> +          - const: allwinner,sun6i-a31-crypto
> +          - const: allwinner,sun8i-v3s-crypto
>  
>  then:
>    required:
> diff --git a/arch/arm/boot/dts/sun8i-v3s.dtsi b/arch/arm/boot/dts/sun8i-v3s.dtsi
> index e5312869c..4fec84c40 100644
> --- a/arch/arm/boot/dts/sun8i-v3s.dtsi
> +++ b/arch/arm/boot/dts/sun8i-v3s.dtsi
> @@ -234,6 +234,16 @@
>  			#size-cells = <0>;
>  		};
>  
> +		crypto: crypto@1c15000 {
> +			compatible = "allwinner,sun8i-v3s-crypto";
> +			reg = <0x01c15000 0x1000>;
> +			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
> +			clock-names = "ahb", "mod";
> +			resets = <&ccu RST_BUS_CE>;
> +			reset-names = "ahb";
> +		};
> +
>  		usb_otg: usb@1c19000 {
>  			compatible = "allwinner,sun8i-h3-musb";
>  			reg = <0x01c19000 0x0400>;
> diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> index a2b67f7f8..d24496cac 100644
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-core.c
> @@ -31,6 +31,10 @@ static const struct ss_variant ss_a33_variant = {
>  	.sha1_in_be = true,
>  };
>  
> +static const struct ss_variant ss_v3s_variant = {
> +	.sha1_in_be = true,
> +};
> +
>  static struct sun4i_ss_alg_template ss_algs[] = {
>  {       .type = CRYPTO_ALG_TYPE_AHASH,
>  	.mode = SS_OP_MD5,
> @@ -505,6 +509,9 @@ static const struct of_device_id a20ss_crypto_of_match_table[] = {
>  	{ .compatible = "allwinner,sun8i-a33-crypto",
>  	  .data = &ss_a33_variant
>  	},
> +	{ .compatible = "allwinner,sun8i-v3s-crypto",
> +	  .data = &ss_v3s_variant
> +	},
>  	{}
>  };
>  MODULE_DEVICE_TABLE(of, a20ss_crypto_of_match_table);
> -- 
> 2.17.1
> 

You should split at least drivers/crypto and the dts part, as drivers/crypto patchs are merged via the cryptodev tree and dts/doc will be merged via the sunxi tree.
And ideally split patch in 3, the doc, the dts and the crypto.
See how I added the same for A33 in:
https://lore.kernel.org/linux-arm-kernel/20191120152833.20443-1-clabbe.montjoie@gmail.com/

Anyway the content is good.
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
