Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A379FC4332E
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81CDB227BF
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbhAPRPZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:15:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727750AbhAPRPI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 12:15:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE9D122AAA;
        Sat, 16 Jan 2021 17:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610816638;
        bh=TeXjR+ItUDvvMxOruc38Sze7esbkZH8fDlyb3hpc3rk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LUAXYqTEskkYmVX/kWrYaoW7aOU/cEu9ltFiI/kj7uxkmbWqaYW8oKHjN+iMGFrqK
         71xkgE5CFr3+IoWO9lbbUmfGNc6R9JhJ6S6FhmM5YuGMtaE0xWLhXOD99Z8rL0dV6X
         8DVZ6TEQ/xSA+9QDYWQB306NpYgaC7gVV8BQWWScH2bbnoEXGcBWb9Ks9eKMIgMuHP
         A+rcPcEOjEom7dBpdjY13WxrDGQO4jIyYyIITK7q3TMr1debJ4HmvEUzKXe3GKC7WK
         jKadYc+KNW47KKYs0dKUGY7LkW8YbDG80+88Zgj1yB5FSxbwhyZ/A6AQB8yLEM+nkQ
         YQB6POdIhyjyA==
Received: by mail-ot1-f50.google.com with SMTP id a109so11924379otc.1;
        Sat, 16 Jan 2021 09:03:58 -0800 (PST)
X-Gm-Message-State: AOAM531fWYq1q/CwV3vHhwpwymLoGKXxLUW5Q83z4y114uWKcUuBfMeS
        im/vynDyQ5ZuVcYSeLKSKIPrfhZT9sJDtXHqVx0=
X-Google-Smtp-Source: ABdhPJzkAjNBN2co9LhDe+hdOICe3q0XS/UMt0Psbae9Vca98cTW7tdIL8QhUipG+4vArEp5q+dNqXhVJom3tXSDjjI=
X-Received: by 2002:a05:6830:1c24:: with SMTP id f4mr12159353ote.108.1610816638018;
 Sat, 16 Jan 2021 09:03:58 -0800 (PST)
