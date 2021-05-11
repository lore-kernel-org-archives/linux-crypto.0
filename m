Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA9C6C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 07:57:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A024461400
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 07:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhEKH6b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 03:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhEKH6b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 03:58:31 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 364F2C06175F
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 00:57:25 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l2so19106776wrm.9
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 00:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=S/QitPv103F5Fk6w9tFGA9scLWKx6oxLZ4e1nVahMtw=;
        b=axsYHDrBYk9E/3NeWYW7ESe28m0wldJ8ylDI9300hs3QE24udpCkECgjFy53F45wax
         e5Oe+MUMZo8/v2kkYplL9VVt2Y+l+yNdn+EwQRvZCoHFiyCOTz1tgNweo+rV7i46tz+Z
         sVvythHQ8qfNTZ4VkoHFeYIoquxoAfYtmN80XpSKJFDLb6FWtO1u4nAzVyVdwe9fSb/s
         UP44KYTFwB1yhXxon6HSvKzEklWxei5bF6Y32VCQ7OozAXdhwqC78BAZJoBirdA2uUkD
         bVS2pYYz9GWx2RpJ02g+dR/CIJZFmsjIhcpzYDG7Z6ealA4cxwauxjm7N3oRXN4S5D7n
         NbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=S/QitPv103F5Fk6w9tFGA9scLWKx6oxLZ4e1nVahMtw=;
        b=RRQDoGwhB/M51FYqEdXTZifvcQhtAKaL8Z7IlF99MAWfr8OVw0ggL0UXC4cMzjyMmA
         ZexUVKGVBct6bxBR2Jenn0lI6RTEqM528K6rOH0A7jKoAya5uxc7CG4PpQQbnJGTZBQo
         VmhQXkOQO7/47oo6YsMwUhLYkxu4mrc9pWYQuhNwwB/F98yBlz9Xc5oLoPO2XGhBL+wn
         ladccsiyzOIyExq4/pV2lVVN2NKhkS9fsSY6JyUsDac71oooFkulD7wupeLFZvuXYiYc
         4GznHolzVazI1CACSF/6ZxYrY8hHoU5vllNicgwnQ0ZvBVIts8lgRfl8QJkIttx6Y0ZI
         L3NA==
X-Gm-Message-State: AOAM533qX9CuHhJ+FzY8JmpYUaPla7TMYFVBvD0hmomrauT5A/vd35XE
        kP2I+klRYwnoGNoJeZ5PJQK5w6e/xug=
X-Google-Smtp-Source: ABdhPJypstYo5SbEWz2FNAXbRyfCjQSW/kTphjD6yGe/pk7eM2R+CJ/GoT4HhddoEyak3CI0Wz7GpQ==
X-Received: by 2002:a5d:5310:: with SMTP id e16mr35088107wrv.321.1620719843880;
        Tue, 11 May 2021 00:57:23 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id y14sm26225211wrs.64.2021.05.11.00.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 00:57:23 -0700 (PDT)
Date:   Tue, 11 May 2021 09:57:21 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] crypto: ixp4xx: convert to platform driver
Message-ID: <YJo44WMLPJ54Bbkw@Red>
References: <20210510213634.600866-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210510213634.600866-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Mon, May 10, 2021 at 11:36:32PM +0200, Linus Walleij a écrit :
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The ixp4xx_crypto driver traditionally registers a bare platform
> device without attaching it to a driver, and detects the hardware
> at module init time by reading an SoC specific hardware register.
> 
> Change this to the conventional method of registering the platform
> device from the platform code itself when the device is present,
> turning the module_init/module_exit functions into probe/release
> driver callbacks.
> 
> This enables compile-testing as well as potentially having ixp4xx
> coexist with other ARMv5 platforms in the same kernel in the future.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Herbert, David: I am looking for an ACK to take this
> into the ARM SoC tree as we want to change more stuff in
> the machine at the same time that we want to resolve
> there.
> ---
>  arch/arm/mach-ixp4xx/common.c  | 26 ++++++++++++++++++++++++
>  drivers/crypto/Kconfig         |  3 ++-
>  drivers/crypto/ixp4xx_crypto.c | 37 ++++++++++++----------------------
>  3 files changed, 41 insertions(+), 25 deletions(-)
> 

Hello

With minor editing I successfully added this series on top of my fix series https://lore.kernel.org/patchwork/cover/1421865/

With the following patch, I successfully booted my epbx100 board and the crypto driver loaded.
--- a/arch/arm/boot/dts/intel-ixp4xx.dtsi
+++ b/arch/arm/boot/dts/intel-ixp4xx.dtsi
@@ -61,9 +61,16 @@ timer@c8005000 {
                        interrupts = <5 IRQ_TYPE_LEVEL_HIGH>;
                };
 
-               npe@c8006000 {
+               npe: npe@c8006000 {
                        compatible = "intel,ixp4xx-network-processing-engine";
                        reg = <0xc8006000 0x1000>, <0xc8007000 0x1000>, <0xc8008000 0x1000>;
+
+                       crypto {
+                               compatible = "intel,ixp4xx-crypto";
+                               intel,npe-handle = <&npe 2>;
+                               queue-rx = <&qmgr 30>;
+                               queue-txready = <&qmgr 29>;
+                       };
                };
        };
 };

So you could add
Tested-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
