Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2212BC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 15:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6C582082C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 15:23:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XFe1S7MZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfFLPXo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 11:23:44 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:51294 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727419AbfFLPXn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 11:23:43 -0400
Received: by mail-it1-f194.google.com with SMTP id m3so11472935itl.1
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 08:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mSwto0mgHYVG9gI2wlGmWLY37bIRTJdnzdpwwnVGmL0=;
        b=XFe1S7MZyajHzRCiT6moaXBw0ryjqOpW/yMsy4TI1lF5nZI0CKOS8ZZeOfmEWg07Iz
         mBl/pmD6OvUpm7TJRKvg5PJaZqDvhPDX4oUsvIINy35Qmx5QirlZR1bPkDOBzYVUDjSO
         C/09pY2qnZ0YLyvfpQAYpWQOOmIv87+TSsZTvg4yy2A2YaXmaJHYSNvchGuIt3SbOmvA
         iIOx7UKyBUyo2GxP6dJHVrLP1s6lIYavjaXTwGNe61NMQ5Xk2XXk6foZtwcdX+FH8LaQ
         a1wvG1tadNed9hXQDv2oTpQ4L9H9vys4k0/b8pxAjVJrI2y2ZId/ISTJdnDqPwWysU9q
         Z2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mSwto0mgHYVG9gI2wlGmWLY37bIRTJdnzdpwwnVGmL0=;
        b=JlX53r/9OGnABGtLUaCPKaOIg/vTfaa+7ytXr8/tF6pPLT/Max7c/erFIg/9rUumCM
         h8FkUOrDNq7mKqx19UM7c4U45FpG3L4XHjRQgS5z3R3LcG8o92A/8BqtJ1+cVD5LiitB
         YC3G2n9PLsMfJ2LsSDRbfVpD7tnyWbFU03AXR0MGhj3ABBMYmeIO9al3iEFw1zIo1N/3
         K4cXGT5QwndyZNRP6qoZgKlrSdKVC6T9qkRQgvYUgV1RTbYnAhvTjDCzBlcTfKLDxfk2
         Sy5QEkuIgr1mm+RLl3mG9WP+3qZ2vE3IqwC1ya1vi8KKcNxfij7oeES7Jw7vxLaCofuC
         XpjA==
X-Gm-Message-State: APjAAAVlcAPctQ+J5sN7+SjJC0iphHvpfbzYWVtjUJ+As07Qit+TzBGU
        5o7yInYUNT2ayHiIGzYrUqnJLJfqxjVrttWdVXqvCNxdvTA=
X-Google-Smtp-Source: APXvYqwRE9Xi8c3OdUeF8baYZYnimKOJKzIvWNnSNf8NbO/b6xA3LlRYBP+2kc0QFTv7hdWv3Qbt5AXLsmXyvLm0ZMg=
X-Received: by 2002:a05:660c:44a:: with SMTP id d10mr20828968itl.153.1560353022409;
 Wed, 12 Jun 2019 08:23:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org> <20190612124838.2492-3-ard.biesheuvel@linaro.org>
In-Reply-To: <20190612124838.2492-3-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 12 Jun 2019 17:23:26 +0200
Message-ID: <CAKv+Gu_9phBet5pMDzqqP5=Hpp0BPN97sDuDDQyjK=DyDCoxWw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/20] crypto: arm/aes - rename local routines to
 prevent future clashes
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 12 Jun 2019 at 14:48, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> Rename some local AES encrypt/decrypt routines so they don't clash with
> the names we are about to introduce for the routines exposes by the
> generic AES library.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

I need to respin this patch - the subject line is inaccurate, and I
forgot to include a similar change for the AES-NI driver.

