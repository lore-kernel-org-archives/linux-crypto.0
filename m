Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D26DC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Nov 2022 14:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiKUOJc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Nov 2022 09:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiKUOJQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2022 09:09:16 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93C59C9A94
        for <linux-crypto@vger.kernel.org>; Mon, 21 Nov 2022 06:05:56 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-37063f855e5so114480047b3.3
        for <linux-crypto@vger.kernel.org>; Mon, 21 Nov 2022 06:05:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aNnRafn2Fe3woBngEtfiMVRe//+9fMOX4/niIs93zPU=;
        b=GqFPnWzRXaVFmPPMpBibORf6Ck5eaQEZchbGXmr8J8iv1mrebP9apgA8SqlaavFZwZ
         tfwNs6yLrp4cvwrlm3HaQAAJoUa8XsncrZMbk1MSQwfHw1YLejFjIxe8A+5mlFZ5YiwF
         Z4R3AmH895OF82fyf+7UTeQaJ01sHxkIKqvJ0WUtDN9qc9rNKBYHqX/YUjJxoku8gnOx
         OpiMS0t2iWoUK+HCgcntQC8mPnhZTmQy0ypacve5YM937WE7KTSvG9k7fqv5GVRLAXJH
         uEgjkNIb7me4Zu08Xf7Tf/1yoOeUA77iawgqczNAwuL3fxFKETjsYfk0hNZ+qJZXnLcO
         p5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aNnRafn2Fe3woBngEtfiMVRe//+9fMOX4/niIs93zPU=;
        b=QSsK0OAckxhA7p78yO7QMKMF2TWAzzaRCgFXSL2oiQM4tSGZBRj+6G182LVadoFD6L
         1Dr2uwXZg5JDQp5o35BRTXB4RyOaQfPMf/wPyd43vjSHtTNZIbHXvxs63KA32ZynF4GU
         QtMo9ssPd99blIPNBJ52R+vaC3pNdTwAM/YTkAVJrNywLCGlX+On5QkHHEGpQzr5J/hE
         9ROy8SqALr0oJ9YkGaPYCmJKpJNZ6qdgpiclhhmx54iCpKZuwEvBYbBj5CPhlnTBAZP6
         20GXhin9/zAjnAs+1CfSpjV2TGd6Y5vWgjecUR+WBVmVxBhhZFWtI0QFPzUFN29d/0v+
         Pf2g==
X-Gm-Message-State: ANoB5pmTvWkPs6m3rWiX9DptLPUFjj/yTVphgTlwKkkN4Dxp/kFWNDiE
        nQAAmJ2iiR1I3rbJQHHzP1HAeHIjtd1ggXFddUMF+g==
X-Google-Smtp-Source: AA0mqf45lZgo4f1/CeR2wR/yqT5+fiTLhHmsEdpl9VSlGpdZ3QL2EjhIzQhvdZ0UdfKZRiKN1YciuGl8lO4vZEUJBFs=
X-Received: by 2002:a0d:fdc7:0:b0:37a:e8f:3cd3 with SMTP id
 n190-20020a0dfdc7000000b0037a0e8f3cd3mr17194099ywf.187.1669039555178; Mon, 21
 Nov 2022 06:05:55 -0800 (PST)
MIME-Version: 1.0
References: <20221119221219.1232541-1-linus.walleij@linaro.org>
 <20221119221219.1232541-3-linus.walleij@linaro.org> <b0b346ca-7b47-758a-c9e7-e7fda2b0856b@foss.st.com>
In-Reply-To: <b0b346ca-7b47-758a-c9e7-e7fda2b0856b@foss.st.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 21 Nov 2022 15:05:43 +0100
Message-ID: <CACRpkdYf3RbPe3FL4wyxAJK0QJ1UqFMhLD=dNJm8VkO4YtZoeA@mail.gmail.com>
Subject: Re: [PATCH v1 2/4] crypto: stm32 - enable drivers to be used on Ux500
To:     Lionel DEBIEVE <lionel.debieve@foss.st.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 21, 2022 at 2:36 PM Lionel DEBIEVE
<lionel.debieve@foss.st.com> wrote:

> One short comment.

>  config CRYPTO_DEV_STM32_HASH
>   tristate "Support for STM32 hash accelerators"
> - depends on ARCH_STM32
> + depends on ARCH_STM32 || ARCH_U8500
>
> I'm not seeing any compatible update in the HASH driver for Ux500.

Correct, I'm just enabling it to be compiled in right now. I haven't
figured out if I will reuse the hash for ux500 as well or just keep
the old driver as it is using polling only. Need to experiment and
figure out what gives the smallest and understandable amount
of code to maintain.

It doesn't hurt to enable it to be compiled in, ideally all depends
on ARCH ... should be removed and replaced with
ARCH_nnn || COMPILE_TEST anyway.

But if you insist I can drop this oneliner.

Yours,
Linus Walleij
