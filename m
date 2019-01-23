Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB3BFC282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 08:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8D422184A
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 08:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548230412;
	bh=zmDyYWtKnhfHf7lFKwakcmxsKn8AOs4Tcp/ip0SX4BY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=lzHNi3OJFtWa9gTn3Arh/en8sPZgQ0YSzopCf57UwpfxrDcNpnXHCjBw5kcioD7T+
	 fFqXbK+E11EV2d3vnLOcarUoxFzmBV0EFWAR1hWVb+ugZwLKtx3dYDoqWzc7tBWsBD
	 dht6fETNH67Aw1tClWR3WVmMhvczB00ZKXH3C3bw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfAWIAM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 03:00:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:53362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbfAWIAL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 03:00:11 -0500
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19ABC2184A;
        Wed, 23 Jan 2019 08:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548230410;
        bh=zmDyYWtKnhfHf7lFKwakcmxsKn8AOs4Tcp/ip0SX4BY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=H9xegQJSTAX2FX17/+lhkVypQWrZ+eKmB9jp6zRTkifrZeLtHZ+JrGcgqYsXU1YX8
         LYwL2D6fjIyWr+tW9ZMg141wF3MJuwLxNi0R6eNA5/l7WgNfEhn0xAVXIPTfVpuE3c
         umhFl4VozTwyiOzUUsK3a1mzAHS6ejcxtPKbxhh4=
Received: by mail-lf1-f49.google.com with SMTP id a8so878454lfk.5;
        Wed, 23 Jan 2019 00:00:10 -0800 (PST)
X-Gm-Message-State: AJcUukcyxdjEnIPA9b6wwn6WhCf6KcGEU3etJLPneOw5rxCt0bBN2n8G
        5B44bhOyGjNZpRp2yPTepcams3Eku/uU/vbpiOg=
X-Google-Smtp-Source: ALg8bN5q24GuIwRANJT7Kpr2GPsYoK2FhbiIF3EEQ5Tt61TPzbvOCKsKjkpIlJS3LGV/55TSPpLg7EFoPinYwEPboVE=
X-Received: by 2002:a19:9b50:: with SMTP id d77mr944239lfe.137.1548230408176;
 Wed, 23 Jan 2019 00:00:08 -0800 (PST)
MIME-Version: 1.0
References: <CGME20190122152608eucas1p27cff7b53eb3bb23447ef7ba2b3f69671@eucas1p2.samsung.com>
 <20190122152553.1537-1-k.konieczny@partner.samsung.com> <20190122152553.1537-3-k.konieczny@partner.samsung.com>
In-Reply-To: <20190122152553.1537-3-k.konieczny@partner.samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 23 Jan 2019 08:59:56 +0100
X-Gmail-Original-Message-ID: <CAJKOXPfGJxzPVcAitU=uDFfrmtwQZD1dcbbhy+BjEUF_6exx2g@mail.gmail.com>
Message-ID: <CAJKOXPfGJxzPVcAitU=uDFfrmtwQZD1dcbbhy+BjEUF_6exx2g@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] dt-bindings: crypto: document Exynos5433 SlimSSS
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 22 Jan 2019 at 16:26, Kamil Konieczny
<k.konieczny@partner.samsung.com> wrote:
>
> Document DT bindings for crypto Samsung Exynos5433 SlimSSS (Slim Security
> SubSystem) IP.
>
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
>  .../devicetree/bindings/crypto/samsung-sss.txt      | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> index 7a5ca56683cc..75718f86fe50 100644
> --- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> +++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
> @@ -1,4 +1,4 @@
> -Samsung SoC SSS (Security SubSystem) module
> +Samsung SoC SSS (Security SubSystem) and SlimSSS module
>
>  The SSS module in S5PV210 SoC supports the following:
>  -- Feeder (FeedCtrl)
> @@ -15,6 +15,11 @@ supports the following also:
>  -- True Random Number Generator (TRNG)
>  -- Secure Key Manager
>
> +The SlimSSS module in Exynos5 (Exynos5433) supports:
> +-- Feeder (FeedCtrl)
> +-- Advanced Encryption Standard (AES)
> +-- SHA-1/SHA-256/HMAC (SHA-1/SHA-256)
> +
>  Required properties:
>
>  - compatible : Should contain entries for this and backward compatible
> @@ -22,11 +27,13 @@ Required properties:
>    - "samsung,s5pv210-secss" for S5PV210 SoC.
>    - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
>                 Exynos5260 and Exynos5420 SoCs.
> +  - "samsung,exynos5433-slim-sss" for Exynos542x and Exynos5433 SoCs.

For Exynos5420 there is a driver for regular/full SSS module. It would
be nice to explain what is the difference between them and/or mention
potential conflicts of usage.

The point is that previously we added drivers/bindings for SSS and now
you use the other interface. It might be pretty confusing for users...

Best regards,
Krzysztof

>  - reg : Offset and length of the register set for the module
>  - interrupts : interrupt specifiers of SSS module interrupts (one feed
>                 control interrupt).
>
>  - clocks : list of clock phandle and specifier pairs for all clocks  listed in
>                 clock-names property.
> -- clock-names : list of device clock input names; should contain one entry
> -               "secss".
> +- clock-names : list of device clock input names; should contain "pclk" and
> +               "aclk" for slim-sss in Exynos5433, and one entry "secss" for
> +               other compatibles.
> --
> 2.20.0
>
