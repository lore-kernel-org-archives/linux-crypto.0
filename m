Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B789C4361B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 10:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04A6B23741
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Dec 2020 10:17:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgLQKRK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Dec 2020 05:17:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbgLQKRI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Dec 2020 05:17:08 -0500
X-Gm-Message-State: AOAM530CmnjOxsAaSHkdjPh4QowdNGtk9Tv5O/M93TN19BBXL1TFZv20
        FCFDTotWAt3Kcv5Jusj+EbJgJq7Mkt2uLDLE0os=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608200186;
        bh=lXESWCOVNL3xUq/X4X+3UAWQlb+EhsufMJKSZHc86l8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iyBsH/nYgjwsmqQoadJyaL4/4Jy3MsieKQQx+M5O2FgvNjiiq1FsCOzZ3LRbHV5QV
         qSg9EGQiexi3aBIbkQLx3IO+Ya6iYOBG+GTKK6pC0QBIj2F4iBtMwTfMOEvjYJeSue
         K00BEqwFYc6cWDZ993vNOV+EgA5AmRUbxmNGz/8piM8G8FrAJ90RP9HaFbwZ37zqft
         W6XiKGunysczZ4wP2XpAItNhXlIq4zioTdxOLfKSEZSA1Neql2OC118EIi6FlY/ybl
         L+IQAy+bByn484WQkhdbLbNQmWDQKsZ20dWVYc5IiJXjGSPz5V2eFOBCU7veakFZST
         sJwKGx00G4iew==
X-Google-Smtp-Source: ABdhPJzzFooji/GQj2QYKfv9fKH2/DJcZJ4ZQPhk7yl8Zx/bVz28Ar+qM2Q6m5Mxwc0vp0l/URBfJw/LWFU+8U/XrjQ=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr4372953oig.33.1608200185024;
 Thu, 17 Dec 2020 02:16:25 -0800 (PST)
MIME-Version: 1.0
References: <20201216174146.10446-1-chang.seok.bae@intel.com> <20201216174146.10446-8-chang.seok.bae@intel.com>
In-Reply-To: <20201216174146.10446-8-chang.seok.bae@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 17 Dec 2020 11:16:14 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGa4f21eH0mdxd1pQsZMUjUr1Btq+Dgw-gC=O-yYft7xw@mail.gmail.com>
Message-ID: <CAMj1kXGa4f21eH0mdxd1pQsZMUjUr1Btq+Dgw-gC=O-yYft7xw@mail.gmail.com>
Subject: Re: [RFC PATCH 7/8] crypto: x86/aes-kl - Support AES algorithm using
 Key Locker instructions
To:     "Chang S. Bae" <chang.seok.bae@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@suse.de>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, ning.sun@intel.com,
        kumar.n.dwarakanath@intel.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello Chang,

On Wed, 16 Dec 2020 at 18:47, Chang S. Bae <chang.seok.bae@intel.com> wrote:
>
> Key Locker (KL) is Intel's new security feature that protects the AES key
> at the time of data transformation. New AES SIMD instructions -- as a
> successor of Intel's AES-NI -- are provided to encode an AES key and
> reference it for the AES algorithm.
>
> New instructions support 128/256-bit keys. While it is not desirable to
> receive any 192-bit key, AES-NI instructions are taken to serve this size.
>
> New instructions are operational in both 32-/64-bit modes.
>
> Add a set of new macros for the new instructions so that no new binutils
> version is required.
>
> Implemented methods are for a single block as well as ECB, CBC, CTR, and
> XTS modes. The methods are not compatible with other AES implementations as
> accessing an encrypted key instead of the normal AES key.
>
> setkey() call encodes an AES key. User may displace the AES key once
> encoded, as encrypt()/decrypt() methods do not need the key.
>
> Most C code follows the AES-NI implementation. It has higher priority than
> the AES-NI as providing key protection.
>
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: x86@kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/x86/crypto/Makefile           |   3 +
>  arch/x86/crypto/aeskl-intel_asm.S  | 881 +++++++++++++++++++++++++++++
>  arch/x86/crypto/aeskl-intel_glue.c | 697 +++++++++++++++++++++++
>  arch/x86/include/asm/inst.h        | 201 +++++++
>  crypto/Kconfig                     |  28 +
>  5 files changed, 1810 insertions(+)

We will need to refactor this - cloning the entire driver and just
replacing aes-ni with aes-kl is a maintenance nightmare.

Please refer to the arm64 tree for an example how to combine chaining
mode routines implemented in assembler with different implementations
of the core AES transforms (aes-modes.S is combined with either
aes-ce.S or aes-neon.S to produce two different drivers)

