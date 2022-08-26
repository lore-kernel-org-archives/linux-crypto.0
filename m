Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FC8ECAAD6
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 08:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343550AbiHZINa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 04:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343563AbiHZIN0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 04:13:26 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 045E2D4BD0
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 01:13:24 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id w19so1722054ejc.7
        for <linux-crypto@vger.kernel.org>; Fri, 26 Aug 2022 01:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=NXwitHio/7JwDumLFpAgiMLj63RaVL17ajcp21R6k2Q=;
        b=mgcopMPyOg5dStcVRGKVJ7sc/uHv47EJrRaQhXAtmc0rfwJ18NGlqkmPZ8PrUvg48P
         MNQfyaWkkDjjt3yjs92nvYyJGerfcBOfhUyLvQoBMX31pB9JqMdkkpotlr9g4XPjdPJf
         MZMS0Rznheo89L7t+kM3kIsVQNEXc//u6oB6+zyMCRGTviL4ZMHMvvkBy2vgLzRGWD3o
         cdcZVSLzUpeykDumVucvbYJY94WGedvDSrBwPTWd0m2HwNYpANQjZrHcOMgWhpfNUzac
         +9gdxj0hyP6wZp5X/p4T5eO5LwExgPWK90CTCVrSYFn7qm6foPijy6PwFFyMLMDt8XZ5
         lNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=NXwitHio/7JwDumLFpAgiMLj63RaVL17ajcp21R6k2Q=;
        b=D1pba/4tDp8XvAUeasSsK+9IWtD1mhrRkDPhLaJdnDWYv+VAxzAZ9vLWI6siDZIY4E
         KRva/JWotncWLlz5Emofu/8c9FcLcr4pe3PqUf1dxVm8+Wqz5slMaslBXY6aha8b4tGE
         OeHOzfetaOCRdVXf+suw5jMxJzfuQaLhIn6zktbUjaIeLd4VGsYTA1pRgCfXhIDvSdM+
         5BA4nJKYP5ms8OSYxpvGFJe9XsyelF+hq62NP/D313qnAa6sbLLZ75maw9r634psgNnH
         L1KBG6wNSMSzhLUSQgXuCWnknQR+vTrg1/YR5O9oyZi9cL308qZC2G38/ooN4aLH2+jc
         Je3w==
X-Gm-Message-State: ACgBeo1wF+M+OZwOc5wOQr7o6+gJqbI7L8rkI9W9asC6muA4CDDWtyLx
        M9AmLe1FTPi9/73Szc9mH/KTkQpiy/ZE67YfbhiERA==
X-Google-Smtp-Source: AA6agR5NtfoC3IPV3u7qtblqvhnD9K3/BH7jOrVDVsoqgbkt9CEFcmJ42imT8TJOmGTee/F+/HtAZgpZSoLJolrOq84=
X-Received: by 2002:a17:907:6293:b0:73d:b27b:e594 with SMTP id
 nd19-20020a170907629300b0073db27be594mr4892481ejc.526.1661501602905; Fri, 26
 Aug 2022 01:13:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220819060801.10443-1-jinpu.wang@ionos.com> <20220819060801.10443-8-jinpu.wang@ionos.com>
In-Reply-To: <20220819060801.10443-8-jinpu.wang@ionos.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 26 Aug 2022 10:13:12 +0200
Message-ID: <CACRpkdYYPGtaVbEwu=EP31cEx6Tc1JjrQsd7MaJ_7LjFTpnQFQ@mail.gmail.com>
Subject: Re: [PATCH v1 07/19] crypto: gemin: Fix error check for dma_map_sg
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 19, 2022 at 8:08 AM Jack Wang <jinpu.wang@ionos.com> wrote:

> dma_map_sg return 0 on error.
>
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>

Good catch!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
