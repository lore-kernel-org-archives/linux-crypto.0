Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 175CBC4332E
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2D9D20732
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbhAPRRK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:17:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:32944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbhAPRRJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 12:17:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A56AD227C3;
        Sat, 16 Jan 2021 17:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610817388;
        bh=0xEHndJAgV7b746LctS4SnJRW0J0zVbPTwTSc4dep+8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=clTkJKTMXnup73UI6P2pa2pJ4TO0KJkIO4wJ9AFRuoepBEqzmEOmZYQbgKF55Baup
         4DD+OqwVUwJebP7oFCJb15vsVqWTO06SFzL0yJQhXveLMeVt4+JqULKDuMjnzf1u2P
         Qs2FNnSBimGY8mhBmdbTfCLvwmI9kVrPBIS9tvj6z/O/AIwKR6FrnM1AHKNLPbIioO
         W3rzVJzO4udf13ar5S6gaBZRvE2wwmvkNtuGJhSnrvhD8V0wrVJRzB0kUiytKy7gns
         pEdOMH7XK9SinZE2Q+vUA18rGGb9cmHTjSeTNQs7YHanFW4XDTWDKH5AEqkHnz3h2+
         G1xr0NFJiyvBA==
Received: by mail-ot1-f41.google.com with SMTP id n42so11881317ota.12;
        Sat, 16 Jan 2021 09:16:28 -0800 (PST)
X-Gm-Message-State: AOAM532MdITs0KZu5KVlwCJw0z3LAAZRdJiEcblZD5q6dFXcNV0nHgBn
        yImDy9cFfrgM1/YsnWYPNhVZHiCckFsOcFkNVw8=
X-Google-Smtp-Source: ABdhPJwCnAXl4nofDeP1LJ6N3qmeHJ8/xReGNnn05oPVwrQQj2guAQy2VeJuvaUC27ts4RKzHlnPOoLRaqvhtZbPGIw=
X-Received: by 2002:a05:6830:10d2:: with SMTP id z18mr12601240oto.90.1610817387910;
 Sat, 16 Jan 2021 09:16:27 -0800 (PST)
