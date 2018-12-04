Return-Path: <SRS0=wDfx=ON=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A0DC04EB8
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Dec 2018 14:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 406592082B
	for <linux-crypto@archiver.kernel.org>; Tue,  4 Dec 2018 14:51:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="SBlNMOi5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 406592082B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbeLDOvV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Dec 2018 09:51:21 -0500
Received: from mail-it1-f195.google.com ([209.85.166.195]:36559 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbeLDOvV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 09:51:21 -0500
Received: by mail-it1-f195.google.com with SMTP id c9so14810321itj.1
        for <linux-crypto@vger.kernel.org>; Tue, 04 Dec 2018 06:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IwvAlNKl3UbCp7ptSkj+3/ohbO44eAYh50QGmGqh2X8=;
        b=SBlNMOi5YWXNJfxggGb+qeSFPeOeQmEs1dcmNDLY1O/X+f/xlGO4tvM9hZhyUDTKrK
         +0DD4CosugAKx5Q+5tptTV3d6roUzjapi4wsG28tbdmP7d3q9iX4MHjS2fGRd7Ie9/X1
         PwUuDS/GJbwD33vEMOO8lgd8PPvgA+RxPSqNw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IwvAlNKl3UbCp7ptSkj+3/ohbO44eAYh50QGmGqh2X8=;
        b=sGnHBX5U0gTEPj2upJfpG5DRCVSJStzm0e/LIJI55JHWOuVdPDbAuPkmX9xzs8vqar
         48dip+u85wQPBUZtylouQ/11tsc5OAR1Rl9oqP/HRnrmtCNKsHoAQLzkVSqsv05bDc4h
         4CPSkhp1doduycRhfEVPm1GQ1RfnhVIKl2+e1HHmB9WDXPN+2pFNSu68dUn8QDiuE9K3
         uGB6+gHk0wGpTHZrDGbTfEzVB3EIdabsnNZdf5KLH4I0wjTnptu1RYEx2VheoWE36zxP
         ArfrHxesTZxeFP+tQCnOSfTCvfOZgTyvMT1/Gpjwp2s6oLmouhDHHCxgQk38RXOB3utp
         lEaA==
X-Gm-Message-State: AA+aEWaUQDrjy7QMwIRM40saqjxBbSMLHEKTimQ8qy83ML6zCcYEHP/y
        3RrnNrelMuSxfoSqBCLl+5E/Mjh+ItvXtPpHnYiVnw==
X-Google-Smtp-Source: AFSGD/VnBZVdhF5kr6ZkoHVa9Z/zEHts3PUFTiEoAoAvyJvuybl9kApYMIc4PJYRL7lUodxR682LQCEZ7E3/9VCyyMw=
X-Received: by 2002:a05:660c:4b:: with SMTP id p11mr12162594itk.71.1543935079919;
 Tue, 04 Dec 2018 06:51:19 -0800 (PST)
MIME-Version: 1.0
References: <20181204035252.14853-1-ebiggers@kernel.org> <20181204035252.14853-3-ebiggers@kernel.org>
In-Reply-To: <20181204035252.14853-3-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 4 Dec 2018 15:51:06 +0100
Message-ID:
 <CAKv+Gu_CJd3T-XyqZbYtCiiJN0ghhvmyHRNLPHrhCZA+tECGTg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] crypto: arm64/chacha20 - add XChaCha20 support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Paul Crowley <paulcrowley@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181204145106.QDB1nLwIn-wK3IUKTBwqx0dQzWxpbWlMSuuZcf7q0Jo@z>

