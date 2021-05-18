Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 674AAC43461
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 21:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4778A6135D
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 21:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352597AbhERVrZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 17:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352598AbhERVrS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 17:47:18 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA29C061573
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 14:45:58 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id q7so14679453lfr.6
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 14:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B97xKjhQ53Gl8Z8TApI8lRn046/G6g2A8NA0fZn8t+w=;
        b=gRb0hTzgC0OL1MiHCnOt1xOtZYUZ3QLk9y9JbAoVDb7uC1KybmqWPzdhZFIHx8mjr1
         ipNrmV8sPw9nouZGe4tcS0dcN/KMmdoCA/wKo+XAJDmp6pzNG8cDDIdUQO8RSHwDY8e4
         +hPIB8MK5cQUFHVFwDqWCNhz6RBaVkdAO/64LW8wulrlVYbaSryD+7I5Yf+61xmAQkv8
         xEb5EDgug1Fe3RjfwC9Y9DctJUf2qApYvFmUH4XC81w+YwPxxtB9WPss9oVbgbs7olwK
         yMOMfC7P0v+sBrnDrVAdl9a9sC/nVidjzAekZC6Ih+kkYEK0BDhPgvuOtFuzXA2Z7Ekb
         DroA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B97xKjhQ53Gl8Z8TApI8lRn046/G6g2A8NA0fZn8t+w=;
        b=Kuv6vBxI06OAGO2dKwJ/P/THXLilJOdcPM6IxGqFEZDwB+F6COmQHbaw8FmFlRi0Sq
         aqRcJwH4/bdH+7f2uS2BRHVctKoX3PwNDcv9v23toIdBYtwnw8z9H7pvODT7AF2aBflE
         z8j0qIeCNuhpiYsaUctfZz33R0QwdXUx09PeCC7DtUl5t42x8NGa0ON2GzH+CUfx5jt9
         kynR+CpZLa/kW9UMVTGblSAFPSu08esP5NxWWPxV0BA3f9sR2AVDFoDQjLjvvwgWT3EA
         ZsD8gDtioG4sOyqMk4JciIDNeR0ucFBgQbu9CXOJ4kJtuzvO/z3U6BOLu5rL7xbz56b8
         cF5Q==
X-Gm-Message-State: AOAM531U0loMVI3gKqqnvOLal51famgitj0B49L/S2J6skfDJuDoj21V
        byxPegb8FurzdlzucdpkJJ5QZl1L96hHEqb2uzCuuw==
X-Google-Smtp-Source: ABdhPJwawJZRAVzoDj+tZLYIiqlDskIlRSmtkXGxkxxxuliOaAVIz0FBDFMTgicKnWF2n/XKgfKoRIgALFP8qVIn/b8=
X-Received: by 2002:a19:b0b:: with SMTP id 11mr5489148lfl.291.1621374357316;
 Tue, 18 May 2021 14:45:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210518151655.125153-1-clabbe@baylibre.com> <20210518151655.125153-6-clabbe@baylibre.com>
In-Reply-To: <20210518151655.125153-6-clabbe@baylibre.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 18 May 2021 23:45:46 +0200
Message-ID: <CACRpkdZNLD9qf2xQrN2zi1ju4L9oexCgjVLsrtv8yZqFtZT_YQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] MAINTAINERS: add gemini crypto sl3516-ce
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 18, 2021 at 5:17 PM Corentin Labbe <clabbe@baylibre.com> wrote:

> Add myself as maintainer of gemini sl3516-ce crypto driver.
> Add also the driver to the list of files for gemini SoC.
>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

I expect this to be applied to the crypto tree with the
bindings and the driver.

Yours,
Linus Walleij
