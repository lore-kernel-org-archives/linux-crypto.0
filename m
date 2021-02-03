Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 469FDC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 09:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC6AA64F96
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 09:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbhBCJgv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 04:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhBCJgt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 04:36:49 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C260C0613ED
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 01:36:08 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id f2so27471431ljp.11
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 01:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6GnRcNKibxztYcvUQzDGCgHL6AviuIrNT8YjYqp4o+g=;
        b=FULorK8vsWlfT9sFbadP6z4zJxOs9AiVRnvUe7J2rfjR8hquBrIAC9NlypGz9UeYow
         fXSHbY/48b4B5FIWctnJBzdDTMZq9tEReP6vEhxmitTovmHof64D1sG8EOw5cefbG83b
         b6WHunVOHISOl9wNdGRCjou+X/7CDB2GZGoy1u48n6WpbKI7eHXwxjaSrEfO+KrQAeGa
         MiIrxSEsA6COQt6+e85FcGXmmkpNbcJ6g/AC8Pvg2DqvXoSiLe8ytw/3OA8kIkmwOMSD
         yBCRLiGLJ8rT5lH/iTbOBidfsCnzjchOZKQeN/OhXQqHkDq0+TtRW3ouM6MyzaxbLyzz
         Rqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6GnRcNKibxztYcvUQzDGCgHL6AviuIrNT8YjYqp4o+g=;
        b=n+rbtCHcUySYflCFXHMgppsql8h0TrXyleGY2qaZ70dBQJUr05QxdSOCymbChxDv1/
         QhgZoqBxTZJAn4s0+vIMXbQuAqcLpIAaH84aEC9Kw5kvBNYJZ2MEa35PHPtwUaNRhs1N
         khx19tGAXXoJFso+pFX+ihDQ0j2vhKUSyuXbS/7eRO3MwSVuuAaNjIqDlgZii1aUP6Yz
         5yxWP7+xjhRIasAtTasEd/mKcWGpOoOIG5zKY+I3b1030TZO3iei//VKA2EAtvodAkGM
         zqcDOS56h4AdJ7VEnI9E90R+Z4x+cWZWdxF96y/BDr0YgffZs2/AjBL0ZSceXcHQ3coN
         LaIg==
X-Gm-Message-State: AOAM532Ephcj72lW9yK1PwJakqYOZdMouh1slage383foNVzaRGAyj2l
        k1H1hLqtU2ZPFXWlON8v2MUC1AHIKvmHZiOaPpW/8w==
X-Google-Smtp-Source: ABdhPJy4FflXpUjChVW+K6gb6Ck95k2cKDdhJLsDyahupxAN2akbTAdmitGaAnNIhYk43WdM7SiuRSAXZjsbLKYTmG8=
X-Received: by 2002:a2e:8746:: with SMTP id q6mr1238712ljj.326.1612344967044;
 Wed, 03 Feb 2021 01:36:07 -0800 (PST)
MIME-Version: 1.0
References: <20210202205544.24812-1-robh@kernel.org>
In-Reply-To: <20210202205544.24812-1-robh@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 3 Feb 2021 10:35:56 +0100
Message-ID: <CACRpkdZF1zvykXj58oKjBVqomH86BSW8N=noDs8q3BA--CLAvw@mail.gmail.com>
Subject: Re: [PATCH 1/3] dt-bindings: Fix undocumented compatible strings in examples
To:     Rob Herring <robh@kernel.org>
Cc:     "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
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
        linux-clk <linux-clk@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "list@263.net:IOMMU DRIVERS <iommu@lists.linux-foundation.org>, Joerg
        Roedel <joro@8bytes.org>," <iommu@lists.linux-foundation.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 2, 2021 at 9:55 PM Rob Herring <robh@kernel.org> wrote:

> Running 'dt-validate -m' will flag any compatible strings missing a schema.
> Fix all the errors found in DT binding examples. Most of these are just
> typos.
>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Daniel Palmer <daniel@thingy.jp>
> Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> Cc: Avi Fishman <avifishman70@gmail.com>
> Cc: Tomer Maimon <tmaimon77@gmail.com>
> Cc: Tali Perry <tali.perry1@gmail.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Andrew Jeffery <andrew@aj.id.au>
> Cc: Joel Stanley <joel@jms.id.au>
> Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Cc: Vincent Cheng <vincent.cheng.xh@renesas.com>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-i2c@vger.kernel.org
> Cc: iommu@lists.linux-foundation.org
> Cc: linux-watchdog@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>

Ooops.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
