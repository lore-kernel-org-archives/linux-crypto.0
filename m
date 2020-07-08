Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D2FC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 05:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17CD820786
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 05:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594187211;
	bh=/WQ9sgKnqvm0XPAXINq6/92qnWxKdA6C2niRBgJzjis=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=MS2HbjxaUdfYsoaTwgwcpC/plTFnT2/nevqmysF3KUgXiXr+Ls2WZ/kltXIi/jkvy
	 db+Ue6AHbf2T6Z69pxqtw5cpMAv0BqYDZvh7CMOWd6ZCcTG6AgJt81dmE9L2iO5pMy
	 XZw6UqpebY+qO6oNwH2/SMHep0qmL+u0yJPojbl0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729218AbgGHFqu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 01:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbgGHFqu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 01:46:50 -0400
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 612B120786
        for <linux-crypto@vger.kernel.org>; Wed,  8 Jul 2020 05:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594187209;
        bh=/WQ9sgKnqvm0XPAXINq6/92qnWxKdA6C2niRBgJzjis=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=N+xY929otJCNtgEebf1mZX9MhGx2wWmBGHQZ6wLa0ovMGx1fSTHBdQRLz1Gp/DCUJ
         8H1LFiWo1gytdODUkqvLdvJ9DcVx7oDHC1FEEWlpMg7eg56qSQAQjpfRByh7Qi9KzV
         9u/SrvyTT3nIuzAPZWKCtmzWgJAu0enbWXLNVX1g=
Received: by mail-oi1-f175.google.com with SMTP id x83so29310753oif.10
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2020 22:46:49 -0700 (PDT)
X-Gm-Message-State: AOAM532R4K5szzNoOMaRhYKladmT/G93BoZhfkM+1vOnxhZGSfsgbjth
        aWXGlMgPH0md8bmkf8vQvjk2+xbwm2JxRA+A4f4=
X-Google-Smtp-Source: ABdhPJwREul5qv7JeQkE5lOQ/WbILKB2FHSyeCWj2MM7RDTntS8A17g3rO5Ou8ZAkmoa0C7I8y8uuPaGPmpF5aCsSOs=
X-Received: by 2002:aca:f257:: with SMTP id q84mr6197335oih.174.1594187208648;
 Tue, 07 Jul 2020 22:46:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200706133733.GA6479@gondor.apana.org.au> <20200706190717.GB736284@gmail.com>
 <20200706223716.GA10958@gondor.apana.org.au> <20200708023108.GK839@sol.localdomain>
 <20200708024402.GA10648@gondor.apana.org.au>
In-Reply-To: <20200708024402.GA10648@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 8 Jul 2020 08:46:37 +0300
X-Gmail-Original-Message-ID: <CAMj1kXEgd61L08k9S0xbvYnAT+bg4cZT-p1JsxtWfGhFOttEPw@mail.gmail.com>
Message-ID: <CAMj1kXEgd61L08k9S0xbvYnAT+bg4cZT-p1JsxtWfGhFOttEPw@mail.gmail.com>
Subject: Re: [v3 PATCH] crypto: chacha - Add DEFINE_CHACHA_STATE macro
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 8 Jul 2020 at 05:44, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Jul 07, 2020 at 07:31:08PM -0700, Eric Biggers wrote:
> >
> > Hmm, __chacha20poly1305_encrypt() already uses:
> >
> >       memzero_explicit(chacha_state, CHACHA_STATE_WORDS * sizeof(u32));
> >
> > That's equivalent to CHACHA_BLOCK_SIZE now, but it would be best to use the same
> > constant everywhere.  Can you pick one or the other to use?
> >
> > Also, in chacha20poly1305-selftest.c there's a state array that needs to be
> > converted to use the new macro:
> >
> >         u32 chacha20_state[CHACHA_STATE_WORDS];
>
> Thanks, here's v3:
>
> ---8<---
> As it stands the chacha state array is made 12 bytes bigger on
> x86 in order for it to be 16-byte aligned.  However, the array
> is not actually aligned until it hits the x86 code.
>

Why is that a problem? Only x86 cares about this.

Also, I wonder if we shouldn't simply change the chacha code to use
unaligned loads for the state array, as it likely makes very little
difference in practice (the state is not accessed from inside the
round processing loop)

