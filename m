Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B02F7C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CF502184C
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:32:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TyuxnYew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfCMKcs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:32:48 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:35721 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfCMKcr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 06:32:47 -0400
Received: by mail-it1-f194.google.com with SMTP id 188so2039448itb.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2019 03:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hGl/+SCklJEv2WgjY1GFKVGeL52BkUbmmU7wBzR7cWc=;
        b=TyuxnYew4rIEgHifTW4W1Ye4ZwyKw74Rp05NiAx1ZvOpJYhYQJiQ2Dy2WjYGXf4uTR
         8tACZU/4TRoSZAY6w/IFnLVlo8uZON8H9Cjdp8CjcHkinZrwl1ONPjJ/36ctEno6oFZQ
         ele2mLP2ARzFCnxzdHAEjM+kTwz2PruSgJEdlJ9TUFZyzEbo7+XaK8wtgcRk1VKCz9SP
         uiMgQYSoCOA/H00m0MsGqtWfbo+2iFBMULrzopqCej7FH27QG3+qS+naa02Goa+XgWB7
         /IeQJ7zUyBCbLJemrHnglBlINF3o2lOCRTYiOWGgRa0plVhZKsNx4LUqByQIwv+fpclh
         9lMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hGl/+SCklJEv2WgjY1GFKVGeL52BkUbmmU7wBzR7cWc=;
        b=J33tqCVJJozwyHFDVD5X7Oe8K0kCjJ4WRU7E2UVtVqb6O5cjLPGQrOyaBD1XwJP3rO
         Jvlyg/+lef6TSWCOT0b7lai+4CRKfC1nEDb7ptIRYR5b2ZD575FC2+ZckmvFE9GDmqPU
         4GqNdfFqkJFhcUqDn74bWy8vEZow4FtlftjwSELBWccrumiDwkeCk+xodBZD9+0VdrnB
         0CsGrec6qo7m9K1spe2NI6v5iAQU3vXEoobF/ycx2aY6412BPO0R5IWExnEWbv9Etidh
         Eds2RCdreLX0sSe2ACI1Mq5troqjgKJPfGvIURHEQ1VLWcMrbvZvJDreaAxJ+675k0JU
         lqyQ==
X-Gm-Message-State: APjAAAV1cgWrZa/xIoGdVMmfP1Quq0zEteKrHWrbXCSmd/gMqVXMGQ3D
        bZhZpikbIt4Hj+xDkUlkFJjcydLXBfCvl4AoLn1dvQ==
X-Google-Smtp-Source: APXvYqyYe/jq3DsSQmGn4IGtfKmQmvv3bH1nHiWxyVuqf3DzlxMXXmVtX42G39yLt1Enzxycb9hYOzodWzAVFuBIfZg=
X-Received: by 2002:a05:6638:2a1:: with SMTP id d1mr23306057jaq.2.1552473165690;
 Wed, 13 Mar 2019 03:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190313051252.2917-1-ebiggers@kernel.org> <20190313051252.2917-5-ebiggers@kernel.org>
