Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E08C433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 08:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D42822573
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 08:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgLDIXb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Dec 2020 03:23:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:34356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgLDIXa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Dec 2020 03:23:30 -0500
X-Gm-Message-State: AOAM5333bDl88BV7NpBwsq9d+e2V4z6DP5vXDyex/68rAw/DWhI1c6RK
        hVlV5VpkP35K1c3lLxIiUHZN2Fqw49kqbxcEDb8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607070169;
        bh=BbsndswaG454/F/Tf749RPAMhWNdE22HBIy0hvvdXQA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=f7uVvsHc81BtXcYQ/lVl9kDpuNCBO3F/HdiP74V4mslZFfj2Ddw9ejvPxysSTkJK7
         iAIlbsDZma6lRgEct5boV8O4aUQyFwJIebqlaS6QPjlwJqfKMnk88tOQFuIcJQoQWq
         XsY0rUXmMs2uX7Us1z5i34lK6lTXThOhKpjf0uqwdrvMt9WaBgw4Hifz/WKyrPQPv5
         Duov1z3xvH0neftrNR2G7mmqMCCE0xqKZtP3D2L5REwABnkiKH8KXWJbzDdwmXCwHd
         2qY9HL2+4XmCKmhEQpnX01/H2lL7Bl2uuqX18QABr3klDRoDOdYlzDk9Vo6Kd/l5qb
         QPaeraDRUw63A==
X-Google-Smtp-Source: ABdhPJyBdCZ7WvEP7qcKrZRJHTWisAckdx44UjnhCmsKcT24MvH8HkiP4BZB7Evun/okNDAvgq70UAfzS8+rjFgppCw=
X-Received: by 2002:a9d:12c:: with SMTP id 41mr2728284otu.77.1607070168862;
 Fri, 04 Dec 2020 00:22:48 -0800 (PST)
MIME-Version: 1.0
References: <20201203222557.952393-1-arnd@kernel.org>
In-Reply-To: <20201203222557.952393-1-arnd@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 4 Dec 2020 09:22:37 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEFbTWSRg5fvD=YiJRCSuvpyF2zThaTvQVwFiSFGYvXZQ@mail.gmail.com>
Message-ID: <CAMj1kXEFbTWSRg5fvD=YiJRCSuvpyF2zThaTvQVwFiSFGYvXZQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis128 - fix link error without SIMD
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 3 Dec 2020 at 23:26, Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> When the SIMD portion of the driver is disabled, the compiler cannot
> figure out in advance if it will be called:
>
> ERROR: modpost: "crypto_aegis128_update_simd" [crypto/aegis128.ko] undefined!
>
> Add a conditional to let the compiler use dead code elimination
> as before.
>
> Fixes: ac50aec41a9f ("crypto: aegis128 - expose SIMD code path as separate driver")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

I already sent the exact same fix a couple of days ago, and Herbert
just merged it today.

> ---
>  crypto/aegis128-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/aegis128-core.c b/crypto/aegis128-core.c
> index 2b05f79475d3..89dc1c559689 100644
> --- a/crypto/aegis128-core.c
> +++ b/crypto/aegis128-core.c
> @@ -89,7 +89,7 @@ static void crypto_aegis128_update_a(struct aegis_state *state,
>                                      const union aegis_block *msg,
>                                      bool do_simd)
>  {
> -       if (do_simd) {
> +       if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) && do_simd) {
>                 crypto_aegis128_update_simd(state, msg);
>                 return;
>         }
> @@ -101,7 +101,7 @@ static void crypto_aegis128_update_a(struct aegis_state *state,
>  static void crypto_aegis128_update_u(struct aegis_state *state, const void *msg,
>                                      bool do_simd)
>  {
> -       if (do_simd) {
> +       if (IS_ENABLED(CONFIG_CRYPTO_AEGIS128_SIMD) && do_simd) {
>                 crypto_aegis128_update_simd(state, msg);
>                 return;
>         }
> --
> 2.27.0
>