> This patch moves the alignment to where the state array is defined.
> To do so a macro DEFINE_CHACHA_STATE has been added which takes
> care of all the work to ensure that it is actually aligned on the
> stack.
>
> This patch also changes an awkward use of CHACHA_STATE_WORDS to
> CHACHA_BLOCK_SIZE.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
> index 22250091cdbec..20d0252f11aa5 100644
> --- a/arch/x86/crypto/chacha_glue.c
> +++ b/arch/x86/crypto/chacha_glue.c
> @@ -14,8 +14,6 @@
>  #include <linux/module.h>
>  #include <asm/simd.h>
>
> -#define CHACHA_STATE_ALIGN 16
> -
>  asmlinkage void chacha_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
>                                        unsigned int len, int nrounds);
>  asmlinkage void chacha_4block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
> @@ -124,8 +122,6 @@ static void chacha_dosimd(u32 *state, u8 *dst, const u8 *src,
>
>  void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
>  {
> -       state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
> -
>         if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable()) {
>                 hchacha_block_generic(state, stream, nrounds);
>         } else {
> @@ -138,8 +134,6 @@ EXPORT_SYMBOL(hchacha_block_arch);
>
>  void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
>  {
> -       state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
> -
>         chacha_init_generic(state, key, iv);
>  }
>  EXPORT_SYMBOL(chacha_init_arch);
> @@ -147,8 +141,6 @@ EXPORT_SYMBOL(chacha_init_arch);
>  void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
>                        int nrounds)
>  {
> -       state = PTR_ALIGN(state, CHACHA_STATE_ALIGN);
> -
>         if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable() ||
>             bytes <= CHACHA_BLOCK_SIZE)
>                 return chacha_crypt_generic(state, dst, src, bytes, nrounds);
> @@ -170,15 +162,12 @@ EXPORT_SYMBOL(chacha_crypt_arch);
>  static int chacha_simd_stream_xor(struct skcipher_request *req,
>                                   const struct chacha_ctx *ctx, const u8 *iv)
>  {
> -       u32 *state, state_buf[16 + 2] __aligned(8);
> +       DEFINE_CHACHA_STATE(state);
>         struct skcipher_walk walk;
>         int err;
>
>         err = skcipher_walk_virt(&walk, req, false);
>
> -       BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
> -       state = PTR_ALIGN(state_buf + 0, CHACHA_STATE_ALIGN);
> -
>         chacha_init_generic(state, ctx->key, iv);
>
>         while (walk.nbytes > 0) {
> @@ -217,12 +206,10 @@ static int xchacha_simd(struct skcipher_request *req)
>  {
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>         struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
> -       u32 *state, state_buf[16 + 2] __aligned(8);
> +       DEFINE_CHACHA_STATE(state);
>         struct chacha_ctx subctx;
>         u8 real_iv[16];
>
> -       BUILD_BUG_ON(CHACHA_STATE_ALIGN != 16);
> -       state = PTR_ALIGN(state_buf + 0, CHACHA_STATE_ALIGN);
>         chacha_init_generic(state, ctx->key, req->iv);
>
>         if (req->cryptlen > CHACHA_BLOCK_SIZE && crypto_simd_usable()) {
> diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
> index 2676f4fbd4c16..dcc8cfe2debb9 100644
> --- a/include/crypto/chacha.h
> +++ b/include/crypto/chacha.h
> @@ -16,7 +16,7 @@
>  #define _CRYPTO_CHACHA_H
>
>  #include <asm/unaligned.h>
> -#include <linux/types.h>
> +#include <linux/kernel.h>
>
>  /* 32-bit stream position, then 96-bit nonce (RFC7539 convention) */
>  #define CHACHA_IV_SIZE         16
> @@ -25,10 +25,14 @@
>  #define CHACHA_BLOCK_SIZE      64
>  #define CHACHAPOLY_IV_SIZE     12
>
> +#define CHACHA_STATE_WORDS     (CHACHA_BLOCK_SIZE / sizeof(u32))
> +
>  #ifdef CONFIG_X86_64
> -#define CHACHA_STATE_WORDS     ((CHACHA_BLOCK_SIZE + 12) / sizeof(u32))
> +#define DEFINE_CHACHA_STATE(name) \
> +       u32 __##name##_buf[CHACHA_STATE_WORDS + 2] __aligned(8); \
> +       u32 *name = PTR_ALIGN((u32 *)__##name##_buf, 16)
>  #else
> -#define CHACHA_STATE_WORDS     (CHACHA_BLOCK_SIZE / sizeof(u32))
> +#define DEFINE_CHACHA_STATE(name) u32 name[CHACHA_STATE_WORDS]
>  #endif
>
>  /* 192-bit nonce, then 64-bit stream position */
> diff --git a/lib/crypto/chacha20poly1305-selftest.c b/lib/crypto/chacha20poly1305-selftest.c
> index fa43deda2660d..b8569b22ef549 100644
> --- a/lib/crypto/chacha20poly1305-selftest.c
> +++ b/lib/crypto/chacha20poly1305-selftest.c
> @@ -8832,7 +8832,7 @@ chacha20poly1305_encrypt_bignonce(u8 *dst, const u8 *src, const size_t src_len,
>  {
>         const u8 *pad0 = page_address(ZERO_PAGE(0));
>         struct poly1305_desc_ctx poly1305_state;
> -       u32 chacha20_state[CHACHA_STATE_WORDS];
> +       DEFINE_CHACHA_STATE(chacha20_state);
>         union {
>                 u8 block0[POLY1305_KEY_SIZE];
>                 __le64 lens[2];
> diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
> index ad0699ce702f9..c6baa946ccb1a 100644
> --- a/lib/crypto/chacha20poly1305.c
> +++ b/lib/crypto/chacha20poly1305.c
> @@ -85,7 +85,7 @@ __chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>
>         poly1305_final(&poly1305_state, dst + src_len);
>
> -       memzero_explicit(chacha_state, CHACHA_STATE_WORDS * sizeof(u32));
> +       memzero_explicit(chacha_state, CHACHA_BLOCK_SIZE);
>         memzero_explicit(&b, sizeof(b));
>  }
>
> @@ -94,7 +94,7 @@ void chacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>                               const u64 nonce,
>                               const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
> -       u32 chacha_state[CHACHA_STATE_WORDS];
> +       DEFINE_CHACHA_STATE(chacha_state);
>         u32 k[CHACHA_KEY_WORDS];
>         __le64 iv[2];
>
> @@ -116,7 +116,7 @@ void xchacha20poly1305_encrypt(u8 *dst, const u8 *src, const size_t src_len,
>                                const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
>                                const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
> -       u32 chacha_state[CHACHA_STATE_WORDS];
> +       DEFINE_CHACHA_STATE(chacha_state);
>
>         xchacha_init(chacha_state, key, nonce);
>         __chacha20poly1305_encrypt(dst, src, src_len, ad, ad_len, chacha_state);
> @@ -172,7 +172,7 @@ bool chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>                               const u64 nonce,
>                               const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
> -       u32 chacha_state[CHACHA_STATE_WORDS];
> +       DEFINE_CHACHA_STATE(chacha_state);
>         u32 k[CHACHA_KEY_WORDS];
>         __le64 iv[2];
>         bool ret;
> @@ -186,7 +186,7 @@ bool chacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>         ret = __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
>                                          chacha_state);
>
> -       memzero_explicit(chacha_state, sizeof(chacha_state));
> +       memzero_explicit(chacha_state, CHACHA_BLOCK_SIZE);
>         memzero_explicit(iv, sizeof(iv));
>         memzero_explicit(k, sizeof(k));
>         return ret;
> @@ -198,7 +198,7 @@ bool xchacha20poly1305_decrypt(u8 *dst, const u8 *src, const size_t src_len,
>                                const u8 nonce[XCHACHA20POLY1305_NONCE_SIZE],
>                                const u8 key[CHACHA20POLY1305_KEY_SIZE])
>  {
> -       u32 chacha_state[CHACHA_STATE_WORDS];
> +       DEFINE_CHACHA_STATE(chacha_state);
>
>         xchacha_init(chacha_state, key, nonce);
>         return __chacha20poly1305_decrypt(dst, src, src_len, ad, ad_len,
> @@ -216,7 +216,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
>  {
>         const u8 *pad0 = page_address(ZERO_PAGE(0));
>         struct poly1305_desc_ctx poly1305_state;
> -       u32 chacha_state[CHACHA_STATE_WORDS];
> +       DEFINE_CHACHA_STATE(chacha_state);
>         struct sg_mapping_iter miter;
>         size_t partial = 0;
>         unsigned int flags;
> @@ -328,7 +328,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
>                       !crypto_memneq(b.mac[0], b.mac[1], POLY1305_DIGEST_SIZE);
>         }
>
> -       memzero_explicit(chacha_state, sizeof(chacha_state));
> +       memzero_explicit(chacha_state, CHACHA_BLOCK_SIZE);
>         memzero_explicit(&b, sizeof(b));
>
>         return ret;
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