MIME-Version: 1.0
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com> <1608325864-4033-6-git-send-email-megha.dey@intel.com>
In-Reply-To: <1608325864-4033-6-git-send-email-megha.dey@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 16 Jan 2021 18:03:47 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH3Mkwfeq-Mu9s9p1fB3i3ez2EEnRbr9ZHZWePShnovcw@mail.gmail.com>
Message-ID: <CAMj1kXH3Mkwfeq-Mu9s9p1fB3i3ez2EEnRbr9ZHZWePShnovcw@mail.gmail.com>
Subject: Re: [RFC V1 5/7] crypto: aesni - AES CTR x86_64 "by16" AVX512 optimization
To:     Megha Dey <megha.dey@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, Dave Hansen <dave.hansen@intel.com>,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        Tony Luck <tony.luck@intel.com>, ira.weiny@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 18 Dec 2020 at 22:08, Megha Dey <megha.dey@intel.com> wrote:
>
> Introduce the "by16" implementation of the AES CTR mode using AVX512
> optimizations. "by16" means that 16 independent blocks (each block
> being 128 bits) can be ciphered simultaneously as opposed to the
> current 8 blocks.
>
> The glue code in AESNI module overrides the existing "by8" CTR mode
> encryption/decryption routines with the "by16" ones when the following
> criteria are met:
> At compile time:
> 1. CONFIG_CRYPTO_AVX512 is enabled
> 2. toolchain(assembler) supports VAES instructions
> At runtime:
> 1. VAES and AVX512VL features are supported on platform (currently
>    only Icelake)
> 2. aesni_intel.use_avx512 module parameter is set at boot time. For this
>    algorithm, switching from AVX512 optimized version is not possible once
>    set at boot time because of how the code is structured today.(Can be
>    changed later if required)
>
> The functions aes_ctr_enc_128_avx512_by16(), aes_ctr_enc_192_avx512_by16()
> and aes_ctr_enc_256_avx512_by16() are adapted from Intel Optimized IPSEC
> Cryptographic library.
>
> On a Icelake desktop, with turbo disabled and all CPUs running at maximum
> frequency, the "by16" CTR mode optimization shows better performance
> across data & key sizes as measured by tcrypt.
>
> The average performance improvement of the "by16" version over the "by8"
> version is as follows:
> For all key sizes(128/192/256 bits),
>         data sizes < 128 bytes/block, negligible improvement(~3% loss)
>         data sizes > 128 bytes/block, there is an average improvement of
> 48% for both encryption and decryption.
>
> A typical run of tcrypt with AES CTR mode encryption/decryption of the
> "by8" and "by16" optimization on a Icelake desktop shows the following
> results:
>
> --------------------------------------------------------------
> |  key   | bytes | cycles/op (lower is better)| percentage   |
> | length |  per  |  encryption  |  decryption |  loss/gain   |
> | (bits) | block |-------------------------------------------|
> |        |       | by8  | by16  | by8  | by16 |  enc | dec   |
> |------------------------------------------------------------|
> |  128   |  16   | 156  | 168   | 164  | 168  | -7.7 |  -2.5 |
> |  128   |  64   | 180  | 190   | 157  | 146  | -5.6 |   7.1 |
> |  128   |  256  | 248  | 158   | 251  | 161  | 36.3 |  35.9 |
> |  128   |  1024 | 633  | 316   | 642  | 319  | 50.1 |  50.4 |
> |  128   |  1472 | 853  | 411   | 877  | 407  | 51.9 |  53.6 |
> |  128   |  8192 | 4463 | 1959  | 4447 | 1940 | 56.2 |  56.4 |
> |  192   |  16   | 136  | 145   | 149  | 166  | -6.7 | -11.5 |
> |  192   |  64   | 159  | 154   | 157  | 160  |  3.2 |  -2   |
> |  192   |  256  | 268  | 172   | 274  | 177  | 35.9 |  35.5 |
> |  192   |  1024 | 710  | 358   | 720  | 355  | 49.6 |  50.7 |
> |  192   |  1472 | 989  | 468   | 983  | 469  | 52.7 |  52.3 |
> |  192   |  8192 | 6326 | 3551  | 6301 | 3567 | 43.9 |  43.4 |
> |  256   |  16   | 153  | 165   | 139  | 156  | -7.9 | -12.3 |
> |  256   |  64   | 158  | 152   | 174  | 161  |  3.8 |   7.5 |
> |  256   |  256  | 283  | 176   | 287  | 202  | 37.9 |  29.7 |
> |  256   |  1024 | 797  | 393   | 807  | 395  | 50.7 |  51.1 |
> |  256   |  1472 | 1108 | 534   | 1107 | 527  | 51.9 |  52.4 |
> |  256   |  8192 | 5763 | 2616  | 5773 | 2617 | 54.7 |  54.7 |
> --------------------------------------------------------------
>
> This work was inspired by the AES CTR mode optimization published
> in Intel Optimized IPSEC Cryptographic library.
> https://github.com/intel/intel-ipsec-mb/blob/master/lib/avx512/cntr_vaes_avx512.asm
>
> Co-developed-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
> Signed-off-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
> Signed-off-by: Megha Dey <megha.dey@intel.com>
> ---
>  arch/x86/crypto/Makefile                    |   1 +
>  arch/x86/crypto/aes_ctrby16_avx512-x86_64.S | 856 ++++++++++++++++++++++++++++
>  arch/x86/crypto/aesni-intel_glue.c          |  57 +-
>  arch/x86/crypto/avx512_vaes_common.S        | 422 ++++++++++++++
>  arch/x86/include/asm/disabled-features.h    |   8 +-
>  crypto/Kconfig                              |  12 +
>  6 files changed, 1354 insertions(+), 2 deletions(-)
>  create mode 100644 arch/x86/crypto/aes_ctrby16_avx512-x86_64.S
>
...
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index ad8a718..f45059e 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -46,6 +46,10 @@
>  #define CRYPTO_AES_CTX_SIZE (sizeof(struct crypto_aes_ctx) + AESNI_ALIGN_EXTRA)
>  #define XTS_AES_CTX_SIZE (sizeof(struct aesni_xts_ctx) + AESNI_ALIGN_EXTRA)
>
> +static bool use_avx512;
> +module_param(use_avx512, bool, 0644);
> +MODULE_PARM_DESC(use_avx512, "Use AVX512 optimized algorithm, if available");
> +
>  /* This data is stored at the end of the crypto_tfm struct.
>   * It's a type of per "session" data storage location.
>   * This needs to be 16 byte aligned.
> @@ -191,6 +195,35 @@ asmlinkage void aes_ctr_enc_192_avx_by8(const u8 *in, u8 *iv,
>                 void *keys, u8 *out, unsigned int num_bytes);
>  asmlinkage void aes_ctr_enc_256_avx_by8(const u8 *in, u8 *iv,
>                 void *keys, u8 *out, unsigned int num_bytes);
> +
> +#ifdef CONFIG_CRYPTO_AES_CTR_AVX512
> +asmlinkage void aes_ctr_enc_128_avx512_by16(void *keys, u8 *out,
> +                                           const u8 *in,
> +                                           unsigned int num_bytes,
> +                                           u8 *iv);
> +asmlinkage void aes_ctr_enc_192_avx512_by16(void *keys, u8 *out,
> +                                           const u8 *in,
> +                                           unsigned int num_bytes,
> +                                           u8 *iv);
> +asmlinkage void aes_ctr_enc_256_avx512_by16(void *keys, u8 *out,
> +                                           const u8 *in,
> +                                           unsigned int num_bytes,
> +                                           u8 *iv);
> +#else
> +static inline void aes_ctr_enc_128_avx512_by16(void *keys, u8 *out,
> +                                              const u8 *in,
> +                                              unsigned int num_bytes,
> +                                              u8 *iv) {}
> +static inline void aes_ctr_enc_192_avx512_by16(void *keys, u8 *out,
> +                                              const u8 *in,
> +                                              unsigned int num_bytes,
> +                                              u8 *iv) {}
> +static inline void aes_ctr_enc_256_avx512_by16(void *keys, u8 *out,
> +                                              const u8 *in,
> +                                              unsigned int num_bytes,
> +                                              u8 *iv) {}
> +#endif
> +

Please drop these alternatives.

>  /*
>   * asmlinkage void aesni_gcm_init_avx_gen2()
>   * gcm_data *my_ctx_data, context data
> @@ -487,6 +520,23 @@ static void aesni_ctr_enc_avx_tfm(struct crypto_aes_ctx *ctx, u8 *out,
>                 aes_ctr_enc_256_avx_by8(in, iv, (void *)ctx, out, len);
>  }
>
> +static void aesni_ctr_enc_avx512_tfm(struct crypto_aes_ctx *ctx, u8 *out,
> +                                    const u8 *in, unsigned int len, u8 *iv)
> +{
> +       /*
> +        * based on key length, override with the by16 version
> +        * of ctr mode encryption/decryption for improved performance.
> +        * aes_set_key_common() ensures that key length is one of
> +        * {128,192,256}
> +        */
> +       if (ctx->key_length == AES_KEYSIZE_128)
> +               aes_ctr_enc_128_avx512_by16((void *)ctx, out, in, len, iv);
> +       else if (ctx->key_length == AES_KEYSIZE_192)
> +               aes_ctr_enc_192_avx512_by16((void *)ctx, out, in, len, iv);
> +       else
> +               aes_ctr_enc_256_avx512_by16((void *)ctx, out, in, len, iv);
> +}
> +
>  static int ctr_crypt(struct skcipher_request *req)
>  {
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> @@ -1076,7 +1126,12 @@ static int __init aesni_init(void)
>                 aesni_gcm_tfm = &aesni_gcm_tfm_sse;
>         }
>         aesni_ctr_enc_tfm = aesni_ctr_enc;
> -       if (boot_cpu_has(X86_FEATURE_AVX)) {
> +       if (use_avx512 && IS_ENABLED(CONFIG_CRYPTO_AES_CTR_AVX512) &&
> +           cpu_feature_enabled(X86_FEATURE_VAES)) {
> +               /* Ctr mode performance optimization using AVX512 */
> +               aesni_ctr_enc_tfm = aesni_ctr_enc_avx512_tfm;
> +               pr_info("AES CTR mode by16 optimization enabled\n");

This will need to be changed to a static_call_update() once my
outstanding patch is merged.

> +       } else if (boot_cpu_has(X86_FEATURE_AVX)) {
>                 /* optimize performance of ctr mode encryption transform */
>                 aesni_ctr_enc_tfm = aesni_ctr_enc_avx_tfm;
>                 pr_info("AES CTR mode by8 optimization enabled\n");