> ---
>  arch/arm/crypto/aes-cipher-glue.c   | 8 ++++----
>  arch/arm64/crypto/aes-cipher-glue.c | 8 ++++----
>  crypto/aes_generic.c                | 8 ++++----
>  3 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm/crypto/aes-cipher-glue.c b/arch/arm/crypto/aes-cipher-glue.c
> index c222f6e072ad..f6c07867b8ff 100644
> --- a/arch/arm/crypto/aes-cipher-glue.c
> +++ b/arch/arm/crypto/aes-cipher-glue.c
> @@ -19,7 +19,7 @@ EXPORT_SYMBOL(__aes_arm_encrypt);
>  asmlinkage void __aes_arm_decrypt(u32 *rk, int rounds, const u8 *in, u8 *out);
>  EXPORT_SYMBOL(__aes_arm_decrypt);
>
> -static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +static void aes_arm_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>         int rounds = 6 + ctx->key_length / 4;
> @@ -27,7 +27,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>         __aes_arm_encrypt(ctx->key_enc, rounds, in, out);
>  }
>
> -static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +static void aes_arm_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>         int rounds = 6 + ctx->key_length / 4;
> @@ -47,8 +47,8 @@ static struct crypto_alg aes_alg = {
>         .cra_cipher.cia_min_keysize     = AES_MIN_KEY_SIZE,
>         .cra_cipher.cia_max_keysize     = AES_MAX_KEY_SIZE,
>         .cra_cipher.cia_setkey          = crypto_aes_set_key,
> -       .cra_cipher.cia_encrypt         = aes_encrypt,
> -       .cra_cipher.cia_decrypt         = aes_decrypt,
> +       .cra_cipher.cia_encrypt         = aes_arm_encrypt,
> +       .cra_cipher.cia_decrypt         = aes_arm_decrypt,
>
>  #ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>         .cra_alignmask                  = 3,
> diff --git a/arch/arm64/crypto/aes-cipher-glue.c b/arch/arm64/crypto/aes-cipher-glue.c
> index 7288e7cbebff..0e90b06ebcec 100644
> --- a/arch/arm64/crypto/aes-cipher-glue.c
> +++ b/arch/arm64/crypto/aes-cipher-glue.c
> @@ -18,7 +18,7 @@ EXPORT_SYMBOL(__aes_arm64_encrypt);
>  asmlinkage void __aes_arm64_decrypt(u32 *rk, u8 *out, const u8 *in, int rounds);
>  EXPORT_SYMBOL(__aes_arm64_decrypt);
>
> -static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +static void aes_arm64_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>         int rounds = 6 + ctx->key_length / 4;
> @@ -26,7 +26,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>         __aes_arm64_encrypt(ctx->key_enc, out, in, rounds);
>  }
>
> -static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +static void aes_arm64_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>         int rounds = 6 + ctx->key_length / 4;
> @@ -46,8 +46,8 @@ static struct crypto_alg aes_alg = {
>         .cra_cipher.cia_min_keysize     = AES_MIN_KEY_SIZE,
>         .cra_cipher.cia_max_keysize     = AES_MAX_KEY_SIZE,
>         .cra_cipher.cia_setkey          = crypto_aes_set_key,
> -       .cra_cipher.cia_encrypt         = aes_encrypt,
> -       .cra_cipher.cia_decrypt         = aes_decrypt
> +       .cra_cipher.cia_encrypt         = aes_arm64_encrypt,
> +       .cra_cipher.cia_decrypt         = aes_arm64_decrypt
>  };
>
>  static int __init aes_init(void)
> diff --git a/crypto/aes_generic.c b/crypto/aes_generic.c
> index f217568917e4..3aa4a715c216 100644
> --- a/crypto/aes_generic.c
> +++ b/crypto/aes_generic.c
> @@ -1332,7 +1332,7 @@ EXPORT_SYMBOL_GPL(crypto_aes_set_key);
>         f_rl(bo, bi, 3, k);     \
>  } while (0)
>
> -static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +static void crypto_aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>         u32 b0[4], b1[4];
> @@ -1402,7 +1402,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>         i_rl(bo, bi, 3, k);     \
>  } while (0)
>
> -static void aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +static void crypto_aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
>         u32 b0[4], b1[4];
> @@ -1454,8 +1454,8 @@ static struct crypto_alg aes_alg = {
>                         .cia_min_keysize        =       AES_MIN_KEY_SIZE,
>                         .cia_max_keysize        =       AES_MAX_KEY_SIZE,
>                         .cia_setkey             =       crypto_aes_set_key,
> -                       .cia_encrypt            =       aes_encrypt,
> -                       .cia_decrypt            =       aes_decrypt
> +                       .cia_encrypt            =       crypto_aes_encrypt,
> +                       .cia_decrypt            =       crypto_aes_decrypt
>                 }
>         }
>  };
> --
> 2.20.1
>