MIME-Version: 1.0
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com> <1608325864-4033-8-git-send-email-megha.dey@intel.com>
In-Reply-To: <1608325864-4033-8-git-send-email-megha.dey@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 16 Jan 2021 18:16:17 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEOs_x9jHTmksgRZ1bkDV2+je+JaaqLRXyL0hg5uC9gBg@mail.gmail.com>
Message-ID: <CAMj1kXEOs_x9jHTmksgRZ1bkDV2+je+JaaqLRXyL0hg5uC9gBg@mail.gmail.com>
Subject: Re: [RFC V1 7/7] crypto: aesni - AVX512 version of AESNI-GCM using VPCLMULQDQ
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
> Introduce the AVX512 implementation that optimizes the AESNI-GCM encode
> and decode routines using VPCLMULQDQ.
>
> The glue code in AESNI module overrides the existing AVX2 GCM mode
> encryption/decryption routines with the AX512 AES GCM mode ones when the
> following criteria are met:
> At compile time:
> 1. CONFIG_CRYPTO_AVX512 is enabled
> 2. toolchain(assembler) supports VPCLMULQDQ instructions
> At runtime:
> 1. VPCLMULQDQ and AVX512VL features are supported on a platform
>    (currently only Icelake)
> 2. aesni_intel.use_avx512 module parameter is set at boot time. For this
>    algorithm, switching from AVX512 optimized version is not possible
>    once set at boot time because of how the code is structured today.(Can
>    be changed later if required)
>
> The functions aesni_gcm_init_avx_512, aesni_gcm_enc_update_avx_512,
> aesni_gcm_dec_update_avx_512 and aesni_gcm_finalize_avx_512 are adapted
> from the Intel Optimized IPSEC Cryptographic library.
>
> On a Icelake desktop, with turbo disabled and all CPUs running at
> maximum frequency, the AVX512 GCM mode optimization shows better
> performance across data & key sizes as measured by tcrypt.
>
> The average performance improvement of the AVX512 version over the AVX2
> version is as follows:
> For all key sizes(128/192/256 bits),
>         data sizes < 128 bytes/block, negligible improvement (~7.5%)
>         data sizes > 128 bytes/block, there is an average improvement of
>         40% for both encryption and decryption.
>
> A typical run of tcrypt with AES GCM mode encryption/decryption of the
> AVX2 and AVX512 optimization on a Icelake desktop shows the following
> results:
>
>   ----------------------------------------------------------------------
>   |   key  | bytes | cycles/op (lower is better)   | Percentage gain/  |
>   | length |   per |   encryption  |  decryption   |      loss         |
>   | (bits) | block |-------------------------------|-------------------|
>   |        |       | avx2 | avx512 | avx2 | avx512 | Encrypt | Decrypt |
>   |---------------------------------------------------------------------
>   |  128   | 16    | 689  |  701   | 689  |  707   |  -1.7   |  -2.61  |
>   |  128   | 64    | 731  |  660   | 771  |  649   |   9.7   |  15.82  |
>   |  128   | 256   | 911  |  750   | 900  |  721   |  17.67  |  19.88  |
>   |  128   | 512   | 1181 |  814   | 1161 |  782   |  31.07  |  32.64  |
>   |  128   | 1024  | 1676 |  1052  | 1685 |  1030  |  37.23  |  38.87  |
>   |  128   | 2048  | 2475 |  1447  | 2456 |  1419  |  41.53  |  42.22  |
>   |  128   | 4096  | 3806 |  2154  | 3820 |  2119  |  43.41  |  44.53  |
>   |  128   | 8192  | 9169 |  3806  | 6997 |  3718  |  58.49  |  46.86  |
>   |  192   | 16    | 754  |  683   | 737  |  672   |   9.42  |   8.82  |
>   |  192   | 64    | 735  |  686   | 715  |  640   |   6.66  |  10.49  |
>   |  192   | 256   | 949  |  738   | 2435 |  729   |  22.23  |  70     |
>   |  192   | 512   | 1235 |  854   | 1200 |  833   |  30.85  |  30.58  |
>   |  192   | 1024  | 1777 |  1084  | 1763 |  1051  |  38.99  |  40.39  |
>   |  192   | 2048  | 2574 |  1497  | 2592 |  1459  |  41.84  |  43.71  |
>   |  192   | 4096  | 4086 |  2317  | 4091 |  2244  |  43.29  |  45.14  |
>   |  192   | 8192  | 7481 |  4054  | 7505 |  3953  |  45.81  |  47.32  |
>   |  256   | 16    | 755  |  682   | 720  |  683   |   9.68  |   5.14  |
>   |  256   | 64    | 744  |  677   | 719  |  658   |   9     |   8.48  |
>   |  256   | 256   | 962  |  758   | 948  |  749   |  21.21  |  21     |
>   |  256   | 512   | 1297 |  862   | 1276 |  836   |  33.54  |  34.48  |
>   |  256   | 1024  | 1831 |  1114  | 1819 |  1095  |  39.16  |  39.8   |
>   |  256   | 2048  | 2767 |  1566  | 2715 |  1524  |  43.4   |  43.87  |
>   |  256   | 4096  | 4378 |  2382  | 4368 |  2354  |  45.6   |  46.11  |
>   |  256   | 8192  | 8075 |  4262  | 8080 |  4186  |  47.22  |  48.19  |
>   ----------------------------------------------------------------------
>
> This work was inspired by the AES GCM mode optimization published in
> Intel Optimized IPSEC Cryptographic library.
> https://github.com/intel/intel-ipsec-mb/blob/master/lib/avx512/gcm_vaes_avx512.asm
>
> Co-developed-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
> Signed-off-by: Tomasz Kantecki <tomasz.kantecki@intel.com>
> Signed-off-by: Megha Dey <megha.dey@intel.com>
> ---
>  arch/x86/crypto/Makefile                    |    1 +
>  arch/x86/crypto/aesni-intel_avx512-x86_64.S | 1788 +++++++++++++++++++++++++++
>  arch/x86/crypto/aesni-intel_glue.c          |   62 +-
>  crypto/Kconfig                              |   12 +
>  4 files changed, 1858 insertions(+), 5 deletions(-)
>  create mode 100644 arch/x86/crypto/aesni-intel_avx512-x86_64.S
>
...
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index 9e56cdf..8fc5bac 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -55,13 +55,16 @@ MODULE_PARM_DESC(use_avx512, "Use AVX512 optimized algorithm, if available");
>   * This needs to be 16 byte aligned.
>   */
>  struct aesni_rfc4106_gcm_ctx {
> -       u8 hash_subkey[16] AESNI_ALIGN_ATTR;
> +       /* AVX512 optimized algorithms use 48 hash keys to conduct
> +        * multiple PCLMULQDQ operations in parallel
> +        */
> +       u8 hash_subkey[16 * 48] AESNI_ALIGN_ATTR;
>         struct crypto_aes_ctx aes_key_expanded AESNI_ALIGN_ATTR;
>         u8 nonce[4];
>  };
>
>  struct generic_gcmaes_ctx {
> -       u8 hash_subkey[16] AESNI_ALIGN_ATTR;
> +       u8 hash_subkey[16 * 48] AESNI_ALIGN_ATTR;
>         struct crypto_aes_ctx aes_key_expanded AESNI_ALIGN_ATTR;
>  };
>
> @@ -82,7 +85,7 @@ struct gcm_context_data {
>         u8 current_counter[GCM_BLOCK_LEN];
>         u64 partial_block_len;
>         u64 unused;
> -       u8 hash_keys[GCM_BLOCK_LEN * 16];
> +       u8 hash_keys[48 * 16];
>  };
>

