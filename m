Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26297C7618F
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 21:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF10821019
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 21:17:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="itwJ/6Zo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbfGRVRR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 17:17:17 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32864 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbfGRVRR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 17:17:17 -0400
Received: by mail-pf1-f195.google.com with SMTP id g2so13189031pfq.0
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2019 14:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RheZEo0ByWVoAsse+7+UzvQGL1lauI18cqCeYYEU2X4=;
        b=itwJ/6Zo6ire+6bY6hv/pHAeUJPBFE0mWVZnPXePsf/QCBsQoyCkvttntCGmZgpt9q
         di/Tml8A3uZ0iGk9DEVxW9HY1uF7ArPmEZ/UVzu940F6WjerA2LRyzN8JvbSaI/msr99
         A/E5jXKI5Eppe+p99lyQeYLNzcbNg5YciIM9MWBbs/P3RoWvlK+N/bz3qlsfRwZgzIxs
         eYoJPyEMm3drO2JNaQkdca3XU3sPsszzTWIF6u/sNGNVEZIcRLO0wS0SZ8leeC1cFS1Q
         RPxB72BpTO+9tXVFOqiYLj4NsRV2QiH+AVdCbLe9YfuQv8XtvyIXFh7GUYVqdnPP7y1Y
         iDtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RheZEo0ByWVoAsse+7+UzvQGL1lauI18cqCeYYEU2X4=;
        b=pLCUfjISdbIQSIdO6DIHZI6+Cw1aHrizd6LRjB+055VQDomGqzI09hUmm89Z9NwDBS
         51YJz8JnKK5hd7k3re8Et1V6JNpp9Z+AVHH2os5FfHBGAJVoCX/Nw2oi/J5CDR5y360M
         w1INNTdBnvtamsY5Ev2vkaoaTQqypAxH70elAcw75CqNxfvaAx+OAwafS5iUF5YclIuS
         RmM4oO7Dt7CEJc3OfXh/3P48uRz2FbTEaJM93OpZm9Wz967QAaSLkgo8vJFvR3UlLzzi
         NjYP80Kwd2QZDiLD3cdIofKUFCv2AlZAZQ7rMPEdlCrVnUQY+FqvWZvBRUztVzJ5T2J2
         5F9g==
X-Gm-Message-State: APjAAAW5XTOyWU9HEWB2SBdaQpVM8ZmMIEvf6asQDK1m6Y3rm4Eb1+/1
        K1/m1ukgjmK2dgHadfvcplw9QqvH6KwQSSlgg/j1vrC6lFg=
X-Google-Smtp-Source: APXvYqymD3aZQjaUYh2vja626iApTb0mflzjq8KhKYrkBfBW1qEnkrZNy9omKOFqWN6nM+ILbWAQkpFSVU2vHEbSpMM=
X-Received: by 2002:a63:2cd1:: with SMTP id s200mr46303202pgs.10.1563484636536;
 Thu, 18 Jul 2019 14:17:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190718135017.2493006-1-arnd@arndb.de>
In-Reply-To: <20190718135017.2493006-1-arnd@arndb.de>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 18 Jul 2019 14:17:05 -0700
Message-ID: <CAKwvOd=HEjDA7pcsQvONoHgU2JH3xz+9MwHU0pXKathDRQx=nQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis: fix badly optimized clang output
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 18, 2019 at 6:50 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> Clang sometimes makes very different inlining decisions from gcc.
> In case of the aegis crypto algorithms, it decides to turn the innermost
> primitives (and, xor, ...) into separate functions but inline most of
> the rest.
>
> This results in a huge amount of variables spilled on the stack, leading
> to rather slow execution as well as kernel stack usage beyond the 32-bit
> warning limit when CONFIG_KASAN is enabled:
>
> crypto/aegis256.c:123:13: warning: stack frame size of 648 bytes in function 'crypto_aegis256_encrypt_chunk' [-Wframe-larger-than=]
> crypto/aegis256.c:366:13: warning: stack frame size of 1264 bytes in function 'crypto_aegis256_crypt' [-Wframe-larger-than=]
> crypto/aegis256.c:187:13: warning: stack frame size of 656 bytes in function 'crypto_aegis256_decrypt_chunk' [-Wframe-larger-than=]
> crypto/aegis128l.c:135:13: warning: stack frame size of 832 bytes in function 'crypto_aegis128l_encrypt_chunk' [-Wframe-larger-than=]
> crypto/aegis128l.c:415:13: warning: stack frame size of 1480 bytes in function 'crypto_aegis128l_crypt' [-Wframe-larger-than=]
> crypto/aegis128l.c:218:13: warning: stack frame size of 848 bytes in function 'crypto_aegis128l_decrypt_chunk' [-Wframe-larger-than=]
> crypto/aegis128.c:116:13: warning: stack frame size of 584 bytes in function 'crypto_aegis128_encrypt_chunk' [-Wframe-larger-than=]
> crypto/aegis128.c:351:13: warning: stack frame size of 1064 bytes in function 'crypto_aegis128_crypt' [-Wframe-larger-than=]
> crypto/aegis128.c:177:13: warning: stack frame size of 592 bytes in function 'crypto_aegis128_decrypt_chunk' [-Wframe-larger-than=]
>
> Forcing the primitives to all get inlined avoids the issue and the
> resulting code is similar to what gcc produces.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  crypto/aegis.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/crypto/aegis.h b/crypto/aegis.h
> index 41a3090cda8e..efed7251c49d 100644
> --- a/crypto/aegis.h
> +++ b/crypto/aegis.h
> @@ -34,21 +34,21 @@ static const union aegis_block crypto_aegis_const[2] = {
>         } },
>  };
>
> -static void crypto_aegis_block_xor(union aegis_block *dst,
> +static __always_inline void crypto_aegis_block_xor(union aegis_block *dst,

`static inline` would be more concise and expand to the same
attribute, IIRC.  Not sure if that's worth sending a v2. But for now,
thanks for the patch and:
Acked-by: Nick Desaulniers <ndesaulniers@google.com>

-- 
Thanks,
~Nick Desaulniers
