Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E910FC433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 21:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1CBC6124C
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 21:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236817AbhERVoq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 17:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236158AbhERVop (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 17:44:45 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFC0C06175F
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 14:43:26 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id j6so13337878lfr.11
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 14:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9W8CG42kAAwkhvgorWzkgl2HDP2DkVdnYaRY02J71Bs=;
        b=uNTgtOUlmnxpNkiXuhNVaEaI+mym1NHTPnngxZrWzShoDImoaVBo4fUB4Ttv2KLd58
         CZSzwugn8LcRRojl5bxNAU/JXg+vFA327UfuZnNFHH6JwUO0rXwDPkaRrRcpZBSV/Lp5
         i2FLsHQbOpo0DsA29NdLARZF3jGpEzOE4pd1Ey82TJr3YdrswYzMIng43aGGv3i74OY3
         OzNhXN0/JTjkQPdIiif8MKB0FV0aUjhpUuwT6DCynt2aB1tTYB/3jI1d5puNNMmuAVxU
         kaclZPke/UVkfFSsb9TcP8GGfTO3fzI+GDnXsNfalCnH5VINfC8OiVZzdqewT5CInNvo
         zx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9W8CG42kAAwkhvgorWzkgl2HDP2DkVdnYaRY02J71Bs=;
        b=kwg/jlWow6nitZwg/HK0uqC0dsFCWImeIloY17+LAko1Auv/zyP5UZ//dfWY2XTQSy
         iOmnnAVuMu639saBQC/6QdU8e8jQkUMp/z0TLxyz+cxcL3o9OP+LvLQHg5PdoUwZ5g+S
         E8pR1mcp0rN6PsfO6g0B+LmlvojzoZPR0PVDIgZx3h1vvUoCMxEj+cRHder10Fcmm4Wr
         Joprlha++JTII/Feysj6JctaQJQ6CBSgjXs5AmN7pX6GxJiC8EFd/Hl85hFSU9ODgOU6
         OHYpnQXMQQDWEHvHLom/I95bqjG9sFUuTmT7nRwRxtzrQRqctOSTgoK+Xp39mJOGsisZ
         d4zQ==
X-Gm-Message-State: AOAM531R6Hvoj4dcNuJmxLQVFdNQdGmF+7MlDmmNf9MsAa79AmhC2ACs
        iJ5WFFxBkPBf3oAvSW/Rek9+oIJkgKNXTEbs7tN61A==
X-Google-Smtp-Source: ABdhPJxiQ3bmMsEgGknfvRhvTLU6Jz2UZqabLd+SRMPufcllZQf1K+8AtkRfkP47bpUsSgIFtiajY6O3HSKHCIkPtiw=
X-Received: by 2002:a19:a418:: with SMTP id q24mr5417009lfc.649.1621374205507;
 Tue, 18 May 2021 14:43:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210518151655.125153-1-clabbe@baylibre.com> <20210518151655.125153-4-clabbe@baylibre.com>
In-Reply-To: <20210518151655.125153-4-clabbe@baylibre.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 18 May 2021 23:43:14 +0200
Message-ID: <CACRpkdZ2LH9zKgbs7ci=7paOF6KRsQhMNSOJ_5qjzr=KKFnV+w@mail.gmail.com>
Subject: Re: [PATCH 3/5] ARM: dts: gemini: add crypto node
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

> The SL3516 SoC has a crypto offloader IP.
> This patch adds it on the gemini SoC Device-tree.
>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>

Looks good to me, as soon as the bindings are accepted I will apply
this patch to my gemini DTS branch.

Yours,
Linus Walleij
