Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F93C64ED6
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Feb 2023 21:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjB0V2y (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Feb 2023 16:28:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjB0V2x (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Feb 2023 16:28:53 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9963921962
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2023 13:28:49 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-536cd8f6034so213853947b3.10
        for <linux-crypto@vger.kernel.org>; Mon, 27 Feb 2023 13:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KmeRELRjX+toI8U9S0q+sHldmJmMtE+gM2tXQFayu+U=;
        b=y4E6zHRqFiXuN7c7PneeDu+wNuShz4nVMZLDBPxHPc3IA1/g6oiV5bwS1dwa2qJlig
         KK4dWSPTjhffcVsaO4aTSzFFcUYefVckve3Lqz/d23Ku1SkxUs2z95BXpGkjq0SBaGDR
         xikjSnYwK3gGAR02DOI66/HgvXTQaH7Z8BsB8Nl057AR/dZ0ooaifnLjYdXRJc9YhxUZ
         cIQ1U9NO8IuUbe7aSJuaGMQsftOEbRyzhzqMum27EV68+cp4U1hkmPU6Gk2hwEqhr7+z
         867smwfEWVpn5Clzl4UCKbsxtFx0VU6oT1hlR5vB9Id0crzEpWjB5n42WVV09TrTo5HJ
         WsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KmeRELRjX+toI8U9S0q+sHldmJmMtE+gM2tXQFayu+U=;
        b=6Ievh8E0g+58VdTscRCtMKUT5IP1pZhz8S8/puAHnqr5bt0xTy/Sg/x36dwlDFk2Ss
         pUfyz3lw7JK+Ohr+5rm/ltPvyClMPdDGgegb2xJjHeRbQsl84sEiMwIkdBWJRfwtUunw
         LRP1DTjGsFJLMchrpfQuTy5VaeWGb8vE7tdoUzNguzFKfUlJ8BxNmfQP04lXpVrOxk8K
         G85F4mPrdRhGk2vnrYZQax0OrzoEsiIb658qzR0XUEwWpQ0s4/bvR9c2WtOB4QK1oxkt
         Z0h/UJQhtp/KHnj9u9GTnfEvN3vpM8YwvthIgMOn3VwqP2zDkbp6ZBYBStMLJT++rzfi
         bFqg==
X-Gm-Message-State: AO0yUKWT0dyYfmynqJTcrDklEUoWmm9MG235IbuYYspJIdofGysPAKAF
        GDBfCFDANclAL8kiSdwnXvpkrrysvkcqUWqF/JxwJQ==
X-Google-Smtp-Source: AK7set9Fm6aG84DkHYFF3B61/XmBl2EHBKxyDQxJVBl73mnj2YUhHJ2iyh2VMkT65oKlT4cTP/s5LNQWjMHpy1cdbI4=
X-Received: by 2002:a5b:8b:0:b0:932:8dcd:3a13 with SMTP id b11-20020a5b008b000000b009328dcd3a13mr105010ybp.5.1677533328652;
 Mon, 27 Feb 2023 13:28:48 -0800 (PST)
MIME-Version: 1.0
References: <Y/cBB+q0Ono9j2Jy@gondor.apana.org.au> <20230224231430.2948-1-kunyu@nfschina.com>
 <Y/cy5wUtk10OahpO@gondor.apana.org.au> <CACRpkdYyB=-UnE1bmdVszSSB5ReECZ0fUoWJX6XtYbKHEe52tA@mail.gmail.com>
 <Y/c7iVW67Xhhdu8e@gondor.apana.org.au> <Y/hQdzsKMYgkIfMY@gondor.apana.org.au>
 <Y/yIbPBVCPx9K/0s@gondor.apana.org.au> <CACRpkdZC4z2Xng4=k94rmM=AFzNzTdXkvtkArMnK7afouz=7VA@mail.gmail.com>
In-Reply-To: <CACRpkdZC4z2Xng4=k94rmM=AFzNzTdXkvtkArMnK7afouz=7VA@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 27 Feb 2023 22:28:36 +0100
Message-ID: <CACRpkdb3xVYspjHTZ+z8Xh0mgd+Ht3VCA_F6xon90gyK-bdPhQ@mail.gmail.com>
Subject: Re: [v3 PATCH] crypto: stm32 - Save and restore between each request
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

On Mon, Feb 27, 2023 at 10:17 PM Linus Walleij <linus.walleij@linaro.org> wrote:

> I am trying to debug!

I am confused by the use of the state flag HASH_FLAGS_INIT in this
driver.

In stm32_hash_write_ctrl() that set up all the algorithm properties
this flag seems to mean "initialized the control register", as it sets
the flag after initializing the register and then does not write it
again if the flag is set.

I wonder if this is in line with the crypto driver expectations of that
flag.

I am wondering because at the end stm32_hash_dma_send()
you set this flag, and that function calls
stm32_hash_write_ctrl() first thing it does which will set the flag
unless it was set already.

Yours,
Linus Walleij