This structure gets allocated on the stack, and gets inflated
significantly by this change, even though the code is not enabled by
default, and not even supported for most users.

Is it really necessary for this to be per-request data? If these are
precomputed powers of H, they can be moved into the TFM context
structure instead, which lives on the heap (and can be shared by all
concurrent users of the TFM)

>  asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
> @@ -266,6 +269,47 @@ static const struct aesni_gcm_tfm_s aesni_gcm_tfm_avx_gen2 = {
>         .finalize = &aesni_gcm_finalize_avx_gen2,
>  };
>
> +#ifdef CONFIG_CRYPTO_AES_GCM_AVX512
> +/*
> + * asmlinkage void aesni_gcm_init_avx_512()
> + * gcm_data *my_ctx_data, context data
> + * u8 *hash_subkey,  the Hash sub key input. Data starts on a 16-byte boundary.
> + */
> +asmlinkage void aesni_gcm_init_avx_512(void *my_ctx_data,
> +                                      struct gcm_context_data *gdata,
> +                                      u8 *iv,
> +                                      u8 *hash_subkey,
> +                                      const u8 *aad,
> +                                      unsigned long aad_len);
> +asmlinkage void aesni_gcm_enc_update_avx_512(void *ctx,
> +                                            struct gcm_context_data *gdata,
> +                                            u8 *out,
> +                                            const u8 *in,
> +                                            unsigned long plaintext_len);
> +asmlinkage void aesni_gcm_dec_update_avx_512(void *ctx,
> +                                            struct gcm_context_data *gdata,
> +                                            u8 *out,
> +                                            const u8 *in,
> +                                            unsigned long ciphertext_len);
> +asmlinkage void aesni_gcm_finalize_avx_512(void *ctx,
> +                                          struct gcm_context_data *gdata,
> +                                          u8 *auth_tag,
> +                                          unsigned long auth_tag_len);
> +
> +asmlinkage void aes_gcm_precomp_avx_512(struct crypto_aes_ctx *ctx, u8 *hash_subkey);
> +
> +static const struct aesni_gcm_tfm_s aesni_gcm_tfm_avx_512 = {
> +       .init = &aesni_gcm_init_avx_512,
> +       .enc_update = &aesni_gcm_enc_update_avx_512,
> +       .dec_update = &aesni_gcm_dec_update_avx_512,
> +       .finalize = &aesni_gcm_finalize_avx_512,
> +};
> +#else
> +static void aes_gcm_precomp_avx_512(struct crypto_aes_ctx *ctx, u8 *hash_subkey)
> +{}
> +static const struct aesni_gcm_tfm_s aesni_gcm_tfm_avx_512 = {};
> +#endif
> +

