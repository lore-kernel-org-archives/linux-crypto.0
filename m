Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AA1DC64EC7
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Mar 2023 12:22:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCAMWf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Mar 2023 07:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjCAMW2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Mar 2023 07:22:28 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102D33CE02
        for <linux-crypto@vger.kernel.org>; Wed,  1 Mar 2023 04:22:27 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id x12so103752ybt.7
        for <linux-crypto@vger.kernel.org>; Wed, 01 Mar 2023 04:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l8Nz7GHrjsKkrFAhlS/NkKdyC63Tn/KzsoBmeKFSXCw=;
        b=w+EvywvXa3hPR1XRdg3fT9+2+j3fg01b9pb8YjCHXKBafIgJSWWztnhMRN78aDH1Gl
         tIeHLL3AoQD9YS0rnC3Aier7ZvdJU+ue3uDqfCYSye3KgmjuM/ws69r9wlmAQaReSTX3
         NElMSx/U74nuneh6v1fjqAVQeC0wPYvKtaMBRWpF+L4TMLK7WYs65RM5vWaPAtuTt+Kr
         ypXDt+vTfG8L73u0jM6oN5/3R9TgvRBMmSEKL0gUiJU2UOX/EqKdHgRjEi8pCu6A9TmN
         uU4ER6e0X5mDuDbr9vmHJy4JhNb/OXaJjONAEFZ35cJpmmzKjdFofE9FJ0L0MZ61wWQM
         M2pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l8Nz7GHrjsKkrFAhlS/NkKdyC63Tn/KzsoBmeKFSXCw=;
        b=N17VxycH9JjhcobZzVu2wXIafVQHMHc/Yrr3k0gcEj+FUfrzhnlVjs/61vXpkYRrPT
         nX2x4Rjj1JTrJCq8RXW+GN6fenvkGRggN9y6hcVm36osoHlZ32MrkTw/b5fgDRzJp0U/
         y1Jy+hfX4KxuwmclTLCzOfk7on6gDRdGNtZos+he0syc3sr9UyX4Up1MwjGKvfzK4zuK
         bpv+j9ovleEkRqvT2d952XvbfEmk9xmFN7AOzb/29vlh+Myfv/YF51I2HOCKGCo/PEI3
         STINHugicWfxsqxbYhFmrR8lvR20UbmnLdn86QB8f5hGGUSolHGMTMbQLtZ4k/NdnWg9
         lF/g==
X-Gm-Message-State: AO0yUKWWKJWJW5GzdM4RjfA7Q4vkjrsznWvL37zDLOPlnQFNZqpKS6MN
        9BhgZ+vSIZAz9BBLGw0l2QmlxUgfGlAcVU3yeozTIA==
X-Google-Smtp-Source: AK7set/3PSECcYx5SDkKwfxXxVfKsTGwUn5f13PiuIuMv3U3cT7CDjiLP8yKUH8w5up+OiziuGYjkVabAyYxu7cUyWk=
X-Received: by 2002:a05:6902:4d1:b0:ab8:1ed9:cfd6 with SMTP id
 v17-20020a05690204d100b00ab81ed9cfd6mr2429104ybs.5.1677673346062; Wed, 01 Mar
 2023 04:22:26 -0800 (PST)
MIME-Version: 1.0
References: <Y/cy5wUtk10OahpO@gondor.apana.org.au> <CACRpkdYyB=-UnE1bmdVszSSB5ReECZ0fUoWJX6XtYbKHEe52tA@mail.gmail.com>
 <Y/c7iVW67Xhhdu8e@gondor.apana.org.au> <Y/hQdzsKMYgkIfMY@gondor.apana.org.au>
 <Y/yIbPBVCPx9K/0s@gondor.apana.org.au> <CACRpkdZC4z2Xng4=k94rmM=AFzNzTdXkvtkArMnK7afouz=7VA@mail.gmail.com>
 <Y/3FYZJeLE7DVPBf@gondor.apana.org.au> <Y/3IA4OjmUmjMgh1@gondor.apana.org.au>
 <Y/3N6zFOZeehJQ/p@gondor.apana.org.au> <CACRpkdZ3rCsOWqooNkPL6m7vZ2Z2Frh2sdxruKhrS0t3QHcSKw@mail.gmail.com>
 <Y/6sCC2nH0FcD6kJ@gondor.apana.org.au>
In-Reply-To: <Y/6sCC2nH0FcD6kJ@gondor.apana.org.au>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 1 Mar 2023 13:22:13 +0100
Message-ID: <CACRpkdYN-SDfxXKLt3HWGVkWb3V1rABwvWuytwDrzfTqm81fNA@mail.gmail.com>
Subject: Re: [v4 PATCH] crypto: stm32 - Save and restore between each request
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 1, 2023 at 2:36 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:

> The failing vector is the first one where we save the state from
> the hardware and then try to restore it.

Yeah that's typical :/

> Is your device ux500 or stm32? Perhaps state saving/restoring is
> simply broken on ux500 (as the original ux500 driver didn't support
> export/import and always used a fallback)?

It's Ux500 but I had no problem with import/export before,
and yeah it has state save/restore in HW.

Yours,
Linus Walleij
