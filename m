Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D076C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6A1C263A6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 06:48:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CEgAEcvy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfFCGsI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 02:48:08 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:52000 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfFCGsH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 02:48:07 -0400
Received: by mail-it1-f193.google.com with SMTP id m3so25609112itl.1
        for <linux-crypto@vger.kernel.org>; Sun, 02 Jun 2019 23:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d8UtJ6o14HEX5h24XU1aacdxkU2D4UD+L8QjVE3PV78=;
        b=CEgAEcvy3jHhvtW1WV91xVIld7qFUSjDWYX0sM52wF3gqY/8QEF6xcktUJR0j3WRbF
         dghCkXX3lqnTD7bk7pbOlttlSkRUG6Ojy7OtPShxQ+HvjGrFlIH59/P+WQheFSwPKCH9
         H9LbD1/nZSDtrHYx9I8soh35ddrK5dkxsQ/w+yV/+8JUvgRHM8/Y5Uitla9s2qRyGseg
         VmFIxzFGDC9ck9FlFVzHMTPqXP/b/yqDV7L2TjoiqyCPkUr9lkySnhp9p+4rXkiiC0f6
         DK/KOQb6hUx7IAlsiXdPL7Q4p1bvJBfFIuPJLVq0WkuT02TagKg6QlZ+F0yKAWAK8hyu
         lBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d8UtJ6o14HEX5h24XU1aacdxkU2D4UD+L8QjVE3PV78=;
        b=H9mL69v28AYeSA2KkhDvQhmjEPj+ziGUWWEmmVNI5e5+hflya8wbCTD+yh6LFr2jsx
         POWzb+GRxVJBqm5DC7b2NvrcE8mlVev95jhWsXp7zPN0Avd+j14SGIdCJCNHFgQ+Tsgr
         FqsQz9EMhQuUOTbtEQS/d3THdMWoAKUSNhFOQRiW/KP/fNBrCJB+bgNNhUq+KmhhBmHk
         nkoD10iS6ii6dlvIe9NQqnud1ben+RpQLPA7b2g7jmTNtYv6X7R9K+5tl6rxW81P8rS5
         G7iTwg334HyYDW1hrkeVwcXwPaFYvS6wZKjuz9mlrOElJT2Xx/68k+TF00cRURyejcNH
         nUyA==
X-Gm-Message-State: APjAAAVmx+b6ap/S0ljaXM1HBs5RGQ8JVAcq70J1K3cjUJS0oSqWbO+p
        FPlqhyoXZTT1IVdG7n7Daoxff312tNrr8qdMxDJTaA==
X-Google-Smtp-Source: APXvYqwbd9uvGZpmobVUpUDFufycBdgtN7VeETHal7p804TTsJTcGeQDDq0CFd6MZAUEPgYQq4XwT68jKMzq6xSDsT0=
X-Received: by 2002:a24:740f:: with SMTP id o15mr54682itc.76.1559544486979;
 Sun, 02 Jun 2019 23:48:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190603054714.6477-1-ebiggers@kernel.org>
In-Reply-To: <20190603054714.6477-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 3 Jun 2019 08:47:54 +0200
Message-ID: <CAKv+Gu8YNvMY=iquLGuJj3gjaybr3V=BaFrT7YDM4Qb7muhoNg@mail.gmail.com>
Subject: Re: [PATCH] crypto: chacha - constify ctx and iv arguments
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 3 Jun 2019 at 07:47, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Constify the ctx and iv arguments to crypto_chacha_init() and the
> various chacha*_stream_xor() functions.  This makes it clear that they
> are not modified.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/chacha-neon-glue.c   | 2 +-
>  arch/arm64/crypto/chacha-neon-glue.c | 2 +-
>  arch/x86/crypto/chacha_glue.c        | 2 +-
>  crypto/chacha_generic.c              | 4 ++--
>  include/crypto/chacha.h              | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/crypto/chacha-neon-glue.c b/arch/arm/crypto/chacha-neon-glue.c
> index 48a89537b8283..a8e9b534c8da5 100644
> --- a/arch/arm/crypto/chacha-neon-glue.c
> +++ b/arch/arm/crypto/chacha-neon-glue.c
> @@ -63,7 +63,7 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
>  }
>
>  static int chacha_neon_stream_xor(struct skcipher_request *req,
> -                                 struct chacha_ctx *ctx, u8 *iv)
> +                                 const struct chacha_ctx *ctx, const u8 *iv)
>  {
>         struct skcipher_walk walk;
>         u32 state[16];
> diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
> index 82029cda2e77a..1495d2b18518d 100644
> --- a/arch/arm64/crypto/chacha-neon-glue.c
> +++ b/arch/arm64/crypto/chacha-neon-glue.c
> @@ -60,7 +60,7 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
>  }
>
>  static int chacha_neon_stream_xor(struct skcipher_request *req,
> -                                 struct chacha_ctx *ctx, u8 *iv)
> +                                 const struct chacha_ctx *ctx, const u8 *iv)
>  {
>         struct skcipher_walk walk;
>         u32 state[16];
> diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
> index 4967ad620775b..7276b7ef14ec4 100644
> --- a/arch/x86/crypto/chacha_glue.c
> +++ b/arch/x86/crypto/chacha_glue.c
> @@ -128,7 +128,7 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
>  }
>
>  static int chacha_simd_stream_xor(struct skcipher_walk *walk,
> -                                 struct chacha_ctx *ctx, u8 *iv)
> +                                 const struct chacha_ctx *ctx, const u8 *iv)
>  {
>         u32 *state, state_buf[16 + 2] __aligned(8);
>         int next_yield = 4096; /* bytes until next FPU yield */
> diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
> index d2ec04997832e..d283bd3bdb607 100644
> --- a/crypto/chacha_generic.c
> +++ b/crypto/chacha_generic.c
> @@ -36,7 +36,7 @@ static void chacha_docrypt(u32 *state, u8 *dst, const u8 *src,
>  }
>
>  static int chacha_stream_xor(struct skcipher_request *req,
> -                            struct chacha_ctx *ctx, u8 *iv)
> +                            const struct chacha_ctx *ctx, const u8 *iv)
>  {
>         struct skcipher_walk walk;
>         u32 state[16];
> @@ -60,7 +60,7 @@ static int chacha_stream_xor(struct skcipher_request *req,
>         return err;
>  }
>
> -void crypto_chacha_init(u32 *state, struct chacha_ctx *ctx, u8 *iv)
> +void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv)
>  {
>         state[0]  = 0x61707865; /* "expa" */
>         state[1]  = 0x3320646e; /* "nd 3" */
> diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
> index 1fc70a69d5508..d1e723c6a37dd 100644
> --- a/include/crypto/chacha.h
> +++ b/include/crypto/chacha.h
> @@ -41,7 +41,7 @@ static inline void chacha20_block(u32 *state, u8 *stream)
>  }
>  void hchacha_block(const u32 *in, u32 *out, int nrounds);
>
> -void crypto_chacha_init(u32 *state, struct chacha_ctx *ctx, u8 *iv);
> +void crypto_chacha_init(u32 *state, const struct chacha_ctx *ctx, const u8 *iv);
>
>  int crypto_chacha20_setkey(struct crypto_skcipher *tfm, const u8 *key,
>                            unsigned int keysize);
> --
> 2.21.0
>
