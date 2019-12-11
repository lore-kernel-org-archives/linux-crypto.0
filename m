Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B750C3F68F
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 10:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41DF522464
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 10:42:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kOm19GDw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfLKKmD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 05:42:03 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:40665 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbfLKKmD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 05:42:03 -0500
Received: by mail-il1-f195.google.com with SMTP id b15so18997471ila.7;
        Wed, 11 Dec 2019 02:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ytdBVhk/qhHIU0f1ejIbJ7Mj79TlpQjDmvTTuwp3S/w=;
        b=kOm19GDwtrHwCIEW2BVH8UFPDw9yPqTLsunbaXqDGj8DbJC4FeLahCOjAkBmfU8jdq
         wlCP5QKmvhJzEGgRObxhFZqvpWiWfgbhA2rJQlVa+c1qcr2VGMOunxaVzcb3B//KeX32
         oVP5L12yfCwgZGBOrX5n7wnQ/mW3lEUH84HuypEIDoZGMUiAOtWCSqL/4qjn8Cu5Xbvd
         UUFyq0WuaYJTyaQ+qFnFZM/ag7JkZE0chQK0S8iH5rc+sv4RJxXT9VFTBhYsd4Xj5xmE
         jku0y7RZm8ZfYNo2z8sqpTmN3POmLJaolkukjqI89zqQsqf1wMaqekHud4CRRVefPxFa
         6XXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ytdBVhk/qhHIU0f1ejIbJ7Mj79TlpQjDmvTTuwp3S/w=;
        b=b0iZUfnNZeEN30Q0FDH3ml5rMT2uStFnV0r9C3IPyOI8YlauugLVmK3ou9+7Zln21i
         gvVqTDAMp4y9Gowh9VAMlmWRg88QuFRL7QwkI91fwlaQuc1KJf9bsXO50kcdph2KRmSS
         8GhNpQzIui4oAw3zPy31a+nfhfhkF0d7crAFXbwdDyu0lAqQufkeDO2D7bqaTKpeMZz4
         3SudhUoOQpe+G2zSBu55YV3Qd4qVgzujDcUw4T1PSy3+X99ZNMhrNZ8zVUVfDHC+tY8o
         2BVaL3B/7ruS7Fm1LeH8TJxPJVLKCMzoyE3TZj4PAIP0f/UAMJ8VJusU1Fh+DTJBt2Gg
         f7Fg==
X-Gm-Message-State: APjAAAW7VWKmOqIlOIMcbU7DD9e6zd1SEM72J0XjEoXEFbyDv8UC1KYF
        k09nhva/Rd3opx/icsicSlrN9T0K6AotSTaygMg=
X-Google-Smtp-Source: APXvYqzIxiN8rtHbQW0oVmIRPfEAsZq+Jg6CQUNJF2OQPs6YegAImh5AqiNO0lzZwdGY8+YC11yEKidsfRdIltG2fDE=
X-Received: by 2002:a92:5d92:: with SMTP id e18mr2311277ilg.75.1576060922553;
 Wed, 11 Dec 2019 02:42:02 -0800 (PST)
MIME-Version: 1.0
References: <20191211084112.971-1-linux.amoon@gmail.com> <20191211084112.971-2-linux.amoon@gmail.com>
In-Reply-To: <20191211084112.971-2-linux.amoon@gmail.com>
From:   Anand Moon <linux.amoon@gmail.com>
Date:   Wed, 11 Dec 2019 16:11:51 +0530
Message-ID: <CANAwSgRLCNUxmiaRNBSQ9ysAFs+RpnbBqZGZ4bq4=BzdnPRR2g@mail.gmail.com>
Subject: Re: [PATCHv1 1/3] arm64: dts: amlogic: adds crypto hardware node for
 GXBB SoCs
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-amlogic@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Neil,

On Wed, 11 Dec 2019 at 14:11, Anand Moon <linux.amoon@gmail.com> wrote:
>
> This patch adds the crypto hardware node for all GXBB SoCs.
>
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Signed-off-by: Anand Moon <linux.amoon@gmail.com>
> ---
> Tested on Odroid C2 GXBB
> ---
>  arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> index 0cb40326b0d3..bac8fbfd4f01 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
> @@ -14,6 +14,16 @@ / {
>         compatible = "amlogic,meson-gxbb";
>
>         soc {
> +               crypto: crypto@c883e000 {

My mistake I got this reg value wrong, as per the
"S905_Public_Datasheet_V1.1.4" [0]
it should be *0xda832000 + offset*4*
I changes this at my end but I get kernel panic on loading the module.

# sudo modprobe tcrypt sec=1 mode=500

It's looks like the crypto node is wrongly configured.

> +                       compatible = "amlogic,gxbb-crypto";
> +                       reg = <0x0 0xc883e000 0x0 0x36>;
> +                       interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>,
> +                                    <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
> +                       clocks = <&clkc CLKID_BLKMV>;
> +                       clock-names = "blkmv";
> +                       status = "okay";
> +               };
> +
>                 usb0_phy: phy@c0000000 {
>                         compatible = "amlogic,meson-gxbb-usb2-phy";
>                         #phy-cells = <0>;
> --
> 2.24.0
>

[0] https://dn.odroid.com/S905/DataSheet/S905_Public_Datasheet_V1.1.4.pdf

-Anand