On Tue, 4 Dec 2018 at 04:56, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add an XChaCha20 implementation that is hooked up to the ARM64 NEON
> implementation of ChaCha20.  This can be used by Adiantum.
>
> A NEON implementation of single-block HChaCha20 is also added so that
> XChaCha20 can use it rather than the generic implementation.  This
> required refactoring the ChaCha20 permutation into its own function.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm64/crypto/Kconfig              |   2 +-
>  arch/arm64/crypto/chacha20-neon-core.S |  65 +++++++++++-----
>  arch/arm64/crypto/chacha20-neon-glue.c | 101 +++++++++++++++++++------
>  3 files changed, 125 insertions(+), 43 deletions(-)
>
> diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
> index 3f5aeb786192..d54ddb8468ef 100644
> --- a/arch/arm64/crypto/Kconfig
> +++ b/arch/arm64/crypto/Kconfig
> @@ -101,7 +101,7 @@ config CRYPTO_AES_ARM64_NEON_BLK
>         select CRYPTO_SIMD
>
>  config CRYPTO_CHACHA20_NEON
> -       tristate "NEON accelerated ChaCha20 symmetric cipher"
> +       tristate "ChaCha20 and XChaCha20 stream ciphers using NEON instructions"
>         depends on KERNEL_MODE_NEON
>         select CRYPTO_BLKCIPHER
>         select CRYPTO_CHACHA20
> diff --git a/arch/arm64/crypto/chacha20-neon-core.S b/arch/arm64/crypto/chacha20-neon-core.S
> index 13c85e272c2a..0571e45a1a0a 100644
> --- a/arch/arm64/crypto/chacha20-neon-core.S
> +++ b/arch/arm64/crypto/chacha20-neon-core.S
> @@ -23,25 +23,20 @@
>         .text
>         .align          6
>
> -ENTRY(chacha20_block_xor_neon)
> -       // x0: Input state matrix, s
> -       // x1: 1 data block output, o
> -       // x2: 1 data block input, i
> -
> -       //
> -       // This function encrypts one ChaCha20 block by loading the state matrix
> -       // in four NEON registers. It performs matrix operation on four words in
> -       // parallel, but requires shuffling to rearrange the words after each
> -       // round.
> -       //
> -
> -       // x0..3 = s0..3
> -       adr             x3, ROT8
> -       ld1             {v0.4s-v3.4s}, [x0]
> -       ld1             {v8.4s-v11.4s}, [x0]
> -       ld1             {v12.4s}, [x3]
> +/*
> + * chacha20_permute - permute one block
> + *
> + * Permute one 64-byte block where the state matrix is stored in the four NEON
> + * registers v0-v3.  It performs matrix operations on four words in parallel,
> + * but requires shuffling to rearrange the words after each round.
> + *
> + * Clobbers: x3, x10, v4, v12
> + */
> +chacha20_permute:
>
>         mov             x3, #10
> +       adr             x10, ROT8
> +       ld1             {v12.4s}, [x10]
>
>  .Ldoubleround:
>         // x0 += x1, x3 = rotl32(x3 ^ x0, 16)
> @@ -105,6 +100,23 @@ ENTRY(chacha20_block_xor_neon)
>         subs            x3, x3, #1
>         b.ne            .Ldoubleround
>
> +       ret
> +ENDPROC(chacha20_permute)
> +
> +ENTRY(chacha20_block_xor_neon)
> +       // x0: Input state matrix, s
> +       // x1: 1 data block output, o
> +       // x2: 1 data block input, i
> +
> +       stp             x29, x30, [sp, #-16]!
> +       mov             x29, sp
> +
> +       // x0..3 = s0..3
> +       ld1             {v0.4s-v3.4s}, [x0]
> +       ld1             {v8.4s-v11.4s}, [x0]
> +
> +       bl              chacha20_permute
> +
>         ld1             {v4.16b-v7.16b}, [x2]
>
>         // o0 = i0 ^ (x0 + s0)
> @@ -125,9 +137,28 @@ ENTRY(chacha20_block_xor_neon)
>
>         st1             {v0.16b-v3.16b}, [x1]
>
> +       ldp             x29, x30, [sp], #16
>         ret
>  ENDPROC(chacha20_block_xor_neon)
>
> +ENTRY(hchacha20_block_neon)
> +       // x0: Input state matrix, s
> +       // x1: output (8 32-bit words)
> +
> +       stp             x29, x30, [sp, #-16]!
> +       mov             x29, sp
> +
> +       ld1             {v0.4s-v3.4s}, [x0]
> +
> +       bl              chacha20_permute
> +
> +       st1             {v0.16b}, [x1], #16
> +       st1             {v3.16b}, [x1]
> +
> +       ldp             x29, x30, [sp], #16
> +       ret
> +ENDPROC(hchacha20_block_neon)
> +
>         .align          6
>  ENTRY(chacha20_4block_xor_neon)
>         // x0: Input state matrix, s
> diff --git a/arch/arm64/crypto/chacha20-neon-glue.c b/arch/arm64/crypto/chacha20-neon-glue.c
> index 96e0cfb8c3f5..a5b9cbc0c4de 100644
> --- a/arch/arm64/crypto/chacha20-neon-glue.c
> +++ b/arch/arm64/crypto/chacha20-neon-glue.c
> @@ -30,6 +30,7 @@
>
>  asmlinkage void chacha20_block_xor_neon(u32 *state, u8 *dst, const u8 *src);
>  asmlinkage void chacha20_4block_xor_neon(u32 *state, u8 *dst, const u8 *src);
> +asmlinkage void hchacha20_block_neon(const u32 *state, u32 *out);
>
>  static void chacha20_doneon(u32 *state, u8 *dst, const u8 *src,
>                             unsigned int bytes)
> @@ -65,20 +66,16 @@ static void chacha20_doneon(u32 *state, u8 *dst, const u8 *src,
>         kernel_neon_end();
>  }
>
> -static int chacha20_neon(struct skcipher_request *req)
> +static int chacha20_neon_stream_xor(struct skcipher_request *req,
> +                                   struct chacha_ctx *ctx, u8 *iv)
>  {
> -       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> -       struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
>         struct skcipher_walk walk;
>         u32 state[16];
>         int err;
>
> -       if (!may_use_simd() || req->cryptlen <= CHACHA_BLOCK_SIZE)
> -               return crypto_chacha_crypt(req);
> -
>         err = skcipher_walk_virt(&walk, req, false);
>
> -       crypto_chacha_init(state, ctx, walk.iv);
> +       crypto_chacha_init(state, ctx, iv);
>
>         while (walk.nbytes > 0) {
>                 unsigned int nbytes = walk.nbytes;
> @@ -94,22 +91,73 @@ static int chacha20_neon(struct skcipher_request *req)
>         return err;
>  }
>
> -static struct skcipher_alg alg = {
> -       .base.cra_name          = "chacha20",
> -       .base.cra_driver_name   = "chacha20-neon",
> -       .base.cra_priority      = 300,
> -       .base.cra_blocksize     = 1,
> -       .base.cra_ctxsize       = sizeof(struct chacha_ctx),
> -       .base.cra_module        = THIS_MODULE,
> -
> -       .min_keysize            = CHACHA_KEY_SIZE,
> -       .max_keysize            = CHACHA_KEY_SIZE,
> -       .ivsize                 = CHACHA_IV_SIZE,
> -       .chunksize              = CHACHA_BLOCK_SIZE,
> -       .walksize               = 4 * CHACHA_BLOCK_SIZE,
> -       .setkey                 = crypto_chacha20_setkey,
> -       .encrypt                = chacha20_neon,
> -       .decrypt                = chacha20_neon,
> +static int chacha20_neon(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> +
> +       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
> +               return crypto_chacha_crypt(req);
> +
> +       return chacha20_neon_stream_xor(req, ctx, req->iv);
> +}
> +
> +static int xchacha20_neon(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       struct chacha_ctx subctx;
> +       u32 state[16];
> +       u8 real_iv[16];
> +
> +       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
> +               return crypto_xchacha_crypt(req);
> +
> +       crypto_chacha_init(state, ctx, req->iv);
> +
> +       kernel_neon_begin();
> +       hchacha20_block_neon(state, subctx.key);
> +       kernel_neon_end();
> +
> +       memcpy(&real_iv[0], req->iv + 24, 8);
> +       memcpy(&real_iv[8], req->iv + 16, 8);
> +       return chacha20_neon_stream_xor(req, &subctx, real_iv);
> +}
> +
> +static struct skcipher_alg algs[] = {
> +       {
> +               .base.cra_name          = "chacha20",
> +               .base.cra_driver_name   = "chacha20-neon",
> +               .base.cra_priority      = 300,
> +               .base.cra_blocksize     = 1,
> +               .base.cra_ctxsize       = sizeof(struct chacha_ctx),
> +               .base.cra_module        = THIS_MODULE,
> +
> +               .min_keysize            = CHACHA_KEY_SIZE,
> +               .max_keysize            = CHACHA_KEY_SIZE,
> +               .ivsize                 = CHACHA_IV_SIZE,
> +               .chunksize              = CHACHA_BLOCK_SIZE,
> +               .walksize               = 4 * CHACHA_BLOCK_SIZE,
> +               .setkey                 = crypto_chacha20_setkey,
> +               .encrypt                = chacha20_neon,
> +               .decrypt                = chacha20_neon,
> +       }, {
> +               .base.cra_name          = "xchacha20",
> +               .base.cra_driver_name   = "xchacha20-neon",
> +               .base.cra_priority      = 300,
> +               .base.cra_blocksize     = 1,
> +               .base.cra_ctxsize       = sizeof(struct chacha_ctx),
> +               .base.cra_module        = THIS_MODULE,
> +
> +               .min_keysize            = CHACHA_KEY_SIZE,
> +               .max_keysize            = CHACHA_KEY_SIZE,
> +               .ivsize                 = XCHACHA_IV_SIZE,
> +               .chunksize              = CHACHA_BLOCK_SIZE,
> +               .walksize               = 4 * CHACHA_BLOCK_SIZE,
> +               .setkey                 = crypto_chacha20_setkey,
> +               .encrypt                = xchacha20_neon,
> +               .decrypt                = xchacha20_neon,
> +       }
>  };
>
>  static int __init chacha20_simd_mod_init(void)
> @@ -117,12 +165,12 @@ static int __init chacha20_simd_mod_init(void)
>         if (!(elf_hwcap & HWCAP_ASIMD))
>                 return -ENODEV;
>
> -       return crypto_register_skcipher(&alg);
> +       return crypto_register_skciphers(algs, ARRAY_SIZE(algs));
>  }
>
>  static void __exit chacha20_simd_mod_fini(void)
>  {
> -       crypto_unregister_skcipher(&alg);
> +       crypto_unregister_skciphers(algs, ARRAY_SIZE(algs));
>  }
>
>  module_init(chacha20_simd_mod_init);
> @@ -131,3 +179,6 @@ module_exit(chacha20_simd_mod_fini);
>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>  MODULE_LICENSE("GPL v2");
>  MODULE_ALIAS_CRYPTO("chacha20");
> +MODULE_ALIAS_CRYPTO("chacha20-neon");
> +MODULE_ALIAS_CRYPTO("xchacha20");
> +MODULE_ALIAS_CRYPTO("xchacha20-neon");
> --
> 2.19.2
>
