Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905B6C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 11:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349609AbiBKLsc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 06:48:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245485AbiBKLsb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 06:48:31 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACD4DCF1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 03:48:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE117CE2916
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 11:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFBDC340E9
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 11:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644580106;
        bh=LDw1Brop06iAPM+tW2aufBfmj2b24Mj3m12mlORTFrs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mYG8dxfbtuchntRWdJVQOY51HWcN+5r5ZiyrESeDggErGWONzq8VyU+BZT0rPAoSh
         kASCuq80OFUCMr9R1e8qB5j13txV76E7ImMwoI5ndkrK3TCsbzy3FyaJLzkSpTbT8j
         sNHOI+e0rVk4DmpQqwkHNPTqxoUIqCtaym5XDVJcO0HC/xIoz0RQVkAMr9bT8UWW6A
         FyAiffsjhvyAB1Z8UAGOz154fVwIpTjQ/P+Dl4hWYUnuUdI5kE+Idv+CQFbHcINO+e
         xrIktYk72mDUG6kyhfJ6yF2TFxZfsEijVTHLMCq1XofSwgVF4h+o2OqoztG8Gte/L0
         zW7WZ/KtXKCAA==
Received: by mail-wm1-f43.google.com with SMTP id k41so4134445wms.0
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 03:48:26 -0800 (PST)
X-Gm-Message-State: AOAM532r76i1FSuVTLOncj+awHknYp+rViNLcJCFHiyOZdIhoZfTPxhO
        Qr3WPMkKd/PIQ6QnwMdOrxBW32WBD2Vpykea7Xk=
X-Google-Smtp-Source: ABdhPJwUPp1hOG3w6NRpc5I3a0CxFO31XErqbot9WoQ3hqxdlHDr4yWRVQnaFe+No9TsDeixdEWlqwcJmroctaskSJA=
X-Received: by 2002:a05:600c:4f84:: with SMTP id n4mr1206131wmq.106.1644580104649;
 Fri, 11 Feb 2022 03:48:24 -0800 (PST)
MIME-Version: 1.0
References: <20220210232812.798387-1-nhuck@google.com> <20220210232812.798387-6-nhuck@google.com>
In-Reply-To: <20220210232812.798387-6-nhuck@google.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Fri, 11 Feb 2022 12:48:13 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEJRBcLBsO6HVQJNmGkxmY+aXY+BnyApn6s_MCtXo0eng@mail.gmail.com>
Message-ID: <CAMj1kXEJRBcLBsO6HVQJNmGkxmY+aXY+BnyApn6s_MCtXo0eng@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/7] crypto: arm64/aes-xctr: Add accelerated
 implementation of XCTR
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 11 Feb 2022 at 00:28, Nathan Huckleberry <nhuck@google.com> wrote:
>
> Add hardware accelerated version of XCTR for ARM64 CPUs with ARMv8
> Crypto Extension support.  This XCTR implementation is based on the CTR
> implementation in aes-modes.S.
>
> More information on XCTR can be found in
> the HCTR2 paper: Length-preserving encryption with HCTR2:
> https://eprint.iacr.org/2021/1441.pdf
>
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> ---
>
> Changes since v1:
>  * Added STRIDE back to aes-glue.c
>

NAK. Feel free to respond to my comments/questions against v1 if you
want to discuss this.


