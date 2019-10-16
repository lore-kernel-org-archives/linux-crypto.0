Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D120FA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 16:44:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56A7D21928
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 16:44:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sFLTSa9h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391615AbfJPQof (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 12:44:35 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:45217 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389763AbfJPQof (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 12:44:35 -0400
Received: by mail-ed1-f44.google.com with SMTP id h33so21820613edh.12;
        Wed, 16 Oct 2019 09:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZjLuelx3S+vgGEqA0Wa177sYJKNlYV9yc/c2zDhGqzk=;
        b=sFLTSa9hhwygpd1bl/N+6RbfhNg5GlETinvAuHy8UaAmNw/uEtQKh17fwDDVt/7XjU
         YASM8CdrdHu5jck713OgMYVtoaiyODLeYM92R3a8VLjJ2DVFbz9h5tR9yP3fqx4UM2Sz
         qGBXypuwhBKm/jetCiIgFMYdu1+erRSbZzMd6f9RshqmAx843SHbj/wle9H7rh7aNlBO
         Pjm/5XNttCpD8Mv7aHWjZIXUQHPb0I+gDK8l8U3uKoOSbHOXueeJTxmhD3asqUmN6Pft
         P8RQGb7En6PW9rtUyUQBR+lmpSEaBthsDZrwQEFQKJB4qk+eqX/73OlD/biO2UeORM41
         wIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ZjLuelx3S+vgGEqA0Wa177sYJKNlYV9yc/c2zDhGqzk=;
        b=ZYzFEUHbFwYRdOKqrzyJXeOzOzZXEO4Yf3cYZYHIVDFnNGEdVkWbKSkGBf8jt3d4tQ
         pFc92XUPyP2fSikKGeCZjZgRUMc6CHp7ECdMgxQB/vkwUaVYffRsHkIwuTdJIVs5fqT7
         Mmx2M4QVjcKTH/2cXOyKQilNHSGxA8b9gwqIH8vJTi+q0d1/OOEfx9Np+KLdT2XvxF7y
         gh6MR3kbKxUACn//vSMEmN3kM0s/GTIM/xlhJfRrJSVJXlHBriXXV+RUOTt+TLfjgxMw
         zGoIin7RiY8B/Z38bAX57mfluK6p0TPyHdTxhu4C93hmQj5tsN+3HkxMPa9bCA8hTziF
         cGVw==
X-Gm-Message-State: APjAAAWlgojPmYr9IVJ2cvBCtQ3MoSzU47gqQCaSN4b6agFe4sKbZmjY
        vjQscM79JVVTKjkNdfjKjl8=
X-Google-Smtp-Source: APXvYqxIERiZ5w64+xqs7jAq4hXeyVbjFAQKX837pLY6HTLxJZOWrfK9CNoOE8J3X4tpR4eT5bVQ2g==
X-Received: by 2002:a17:907:20c8:: with SMTP id qq8mr40330276ejb.311.1571244271178;
        Wed, 16 Oct 2019 09:44:31 -0700 (PDT)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h38sm4079614edh.13.2019.10.16.09.44.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 09:44:30 -0700 (PDT)
Subject: Re: [PATCH -next 00/13] hwrng: use devm_platform_ioremap_resource()
 to simplify code
To:     YueHaibing <yuehaibing@huawei.com>, herbert@gondor.apana.org.au,
        mpm@selenic.com, arnd@arndb.de, gregkh@linuxfoundation.org,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, f.fainelli@gmail.com,
        rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, eric@anholt.net,
        wahrenst@gmx.net, l.stelmach@samsung.com, kgene@kernel.org,
        krzk@kernel.org, khilman@baylibre.com, dsaxena@plexity.net,
        patrice.chotard@st.com
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        linux-amlogic@lists.infradead.org, linuxppc-dev@lists.ozlabs.org
References: <20191016104621.26056-1-yuehaibing@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <2c60b926-1e98-cca0-ec17-6b45f9da404a@gmail.com>
Date:   Wed, 16 Oct 2019 09:44:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191016104621.26056-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 10/16/19 3:46 AM, YueHaibing wrote:
> devm_platform_ioremap_resource() internally have platform_get_resource()
> and devm_ioremap_resource() in it. So instead of calling them separately
> use devm_platform_ioremap_resource() directly.

Did your coccinelle script not cover
drivers/char/hw_random/iproc-rng200.c somehow? Do you mind including it
as a separate patch?

Thanks

> 
> YueHaibing (13):
>   hwrng: atmel - use devm_platform_ioremap_resource() to simplify code
>   hwrng: bcm2835 - use devm_platform_ioremap_resource() to simplify code
>   hwrng: exynos - use devm_platform_ioremap_resource() to simplify code
>   hwrng: hisi - use devm_platform_ioremap_resource() to simplify code
>   hwrng: ks-sa - use devm_platform_ioremap_resource() to simplify code
>   hwrng: meson - use devm_platform_ioremap_resource() to simplify code
>   hwrng: npcm - use devm_platform_ioremap_resource() to simplify code
>   hwrng: omap - use devm_platform_ioremap_resource() to simplify code
>   hwrng: pasemi - use devm_platform_ioremap_resource() to simplify code
>   hwrng: pic32 - use devm_platform_ioremap_resource() to simplify code
>   hwrng: st - use devm_platform_ioremap_resource() to simplify code
>   hwrng: tx4939 - use devm_platform_ioremap_resource() to simplify code
>   hwrng: xgene - use devm_platform_ioremap_resource() to simplify code
> 
>  drivers/char/hw_random/atmel-rng.c   | 4 +---
>  drivers/char/hw_random/bcm2835-rng.c | 5 +----
>  drivers/char/hw_random/exynos-trng.c | 4 +---
>  drivers/char/hw_random/hisi-rng.c    | 4 +---
>  drivers/char/hw_random/ks-sa-rng.c   | 4 +---
>  drivers/char/hw_random/meson-rng.c   | 4 +---
>  drivers/char/hw_random/npcm-rng.c    | 4 +---
>  drivers/char/hw_random/omap-rng.c    | 4 +---
>  drivers/char/hw_random/pasemi-rng.c  | 4 +---
>  drivers/char/hw_random/pic32-rng.c   | 4 +---
>  drivers/char/hw_random/st-rng.c      | 4 +---
>  drivers/char/hw_random/tx4939-rng.c  | 4 +---
>  drivers/char/hw_random/xgene-rng.c   | 4 +---
>  13 files changed, 13 insertions(+), 40 deletions(-)
> 


-- 
Florian
