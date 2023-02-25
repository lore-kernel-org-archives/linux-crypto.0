Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB55FC7EE2D
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Feb 2023 23:15:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBYXPl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Feb 2023 18:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjBYXPk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Feb 2023 18:15:40 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C35F940
        for <linux-crypto@vger.kernel.org>; Sat, 25 Feb 2023 15:15:39 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-536cd8f6034so78913827b3.10
        for <linux-crypto@vger.kernel.org>; Sat, 25 Feb 2023 15:15:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SJmSfEEN4ER+rrwr2AAo+0NwW5TiTbnjxiFoVH+2l9g=;
        b=lJuA91aU+Z6dTyfnGMZiVv3hrjIkUarjSMsX4//t7Svg2+BqrGDoGH0GjaPHAdBO4u
         G3blhCZrGSY7lPwfnaKaW39TqZjA/tz4w6Vv1c+0JaDZS2srvRmFlfxteeK3UpfVBreJ
         5F8qqdMVrlED+IGO+nY37MbRA7IKvEt4wWuVcgZAA84RtrzqTpYeSsqH2SMeL6gpX0lE
         +n9MzpJR4CBJEDStxxjecE5wzyZK8v8sgZwd7sYVY4RtLz7ZEul2g8HJPy7fggXDL3xB
         8gWG3WGEGYMnEs1sowTXxetmnWh9yN9AfLCCjOiKo0CniLKCUTCTXaz+sgbee/E0TQGH
         XHIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SJmSfEEN4ER+rrwr2AAo+0NwW5TiTbnjxiFoVH+2l9g=;
        b=M7R0s4xiartT6nh65AFam+7SByAuhx0/JyumcuU3MlmDF1z0xJYG03MUdw8TBPlyXp
         G9d9eqE5N1Rh9gpAQaik3pGRXYncjjfmDEChFD6A9ryyRDXTwLZb4kf+cHs8FE8Lsgpa
         non0nwAJJl5e7iCXEHnBz3Eb1pMFgnhx7lilmmHKBbKkgSkH0iu69DZC9VHQjijuUTXy
         My+wk3L0tvhYJ84Xcg4TGWTYez/x1EC8WgbVERTWpt0PdWhecw53aFHhenYzDihr3rgv
         tUAetZKyziwUW9g0I7CJLMeUjLQQygrpBj1L49vCKAHf2LAJ0vFP4sXKhHGfdOFmXp/o
         rm2g==
X-Gm-Message-State: AO0yUKXP2vUeaemPsiE2oxcDRzctk/LXEcIaUjIhF2iekAqGrpn7uWPI
        o90l4PX387B7FIbcfnKP8uIL87JHyF+Sd4HtdB3REtZEWc4dyfAo
X-Google-Smtp-Source: AK7set81k6a7OARPbG8rGRSwKMm+X+pUCEQjYElVtITGMi8kMV0p1mfBo4QFoFXB6q5yGAxkalHBm6shkJcbwLjHKLw=
X-Received: by 2002:a81:af5d:0:b0:52e:cea7:f6e3 with SMTP id
 x29-20020a81af5d000000b0052ecea7f6e3mr7373343ywj.10.1677366938879; Sat, 25
 Feb 2023 15:15:38 -0800 (PST)
MIME-Version: 1.0
References: <Y/cBB+q0Ono9j2Jy@gondor.apana.org.au> <20230224231430.2948-1-kunyu@nfschina.com>
 <Y/cy5wUtk10OahpO@gondor.apana.org.au> <CACRpkdYyB=-UnE1bmdVszSSB5ReECZ0fUoWJX6XtYbKHEe52tA@mail.gmail.com>
 <Y/c7iVW67Xhhdu8e@gondor.apana.org.au> <Y/hQdzsKMYgkIfMY@gondor.apana.org.au> <CACRpkdZe3cMMxJesD0mpqHTwvuWHjSGVHsiFUQQyuA+VWknMTQ@mail.gmail.com>
In-Reply-To: <CACRpkdZe3cMMxJesD0mpqHTwvuWHjSGVHsiFUQQyuA+VWknMTQ@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sun, 26 Feb 2023 00:15:27 +0100
Message-ID: <CACRpkdY7V=x9+oWsbPtmjc-WBz6v2aSr9RVD1pJ4SGu+Dxejvw@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: stm32 - Save and restore between each request
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

On Sat, Feb 25, 2023 at 1:01 AM Linus Walleij <linus.walleij@linaro.org> wrote:

> I tested this on the Ux500 and sadly this happens
> already in probe():
(...)
> [    2.828815] stm32-hash a03c2000.hash: Algo 0 : 0 failed
> [    2.834144] stm32-hash: probe of a03c2000.hash failed with error -22

It turns out that this is because this:

-       /* Export Context */
-       u32                     *hw_context;
+       /* hash state */
+       u32                     hw_context[3 + HASH_CSR_REGISTER_NUMBER];

Makes struct stm32_hash_request_ctx 580 bytes
and that fails sanity check in ahash.c because
HASH_MAX_STATESIZE is 512.

I don't know the story behind why HASH_MAX_STATESIZE
is 512, the stm32 hash state contains a buffer of 256 bytes
so I guess either that buffer is a bit big or
HASH_MAX_STATESIZE is a bit small?

I'm happy to try to change either to make this fit.

Yours,
Linus Walleij
