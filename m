Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB1DC433DB
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 09:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40C1964F61
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 09:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhBCJtP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 04:49:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhBCJtF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 04:49:05 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7148FC06178A
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 01:47:57 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id l23so17060009qtq.13
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 01:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zk8/vp8JgNY876P4l17ZIlAqzB9Wo0hE+dFWOx8FtrM=;
        b=SY8KB6ZL7hu4tsDAT4WtjBrjedqhdXnJ0WfEvfJfTY4yh0iSUYYRhinj5pTMbKBDV1
         aUGstOUKrtsV6s3+W+PrL5fuzfzO0w1ItRwwVf+Gj24JPi7XOxzASbip5S8aN+T6CEwU
         +NX0nAvHbl0Z+rP1h+42oA2pbBBS/9Oc57Pzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zk8/vp8JgNY876P4l17ZIlAqzB9Wo0hE+dFWOx8FtrM=;
        b=hptlYdD0Adf6DsAvXEdca+X4bFiPL2q4OkDTaNIE5+DH63quYvYK2bNTrVzeW2LFJg
         g7Hl7ZDgHG8JH2iVVlggGDzJSakAw8vZfGhIcF4QqQF4QRBsDxKt4VlRaJAXtck6cWDP
         PKCH21ln4Yy5hE06X+MO9o8S+DC50vk1Nhsc/luxozLzE2OackcFXoP4fb0jgr/2lzwU
         FVikBJkDd6KuP2CKTtAdu6glsdEVNS/teFYHwrSH08JakscedqvmjiJxsZ4lByEErSfw
         6p++zZC5iqbH31Tx/zwVDPMlMr3DFBDm32efEBsdgdupGPShFQ1z24cwAId0zkFiaTy6
         vTCg==
X-Gm-Message-State: AOAM533Y7vyuy2r1gSAQ+bX2qE8gn3iDKx6ekNjkh+TMdj3NgTZIjwIq
        Z+wLYECcjpDXB8aqnbhDjZiPo0lP40jmbvq+LOfFiQ==
X-Google-Smtp-Source: ABdhPJybIlxUI+vQirOWdUqx6AbdqbGySWHXWBWrXBPSLHmsuhjkp60HqhVWg2mWEWZVLnKYEXPVHI64xIy6+ueWcow=
X-Received: by 2002:ac8:5dc8:: with SMTP id e8mr1685704qtx.249.1612345676494;
 Wed, 03 Feb 2021 01:47:56 -0800 (PST)
MIME-Version: 1.0
References: <20210202205544.24812-1-robh@kernel.org>
In-Reply-To: <20210202205544.24812-1-robh@kernel.org>
From:   Daniel Palmer <daniel@0x0f.com>
Date:   Wed, 3 Feb 2021 18:48:59 +0900
Message-ID: <CAFr9PX=NmCev3c1jQ3VA89rwcTr3jpRQB-NKf+j+LOeOMHy1Og@mail.gmail.com>
Subject: Re: [PATCH 1/3] dt-bindings: Fix undocumented compatible strings in examples
To:     Rob Herring <robh@kernel.org>
Cc:     DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Palmer <daniel@thingy.jp>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Avi Fishman <avifishman70@gmail.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        Joel Stanley <joel@jms.id.au>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-i2c@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Rob,

On Wed, 3 Feb 2021 at 05:55, Rob Herring <robh@kernel.org> wrote:
> diff --git a/Documentation/devicetree/bindings/gpio/mstar,msc313-gpio.yaml b/Documentation/devicetree/bindings/gpio/mstar,msc313-gpio.yaml
> index 1f2ef408bb43..fe1e1c63ffe3 100644
> --- a/Documentation/devicetree/bindings/gpio/mstar,msc313-gpio.yaml
> +++ b/Documentation/devicetree/bindings/gpio/mstar,msc313-gpio.yaml
> @@ -46,7 +46,7 @@ examples:
>      #include <dt-bindings/gpio/msc313-gpio.h>
>
>      gpio: gpio@207800 {
> -      compatible = "mstar,msc313e-gpio";
> +      compatible = "mstar,msc313-gpio";
>        #gpio-cells = <2>;
>        reg = <0x207800 0x200>;
>        gpio-controller;

This is correct. The compatible string dropped the e at some point and
I must have missed the example.
Thanks for the fix.

Reviewed-by: Daniel Palmer <daniel@thingy.jp>
