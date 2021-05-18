Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D70C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 21:42:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BAB36135D
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 21:42:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352556AbhERVno (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 17:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352530AbhERVno (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 17:43:44 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9F60C061573
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 14:42:25 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id v5so13163798ljg.12
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 14:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y4LHlxzr4W8jpC9HaYJhZwDuaET8kSiDblyaNEqOksE=;
        b=e2d04N4scOqVY5LnU5k7L8BleWQxhOqAWodCpHroRMd5HD8smKH/IWEOdI5GEAF97Y
         2x4MMEc0/DYgRpdJ4TDrpYOxpqipZXuec0IBieTXUlaShYYFxW+/9MYk2Yhf0FxEGuG1
         pjonRAyNOcnMa+d3BW7U4nwWT3N8+9kzTQq9CIjVoJy8CtH6huhmVshmzjfkGad2ykeS
         FyCCWP6LVnImwElscEgq9TWNVSX108MBYEvWnR1SCWboLPuxbeQQm73NCOuWwscuJkzT
         jWhA6Ixw0RgYbNqXkFdmOINwj8ZJJG4kghhC2VqnQrh2F9UIMWL3fwtLzQ5Tn//uIWCG
         q0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y4LHlxzr4W8jpC9HaYJhZwDuaET8kSiDblyaNEqOksE=;
        b=NzET1W+M5fNpQrHHDjFp36oy3iybNt/YeBmo+LC0rLCNUBqBlil2G0wivoYDx0ptj9
         FdfJ/JPH+M/JuPko2LlDnP3BqZJTZ1c0q5wPmvE+byPj7cMOZpEHK36rm0tZna3gu4bd
         AzscihWvvZ4j7tbbPXQ1p+c62NyMNCBUF/rcHU1oBCY5HcGS7wwFokioxUQ7HhFgrYbu
         B8IlmnTft8SQc9FbbICo5wOkAKDPq7MVYExV1BtJ+yVOB1lrRXfB0i+app3E8nnwQAzH
         NbFESHvRsW8bBlsoQ7q8m1aFHJDNvyNAOYWPzOnAsPDqiV6bSkPSzO/XKZ5H5rAceZv+
         0umw==
X-Gm-Message-State: AOAM533U2VXXa2xB6UwjVyEreaKYh5FBeozmNkjmrixgpSmMJTyP3rrX
        0mjgKODkYop1oIyod9aE87LUy1PLZDrHmpEZ/N9llQ==
X-Google-Smtp-Source: ABdhPJxIDosGtpEMw/NzLU3CFkVL5CB0sVhyAqTIltm3eI4YBXm439TxCqXSIGogB28/qWeNyG51TXbSYcaBkXQRwy8=
X-Received: by 2002:a2e:81d0:: with SMTP id s16mr5891482ljg.74.1621374144508;
 Tue, 18 May 2021 14:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210518151655.125153-1-clabbe@baylibre.com> <20210518151655.125153-3-clabbe@baylibre.com>
In-Reply-To: <20210518151655.125153-3-clabbe@baylibre.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 18 May 2021 23:42:13 +0200
Message-ID: <CACRpkdZsYvxif8kisM9af8XhS=4Ctf8iS5rhbWxbujSjVs1RRw@mail.gmail.com>
Subject: Re: [PATCH 2/5] crypto: Add sl3516 crypto engine
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

> The cortina/gemini SL3516 SoC has a crypto IP name either (crypto
> engine/crypto acceleration engine in the datasheet).
> It support many algorithms like [AES|DES|3DES][ECB|CBC], SHA1, MD5 and
> some HMAC.
>
> This patch adds the core files and support for ecb(aes) and the RNG.
>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

I'm not a crypto guy and definitely trust you and the crypto folks with
this, but FWIW I am obviously happy about this so:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
