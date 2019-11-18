Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05105C432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 07:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDD4420722
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 07:26:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NkrphAnI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfKRH0Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 02:26:24 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38456 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbfKRH0X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 02:26:23 -0500
Received: by mail-wr1-f65.google.com with SMTP id i12so18111781wro.5
        for <linux-crypto@vger.kernel.org>; Sun, 17 Nov 2019 23:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BQgLlwjFrDhOMMEiVqWy1bw521Ws4Cr7r/bflCmBelE=;
        b=NkrphAnIWbeKoBRRDOzpNzyBbKlBjRAoljf3f7xe9H7K2blM41vawLs6p540Zn8UOu
         +UNlVexkzJZ9S+wwTqA+gSUeidB63OC1GEoIS/uBBo4AA/aGA52fls/QyawHBvFJc9Sk
         ZOOUOdsdNp5hpRijOqOt7pK9LIKAVhVoTA6pDFQCT5EKZedMFPG0U+nZ/7szlYNz8Adf
         nk1fDNezb0RpOxVc92IW6McTmlbZRoFtJRU7GOp88WJ3bXWdW59MZ3yrjjH/kznx2nzJ
         +F4oZ5/qmiQXcCrusHGrsA+ReQdimFR3AipFUKBXFjz0i5q0vCTFbtu9JJvSZMYTgc6o
         jB+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BQgLlwjFrDhOMMEiVqWy1bw521Ws4Cr7r/bflCmBelE=;
        b=Dw4FjCvpRQJRldy2Q1xI2povbM7lzeiSMf7SbHF2FZ31KNdEvonQJJFLUqvrLqM5wl
         CLPqlE7tSj8Xr7j4XhCwa3a6BYAvbfFb/iioqvnd5LXms7E9VKguCnkoyBFiJrVztco8
         TqifL83plkUkfQeI60DKHUdPAc656WpyeBMqHfifD0cgXKncDpnguTMDu48JtPC9aaR7
         9T9hpKuo/RWj2ONCXOE3ZzLc2G15DYIsz54z8VcJH9wupRKTEDt/96juDIgshuH+vP5n
         clEdDHB7CjDY/s4h9cVLB8niJDaB0Ydg8q18cJAXDd4J8YQ2a4H1Ix0ahqYkAM+x+Kp2
         leSA==
X-Gm-Message-State: APjAAAWpdfZoqWY/MPeqzGG4B4yx4XCgxmFJWxrXABOSbSkGHe1Xay7L
        XdK53HHqOshmZmYe1NhCOj3xsuMCsirkcxcq1WKJPCinZi1NaA==
X-Google-Smtp-Source: APXvYqztq/lAoXftGE3joGYcuxCTGnu9yfcTUa1hk0WXZinE8q9PrjYKCaYFyn5sIdVXX4c6bRYWQEwRY4Cg9N6bJD8=
X-Received: by 2002:adf:f20d:: with SMTP id p13mr26827067wro.325.1574061981618;
 Sun, 17 Nov 2019 23:26:21 -0800 (PST)
MIME-Version: 1.0
References: <20191118072216.467693-1-ebiggers@kernel.org>
In-Reply-To: <20191118072216.467693-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 18 Nov 2019 08:26:09 +0100
Message-ID: <CAKv+Gu8t-NTBcprdP2fW41jQubxN3s-FUBSPCBcU8LcDghbV7g@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/chacha20poly1305 - use chacha20_crypt()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 18 Nov 2019 at 08:22, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Use chacha20_crypt() instead of chacha_crypt(), since it's not really
> appropriate for users of the ChaCha library API to be passing the number
> of rounds as an argument.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  lib/crypto/chacha20poly1305.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index 821e5cc9b14e..6d83cafebc69 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -66,14 +66,14 @@ __chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>                 __le64 lens[2];
>         } b;
>
> -       chacha_crypt(chacha_state, b.block0, pad0, sizeof(b.block0), 20);
> +       chacha20_crypt(chacha_state, b.block0, pad0, sizeof(b.block0));
>         poly1305_init(&poly1305_state, b.block0);
>
>         poly1305_update(&poly1305_state, ad, ad_len);
>         if (ad_len & 0xf)
>                 poly1305_update(&poly1305_state, pad0, 0x10 - (ad_len & 0xf));
>
> -       chacha_crypt(chacha_state, dst, src, src_len, 20);
> +       chacha20_crypt(chacha_state, dst, src, src_len);
>
>         poly1305_update(&poly1305_state, dst, src_len);
>         if (src_len & 0xf)
> @@ -140,7 +140,7 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>         if (unlikely(src_len < POLY1305_DIGEST_SIZE))
>                 return false;
>
> -       chacha_crypt(chacha_state, b.block0, pad0, sizeof(b.block0), 20);
> +       chacha20_crypt(chacha_state, b.block0, pad0, sizeof(b.block0));
>         poly1305_init(&poly1305_state, b.block0);
>
>         poly1305_update(&poly1305_state, ad, ad_len);
> @@ -160,7 +160,7 @@ __chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>
>         ret = crypto_memneq(b.mac, src + dst_len, POLY1305_DIGEST_SIZE);
>         if (likely(!ret))
> -               chacha_crypt(chacha_state, dst, src, dst_len, 20);
> +               chacha20_crypt(chacha_state, dst, src, dst_len);
>
>         memzero_explicit(&b, sizeof(b));
>
> @@ -241,7 +241,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
>         b.iv[1] = cpu_to_le64(nonce);
>
>         chacha_init(chacha_state, b.k, (u8 *)b.iv);
> -       chacha_crypt(chacha_state, b.block0, pad0, sizeof(b.block0), 20);
> +       chacha20_crypt(chacha_state, b.block0, pad0, sizeof(b.block0));
>         poly1305_init(&poly1305_state, b.block0);
>
>         if (unlikely(ad_len)) {
> @@ -278,14 +278,14 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
>
>                         if (unlikely(length < sl))
>                                 l &= ~(CHACHA_BLOCK_SIZE - 1);
> -                       chacha_crypt(chacha_state, addr, addr, l, 20);
> +                       chacha20_crypt(chacha_state, addr, addr, l);
>                         addr += l;
>                         length -= l;
>                 }
>
>                 if (unlikely(length > 0)) {
> -                       chacha_crypt(chacha_state, b.chacha_stream, pad0,
> -                                    CHACHA_BLOCK_SIZE, 20);
> +                       chacha20_crypt(chacha_state, b.chacha_stream, pad0,
> +                                      CHACHA_BLOCK_SIZE);
>                         crypto_xor(addr, b.chacha_stream, length);
>                         partial = length;
>                 }
> --
> 2.24.0
>