Please drop the alternative dummy definitions.

>  /*
>   * asmlinkage void aesni_gcm_init_avx_gen4()
>   * gcm_data *my_ctx_data, context data
> @@ -669,7 +713,11 @@ rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
>         /* We want to cipher all zeros to create the hash sub key. */
>         memset(hash_subkey, 0, RFC4106_HASH_SUBKEY_SIZE);
>
> -       aes_encrypt(&ctx, hash_subkey, hash_subkey);
> +       if (IS_ENABLED(CONFIG_CRYPTO_AES_GCM_AVX512) && use_avx512 &&
> +           cpu_feature_enabled(X86_FEATURE_VPCLMULQDQ))
> +               aes_gcm_precomp_avx_512(&ctx, hash_subkey);
> +       else
> +               aes_encrypt(&ctx, hash_subkey, hash_subkey);
>

I suppose this answers my question about the subkeys. Please find a
way to move these out of struct gcm_context_data so they don't need to
be copied to the stack for each request.


>         memzero_explicit(&ctx, sizeof(ctx));
>         return 0;
> @@ -1114,7 +1162,11 @@ static int __init aesni_init(void)
>         if (!x86_match_cpu(aesni_cpu_id))
>                 return -ENODEV;
>  #ifdef CONFIG_X86_64
> -       if (boot_cpu_has(X86_FEATURE_AVX2)) {
> +       if (use_avx512 && IS_ENABLED(CONFIG_CRYPTO_AES_GCM_AVX512) &&
> +           cpu_feature_enabled(X86_FEATURE_VPCLMULQDQ)) {
> +               pr_info("AVX512 version of gcm_enc/dec engaged.\n");
> +               aesni_gcm_tfm = &aesni_gcm_tfm_avx_512;

This was changed in the cryptodev tree to use static keys.

> +       } else if (boot_cpu_has(X86_FEATURE_AVX2)) {
>                 pr_info("AVX2 version of gcm_enc/dec engaged.\n");
>                 aesni_gcm_tfm = &aesni_gcm_tfm_avx_gen4;
>         } else if (boot_cpu_has(X86_FEATURE_AVX)) {
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 3043849..8c8a68d 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -661,6 +661,18 @@ config CRYPTO_AES_CTR_AVX512
>         depends on CRYPTO_AES_NI_INTEL
>         depends on AS_VAES_AVX512
>
> +# We default CRYPTO_AES_GCM_AVX512 to Y but depend on CRYPTO_AVX512 in
> +# order to have a singular option (CRYPTO_AVX512) select multiple algorithms
> +# when supported. Specifically, if the platform and/or toolset does not
> +# support VPLMULQDQ. Then this algorithm should not be supported as part of
> +# the set that CRYPTO_AVX512 selects.
> +config CRYPTO_AES_GCM_AVX512
> +       bool
> +       default y
> +       depends on CRYPTO_AVX512
> +       depends on CRYPTO_AES_NI_INTEL
> +       depends on AS_VPCLMULQDQ
> +
>  config CRYPTO_CRC32C_SPARC64
>         tristate "CRC32c CRC algorithm (SPARC64)"
>         depends on SPARC64
> --
> 2.7.4
>
