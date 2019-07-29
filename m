Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF906C7618B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 07:55:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACA902070B
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 07:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfG2Hzw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 03:55:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38592 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfG2Hzw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 03:55:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so60683100wrr.5
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2019 00:55:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OIS18r6UK0eOsXM1pY3I+V/7ZxX2mkZ4n37sC/EULhw=;
        b=d25mP+30UWNmAyjOOuRJJ7MJmP9gYinAncOk8UqAP6yKGzBmWlrnHPHykfmDb4QEmL
         2jo9Uz/8gMi/q6Kp5rlN9EC336ooM2fm5VwzO7ntc2oQ1ypuf7l9RxkVjBM/iDs4pgfl
         +NfQEI7dneKujr3zfKQQyhyGXyhbF++aUg4PM9fpB4x61NE0cv8NtMtRfwJZJXJqrBuv
         kEPhxAPyd8WcF41S2GVl5AjZy7rEHTjENel9Yv7H5g1Xn5+hfoiYr2tccT1/VP+Q1I22
         dFGSfHLYzOoJsw8ITE0CGmEiIykT780cOOCbCySDqk5zsYWNwNZii9OOiHG1NsPnQa3u
         HFig==
X-Gm-Message-State: APjAAAW4r/oA0EzPoamT22tB514ukbDmzuVG30StarBw7W1GVLA1XbJl
        wc1BmBx/NomU3vOMIs0WSj0VtsHY2EYHUaqD8QE=
X-Google-Smtp-Source: APXvYqx7N9+Dpp6yC70otmSXS9Vj9+OqHy7gAxGJhvIF0l5Dsofjp1qnzjIJB/a04eU2xEIac5RPXST4Jfo49sLkEKE=
X-Received: by 2002:adf:cd81:: with SMTP id q1mr116799597wrj.16.1564386949855;
 Mon, 29 Jul 2019 00:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190729074434.21064-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190729074434.21064-1-ard.biesheuvel@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 29 Jul 2019 09:55:38 +0200
Message-ID: <CAMuHMdUr9jidASX3X15B7R9z0zhKFNTUxQZtXv4NO1N53uZGPg@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis128 - deal with missing simd.h header on
 some architecures
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

On Mon, Jul 29, 2019 at 9:44 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> The generic aegis128 driver has been updated to support using SIMD
> intrinsics to implement the core AES based transform, and this has
> been wired up for ARM and arm64, which both provide a simd.h header.
>
> As it turns out, most architectures don't provide this header, even
> though a version of it exists in include/asm-generic, and this is
> not taken into account by the aegis128 driver, resulting in build
> failures on those architectures.
>
> So update the aegis128 code to only import simd.h (and the related
> header in internal/crypto) if the SIMD functionality is enabled for
> this driver.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thanks for your patch!

> --- a/crypto/aegis128-core.c
> +++ b/crypto/aegis128-core.c
> @@ -8,7 +8,6 @@
>
>  #include <crypto/algapi.h>
>  #include <crypto/internal/aead.h>
> -#include <crypto/internal/simd.h>
>  #include <crypto/internal/skcipher.h>
>  #include <crypto/scatterwalk.h>
>  #include <linux/err.h>
> @@ -16,7 +15,11 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/scatterlist.h>
> +
> +#ifdef CONFIG_CRYPTO_AEGIS128_SIMD
> +#include <crypto/internal/simd.h>
>  #include <asm/simd.h>

Wouldn't including <crypto/internal/simd.h> unconditionally, and
adding just

    #else
    static inline bool may_use_simd(void)
    {
            return false;
    }

and be done with it, work too?

> +#endif
>
>  #include "aegis.h"
>
> @@ -44,6 +47,15 @@ struct aegis128_ops {
>
>  static bool have_simd;
>
> +static bool aegis128_do_simd(void)
> +{
> +#ifdef CONFIG_CRYPTO_AEGIS128_SIMD
> +       if (have_simd)
> +               return crypto_simd_usable();
> +#endif
> +       return false;
> +}
> +
>  bool crypto_aegis128_have_simd(void);
>  void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg);
>  void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
> @@ -66,7 +78,7 @@ static void crypto_aegis128_update(struct aegis_state *state)
>  static void crypto_aegis128_update_a(struct aegis_state *state,
>                                      const union aegis_block *msg)
>  {
> -       if (have_simd && crypto_simd_usable()) {
> +       if (aegis128_do_simd()) {
>                 crypto_aegis128_update_simd(state, msg);
>                 return;
>         }

[...]

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
