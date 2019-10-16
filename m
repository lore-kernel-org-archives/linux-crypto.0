Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A77A6FA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 16:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 801C121835
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 16:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="Fqt4lOhA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406510AbfJPQwr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 12:52:47 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38926 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406509AbfJPQwq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 12:52:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id p12so5295059pgn.6
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2019 09:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=DWB28C23b4LvznGkG5ZeUrO8QaxjHT8svafhe7nPaII=;
        b=Fqt4lOhAUnwSxBzgtRVB2hal9xbqZxbyM6Sh7YLtYAQ9a9+L1sF3rBWAwWldX6BbAQ
         VmNZDebEzUpKD+9uXmhyU0PPgZ6oJfmecVjpa/valJuWqzb+mdfzfZ2XUaW5tb/5ENrF
         99RIBdhdicBLu2QI3kdHUbBJWeP+6N1sm+ximgH1b6AXpqq9zjtYzFMRLExakZJoTpMc
         /G9oUKnLPTI9a/+cESsKQS8dNxahHXoQfwlDF5IcgIaWK6DcWrG5b1tG+vZsV7N+L6Nv
         JtwEnkf/v8cm4HjNLyZK0UyY31vIdn4JBCyP7yMFIbLXqMyo2Zwc9yddVNtO5FnFhdOD
         J5HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=DWB28C23b4LvznGkG5ZeUrO8QaxjHT8svafhe7nPaII=;
        b=kodeL7gtnE0ovnbnrFZHC1mNRxaZRay7Ycjd6OtLlL5WgvWRX53MrdX2IVZk/ZHN17
         OMW4cMIdGnAK5pxq7HZTNOG5fxcAaKw7QVvFVZXO7dNIrWuc9bVRFaEah5Lh9MjDNi6X
         Foz+01BIECtGjK3jaQ+0xReLc4kUrB419kKqWPDaZEp9mkI7N0ztcLYYclGD64ESiYMI
         dlPsk1igWBw9/3auIdtNwqxPejxUWBnn1F1zQH0q/SQs1G0uxgjr/dvNxr4GbmjEfyu1
         SyqvToqJ1FoCRgHJOr1OAnbgoOmJQXBfz2uSoPAoHBA8kAGnsgzoUOvMGXzds1OWbsqh
         szGQ==
X-Gm-Message-State: APjAAAWmM/2VWB0c0qfgzwXsdygxTrfpjDG62Q2Ian7w1P4zqdYtHfxS
        1q0W7kPgZKf5Dxdm9CO5vNOGiw==
X-Google-Smtp-Source: APXvYqwEa5xX0UPGLDw3yx5YgchQI4Nl9Up2L3YAU98vchmqR+FbNObjPraFt55twMf+r/Me6ucjtQ==
X-Received: by 2002:a17:90a:3628:: with SMTP id s37mr6287710pjb.38.1571244763750;
        Wed, 16 Oct 2019 09:52:43 -0700 (PDT)
Received: from localhost (c-71-197-186-152.hsd1.wa.comcast.net. [71.197.186.152])
        by smtp.gmail.com with ESMTPSA id u13sm21952806pgk.88.2019.10.16.09.52.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Oct 2019 09:52:43 -0700 (PDT)
From:   Kevin Hilman <khilman@baylibre.com>
To:     Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, mark.rutland@arm.com,
        robh+dt@kernel.org, martin.blumenstingl@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: Re: [PATCH v2 4/4] ARM64: dts: amlogic: adds crypto hardware node
In-Reply-To: <1571031104-6880-5-git-send-email-clabbe@baylibre.com>
References: <1571031104-6880-1-git-send-email-clabbe@baylibre.com> <1571031104-6880-5-git-send-email-clabbe@baylibre.com>
Date:   Wed, 16 Oct 2019 09:52:42 -0700
Message-ID: <7hk194fx9h.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Corentin Labbe <clabbe@baylibre.com> writes:

> This patch adds the GXL crypto hardware node for all GXL SoCs.
>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  arch/arm64/boot/dts/amlogic/meson-gxl.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
> index 49ff0a7d0210..ed33d8efaf62 100644
> --- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
> +++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
> @@ -36,6 +36,16 @@
>  				phys = <&usb3_phy>, <&usb2_phy0>, <&usb2_phy1>;
>  			};
>  		};
> +
> +		crypto: crypto@c883e000 {
> +			compatible = "amlogic,gxl-crypto";
> +			reg = <0x0 0xc883e000 0x0 0x36>;
> +			interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
> +			clocks = <&clkc CLKID_BLKMV>;
> +			clock-names = "blkmv";
> +			status = "okay";
> +		};

Looks good.

I'll apply this via the amlogic tree as soon as Herbet applies the
driver part.

Reviewed-by: Kevin Hilman <khilman@baylibre.com>

Kevin

