Return-Path: <SRS0=f6g1=RQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 751B8C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39551214AE
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Mar 2019 10:33:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TT0GFMQC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfCMKdW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Mar 2019 06:33:22 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37859 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMKdW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Mar 2019 06:33:22 -0400
Received: by mail-io1-f65.google.com with SMTP id x7so1196734ioh.4
        for <linux-crypto@vger.kernel.org>; Wed, 13 Mar 2019 03:33:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dc0IG5H+DakIQFgVEIsEOyqBhKRLJWrwMh83ZWudukw=;
        b=TT0GFMQCPQRLk8lUUszU7NRnTUqRweS/3rfJIZaug9udtH8WiV2ByjFjj+kX/axDZS
         D5MosJ1+Y9Iv8rtG4jliL3K7qo541SEXKEGV4LTeciztihfqhmj8BHXVGlcLzMIMZrx4
         HI2y1QNi7B+LsOXYsCLcTfzzXzgS/KUnfP/iq7EtkWDOX4n13WF0HaAJ1BdDcJs1cCHX
         JkIZWDB81wwS7mkgcETajj03ez1vdCrar1UaGxFpwm1H2umcoEcELeq3tmEFpAitnn5q
         KgJpi/K0TOX0zI+fVbQPpyvxlhkQtJoNwk8h33MdERXFexcyLZHbIA0CJEwGq/i3bpjO
         C9Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dc0IG5H+DakIQFgVEIsEOyqBhKRLJWrwMh83ZWudukw=;
        b=WEj12aa92vgCrvxhXmpD2EaTod+PnmCGtZLZYg810UKx5/WPKwJhdVQPsMSW3hxgPw
         Gx6hUIlTG2rzFdoiqa0ChcW+azhIfapbhnLRGHOgbSutnspYKUSFHuopJtIP74t8JuXX
         8b3wEx8pZiCTh/qbc2XMvfSUGyZTOgcLZS4O6KIzwtMdusMOUaRIYI/tm3uSfpM/K3ws
         //qNAmBfG9xiCRUzKh5Aqu97ZJq7c9fpcNUWpyj23GubMBlzP3dHpE3gPSQdIBHXBElQ
         XeECEqbjNinjstM/quhEAPVbWPLPfzRJXGwDS8QReNwcOhCaPZdnrZTXUUJ2yWLx8Xbu
         JObg==
X-Gm-Message-State: APjAAAXNEw8oOviTod6+Itat/bQhWy84ja/ai0/Lqqu0KyDdLAJofnk9
        azXGESD3cB9Rbxzkuxsrz/0yEpsXvG+Fi2Ex/zjtRg==
X-Google-Smtp-Source: APXvYqyZW0oowkXhrb9N+N+gtmWSDCQD0xbTu7tvkzCzWtyk8XZAmnM1dX/bpLZqFITV2cd2AI+W1CFt/aqFSL1iKmo=
X-Received: by 2002:a6b:6511:: with SMTP id z17mr22996496iob.173.1552473199674;
 Wed, 13 Mar 2019 03:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190313051252.2917-1-ebiggers@kernel.org> <20190313051252.2917-6-ebiggers@kernel.org>
