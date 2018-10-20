Return-Path: <SRS0=gnyg=NA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C87F3ECDE3D
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Oct 2018 02:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55A0E21476
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Oct 2018 02:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="feEch0lO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55A0E21476
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbeJTKij (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Oct 2018 06:38:39 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:55976 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbeJTKij (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Oct 2018 06:38:39 -0400
Received: by mail-it1-f193.google.com with SMTP id c23-v6so6402727itd.5
        for <linux-crypto@vger.kernel.org>; Fri, 19 Oct 2018 19:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=i38GJYdCXacWqMuBUDgtH6Y/MQDaOipYTR80RO/edhg=;
        b=feEch0lOdmJKEUBzDciSC9UpNeGv2/Y28umgdgXAVnt+kkoDoEzX8JLAQuf29QvMsW
         rnt9wdqQU/LAN6QNBetxxdNOq3m1i8SODFR8B+hEGhygogLzURa2jJMAgc+sXA1NU1TB
         VZ0bT4txAtCJATHKixGZh05VjDKCCndYBRFLo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=i38GJYdCXacWqMuBUDgtH6Y/MQDaOipYTR80RO/edhg=;
        b=Cf2+5/oKMfHLKcw4LjgW5ygavA1KfdwAsXBYgeucwJlhmsRRD6/WcYdea6OfrTj20V
         oUt5rr4u/XRPSxqvZ0JDi+xZsKUGT33ttajktdtahy+w2w2XN/YKhPL3y6aMNroZHkJn
         NnCds2p4nZUVNrSqSii3jtxevn+V8qUjswMQVvAs5y7ZDCrhZRDGDcBdHRz9ejKshbsu
         dhGrFXDIQ3DK4F/5Q9la/+Sz+MQI8aud7ATko4tX3s17cmFFXBy3SZScLxdfg+cLtwUC
         qAUcSco3Uit6b5ihoOXQvTubq9ObvA1/fin8fOPPIFnsuuw5TU1yfjfB37//25ORDm4G
         MKYA==
X-Gm-Message-State: ABuFfoh4NpI5VCIIwYnqDPjVud3ohq45WLOOoJnv4mFRlmPzOabg+d0P
        hGt9Cuja6ZdyFGNdzlNQNVW2wRenoJYb/Z2k2i1sRg==
X-Google-Smtp-Source: ACcGV62IT08kpwwHwk2R72CSEoFVhBKv0Y0dBMQQyjuoIBV4O2S7wk70akOD8ceJ8QvVsBTWKiw8x1hpsa6GzF5z1mI=
X-Received: by 2002:a02:5147:: with SMTP id s68-v6mr26439793jaa.62.1540002592994;
 Fri, 19 Oct 2018 19:29:52 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a6b:5910:0:0:0:0:0 with HTTP; Fri, 19 Oct 2018 19:29:52
 -0700 (PDT)
In-Reply-To: <20181015175424.97147-6-ebiggers@kernel.org>
References: <20181015175424.97147-1-ebiggers@kernel.org> <20181015175424.97147-6-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sat, 20 Oct 2018 10:29:52 +0800
Message-ID:
 <CAKv+Gu88h8VEVbm-t1QBvNzCxfntivGwgRBb=z5mM-8JfCAY1Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 05/12] crypto: arm/chacha20 - add XChaCha20 support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kaiser <gkaiser@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Samuel Neves <samuel.c.p.neves@gmail.com>,
        Michael Halcrow <mhalcrow@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Tomer Ashur <tomer.ashur@esat.kuleuven.be>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181020022952.PHzvX7YBD7XqOYE9jrup7Nk5P6QpVkUqWBRiBxO7GXo@z>

On 16 October 2018 at 01:54, Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> Add an XChaCha20 implementation that is hooked up to the ARM NEON
> implementation of ChaCha20.  This is needed for use in the Adiantum
> encryption mode; see the generic code patch,
> "crypto: chacha20-generic - add XChaCha20 support", for more details.
>
> We also update the NEON code to support HChaCha20 on one block, so we
> can use that in XChaCha20 rather than calling the generic HChaCha20.
> This required factoring the permutation out into its own macro.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/arm/crypto/Kconfig              |   2 +-
>  arch/arm/crypto/chacha20-neon-core.S |  68 ++++++++++------
>  arch/arm/crypto/chacha20-neon-glue.c | 111 ++++++++++++++++++++-------
>  3 files changed, 130 insertions(+), 51 deletions(-)
>
> diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
> index ef0c7feea6e29..0aa1471f27d2e 100644
> --- a/arch/arm/crypto/Kconfig
> +++ b/arch/arm/crypto/Kconfig
> @@ -117,7 +117,7 @@ config CRYPTO_CRC32_ARM_CE
>         select CRYPTO_HASH
>
>  config CRYPTO_CHACHA20_NEON
> -       tristate "NEON accelerated ChaCha20 symmetric cipher"
> +       tristate "NEON accelerated ChaCha20 stream cipher algorithms"
>         depends on KERNEL_MODE_NEON
>         select CRYPTO_BLKCIPHER
>         select CRYPTO_CHACHA20
> diff --git a/arch/arm/crypto/chacha20-neon-core.S b/arch/arm/crypto/chacha20-neon-core.S
> index 50e7b98968189..db59f1fbc728b 100644
> --- a/arch/arm/crypto/chacha20-neon-core.S
> +++ b/arch/arm/crypto/chacha20-neon-core.S
> @@ -52,33 +52,22 @@
>         .fpu            neon
>         .align          5
>
> -ENTRY(chacha20_block_xor_neon)
> -       // r0: Input state matrix, s
> -       // r1: 1 data block output, o
> -       // r2: 1 data block input, i
> -
> -       //
> -       // This function encrypts one ChaCha20 block by loading the state matrix
> -       // in four NEON registers. It performs matrix operation on four words in
> -       // parallel, but requireds shuffling to rearrange the words after each
> -       // round.
> -       //
> -
> -       // x0..3 = s0..3
> -       add             ip, r0, #0x20
> -       vld1.32         {q0-q1}, [r0]
> -       vld1.32         {q2-q3}, [ip]
> -
> -       vmov            q8, q0
> -       vmov            q9, q1
> -       vmov            q10, q2
> -       vmov            q11, q3
> +/*
> + * _chacha20_permute - permute one block
> + *
> + * Permute one 64-byte block where the state matrix is stored in the four NEON
> + * registers q0-q3.  It performs matrix operation on four words in parallel, but

operations [since you're touching this anyway]

> + * requires shuffling to rearrange the words after each round.
> + *
> + * Clobbers: r3, q4-q5
> + */
> +.macro _chacha20_permute
>

As you know, I'd prefer the GAS directives to be indented and their
arguments to be aligned with the right hand sides of the ordinary
instructions. However, this entire file may end up getting replaced
once we move to your scalar version combined with AndyP's NEON
version, at which point it may no longer matter. [Does that code
support the alternative xchacha constructions btw?]

>         adr             ip, .Lrol8_table
>         mov             r3, #10
>         vld1.8          {d10}, [ip, :64]
>
> -.Ldoubleround:
> +.Ldoubleround_\@:
>         // x0 += x1, x3 = rotl32(x3 ^ x0, 16)
>         vadd.i32        q0, q0, q1
>         veor            q3, q3, q0
> @@ -140,7 +129,25 @@ ENTRY(chacha20_block_xor_neon)
>         vext.8          q3, q3, q3, #4
>
>         subs            r3, r3, #1
> -       bne             .Ldoubleround
> +       bne             .Ldoubleround_\@
> +.endm
> +

Since your macro does not take any parameters: could we change this to
a subroutine?

> +ENTRY(chacha20_block_xor_neon)
> +       // r0: Input state matrix, s
> +       // r1: 1 data block output, o
> +       // r2: 1 data block input, i
> +
> +       // x0..3 = s0..3
> +       add             ip, r0, #0x20
> +       vld1.32         {q0-q1}, [r0]
> +       vld1.32         {q2-q3}, [ip]
> +
> +       vmov            q8, q0
> +       vmov            q9, q1
> +       vmov            q10, q2
> +       vmov            q11, q3
> +
> +       _chacha20_permute
>
>         add             ip, r2, #0x20
>         vld1.8          {q4-q5}, [r2]
> @@ -169,6 +176,21 @@ ENTRY(chacha20_block_xor_neon)
>         bx              lr
>  ENDPROC(chacha20_block_xor_neon)
>
> +ENTRY(hchacha20_block_neon)
> +       // r0: Input state matrix, s
> +       // r1: output (8 32-bit words)
> +
> +       vld1.32         {q0-q1}, [r0]!
> +       vld1.32         {q2-q3}, [r0]
> +
> +       _chacha20_permute
> +
> +       vst1.32         {q0}, [r1]!
> +       vst1.32         {q3}, [r1]
> +
> +       bx              lr
> +ENDPROC(hchacha20_block_neon)
> +
>         .align          4
>  .Lctrinc:      .word   0, 1, 2, 3
>  .Lrol8_table:  .byte   3, 0, 1, 2, 7, 4, 5, 6
> diff --git a/arch/arm/crypto/chacha20-neon-glue.c b/arch/arm/crypto/chacha20-neon-glue.c
> index 7386eb1c1889d..becc7990b1d39 100644
> --- a/arch/arm/crypto/chacha20-neon-glue.c
> +++ b/arch/arm/crypto/chacha20-neon-glue.c
> @@ -1,5 +1,5 @@
>  /*
> - * ChaCha20 256-bit cipher algorithm, RFC7539, ARM NEON functions
> + * ChaCha20 (RFC7539) and XChaCha20 stream ciphers, NEON accelerated
>   *
>   * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
>   *
> @@ -30,6 +30,7 @@
>
>  asmlinkage void chacha20_block_xor_neon(u32 *state, u8 *dst, const u8 *src);
>  asmlinkage void chacha20_4block_xor_neon(u32 *state, u8 *dst, const u8 *src);
> +asmlinkage void hchacha20_block_neon(const u32 *state, u32 *out);
>
>  static void chacha20_doneon(u32 *state, u8 *dst, const u8 *src,
>                             unsigned int bytes)
> @@ -57,22 +58,17 @@ static void chacha20_doneon(u32 *state, u8 *dst, const u8 *src,
>         }
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
> -       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
> -               return crypto_chacha_crypt(req);
> -
>         err = skcipher_walk_virt(&walk, req, true);
>

I am slightly unhappy that we are still using atomic==true here, and
perform the entire scatterwalk with preemption disabled. Could we
please try and fix that as well (as a separate patch)? Thanks.

> -       crypto_chacha_init(state, ctx, walk.iv);
> +       crypto_chacha_init(state, ctx, iv);
>
> -       kernel_neon_begin();
>         while (walk.nbytes > 0) {
>                 unsigned int nbytes = walk.nbytes;
>
> @@ -83,27 +79,85 @@ static int chacha20_neon(struct skcipher_request *req)
>                                 nbytes);
>                 err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
>         }
> +
> +       return err;
> +}
> +
> +static int chacha20_neon(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       int err;
> +
> +       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
> +               return crypto_chacha_crypt(req);
> +
> +       kernel_neon_begin();
> +       err = chacha20_neon_stream_xor(req, ctx, req->iv);
> +       kernel_neon_end();
> +       return err;
> +}
> +
> +static int xchacha20_neon(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       struct chacha_ctx subctx;
> +       u32 state[16];
> +       u8 real_iv[16];
> +       int err;
> +
> +       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
> +               return crypto_xchacha_crypt(req);
> +
> +       crypto_chacha_init(state, ctx, req->iv);
> +
> +       kernel_neon_begin();
> +
> +       hchacha20_block_neon(state, subctx.key);
> +       memcpy(&real_iv[0], req->iv + 24, 8);
> +       memcpy(&real_iv[8], req->iv + 16, 8);
> +       err = chacha20_neon_stream_xor(req, &subctx, real_iv);
> +
>         kernel_neon_end();
>
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
> @@ -111,12 +165,12 @@ static int __init chacha20_simd_mod_init(void)
>         if (!(elf_hwcap & HWCAP_NEON))
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
> @@ -125,3 +179,6 @@ module_exit(chacha20_simd_mod_fini);
>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
>  MODULE_LICENSE("GPL v2");
>  MODULE_ALIAS_CRYPTO("chacha20");
> +MODULE_ALIAS_CRYPTO("chacha20-neon");
> +MODULE_ALIAS_CRYPTO("xchacha20");
> +MODULE_ALIAS_CRYPTO("xchacha20-neon");
> --
> 2.19.1.331.ge82ca0e54c-goog
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
