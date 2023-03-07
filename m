Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63AA2C678D5
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Mar 2023 20:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjCGUzt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Mar 2023 15:55:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjCGUzs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Mar 2023 15:55:48 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54DD559F2
        for <linux-crypto@vger.kernel.org>; Tue,  7 Mar 2023 12:55:46 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so17816230pjb.3
        for <linux-crypto@vger.kernel.org>; Tue, 07 Mar 2023 12:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20210112.gappssmtp.com; s=20210112; t=1678222546;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PO0KQCxzIVJEU61zfS2DoDmuDuWz5uR1jN4Ijq9LhZo=;
        b=lpHxnwwPK15OkkFaTvNUoMCaaJEJi5c9/PYeQlJ2jMiPjoPkgwrepzfmkgtyO8O+HT
         wu3juAerU/L8cjIvUiZtQspVCHC1d+932kvi9FW+xS58qaCCsLdpwmai+bjXxQUdzCBk
         l5mlHFpS9jE3/r4xQTsIA2O/p/CuMHJIkcb3A1pOHy9/Eybrn33WBmaDgDf4G3UIfr1c
         iefB4omy/roI6W5ox5wVdjkHqU98G/aw2ZD5T4ZB2CVf1Z6vufEQTV3jCShu28V1PcbC
         KCwAXE2IWqbcaM7JP5Wtn8oVYsGG0J89eG+an5RJcAvSARQQ+1X9OB8PkFV4ARWVOREC
         56Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678222546;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PO0KQCxzIVJEU61zfS2DoDmuDuWz5uR1jN4Ijq9LhZo=;
        b=gX4bvZKeYMkPps6qDyy7WeDMy4VruXuRrDfQcu6Cn0s8tsfbkXZ16ynXSaYuFFaF3J
         pNdge5ulrK1vA9NuxKKTwk5MBJrsCH33/9GIaNjYFbep+0vvOOYayNFiX1D8KVG5LMv/
         d0lkue8l/Tj8Yc9+seBoHocTr3ZzqmX7O1RUb92+b7JuqIYyeNGtOFoI1lcoKIu6mGq+
         tc2kN/hLNy2Idl3uq+8mGOB5Czo5lthjhBh+zNeH5zquoyZ3tnOxPTzMx/8lfUtTS/nn
         XMSQyjbdzt0GwjZNUFcCQEMPFYnMTHQIgn3bWvpBOE8FO/g+d5KNGynYEuuxCAdgtK3b
         /9Dw==
X-Gm-Message-State: AO0yUKWy0Xtw0ZoDY7JcOx1+hYm1gRiGTAycpmafb/+49yq2rZM0H6Yn
        wC5NYuFF988Wt/J01/qAeFSlng==
X-Google-Smtp-Source: AK7set8dzNL26UJcqtdZJRUN5setrL9jyj2OiCFQRqVQnRmvelN4BI2oq+p+jIfWk57Ieeg5LqLM/Q==
X-Received: by 2002:a17:902:bc42:b0:19e:6a4c:9fa0 with SMTP id t2-20020a170902bc4200b0019e6a4c9fa0mr14126770plz.49.1678222546093;
        Tue, 07 Mar 2023 12:55:46 -0800 (PST)
Received: from localhost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902c1c600b0019c2cf1554csm8814373plc.13.2023.03.07.12.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 12:55:45 -0800 (PST)
Date:   Tue, 07 Mar 2023 12:55:45 -0800 (PST)
X-Google-Original-Date: Tue, 07 Mar 2023 12:54:38 PST (-0800)
Subject:     Re: [PATCH v2 3/3] riscv: dts: allwinner: d1: Add crypto engine node
In-Reply-To: <20221231220146.646-4-samuel@sholland.org>
CC:     clabbe.montjoie@gmail.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, wens@csie.org, jernej.skrabec@gmail.com,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        samuel@sholland.org, aou@eecs.berkeley.edu,
        Conor Dooley <conor@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-sunxi@lists.linux.dev
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     samuel@sholland.org
Message-ID: <mhng-0ef61e01-7731-4c5f-9487-e4ab8553b87c@palmer-ri-x1c9a>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, 31 Dec 2022 14:01:45 PST (-0800), samuel@sholland.org wrote:
> D1 contains a crypto engine which is supported by the sun8i-ce driver.
>
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
>
> Changes in v2:
>  - New patch for v2
>
>  arch/riscv/boot/dts/allwinner/sunxi-d1s-t113.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/arch/riscv/boot/dts/allwinner/sunxi-d1s-t113.dtsi b/arch/riscv/boot/dts/allwinner/sunxi-d1s-t113.dtsi
> index dff363a3c934..b30b4b1465f6 100644
> --- a/arch/riscv/boot/dts/allwinner/sunxi-d1s-t113.dtsi
> +++ b/arch/riscv/boot/dts/allwinner/sunxi-d1s-t113.dtsi
> @@ -378,6 +378,18 @@ sid: efuse@3006000 {
>  			#size-cells = <1>;
>  		};
>
> +		crypto: crypto@3040000 {
> +			compatible = "allwinner,sun20i-d1-crypto";
> +			reg = <0x3040000 0x800>;
> +			interrupts = <SOC_PERIPHERAL_IRQ(52) IRQ_TYPE_LEVEL_HIGH>;
> +			clocks = <&ccu CLK_BUS_CE>,
> +				 <&ccu CLK_CE>,
> +				 <&ccu CLK_MBUS_CE>,
> +				 <&rtc CLK_IOSC>;
> +			clock-names = "bus", "mod", "ram", "trng";
> +			resets = <&ccu RST_BUS_CE>;
> +		};
> +
>  		mbus: dram-controller@3102000 {
>  			compatible = "allwinner,sun20i-d1-mbus";
>  			reg = <0x3102000 0x1000>,

Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