In-Reply-To: <20190313051252.2917-6-ebiggers@kernel.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 13 Mar 2019 11:33:08 +0100
Message-ID: <CAKv+Gu9JEm2HFPb_pQT_H8iCRbBz9WCNitaL1sU3udSMsEevJw@mail.gmail.com>
Subject: Re: [PATCH 5/8] crypto: arm - convert to use crypto_simd_usable()
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
> Replace all calls to may_use_simd() in the arm crypto code with
> crypto_simd_usable(), in order to allow testing the no-SIMD code paths.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm/crypto/chacha-neon-glue.c     | 5 +++--
>  arch/arm/crypto/crc32-ce-glue.c        | 5 +++--
>  arch/arm/crypto/crct10dif-ce-glue.c    | 3 ++-
>  arch/arm/crypto/ghash-ce-glue.c        | 7 ++++---
>  arch/arm/crypto/nhpoly1305-neon-glue.c | 3 ++-
>  arch/arm/crypto/sha1-ce-glue.c         | 5 +++--
>  arch/arm/crypto/sha1_neon_glue.c       | 5 +++--
>  arch/arm/crypto/sha2-ce-glue.c         | 5 +++--
>  arch/arm/crypto/sha256_neon_glue.c     | 5 +++--
>  arch/arm/crypto/sha512-neon-glue.c     | 5 +++--
>  10 files changed, 29 insertions(+), 19 deletions(-)
>
> diff --git a/arch/arm/crypto/chacha-neon-glue.c b/arch/arm/crypto/chacha-neon-glue.c
> index 9d6fda81986d..48a89537b828 100644
> --- a/arch/arm/crypto/chacha-neon-glue.c
> +++ b/arch/arm/crypto/chacha-neon-glue.c
> @@ -21,6 +21,7 @@
>
>  #include <crypto/algapi.h>
>  #include <crypto/chacha.h>
> +#include <crypto/internal/simd.h>
>  #include <crypto/internal/skcipher.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> @@ -93,7 +94,7 @@ static int chacha_neon(struct skcipher_request *req)
>         struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>         struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
>
> -       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
> +       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
>                 return crypto_chacha_crypt(req);
>
>         return chacha_neon_stream_xor(req, ctx, req->iv);
> @@ -107,7 +108,7 @@ static int xchacha_neon(struct skcipher_request *req)
>         u32 state[16];
>         u8 real_iv[16];
>
> -       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !may_use_simd())
> +       if (req->cryptlen <= CHACHA_BLOCK_SIZE || !crypto_simd_usable())
>                 return crypto_xchacha_crypt(req);
>
>         crypto_chacha_init(state, ctx, req->iv);
> diff --git a/arch/arm/crypto/crc32-ce-glue.c b/arch/arm/crypto/crc32-ce-glue.c
> index cd9e93b46c2d..e712c2a7d387 100644
> --- a/arch/arm/crypto/crc32-ce-glue.c
> +++ b/arch/arm/crypto/crc32-ce-glue.c
> @@ -16,6 +16,7 @@
>  #include <linux/string.h>
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>
>  #include <asm/hwcap.h>
>  #include <asm/neon.h>
> @@ -113,7 +114,7 @@ static int crc32_pmull_update(struct shash_desc *desc, const u8 *data,
>         u32 *crc = shash_desc_ctx(desc);
>         unsigned int l;
>
> -       if (may_use_simd()) {
> +       if (crypto_simd_usable()) {
>                 if ((u32)data % SCALE_F) {
>                         l = min_t(u32, length, SCALE_F - ((u32)data % SCALE_F));
>
> @@ -147,7 +148,7 @@ static int crc32c_pmull_update(struct shash_desc *desc, const u8 *data,
>         u32 *crc = shash_desc_ctx(desc);
>         unsigned int l;
>
> -       if (may_use_simd()) {
> +       if (crypto_simd_usable()) {
>                 if ((u32)data % SCALE_F) {
>                         l = min_t(u32, length, SCALE_F - ((u32)data % SCALE_F));
>
> diff --git a/arch/arm/crypto/crct10dif-ce-glue.c b/arch/arm/crypto/crct10dif-ce-glue.c
> index 3d6b800b8396..3b24f2872592 100644
> --- a/arch/arm/crypto/crct10dif-ce-glue.c
> +++ b/arch/arm/crypto/crct10dif-ce-glue.c
> @@ -15,6 +15,7 @@
>  #include <linux/string.h>
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>
>  #include <asm/neon.h>
>  #include <asm/simd.h>
> @@ -36,7 +37,7 @@ static int crct10dif_update(struct shash_desc *desc, const u8 *data,
>  {
>         u16 *crc = shash_desc_ctx(desc);
>
> -       if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && may_use_simd()) {
> +       if (length >= CRC_T10DIF_PMULL_CHUNK_SIZE && crypto_simd_usable()) {
>                 kernel_neon_begin();
>                 *crc = crc_t10dif_pmull(*crc, data, length);
>                 kernel_neon_end();
> diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
> index b7d30b6cf49c..60123e9ea9d8 100644
> --- a/arch/arm/crypto/ghash-ce-glue.c
> +++ b/arch/arm/crypto/ghash-ce-glue.c
> @@ -14,6 +14,7 @@
>  #include <asm/unaligned.h>
>  #include <crypto/cryptd.h>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <crypto/gf128mul.h>
>  #include <linux/cpufeature.h>
>  #include <linux/crypto.h>
> @@ -196,7 +197,7 @@ static int ghash_async_update(struct ahash_request *req)
>         struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
>         struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
>                 memcpy(cryptd_req, req, sizeof(*req));
>                 ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
> @@ -214,7 +215,7 @@ static int ghash_async_final(struct ahash_request *req)
>         struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
>         struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
>                 memcpy(cryptd_req, req, sizeof(*req));
>                 ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
> @@ -232,7 +233,7 @@ static int ghash_async_digest(struct ahash_request *req)
>         struct ahash_request *cryptd_req = ahash_request_ctx(req);
>         struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
>                 memcpy(cryptd_req, req, sizeof(*req));
>                 ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
> diff --git a/arch/arm/crypto/nhpoly1305-neon-glue.c b/arch/arm/crypto/nhpoly1305-neon-glue.c
> index 49aae87cb2bc..ae5aefc44a4d 100644
> --- a/arch/arm/crypto/nhpoly1305-neon-glue.c
> +++ b/arch/arm/crypto/nhpoly1305-neon-glue.c
> @@ -9,6 +9,7 @@
>  #include <asm/neon.h>
>  #include <asm/simd.h>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <crypto/nhpoly1305.h>
>  #include <linux/module.h>
>
> @@ -25,7 +26,7 @@ static void _nh_neon(const u32 *key, const u8 *message, size_t message_len,
>  static int nhpoly1305_neon_update(struct shash_desc *desc,
>                                   const u8 *src, unsigned int srclen)
>  {
> -       if (srclen < 64 || !may_use_simd())
> +       if (srclen < 64 || !crypto_simd_usable())
>                 return crypto_nhpoly1305_update(desc, src, srclen);
>
>         do {
> diff --git a/arch/arm/crypto/sha1-ce-glue.c b/arch/arm/crypto/sha1-ce-glue.c
> index b732522e20f8..4c6c6900853c 100644
> --- a/arch/arm/crypto/sha1-ce-glue.c
> +++ b/arch/arm/crypto/sha1-ce-glue.c
> @@ -9,6 +9,7 @@
>   */
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <crypto/sha.h>
>  #include <crypto/sha1_base.h>
>  #include <linux/cpufeature.h>
> @@ -33,7 +34,7 @@ static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
>  {
>         struct sha1_state *sctx = shash_desc_ctx(desc);
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
>                 return sha1_update_arm(desc, data, len);
>
> @@ -47,7 +48,7 @@ static int sha1_ce_update(struct shash_desc *desc, const u8 *data,
>  static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
>                          unsigned int len, u8 *out)
>  {
> -       if (!may_use_simd())
> +       if (!crypto_simd_usable())
>                 return sha1_finup_arm(desc, data, len, out);
>
>         kernel_neon_begin();
> diff --git a/arch/arm/crypto/sha1_neon_glue.c b/arch/arm/crypto/sha1_neon_glue.c
> index d15e0ea2c95e..d6c95c213d42 100644
> --- a/arch/arm/crypto/sha1_neon_glue.c
> +++ b/arch/arm/crypto/sha1_neon_glue.c
> @@ -19,6 +19,7 @@
>   */
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/mm.h>
> @@ -39,7 +40,7 @@ static int sha1_neon_update(struct shash_desc *desc, const u8 *data,
>  {
>         struct sha1_state *sctx = shash_desc_ctx(desc);
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (sctx->count % SHA1_BLOCK_SIZE) + len < SHA1_BLOCK_SIZE)
>                 return sha1_update_arm(desc, data, len);
>
> @@ -54,7 +55,7 @@ static int sha1_neon_update(struct shash_desc *desc, const u8 *data,
>  static int sha1_neon_finup(struct shash_desc *desc, const u8 *data,
>                            unsigned int len, u8 *out)
>  {
> -       if (!may_use_simd())
> +       if (!crypto_simd_usable())
>                 return sha1_finup_arm(desc, data, len, out);
>
>         kernel_neon_begin();
> diff --git a/arch/arm/crypto/sha2-ce-glue.c b/arch/arm/crypto/sha2-ce-glue.c
> index 1211a5c129fc..a47a9d4b663e 100644
> --- a/arch/arm/crypto/sha2-ce-glue.c
> +++ b/arch/arm/crypto/sha2-ce-glue.c
> @@ -9,6 +9,7 @@
>   */
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <crypto/sha.h>
>  #include <crypto/sha256_base.h>
>  #include <linux/cpufeature.h>
> @@ -34,7 +35,7 @@ static int sha2_ce_update(struct shash_desc *desc, const u8 *data,
>  {
>         struct sha256_state *sctx = shash_desc_ctx(desc);
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
>                 return crypto_sha256_arm_update(desc, data, len);
>
> @@ -49,7 +50,7 @@ static int sha2_ce_update(struct shash_desc *desc, const u8 *data,
>  static int sha2_ce_finup(struct shash_desc *desc, const u8 *data,
>                          unsigned int len, u8 *out)
>  {
> -       if (!may_use_simd())
> +       if (!crypto_simd_usable())
>                 return crypto_sha256_arm_finup(desc, data, len, out);
>
>         kernel_neon_begin();
> diff --git a/arch/arm/crypto/sha256_neon_glue.c b/arch/arm/crypto/sha256_neon_glue.c
> index 1d82c6cd31a4..f3f6b1624fc3 100644
> --- a/arch/arm/crypto/sha256_neon_glue.c
> +++ b/arch/arm/crypto/sha256_neon_glue.c
> @@ -15,6 +15,7 @@
>   */
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <linux/cryptohash.h>
>  #include <linux/types.h>
>  #include <linux/string.h>
> @@ -34,7 +35,7 @@ static int sha256_update(struct shash_desc *desc, const u8 *data,
>  {
>         struct sha256_state *sctx = shash_desc_ctx(desc);
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (sctx->count % SHA256_BLOCK_SIZE) + len < SHA256_BLOCK_SIZE)
>                 return crypto_sha256_arm_update(desc, data, len);
>
> @@ -49,7 +50,7 @@ static int sha256_update(struct shash_desc *desc, const u8 *data,
>  static int sha256_finup(struct shash_desc *desc, const u8 *data,
>                         unsigned int len, u8 *out)
>  {
> -       if (!may_use_simd())
> +       if (!crypto_simd_usable())
>                 return crypto_sha256_arm_finup(desc, data, len, out);
>
>         kernel_neon_begin();
> diff --git a/arch/arm/crypto/sha512-neon-glue.c b/arch/arm/crypto/sha512-neon-glue.c
> index 8a5642b41fd6..d33ab59c26c0 100644
> --- a/arch/arm/crypto/sha512-neon-glue.c
> +++ b/arch/arm/crypto/sha512-neon-glue.c
> @@ -9,6 +9,7 @@
>   */
>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/simd.h>
>  #include <crypto/sha.h>
>  #include <crypto/sha512_base.h>
>  #include <linux/crypto.h>
> @@ -30,7 +31,7 @@ static int sha512_neon_update(struct shash_desc *desc, const u8 *data,
>  {
>         struct sha512_state *sctx = shash_desc_ctx(desc);
>
> -       if (!may_use_simd() ||
> +       if (!crypto_simd_usable() ||
>             (sctx->count[0] % SHA512_BLOCK_SIZE) + len < SHA512_BLOCK_SIZE)
>                 return sha512_arm_update(desc, data, len);
>
> @@ -45,7 +46,7 @@ static int sha512_neon_update(struct shash_desc *desc, const u8 *data,
>  static int sha512_neon_finup(struct shash_desc *desc, const u8 *data,
>                              unsigned int len, u8 *out)
>  {
> -       if (!may_use_simd())
> +       if (!crypto_simd_usable())
>                 return sha512_arm_finup(desc, data, len, out);
>
>         kernel_neon_begin();
> --
> 2.21.0
>