...
> diff --git a/arch/x86/crypto/aeskl-intel_glue.c b/arch/x86/crypto/aeskl-intel_glue.c
> new file mode 100644
> index 000000000000..9e3f900ad4af
> --- /dev/null
> +++ b/arch/x86/crypto/aeskl-intel_glue.c
> @@ -0,0 +1,697 @@
...
> +static void aeskl_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
> +{
> +       struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
> +       int err = 0;
> +
> +       if (!crypto_simd_usable())
> +               return;
> +

It is clear that AES-KL cannot be handled by a fallback algorithm,
given that the key is no longer available. But that doesn't mean that
you can just give up like this.

This basically implies that we cannot expose the cipher interface at
all, and so AES-KL can only be used by callers that use the
asynchronous interface, which rules out 802.11, s/w kTLS, macsec and
kerberos.

This ties in to a related discussion that is going on about when to
allow kernel mode SIMD. I am currently investigating whether we can
change the rules a bit so that crypto_simd_usable() is guaranteed to
be true.





> +       kernel_fpu_begin();
> +       /* 192-bit key not supported, fall back to AES-NI.*/
> +       if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +               aesni_enc(ctx, dst, src);
> +       else
> +               err = __aeskl_enc1(ctx, dst, src);
> +       kernel_fpu_end();
> +
> +       if (err)
> +               pr_err("aes-kl (encrypt): invalid handle\n");
> +}
> +
> +static void aeskl_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
> +{
> +       struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
> +       int err = 0;
> +
> +       if (!crypto_simd_usable())
> +               return;
> +
> +       kernel_fpu_begin();
> +       /* 192-bit key not supported, fall back to AES-NI */
> +       if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +               aesni_dec(ctx, dst, src);
> +       else
> +               err = __aeskl_dec1(ctx, dst, src);
> +       kernel_fpu_end();
> +
> +       if (err)
> +               pr_err("aes-kl (encrypt): invalid handle\n");
> +}
> +
> +static int aeskl_skcipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
> +                                unsigned int len)
> +{
> +       return aeskl_setkey_common(crypto_skcipher_tfm(tfm),
> +                                  crypto_skcipher_ctx(tfm), key, len);
> +}
> +
> +static int ecb_encrypt(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm;
> +       struct crypto_aes_ctx *ctx;
> +       struct skcipher_walk walk;
> +       unsigned int nbytes;
> +       int err;
> +
> +       tfm = crypto_skcipher_reqtfm(req);
> +       ctx = aes_ctx(crypto_skcipher_ctx(tfm));
> +
> +       err = skcipher_walk_virt(&walk, req, true);
> +       if (err)
> +               return err;
> +
> +       while ((nbytes = walk.nbytes)) {
> +               unsigned int len = nbytes & AES_BLOCK_MASK;
> +               const u8 *src = walk.src.virt.addr;
> +               u8 *dst = walk.dst.virt.addr;
> +
> +               kernel_fpu_begin();
> +               if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +                       aesni_ecb_enc(ctx, dst, src, len);

Could we please use a proper fallback here, and relay the entire request?


> +               else
> +                       err = __aeskl_ecb_enc(ctx, dst, src, len);
> +               kernel_fpu_end();
> +
> +               if (err) {
> +                       skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));

This doesn't look right. The skcipher scatterlist walker may have a
live kmap() here so you can't just return.

> +                       return -EINVAL;
> +               }
> +
> +               nbytes &= AES_BLOCK_SIZE - 1;
> +
> +               err = skcipher_walk_done(&walk, nbytes);
> +               if (err)
> +                       return err;
> +       }
> +
> +       return err;
> +}
> +
> +static int ecb_decrypt(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm;
> +       struct crypto_aes_ctx *ctx;
> +       struct skcipher_walk walk;
> +       unsigned int nbytes;
> +       int err;
> +
> +       tfm = crypto_skcipher_reqtfm(req);
> +       ctx = aes_ctx(crypto_skcipher_ctx(tfm));
> +
> +       err = skcipher_walk_virt(&walk, req, true);
> +       if (err)
> +               return err;
> +
> +       while ((nbytes = walk.nbytes)) {
> +               unsigned int len = nbytes & AES_BLOCK_MASK;
> +               const u8 *src = walk.src.virt.addr;
> +               u8 *dst = walk.dst.virt.addr;
> +
> +               kernel_fpu_begin();
> +               if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +                       aesni_ecb_dec(ctx, dst, src, len);
> +               else
> +                       err = __aeskl_ecb_dec(ctx, dst, src, len);
> +               kernel_fpu_end();
> +
> +               if (err) {
> +                       skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));
> +                       return -EINVAL;
> +               }
> +
> +               nbytes &= AES_BLOCK_SIZE - 1;
> +
> +               err = skcipher_walk_done(&walk, nbytes);
> +               if (err)
> +                       return err;
> +       }
> +
> +       return err;
> +}
> +
> +static int cbc_encrypt(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm;
> +       struct crypto_aes_ctx *ctx;
> +       struct skcipher_walk walk;
> +       unsigned int nbytes;
> +       int err;
> +
> +       tfm = crypto_skcipher_reqtfm(req);
> +       ctx = aes_ctx(crypto_skcipher_ctx(tfm));
> +       err = skcipher_walk_virt(&walk, req, true);
> +       if (err)
> +               return err;
> +
> +       while ((nbytes = walk.nbytes)) {
> +               unsigned int len = nbytes & AES_BLOCK_MASK;
> +               const u8 *src = walk.src.virt.addr;
> +               u8 *dst = walk.dst.virt.addr;
> +               u8 *iv = walk.iv;
> +
> +               kernel_fpu_begin();
> +               if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +                       aesni_cbc_enc(ctx, dst, src, len, iv);
> +               else
> +                       err = __aeskl_cbc_enc(ctx, dst, src, len, iv);
> +               kernel_fpu_end();
> +
> +               if (err) {
> +                       skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));
> +                       return -EINVAL;
> +               }
> +
> +               nbytes &= AES_BLOCK_SIZE - 1;
> +
> +               err = skcipher_walk_done(&walk, nbytes);
> +               if (err)
> +                       return err;
> +       }
> +
> +       return err;
> +}
> +
> +static int cbc_decrypt(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm;
> +       struct crypto_aes_ctx *ctx;
> +       struct skcipher_walk walk;
> +       unsigned int nbytes;
> +       int err;
> +
> +       tfm = crypto_skcipher_reqtfm(req);
> +       ctx = aes_ctx(crypto_skcipher_ctx(tfm));
> +       err = skcipher_walk_virt(&walk, req, true);
> +       if (err)
> +               return err;
> +
> +       while ((nbytes = walk.nbytes)) {
> +               unsigned int len = nbytes & AES_BLOCK_MASK;
> +               const u8 *src = walk.src.virt.addr;
> +               u8 *dst = walk.dst.virt.addr;
> +               u8 *iv = walk.iv;
> +
> +               kernel_fpu_begin();
> +               if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +                       aesni_cbc_dec(ctx, dst, src, len, iv);
> +               else
> +                       err = __aeskl_cbc_dec(ctx, dst, src, len, iv);
> +               kernel_fpu_end();
> +
> +               if (err) {
> +                       skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));
> +                       return -EINVAL;
> +               }
> +
> +               nbytes &= AES_BLOCK_SIZE - 1;
> +
> +               err = skcipher_walk_done(&walk, nbytes);
> +               if (err)
> +                       return err;
> +       }
> +
> +       return err;
> +}
> +
> +#ifdef CONFIG_X86_64
> +static int ctr_crypt(struct skcipher_request *req)
> +{
> +       struct crypto_skcipher *tfm;
> +       struct crypto_aes_ctx *ctx;
> +       struct skcipher_walk walk;
> +       unsigned int nbytes;
> +       int err;
> +
> +       tfm = crypto_skcipher_reqtfm(req);
> +       ctx = aes_ctx(crypto_skcipher_ctx(tfm));
> +
> +       err = skcipher_walk_virt(&walk, req, true);
> +       if (err)
> +               return err;
> +
> +       while ((nbytes = walk.nbytes) >= AES_BLOCK_SIZE) {
> +               unsigned int len = nbytes & AES_BLOCK_MASK;
> +               const u8 *src = walk.src.virt.addr;
> +               u8 *dst = walk.dst.virt.addr;
> +               u8 *iv = walk.iv;
> +
> +               kernel_fpu_begin();
> +               if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +                       aesni_ctr_enc(ctx, dst, src, len, iv);
> +               else
> +                       err = __aeskl_ctr_enc(ctx, dst, src, len, iv);
> +               kernel_fpu_end();
> +
> +               if (err) {
> +                       skcipher_walk_done(&walk, nbytes & (AES_BLOCK_SIZE - 1));
> +                       return -EINVAL;
> +               }
> +
> +               nbytes &= AES_BLOCK_SIZE - 1;
> +
> +               err = skcipher_walk_done(&walk, nbytes);
> +               if (err)
> +                       return err;
> +       }
> +
> +       if (nbytes) {
> +               u8 keystream[AES_BLOCK_SIZE];
> +               u8 *src = walk.src.virt.addr;
> +               u8 *dst = walk.dst.virt.addr;
> +               u8 *ctrblk = walk.iv;
> +
> +               kernel_fpu_begin();
> +               if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +                       aesni_enc(ctx, keystream, ctrblk);
> +               else
> +                       err = __aeskl_enc1(ctx, keystream, ctrblk);
> +               kernel_fpu_end();
> +
> +               if (err) {
> +                       skcipher_walk_done(&walk, 0);
> +                       return -EINVAL;
> +               }
> +
> +               crypto_xor(keystream, src, nbytes);
> +               memcpy(dst, keystream, nbytes);
> +               crypto_inc(ctrblk, AES_BLOCK_SIZE);
> +
> +               err = skcipher_walk_done(&walk, 0);
> +       }
> +
> +       return err;
> +}
> +
> +static int aeskl_xts_setkey(struct crypto_skcipher *tfm, const u8 *key,
> +                           unsigned int keylen)
> +{
> +       struct aeskl_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       int err;
> +
> +       err = xts_verify_key(tfm, key, keylen);
> +       if (err)
> +               return err;
> +
> +       keylen /= 2;
> +
> +       /* first half of xts-key is for crypt */
> +       err = aeskl_setkey_common(crypto_skcipher_tfm(tfm), ctx->raw_crypt_ctx, key, keylen);
> +       if (err)
> +               return err;
> +
> +       /* second half of xts-key is for tweak */
> +       return aeskl_setkey_common(crypto_skcipher_tfm(tfm), ctx->raw_tweak_ctx, key + keylen,
> +                                  keylen);
> +}
> +
> +static void aeskl_xts_tweak(const void *raw_ctx, u8 *out, const u8 *in)
> +{
> +       struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
> +
> +       if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +               aesni_enc(raw_ctx, out, in);
> +       else
> +               aeskl_enc1(raw_ctx, out, in);
> +}
> +
> +static void aeskl_xts_enc1(const void *raw_ctx, u8 *dst, const u8 *src, le128 *iv)
> +{
> +       struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
> +       common_glue_func_t fn = aeskl_enc1;
> +
> +       if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +               fn = aesni_enc;
> +
> +       glue_xts_crypt_128bit_one(raw_ctx, dst, src, iv, fn);
> +}
> +
> +static void aeskl_xts_dec1(const void *raw_ctx, u8 *dst, const u8 *src, le128 *iv)
> +{
> +       struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
> +       common_glue_func_t fn = aeskl_dec1;
> +
> +       if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +               fn = aesni_dec;
> +
> +       glue_xts_crypt_128bit_one(raw_ctx, dst, src, iv, fn);
> +}
> +
> +static void aeskl_xts_enc8(const void *raw_ctx, u8 *dst, const u8 *src, le128 *iv)
> +{
> +       struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
> +       int err = 0;
> +
> +       if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +               aesni_xts_crypt8(raw_ctx, dst, src, true, (u8 *)iv);
> +       else
> +               err = __aeskl_xts_crypt8(raw_ctx, dst, src, true, (u8 *)iv);
> +
> +       if (err)
> +               pr_err("aes-kl (XTS encrypt): invalid handle\n");
> +}
> +
> +static void aeskl_xts_dec8(const void *raw_ctx, u8 *dst, const u8 *src, le128 *iv)
> +{
> +       struct crypto_aes_ctx *ctx = aes_ctx((void *)raw_ctx);
> +       int err = 0;
> +
> +       if (unlikely(ctx->key_length == AES_KEYSIZE_192))
> +               aesni_xts_crypt8(raw_ctx, dst, src, false, (u8 *)iv);
> +       else
> +               __aeskl_xts_crypt8(raw_ctx, dst, src, false, (u8 *)iv);
> +
> +       if (err)
> +               pr_err("aes-kl (XTS decrypt): invalid handle\n");
> +}
> +
> +static const struct common_glue_ctx aeskl_xts_enc = {
> +       .num_funcs = 2,
> +       .fpu_blocks_limit = 1,
> +
> +       .funcs = { {
> +               .num_blocks = 8,
> +               .fn_u = { .xts = aeskl_xts_enc8 }
> +       }, {
> +               .num_blocks = 1,
> +               .fn_u = { .xts = aeskl_xts_enc1 }
> +       } }
> +};
> +
> +static const struct common_glue_ctx aeskl_xts_dec = {
> +       .num_funcs = 2,
> +       .fpu_blocks_limit = 1,
> +
> +       .funcs = { {
> +               .num_blocks = 8,
> +               .fn_u = { .xts = aeskl_xts_dec8 }
> +       }, {
> +               .num_blocks = 1,
> +               .fn_u = { .xts = aeskl_xts_dec1 }
> +       } }
> +};
> +
> +static int xts_crypt(struct skcipher_request *req, bool decrypt)
> +{
> +       struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +       struct aeskl_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
> +       const struct common_glue_ctx *gctx;
> +
> +       if (decrypt)
> +               gctx = &aeskl_xts_dec;
> +       else
> +               gctx = &aeskl_xts_enc;
> +
> +       return glue_xts_req_128bit(gctx, req, aeskl_xts_tweak,
> +                                  aes_ctx(ctx->raw_tweak_ctx),
> +                                  aes_ctx(ctx->raw_crypt_ctx),
> +                                  decrypt);
> +}
> +
> +static int xts_encrypt(struct skcipher_request *req)
> +{
> +       return xts_crypt(req, false);
> +}
> +
> +static int xts_decrypt(struct skcipher_request *req)
> +{
> +       return xts_crypt(req, true);
> +}
> +#endif
> +
> +static struct crypto_alg aeskl_cipher_alg = {
> +       .cra_name               = "aes",
> +       .cra_driver_name        = "aes-aeskl",
> +       .cra_priority           = 301,
> +       .cra_flags              = CRYPTO_ALG_TYPE_CIPHER,
> +       .cra_blocksize          = AES_BLOCK_SIZE,
> +       .cra_ctxsize            = CRYPTO_AESKL_CTX_SIZE,
> +       .cra_module             = THIS_MODULE,
> +       .cra_u  = {
> +               .cipher = {
> +                       .cia_min_keysize        = AES_MIN_KEY_SIZE,
> +                       .cia_max_keysize        = AES_MAX_KEY_SIZE,
> +                       .cia_setkey             = aeskl_setkey,
> +                       .cia_encrypt            = aeskl_encrypt,
> +                       .cia_decrypt            = aeskl_decrypt
> +               }
> +       }
> +};
> +
> +static struct skcipher_alg aeskl_skciphers[] = {
> +       {
> +               .base = {
> +                       .cra_name               = "__ecb(aes)",
> +                       .cra_driver_name        = "__ecb-aes-aeskl",
> +                       .cra_priority           = 401,
> +                       .cra_flags              = CRYPTO_ALG_INTERNAL,
> +                       .cra_blocksize          = AES_BLOCK_SIZE,
> +                       .cra_ctxsize            = CRYPTO_AESKL_CTX_SIZE,
> +                       .cra_module             = THIS_MODULE,
> +               },
> +               .min_keysize    = AES_MIN_KEY_SIZE,
> +               .max_keysize    = AES_MAX_KEY_SIZE,
> +               .setkey         = aeskl_skcipher_setkey,
> +               .encrypt        = ecb_encrypt,
> +               .decrypt        = ecb_decrypt,
> +       }, {
> +               .base = {
> +                       .cra_name               = "__cbc(aes)",
> +                       .cra_driver_name        = "__cbc-aes-aeskl",
> +                       .cra_priority           = 401,
> +                       .cra_flags              = CRYPTO_ALG_INTERNAL,
> +                       .cra_blocksize          = AES_BLOCK_SIZE,
> +                       .cra_ctxsize            = CRYPTO_AESKL_CTX_SIZE,
> +                       .cra_module             = THIS_MODULE,
> +               },
> +               .min_keysize    = AES_MIN_KEY_SIZE,
> +               .max_keysize    = AES_MAX_KEY_SIZE,
> +               .ivsize         = AES_BLOCK_SIZE,
> +               .setkey         = aeskl_skcipher_setkey,
> +               .encrypt        = cbc_encrypt,
> +               .decrypt        = cbc_decrypt,
> +#ifdef CONFIG_X86_64
> +       }, {
> +               .base = {
> +                       .cra_name               = "__ctr(aes)",
> +                       .cra_driver_name        = "__ctr-aes-aeskl",
> +                       .cra_priority           = 401,
> +                       .cra_flags              = CRYPTO_ALG_INTERNAL,
> +                       .cra_blocksize          = 1,
> +                       .cra_ctxsize            = CRYPTO_AESKL_CTX_SIZE,
> +                       .cra_module             = THIS_MODULE,
> +               },
> +               .min_keysize    = AES_MIN_KEY_SIZE,
> +               .max_keysize    = AES_MAX_KEY_SIZE,
> +               .ivsize         = AES_BLOCK_SIZE,
> +               .chunksize      = AES_BLOCK_SIZE,
> +               .setkey         = aeskl_skcipher_setkey,
> +               .encrypt        = ctr_crypt,
> +               .decrypt        = ctr_crypt,
> +       }, {
> +               .base = {
> +                       .cra_name               = "__xts(aes)",
> +                       .cra_driver_name        = "__xts-aes-aeskl",
> +                       .cra_priority           = 402,
> +                       .cra_flags              = CRYPTO_ALG_INTERNAL,
> +                       .cra_blocksize          = AES_BLOCK_SIZE,
> +                       .cra_ctxsize            = XTS_AESKL_CTX_SIZE,
> +                       .cra_module             = THIS_MODULE,
> +               },
> +               .min_keysize    = 2 * AES_MIN_KEY_SIZE,
> +               .max_keysize    = 2 * AES_MAX_KEY_SIZE,
> +               .ivsize         = AES_BLOCK_SIZE,
> +               .setkey         = aeskl_xts_setkey,
> +               .encrypt        = xts_encrypt,
> +               .decrypt        = xts_decrypt,
> +#endif
> +       }
> +};
> +
> +static struct simd_skcipher_alg *aeskl_simd_skciphers[ARRAY_SIZE(aeskl_skciphers)];
> +
> +static const struct x86_cpu_id aes_keylocker_cpuid[] = {
> +       X86_MATCH_FEATURE(X86_FEATURE_AES, NULL),
> +       X86_MATCH_FEATURE(X86_FEATURE_KEYLOCKER, NULL),
> +       {}
> +};
> +
> +static int __init aeskl_init(void)
> +{
> +       u32 eax, ebx, ecx, edx;
> +       int err;
> +
> +       if (!x86_match_cpu(aes_keylocker_cpuid))
> +               return -ENODEV;
> +
> +       cpuid_count(KEYLOCKER_CPUID, 0, &eax, &ebx, &ecx, &edx);
> +       if (!(ebx & KEYLOCKER_CPUID_EBX_AESKLE) ||
> +           !(eax & KEYLOCKER_CPUID_EAX_SUPERVISOR) ||
> +           !(ebx & KEYLOCKER_CPUID_EBX_WIDE))
> +               return -ENODEV;
> +
> +       err = crypto_register_alg(&aeskl_cipher_alg);
> +       if (err)
> +               return err;
> +
> +       err = simd_register_skciphers_compat(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
> +                                            aeskl_simd_skciphers);
> +       if (err)
> +               goto unregister_algs;
> +
> +       return 0;
> +
> +unregister_algs:
> +       crypto_unregister_alg(&aeskl_cipher_alg);
> +
> +       return err;
> +}
> +
> +static void __exit aeskl_exit(void)
> +{
> +       simd_unregister_skciphers(aeskl_skciphers, ARRAY_SIZE(aeskl_skciphers),
> +                                 aeskl_simd_skciphers);
> +       crypto_unregister_alg(&aeskl_cipher_alg);
> +}
> +
> +late_initcall(aeskl_init);
> +module_exit(aeskl_exit);
> +
> +MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm, AES Key Locker implementation");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_CRYPTO("aes");
> diff --git a/arch/x86/include/asm/inst.h b/arch/x86/include/asm/inst.h
> index bd7f02480ca1..b719a11a2905 100644
> --- a/arch/x86/include/asm/inst.h
> +++ b/arch/x86/include/asm/inst.h
> @@ -122,9 +122,62 @@
>  #endif
>         .endm
>
> +       .macro XMM_NUM opd xmm
> +       \opd = REG_NUM_INVALID
> +       .ifc \xmm,%xmm0
> +       \opd = 0
> +       .endif
> +       .ifc \xmm,%xmm1
> +       \opd = 1
> +       .endif
> +       .ifc \xmm,%xmm2
> +       \opd = 2
> +       .endif
> +       .ifc \xmm,%xmm3
> +       \opd = 3
> +       .endif
> +       .ifc \xmm,%xmm4
> +       \opd = 4
> +       .endif
> +       .ifc \xmm,%xmm5
> +       \opd = 5
> +       .endif
> +       .ifc \xmm,%xmm6
> +       \opd = 6
> +       .endif
> +       .ifc \xmm,%xmm7
> +       \opd = 7
> +       .endif
> +       .ifc \xmm,%xmm8
> +       \opd = 8
> +       .endif
> +       .ifc \xmm,%xmm9
> +       \opd = 9
> +       .endif
> +       .ifc \xmm,%xmm10
> +       \opd = 10
> +       .endif
> +       .ifc \xmm,%xmm11
> +       \opd = 11
> +       .endif
> +       .ifc \xmm,%xmm12
> +       \opd = 12
> +       .endif
> +       .ifc \xmm,%xmm13
> +       \opd = 13
> +       .endif
> +       .ifc \xmm,%xmm14
> +       \opd = 14
> +       .endif
> +       .ifc \xmm,%xmm15
> +       \opd = 15
> +       .endif
> +       .endm
> +
>         .macro REG_TYPE type reg
>         R32_NUM reg_type_r32 \reg
>         R64_NUM reg_type_r64 \reg
> +       XMM_NUM reg_type_xmm \reg
>         .if reg_type_r64 <> REG_NUM_INVALID
>         \type = REG_TYPE_R64
>         .elseif reg_type_r32 <> REG_NUM_INVALID
> @@ -134,6 +187,14 @@
>         .endif
>         .endm
>
> +       .macro PFX_OPD_SIZE
> +       .byte 0x66
> +       .endm
> +
> +       .macro PFX_RPT
> +       .byte 0xf3
> +       .endm
> +
>         .macro PFX_REX opd1 opd2 W=0
>         .if ((\opd1 | \opd2) & 8) || \W
>         .byte 0x40 | ((\opd1 & 8) >> 3) | ((\opd2 & 8) >> 1) | (\W << 3)
> @@ -158,6 +219,146 @@
>         .byte 0x0f, 0xc7
>         MODRM 0xc0 rdpid_opd 0x7
>  .endm
> +
> +       .macro ENCODEKEY128 reg1 reg2
> +       R32_NUM encodekey128_opd1 \reg1
> +       R32_NUM encodekey128_opd2 \reg2
> +       PFX_RPT
> +       .byte 0xf, 0x38, 0xfa
> +       MODRM 0xc0  encodekey128_opd2 encodekey128_opd1
> +       .endm
> +
> +       .macro ENCODEKEY256 reg1 reg2
> +       R32_NUM encodekey256_opd1 \reg1
> +       R32_NUM encodekey256_opd2 \reg2
> +       PFX_RPT
> +       .byte 0x0f, 0x38, 0xfb
> +       MODRM 0xc0 encodekey256_opd1 encodekey256_opd2
> +       .endm
> +
> +       .macro AESENC128KL reg, xmm
> +       REG_TYPE aesenc128kl_opd1_type \reg
> +       .if aesenc128kl_opd1_type == REG_TYPE_R64
> +       R64_NUM aesenc128kl_opd1 \reg
> +       .elseif aesenc128kl_opd1_type == REG_TYPE_R32
> +       R32_NUM aesenc128kl_opd1 \reg
> +       .else
> +       aesenc128kl_opd1 = REG_NUM_INVALID
> +       .endif
> +       XMM_NUM aesenc128kl_opd2 \xmm
> +       PFX_RPT
> +       .byte 0x0f, 0x38, 0xdc
> +       MODRM 0x0 aesenc128kl_opd1 aesenc128kl_opd2
> +       .endm
> +
> +       .macro AESDEC128KL reg, xmm
> +       REG_TYPE aesdec128kl_opd1_type \reg
> +       .if aesdec128kl_opd1_type == REG_TYPE_R64
> +       R64_NUM aesdec128kl_opd1 \reg
> +       .elseif aesdec128kl_opd1_type == REG_TYPE_R32
> +       R32_NUM aesdec128kl_opd1 \reg
> +       .else
> +       aesdec128kl_opd1 = REG_NUM_INVALID
> +       .endif
> +       XMM_NUM aesdec128kl_opd2 \xmm
> +       PFX_RPT
> +       .byte 0x0f, 0x38, 0xdd
> +       MODRM 0x0 aesdec128kl_opd1 aesdec128kl_opd2
> +       .endm
> +
> +       .macro AESENC256KL reg, xmm
> +       REG_TYPE aesenc256kl_opd1_type \reg
> +       .if aesenc256kl_opd1_type == REG_TYPE_R64
> +       R64_NUM aesenc256kl_opd1 \reg
> +       .elseif aesenc256kl_opd1_type == REG_TYPE_R32
> +       R32_NUM aesenc256kl_opd1 \reg
> +       .else
> +       aesenc256kl_opd1 = REG_NUM_INVALID
> +       .endif
> +       XMM_NUM aesenc256kl_opd2 \xmm
> +       PFX_RPT
> +       .byte 0x0f, 0x38, 0xde
> +       MODRM 0x0 aesenc256kl_opd1 aesenc256kl_opd2
> +       .endm
> +
> +       .macro AESDEC256KL reg, xmm
> +       REG_TYPE aesdec256kl_opd1_type \reg
> +       .if aesdec256kl_opd1_type == REG_TYPE_R64
> +       R64_NUM aesdec256kl_opd1 \reg
> +       .elseif aesdec256kl_opd1_type == REG_TYPE_R32
> +       R32_NUM aesdec256kl_opd1 \reg
> +       .else
> +       aesdec256kl_opd1 = REG_NUM_INVALID
> +       .endif
> +       XMM_NUM aesdec256kl_opd2 \xmm
> +       PFX_RPT
> +       .byte 0x0f, 0x38, 0xdf
> +       MODRM 0x0 aesdec256kl_opd1 aesdec256kl_opd2
> +       .endm
> +
> +       .macro AESENCWIDE128KL reg
> +       REG_TYPE aesencwide128kl_opd1_type \reg
> +       .if aesencwide128kl_opd1_type == REG_TYPE_R64
> +       R64_NUM aesencwide128kl_opd1 \reg
> +       .elseif aesencwide128kl_opd1_type == REG_TYPE_R32
> +       R32_NUM aesencwide128kl_opd1 \reg
> +       .else
> +       aesencwide128kl_opd1 = REG_NUM_INVALID
> +       .endif
> +       PFX_RPT
> +       .byte 0x0f, 0x38, 0xd8
> +       MODRM 0x0 aesencwide128kl_opd1 0x0
> +       .endm
> +
> +       .macro AESDECWIDE128KL reg
> +       REG_TYPE aesdecwide128kl_opd1_type \reg
> +       .if aesdecwide128kl_opd1_type == REG_TYPE_R64
> +       R64_NUM aesdecwide128kl_opd1 \reg
> +       .elseif aesdecwide128kl_opd1_type == REG_TYPE_R32
> +       R32_NUM aesdecwide128kl_opd1 \reg
> +       .else
> +       aesdecwide128kl_opd1 = REG_NUM_INVALID
> +       .endif
> +       PFX_RPT
> +       .byte 0x0f, 0x38, 0xd8
> +       MODRM 0x0 aesdecwide128kl_opd1 0x1
> +       .endm
> +
> +       .macro AESENCWIDE256KL reg
> +       REG_TYPE aesencwide256kl_opd1_type \reg
> +       .if aesencwide256kl_opd1_type == REG_TYPE_R64
> +       R64_NUM aesencwide256kl_opd1 \reg
> +       .elseif aesencwide256kl_opd1_type == REG_TYPE_R32
> +       R32_NUM aesencwide256kl_opd1 \reg
> +       .else
> +       aesencwide256kl_opd1 = REG_NUM_INVALID
> +       .endif
> +       PFX_RPT
> +       .byte 0x0f, 0x38, 0xd8
> +       MODRM 0x0 aesencwide256kl_opd1 0x2
> +       .endm
> +
> +       .macro AESDECWIDE256KL reg
> +       REG_TYPE aesdecwide256kl_opd1_type \reg
> +       .if aesdecwide256kl_opd1_type == REG_TYPE_R64
> +       R64_NUM aesdecwide256kl_opd1 \reg
> +       .elseif aesdecwide256kl_opd1_type == REG_TYPE_R32
> +       R32_NUM aesdecwide256kl_opd1 \reg
> +       .else
> +       aesdecwide256kl_opd1 = REG_NUM_INVALID
> +       .endif
> +       PFX_RPT
> +       .byte 0x0f, 0x38, 0xd8
> +       MODRM 0x0 aesdecwide256kl_opd1 0x3
> +       .endm
> +
> +       .macro LOADIWKEY xmm1, xmm2
> +       XMM_NUM loadiwkey_opd1 \xmm1
> +       XMM_NUM loadiwkey_opd2 \xmm2
> +       PFX_RPT
> +       .byte 0x0f, 0x38, 0xdc
> +       MODRM 0xc0 loadiwkey_opd1 loadiwkey_opd2
> +       .endm
>  #endif
>
>  #endif
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 094ef56ab7b4..75a184179c72 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1159,6 +1159,34 @@ config CRYPTO_AES_NI_INTEL
>           ECB, CBC, LRW, XTS. The 64 bit version has additional
>           acceleration for CTR.
>
> +config CRYPTO_AES_KL
> +       tristate "AES cipher algorithms (AES-KL)"
> +       depends on X86_KEYLOCKER
> +       select CRYPTO_AES_NI_INTEL
> +       help
> +         Use AES Key Locker instructions for AES algorithm.
> +
> +         AES cipher algorithms (FIPS-197). AES uses the Rijndael
> +         algorithm.
> +
> +         Rijndael appears to be consistently a very good performer in both
> +         hardware and software across a wide range of computing
> +         environments regardless of its use in feedback or non-feedback
> +         modes. Its key setup time is excellent, and its key agility is
> +         good. Rijndael's very low memory requirements make it very well
> +         suited for restricted-space environments, in which it also
> +         demonstrates excellent performance. Rijndael's operations are
> +         among the easiest to defend against power and timing attacks.
> +
> +         The AES specifies three key sizes: 128, 192 and 256 bits
> +
> +         See <http://csrc.nist.gov/encryption/aes/> for more information.
> +
> +         For 128- and 256-bit keys, the AES cipher algorithm is
> +         implemented by AES Key Locker instructions. This implementation
> +         does not need an AES key once wrapped to an encoded form. For AES
> +         compliance, 192-bit is processed by AES-NI instructions.
> +
>  config CRYPTO_AES_SPARC64
>         tristate "AES cipher algorithms (SPARC64)"
>         depends on SPARC64
> --
> 2.17.1
>