>  arch/arm64/crypto/Kconfig     |   4 +-
>  arch/arm64/crypto/aes-glue.c  |  72 ++++++++++++++++++-
>  arch/arm64/crypto/aes-modes.S | 130 ++++++++++++++++++++++++++++++++++
>  3 files changed, 202 insertions(+), 4 deletions(-)
>
> diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
> index 2a965aa0188d..897f9a4b5b67 100644
> --- a/arch/arm64/crypto/Kconfig
> +++ b/arch/arm64/crypto/Kconfig
> @@ -84,13 +84,13 @@ config CRYPTO_AES_ARM64_CE_CCM
>         select CRYPTO_LIB_AES
>
>  config CRYPTO_AES_ARM64_CE_BLK
> -       tristate "AES in ECB/CBC/CTR/XTS modes using ARMv8 Crypto Extensions"
> +       tristate "AES in ECB/CBC/CTR/XTS/XCTR modes using ARMv8 Crypto Extensions"
>         depends on KERNEL_MODE_NEON
>         select CRYPTO_SKCIPHER
>         select CRYPTO_AES_ARM64_CE
>
>  config CRYPTO_AES_ARM64_NEON_BLK
> -       tristate "AES in ECB/CBC/CTR/XTS modes using NEON instructions"
> +       tristate "AES in ECB/CBC/CTR/XTS/XCTR modes using NEON instructions"
>         depends on KERNEL_MODE_NEON
>         select CRYPTO_SKCIPHER
>         select CRYPTO_LIB_AES
> diff --git a/arch/arm64/crypto/aes-glue.c b/arch/arm64/crypto/aes-glue.c
> index 561dd2332571..dd04f3c5b0f1 100644
> --- a/arch/arm64/crypto/aes-glue.c
> +++ b/arch/arm64/crypto/aes-glue.c
> @@ -24,6 +24,7 @@
>  #ifdef USE_V8_CRYPTO_EXTENSIONS
>  #define MODE                   "ce"
>  #define PRIO                   300
> +#define STRIDE                 5
>  #define aes_expandkey          ce_aes_expandkey
>  #define aes_ecb_encrypt                ce_aes_ecb_encrypt
>  #define aes_ecb_decrypt                ce_aes_ecb_decrypt
> @@ -34,13 +35,15 @@
>  #define aes_essiv_cbc_encrypt  ce_aes_essiv_cbc_encrypt
>  #define aes_essiv_cbc_decrypt  ce_aes_essiv_cbc_decrypt
>  #define aes_ctr_encrypt                ce_aes_ctr_encrypt
> +#define aes_xctr_encrypt       ce_aes_xctr_encrypt
>  #define aes_xts_encrypt                ce_aes_xts_encrypt
>  #define aes_xts_decrypt                ce_aes_xts_decrypt
>  #define aes_mac_update         ce_aes_mac_update
> -MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
> +MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS/XCTR using ARMv8 Crypto Extensions");
>  #else
>  #define MODE                   "neon"
>  #define PRIO                   200
> +#define STRIDE                 4
>  #define aes_ecb_encrypt                neon_aes_ecb_encrypt
>  #define aes_ecb_decrypt                neon_aes_ecb_decrypt
>  #define aes_cbc_encrypt                neon_aes_cbc_encrypt
> @@ -50,16 +53,18 @@ MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 Crypto Extensions");
>  #define aes_essiv_cbc_encrypt  neon_aes_essiv_cbc_encrypt
>  #define aes_essiv_cbc_decrypt  neon_aes_essiv_cbc_decrypt
>  #define aes_ctr_encrypt                neon_aes_ctr_encrypt
> +#define aes_xctr_encrypt       neon_aes_xctr_encrypt
>  #define aes_xts_encrypt                neon_aes_xts_encrypt
>  #define aes_xts_decrypt                neon_aes_xts_decrypt
>  #define aes_mac_update         neon_aes_mac_update
> -MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS using ARMv8 NEON");
> +MODULE_DESCRIPTION("AES-ECB/CBC/CTR/XTS/XCTR using ARMv8 NEON");
>  #endif
>  #if defined(USE_V8_CRYPTO_EXTENSIONS) || !IS_ENABLED(CONFIG_CRYPTO_AES_ARM64_BS)
>  MODULE_ALIAS_CRYPTO("ecb(aes)");
>  MODULE_ALIAS_CRYPTO("cbc(aes)");
>  MODULE_ALIAS_CRYPTO("ctr(aes)");
>  MODULE_ALIAS_CRYPTO("xts(aes)");
> +MODULE_ALIAS_CRYPTO("xctr(aes)");
>  #endif
>  MODULE_ALIAS_CRYPTO("cts(cbc(aes))");
>  MODULE_ALIAS_CRYPTO("essiv(cbc(aes),sha256)");
> @@ -89,6 +94,10 @@ asmlinkage void aes_cbc_cts_decrypt(u8 out[], u8 const in[], u32 const rk[],
>  asmlinkage void aes_ctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
>                                 int rounds, int bytes, u8 ctr[]);
>
> +asmlinkage void aes_xctr_encrypt(u8 out[], u8 const in[], u32 const rk[],
> +                                int rounds, int bytes, u8 ctr[], u8 finalbuf[],
> +                                int byte_ctr);
> +
>  asmlinkage void aes_xts_encrypt(u8 out[], u8 const in[], u32 const rk1[],
>                                 int rounds, int bytes, u32 const rk2[], u8 iv[],
>                                 int first);
> @@ -442,6 +451,49 @@ static int __maybe_unused essiv_cbc_decrypt(struct skcipher_request *req)
>         return err ?: cbc_decrypt_walk(req, &walk);
>  }
>
> +static int __maybe_unused xctr_encrypt(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct crypto_aes_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       int err, rounds = 6 + ctx->key_length / 4;
> +       struct skcipher_walk walk;
> +       unsigned int byte_ctr = 0;
> +
> +       err = skcipher_walk_virt(&walk, req, false);
> +
> +       while (walk.nbytes > 0) {
> +               const u8 *src = walk.src.virt.addr;
> +               unsigned int nbytes = walk.nbytes;
> +               u8 *dst = walk.dst.virt.addr;
> +               u8 buf[AES_BLOCK_SIZE];
> +               unsigned int tail;
> +
> +               if (unlikely(nbytes < AES_BLOCK_SIZE))
> +                       src = memcpy(buf, src, nbytes);
> +               else if (nbytes < walk.total)
> +                       nbytes &= ~(AES_BLOCK_SIZE - 1);
> +
> +               kernel_neon_begin();
> +               aes_xctr_encrypt(dst, src, ctx->key_enc, rounds, nbytes,
> +                                                walk.iv, buf, byte_ctr);
> +               kernel_neon_end();
> +
> +               tail = nbytes % (STRIDE * AES_BLOCK_SIZE);
> +               if (tail > 0 && tail < AES_BLOCK_SIZE)
> +                       /*
> +                        * The final partial block could not be returned using
> +                        * an overlapping store, so it was passed via buf[]
> +                        * instead.
> +                        */
> +                       memcpy(dst + nbytes - tail, buf, tail);
> +               byte_ctr += nbytes;
> +
> +               err = skcipher_walk_done(&walk, walk.nbytes - nbytes);
> +       }
> +
> +       return err;
> +}
> +
>  static int __maybe_unused ctr_encrypt(struct skcipher_request *req)
>  {
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> @@ -669,6 +721,22 @@ static struct skcipher_alg aes_algs[] = { {
>         .setkey         = skcipher_aes_setkey,
>         .encrypt        = ctr_encrypt,
>         .decrypt        = ctr_encrypt,
> +}, {
> +       .base = {
> +               .cra_name               = "xctr(aes)",
> +               .cra_driver_name        = "xctr-aes-" MODE,
> +               .cra_priority           = PRIO,
> +               .cra_blocksize          = 1,
> +               .cra_ctxsize            = sizeof(struct crypto_aes_ctx),
> +               .cra_module             = THIS_MODULE,
> +       },
> +       .min_keysize    = AES_MIN_KEY_SIZE,
> +       .max_keysize    = AES_MAX_KEY_SIZE,
> +       .ivsize         = AES_BLOCK_SIZE,
> +       .chunksize      = AES_BLOCK_SIZE,
> +       .setkey         = skcipher_aes_setkey,
> +       .encrypt        = xctr_encrypt,
> +       .decrypt        = xctr_encrypt,
>  }, {
>         .base = {
>                 .cra_name               = "xts(aes)",
> diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
> index dc35eb0245c5..3b5c7a5c21e4 100644
> --- a/arch/arm64/crypto/aes-modes.S
> +++ b/arch/arm64/crypto/aes-modes.S
> @@ -479,6 +479,136 @@ ST5(      mov             v3.16b, v4.16b                  )
>         b               .Lctrout
>  AES_FUNC_END(aes_ctr_encrypt)
>
> +       /*
> +        * aes_xctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
> +        *                 int bytes, u8 const ctr[], u8 finalbuf[], int
> +        *                 byte_ctr)
> +        */
> +
> +AES_FUNC_START(aes_xctr_encrypt)
> +       stp             x29, x30, [sp, #-16]!
> +       mov             x29, sp
> +
> +       enc_prepare     w3, x2, x12
> +       ld1             {vctr.16b}, [x5]
> +
> +       umov            x12, vctr.d[0]          /* keep ctr in reg */
> +       lsr             x7, x7, #4
> +       add             x11, x7, #1
> +
> +.LxctrloopNx:
> +       add             w7, w4, #15
> +       sub             w4, w4, #MAX_STRIDE << 4
> +       lsr             w7, w7, #4
> +       mov             w8, #MAX_STRIDE
> +       cmp             w7, w8
> +       csel            w7, w7, w8, lt
> +       add             x11, x11, x7
> +
> +       mov             v0.16b, vctr.16b
> +       mov             v1.16b, vctr.16b
> +       mov             v2.16b, vctr.16b
> +       mov             v3.16b, vctr.16b
> +ST5(   mov             v4.16b, vctr.16b                )
> +
> +       sub             x7, x11, #MAX_STRIDE
> +       eor             x7, x12, x7
> +       ins             v0.d[0], x7
> +       sub             x7, x11, #MAX_STRIDE - 1
> +       sub             x8, x11, #MAX_STRIDE - 2
> +       eor             x7, x7, x12
> +       sub             x9, x11, #MAX_STRIDE - 3
> +       mov             v1.d[0], x7
> +       eor             x8, x8, x12
> +       eor             x9, x9, x12
> +ST5(   sub             x10, x11, #MAX_STRIDE - 4)
> +       mov             v2.d[0], x8
> +       eor             x10, x10, x12
> +       mov             v3.d[0], x9
> +ST5(   mov             v4.d[0], x10                    )
> +       tbnz            w4, #31, .Lxctrtail
> +       ld1             {v5.16b-v7.16b}, [x1], #48
> +ST4(   bl              aes_encrypt_block4x             )
> +ST5(   bl              aes_encrypt_block5x             )
> +       eor             v0.16b, v5.16b, v0.16b
> +ST4(   ld1             {v5.16b}, [x1], #16             )
> +       eor             v1.16b, v6.16b, v1.16b
> +ST5(   ld1             {v5.16b-v6.16b}, [x1], #32      )
> +       eor             v2.16b, v7.16b, v2.16b
> +       eor             v3.16b, v5.16b, v3.16b
> +ST5(   eor             v4.16b, v6.16b, v4.16b          )
> +       st1             {v0.16b-v3.16b}, [x0], #64
> +ST5(   st1             {v4.16b}, [x0], #16             )
> +       cbz             w4, .Lxctrout
> +       b               .LxctrloopNx
> +
> +.Lxctrout:
> +       ldp             x29, x30, [sp], #16
> +       ret
> +
> +.Lxctrtail:
> +       /* XOR up to MAX_STRIDE * 16 - 1 bytes of in/output with v0 ... v3/v4 */
> +       mov             x17, #16
> +       ands            x13, x4, #0xf
> +       csel            x13, x13, x17, ne
> +
> +ST5(   cmp             w4, #64 - (MAX_STRIDE << 4))
> +ST5(   csel            x14, x17, xzr, gt               )
> +       cmp             w4, #48 - (MAX_STRIDE << 4)
> +       csel            x15, x17, xzr, gt
> +       cmp             w4, #32 - (MAX_STRIDE << 4)
> +       csel            x16, x17, xzr, gt
> +       cmp             w4, #16 - (MAX_STRIDE << 4)
> +       ble             .Lxctrtail1x
> +
> +ST5(   mov             v4.d[0], x10                    )
> +
> +       adr_l           x12, .Lcts_permute_table
> +       add             x12, x12, x13
> +
> +ST5(   ld1             {v5.16b}, [x1], x14             )
> +       ld1             {v6.16b}, [x1], x15
> +       ld1             {v7.16b}, [x1], x16
> +
> +ST4(   bl              aes_encrypt_block4x             )
> +ST5(   bl              aes_encrypt_block5x             )
> +
> +       ld1             {v8.16b}, [x1], x13
> +       ld1             {v9.16b}, [x1]
> +       ld1             {v10.16b}, [x12]
> +
> +ST4(   eor             v6.16b, v6.16b, v0.16b          )
> +ST4(   eor             v7.16b, v7.16b, v1.16b          )
> +ST4(   tbl             v3.16b, {v3.16b}, v10.16b       )
> +ST4(   eor             v8.16b, v8.16b, v2.16b          )
> +ST4(   eor             v9.16b, v9.16b, v3.16b          )
> +
> +ST5(   eor             v5.16b, v5.16b, v0.16b          )
> +ST5(   eor             v6.16b, v6.16b, v1.16b          )
> +ST5(   tbl             v4.16b, {v4.16b}, v10.16b       )
> +ST5(   eor             v7.16b, v7.16b, v2.16b          )
> +ST5(   eor             v8.16b, v8.16b, v3.16b          )
> +ST5(   eor             v9.16b, v9.16b, v4.16b          )
> +
> +ST5(   st1             {v5.16b}, [x0], x14             )
> +       st1             {v6.16b}, [x0], x15
> +       st1             {v7.16b}, [x0], x16
> +       add             x13, x13, x0
> +       st1             {v9.16b}, [x13]         // overlapping stores
> +       st1             {v8.16b}, [x0]
> +       b               .Lxctrout
> +
> +.Lxctrtail1x:
> +       // use finalbuf if less than a full block
> +       csel            x0, x0, x6, eq
> +       ld1             {v5.16b}, [x1]
> +ST5(   mov             v3.16b, v4.16b                  )
> +       encrypt_block   v3, w3, x2, x8, w7
> +       eor             v5.16b, v5.16b, v3.16b
> +       st1             {v5.16b}, [x0]
> +       b               .Lxctrout
> +AES_FUNC_END(aes_xctr_encrypt)
> +
>
>         /*
>          * aes_xts_encrypt(u8 out[], u8 const in[], u8 const rk1[], int rounds,
> --
> 2.35.1.265.g69c8d7142f-goog
>