In-Reply-To: <20190313051252.2917-5-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 13 Mar 2019 11:32:34 +0100
Message-ID: <CAKv+Gu-quNQgB2-A-hQe5VAxUejkjjm85DmTFWB30bSkxUOwDw@mail.gmail.com>
Subject: Re: [PATCH 4/8] crypto: x86 - convert to use crypto_simd_usable()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 13 Mar 2019 at 06:15, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Replace all calls to irq_fpu_usable() in the x86 crypto code with
> crypto_simd_usable(), in order to allow testing the no-SIMD code paths.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/x86/crypto/aesni-intel_glue.c         |  8 ++++----
>  arch/x86/crypto/chacha_glue.c              |  6 +++---
>  arch/x86/crypto/crc32-pclmul_glue.c        |  5 +++--
>  arch/x86/crypto/crc32c-intel_glue.c        |  7 ++++---
>  arch/x86/crypto/crct10dif-pclmul_glue.c    |  7 ++++---
>  arch/x86/crypto/ghash-clmulni-intel_glue.c |  9 +++++----
>  arch/x86/crypto/nhpoly1305-avx2-glue.c     |  5 +++--
>  arch/x86/crypto/nhpoly1305-sse2-glue.c     |  5 +++--
>  arch/x86/crypto/poly1305_glue.c            |  4 ++--
>  arch/x86/crypto/sha1_ssse3_glue.c          |  7 ++++---
>  arch/x86/crypto/sha256_ssse3_glue.c        |  7 ++++---
>  arch/x86/crypto/sha512_ssse3_glue.c        | 10 +++++-----
>  12 files changed, 44 insertions(+), 36 deletions(-)
>
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index 1466d59384ac..21c246799aa5 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -30,8 +30,8 @@
>  #include <crypto/gcm.h>
>  #include <crypto/xts.h>
>  #include <asm/cpu_device_id.h>
> -#include <asm/fpu/api.h>
>  #include <asm/crypto/aes.h>
> +#include <asm/simd.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/internal/aead.h>
>  #include <crypto/internal/simd.h>
> @@ -332,7 +332,7 @@ static int aes_set_key_common(struct crypto_tfm *tfm, void *raw_ctx,
>                 return -EINVAL;
>         }
>
> -       if (!irq_fpu_usable())
> +       if (!crypto_simd_usable())
>                 err = crypto_aes_expand_key(ctx, in_key, key_len);
>         else {
>                 kernel_fpu_begin();
> @@ -353,7 +353,7 @@ static void aes_encrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
>  {
>         struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
>
> -       if (!irq_fpu_usable())
> +       if (!crypto_simd_usable())
>                 crypto_aes_encrypt_x86(ctx, dst, src);
>         else {
>                 kernel_fpu_begin();
> @@ -366,7 +366,7 @@ static void aes_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
>  {
>         struct crypto_aes_ctx *ctx = aes_ctx(crypto_tfm_ctx(tfm));
>
> -       if (!irq_fpu_usable())
> +       if (!crypto_simd_usable())
>                 crypto_aes_decrypt_x86(ctx, dst, src);
>         else {
>                 kernel_fpu_begin();
> diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
> index 45c1c4143176..4967ad620775 100644
> --- a/arch/x86/crypto/chacha_glue.c
> +++ b/arch/x86/crypto/chacha_glue.c
> @@ -12,10 +12,10 @@
>
>  #include <crypto/algapi.h>
>  #include <crypto/chacha.h>
> +#include <crypto/internal/simd.h>
>  #include <crypto/internal/skcipher.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <asm/fpu/api.h>
>  #include <asm/simd.h>
>
>  #define CHACHA_STATE_ALIGN 16
> @@ -170,7 +170,7 @@ static int chacha_simd(struct skcipher_request *req)
>         struct skcipher_walk walk;
>         int err;
>
> -       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !irq_fpu_usable())
> +       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
>                 return crypto_chacha_crypt(req);
>
>         err = skcipher_walk_virt(&walk, req, true);
> @@ -193,7 +193,7 @@ static int xchacha_simd(struct skcipher_request *req)
>         u8 real_iv[16];
>         int err;
>
> -       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !irq_fpu_usable())
> +       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
>                 return crypto_xchacha_crypt(req);
>
>         err = skcipher_walk_virt(&walk, req, true);
> diff --git a/arch/x86/crypto/crc32-pclmul_glue.c b/arch/x86/crypto/crc32-pclmul_glue.c
> index c8d9cdacbf10..cb4ab6645106 100644
> --- a/arch/x86/crypto/crc32-pclmul_glue.c
> +++ b/arch/x86/crypto/crc32-pclmul_glue.c
> @@ -32,10 +32,11 @@
>  #include <linux/kernel.h>
>  #include <linux/crc32.h>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>
>  #include <asm/cpufeatures.h>
>  #include <asm/cpu_device_id.h>
> -#include <asm/fpu/api.h>
> +#include <asm/simd.h>
>
>  #define CHKSUM_BLOCK_SIZE      1
>  #define CHKSUM_DIGEST_SIZE     4
> @@ -54,7 +55,7 @@ static u32 __attribute__((pure))
>         unsigned int iremainder;
>         unsigned int prealign;
>
> -       if (len < PCLMUL_MIN_LEN + SCALE_F_MASK || !irq_fpu_usable())
> +       if (len < PCLMUL_MIN_LEN + SCALE_F_MASK || !crypto_simd_usable())
>                 return crc32_le(crc, p, len);
>
>         if ((long)p & SCALE_F_MASK) {
> diff --git a/arch/x86/crypto/crc32c-intel_glue.c b/arch/x86/crypto/crc32c-intel_glue.c
> index 5773e1161072..a58fe217c856 100644
> --- a/arch/x86/crypto/crc32c-intel_glue.c
> +++ b/arch/x86/crypto/crc32c-intel_glue.c
> @@ -29,10 +29,11 @@
>  #include <linux/string.h>
>  #include <linux/kernel.h>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>
>  #include <asm/cpufeatures.h>
>  #include <asm/cpu_device_id.h>
> -#include <asm/fpu/internal.h>
> +#include <asm/simd.h>
>
>  #define CHKSUM_BLOCK_SIZE      1
>  #define CHKSUM_DIGEST_SIZE     4
> @@ -177,7 +178,7 @@ static int crc32c_pcl_intel_update(struct shash_desc *desc, const u8 *data,
>          * use faster PCL version if datasize is large enough to
>          * overcome kernel fpu state save/restore overhead
>          */
> -       if (len >= CRC32C_PCL_BREAKEVEN && irq_fpu_usable()) {
> +       if (len >= CRC32C_PCL_BREAKEVEN && crypto_simd_usable()) {
>                 kernel_fpu_begin();
>                 *crcp = crc_pcl(data, len, *crcp);
>                 kernel_fpu_end();
> @@ -189,7 +190,7 @@ static int crc32c_pcl_intel_update(struct shash_desc *desc, const u8 *data,
>  static int __crc32c_pcl_intel_finup(u32 *crcp, const u8 *data, unsigned int len,
>                                 u8 *out)
>  {
> -       if (len >= CRC32C_PCL_BREAKEVEN && irq_fpu_usable()) {
> +       if (len >= CRC32C_PCL_BREAKEVEN && crypto_simd_usable()) {
>                 kernel_fpu_begin();
>                 *(__le32 *)out = ~cpu_to_le32(crc_pcl(data, len, *crcp));
>                 kernel_fpu_end();
> diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
> index 0e785c0b2354..64f17d2d8b67 100644
> --- a/arch/x86/crypto/crct10dif-pclmul_glue.c
> +++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
> @@ -26,12 +26,13 @@
>  #include <linux/module.h>
>  #include <linux/crc-t10dif.h>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <linux/init.h>
>  #include <linux/string.h>
>  #include <linux/kernel.h>
> -#include <asm/fpu/api.h>
>  #include <asm/cpufeatures.h>
>  #include <asm/cpu_device_id.h>
> +#include <asm/simd.h>
>
>  asmlinkage u16 crc_t10dif_pcl(u16 init_crc, const u8 *buf, size_t len);
>
> @@ -53,7 +54,7 @@ static int chksum_update(struct shash_desc *desc, const u8 *data,
>  {
>         struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
>
> -       if (length >= 16 && irq_fpu_usable()) {
> +       if (length >= 16 && crypto_simd_usable()) {
>                 kernel_fpu_begin();
>                 ctx->crc = crc_t10dif_pcl(ctx->crc, data, length);
>                 kernel_fpu_end();
> @@ -73,7 +74,7 @@ static int chksum_final(struct shash_desc *desc, u8 *out)
>  static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
>                         u8 *out)
>  {
> -       if (len >= 16 && irq_fpu_usable()) {
> +       if (len >= 16 && crypto_simd_usable()) {
>                 kernel_fpu_begin();
>                 *(__u16 *)out = crc_t10dif_pcl(*crcp, data, len);
>                 kernel_fpu_end();
> diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
> index 3582ae885ee1..4099a0ae17dd 100644
> --- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
> +++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
> @@ -19,8 +19,9 @@
>  #include <crypto/cryptd.h>
>  #include <crypto/gf128mul.h>
>  #include <crypto/internal/hash.h>
> -#include <asm/fpu/api.h>
> +#include <crypto/internal/simd.h>
>  #include <asm/cpu_device_id.h>
> +#include <asm/simd.h>
>
>  #define GHASH_BLOCK_SIZE       16
>  #define GHASH_DIGEST_SIZE      16
> @@ -182,7 +183,7 @@ static int ghash_async_update(struct ahash_request *req)
>         struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
>         struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
>
> -       if (!irq_fpu_usable() ||
> +       if (!crypto_simd_usable() ||
>             (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
>                 memcpy(cryptd_req, req, sizeof(*req));
>                 ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
> @@ -200,7 +201,7 @@ static int ghash_async_final(struct ahash_request *req)
>         struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
>         struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
>
> -       if (!irq_fpu_usable() ||
> +       if (!crypto_simd_usable() ||
>             (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
>                 memcpy(cryptd_req, req, sizeof(*req));
>                 ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
> @@ -241,7 +242,7 @@ static int ghash_async_digest(struct ahash_request *req)
>         struct ahash_request *cryptd_req = ahash_request_ctx(req);
>         struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
>
> -       if (!irq_fpu_usable() ||
> +       if (!crypto_simd_usable() ||
>             (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
>                 memcpy(cryptd_req, req, sizeof(*req));
>                 ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
> diff --git a/arch/x86/crypto/nhpoly1305-avx2-glue.c b/arch/x86/crypto/nhpoly1305-avx2-glue.c
> index 20d815ea4b6a..f7567cbd35b6 100644
> --- a/arch/x86/crypto/nhpoly1305-avx2-glue.c
> +++ b/arch/x86/crypto/nhpoly1305-avx2-glue.c
> @@ -7,9 +7,10 @@
>   */
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <crypto/nhpoly1305.h>
>  #include <linux/module.h>
> -#include <asm/fpu/api.h>
> +#include <asm/simd.h>
>
>  asmlinkage void nh_avx2(const u32 *key, const u8 *message, size_t message_len,
>                         u8 hash[NH_HASH_BYTES]);
> @@ -24,7 +25,7 @@ static void _nh_avx2(const u32 *key, const u8 *message, size_t message_len,
>  static int nhpoly1305_avx2_update(struct shash_desc *desc,
>                                   const u8 *src, unsigned int srclen)
>  {
> -       if (srclen < 64 || !irq_fpu_usable())
> +       if (srclen < 64 || !crypto_simd_usable())
>                 return crypto_nhpoly1305_update(desc, src, srclen);
>
>         do {
> diff --git a/arch/x86/crypto/nhpoly1305-sse2-glue.c b/arch/x86/crypto/nhpoly1305-sse2-glue.c
> index ed68d164ce14..a661ede3b5cf 100644
> --- a/arch/x86/crypto/nhpoly1305-sse2-glue.c
> +++ b/arch/x86/crypto/nhpoly1305-sse2-glue.c
> @@ -7,9 +7,10 @@
>   */
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <crypto/nhpoly1305.h>
>  #include <linux/module.h>
> -#include <asm/fpu/api.h>
> +#include <asm/simd.h>
>
>  asmlinkage void nh_sse2(const u32 *key, const u8 *message, size_t message_len,
>                         u8 hash[NH_HASH_BYTES]);
> @@ -24,7 +25,7 @@ static void _nh_sse2(const u32 *key, const u8 *message, size_t message_len,
>  static int nhpoly1305_sse2_update(struct shash_desc *desc,
>                                   const u8 *src, unsigned int srclen)
>  {
> -       if (srclen < 64 || !irq_fpu_usable())
> +       if (srclen < 64 || !crypto_simd_usable())
>                 return crypto_nhpoly1305_update(desc, src, srclen);
>
>         do {
> diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
> index 88cc01506c84..6eb65b237b3c 100644
> --- a/arch/x86/crypto/poly1305_glue.c
> +++ b/arch/x86/crypto/poly1305_glue.c
> @@ -11,11 +11,11 @@
>
>  #include <crypto/algapi.h>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <crypto/poly1305.h>
>  #include <linux/crypto.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <asm/fpu/api.h>
>  #include <asm/simd.h>
>
>  struct poly1305_simd_desc_ctx {
> @@ -126,7 +126,7 @@ static int poly1305_simd_update(struct shash_desc *desc,
>         unsigned int bytes;
>
>         /* kernel_fpu_begin/end is costly, use fallback for small updates */
> -       if (srclen <= 288 || !may_use_simd())
> +       if (srclen <= 288 || !crypto_simd_usable())
>                 return crypto_poly1305_update(desc, src, srclen);
>
>         kernel_fpu_begin();
> diff --git a/arch/x86/crypto/sha1_ssse3_glue.c b/arch/x86/crypto/sha1_ssse3_glue.c
> index 7391c7de72c7..42f177afc33a 100644
> --- a/arch/x86/crypto/sha1_ssse3_glue.c
> +++ b/arch/x86/crypto/sha1_ssse3_glue.c
> @@ -22,6 +22,7 @@
>  #define pr_fmt(fmt)    KBUILD_MODNAME ": " fmt
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/mm.h>
> @@ -29,7 +30,7 @@
>  #include <linux/types.h>
>  #include <crypto/sha.h>
>  #include <crypto/sha1_base.h>
> -#include <asm/fpu/api.h>
> +#include <asm/simd.h>
>
>  typedef void (sha1_transform_fn)(u32 *digest, const char *data,
>                                 unsigned int rounds);
> @@ -39,7 +40,7 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
>  {
>         struct sha1_state *sctx = shash_desc_ctx(desc);
>
> -       if (!irq_fpu_usable() ||
> +       if (!crypto_simd_usable() ||
>             (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
>                 return crypto_sha1_update(desc, data, len);
>
> @@ -57,7 +58,7 @@ static int sha1_update(struct shash_desc *desc, const u8 *data,
>  static int sha1_finup(struct shash_desc *desc, const u8 *data,
>                       unsigned int len, u8 *out, sha1_transform_fn *sha1_xform)
>  {
> -       if (!irq_fpu_usable())
> +       if (!crypto_simd_usable())
>                 return crypto_sha1_finup(desc, data, len, out);
>
>         kernel_fpu_begin();
> diff --git a/arch/x86/crypto/sha256_ssse3_glue.c b/arch/x86/crypto/sha256_ssse3_glue.c
> index 773a873d2b28..73867da3cbee 100644
> --- a/arch/x86/crypto/sha256_ssse3_glue.c
> +++ b/arch/x86/crypto/sha256_ssse3_glue.c
> @@ -30,6 +30,7 @@
>  #define pr_fmt(fmt)    KBUILD_MODNAME ": " fmt
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/mm.h>
> @@ -37,8 +38,8 @@
>  #include <linux/types.h>
>  #include <crypto/sha.h>
>  #include <crypto/sha256_base.h>
> -#include <asm/fpu/api.h>
>  #include <linux/string.h>
> +#include <asm/simd.h>
>
>  asmlinkage void sha256_transform_ssse3(u32 *digest, const char *data,
>                                        u64 rounds);
> @@ -49,7 +50,7 @@ static int sha256_update(struct shash_desc *desc, const u8 *data,
>  {
>         struct sha256_state *sctx = shash_desc_ctx(desc);
>
> -       if (!irq_fpu_usable() ||
> +       if (!crypto_simd_usable() ||
>             (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
>                 return crypto_sha256_update(desc, data, len);
>
> @@ -67,7 +68,7 @@ static int sha256_update(struct shash_desc *desc, const u8 *data,
>  static int sha256_finup(struct shash_desc *desc, const u8 *data,
>               unsigned int len, u8 *out, sha256_transform_fn *sha256_xform)
>  {
> -       if (!irq_fpu_usable())
> +       if (!crypto_simd_usable())
>                 return crypto_sha256_finup(desc, data, len, out);
>
>         kernel_fpu_begin();
> diff --git a/arch/x86/crypto/sha512_ssse3_glue.c b/arch/x86/crypto/sha512_ssse3_glue.c
> index f1b811b60ba6..458356a3f124 100644
> --- a/arch/x86/crypto/sha512_ssse3_glue.c
> +++ b/arch/x86/crypto/sha512_ssse3_glue.c
> @@ -28,16 +28,16 @@
>  #define pr_fmt(fmt)    KBUILD_MODNAME ": " fmt
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/mm.h>
>  #include <linux/cryptohash.h>
> +#include <linux/string.h>
>  #include <linux/types.h>
>  #include <crypto/sha.h>
>  #include <crypto/sha512_base.h>
> -#include <asm/fpu/api.h>
> -
> -#include <linux/string.h>
> +#include <asm/simd.h>
>
>  asmlinkage void sha512_transform_ssse3(u64 *digest, const char *data,
>                                        u64 rounds);
> @@ -49,7 +49,7 @@ static int sha512_update(struct shash_desc *desc, const u8 *data,
>  {
>         struct sha512_state *sctx = shash_desc_ctx(desc);
>
> -       if (!irq_fpu_usable() ||
> +       if (!crypto_simd_usable() ||
>             (sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
>                 return crypto_sha512_update(desc, data, len);
>
> @@ -67,7 +67,7 @@ static int sha512_update(struct shash_desc *desc, const u8 *data,
>  static int sha512_finup(struct shash_desc *desc, const u8 *data,
>               unsigned int len, u8 *out, sha512_transform_fn *sha512_xform)
>  {
> -       if (!irq_fpu_usable())
> +       if (!crypto_simd_usable())
>                 return crypto_sha512_finup(desc, data, len, out);
>
>         kernel_fpu_begin();
> --
> 2.21.0
>
