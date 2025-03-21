Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44691F1527
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 11:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742557916; cv=none; b=rq2eqWCMQM1XSWDae1xmv9up2iHKaZ6J5sFtnEZtHUhv+rXfxT9FBx2gS4nCtObmQ8MtN+8JIItmwP2Xfd8n4cJS4A46Akfwp+fpfbEvZcDaUWpQZs8EAqQHYsJbeFQWFlnpunCZnj0UBmpx+0DEEYpvblikt1iN4CUGnRGdITQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742557916; c=relaxed/simple;
	bh=4+I1iV8BPTu0zQ7NnPKAjGcyEhEiRIJKZgNzi4yXSOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hedQv2nj9A2K7ldm4GqIK0s6/HDslWivcFyHPxsKuo+inwLwEj10D6R8pAFD6w1Ah3O+F0dCL2mrTBwO2waZWjh4x1q8OJz5b9QQhDYcZCgOGDvNuqpelnfkIffbQjltyGtx6HufcVfB7UTYkp4cA7g8ZKgZOUuBMXvrbaj+ogw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=toYoFgkz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="toYoFgkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE5BC4CEE3
	for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 11:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742557916;
	bh=4+I1iV8BPTu0zQ7NnPKAjGcyEhEiRIJKZgNzi4yXSOY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=toYoFgkzI82ZsYfpvWc0kDN4ZzYigdZgO+bgTpLy/Am9HpiMRxfRNvxNq7s7TWIB7
	 6Hc0lYu0aBOtsWra+uV787YOP7NWJe3op7OCELApeRN/km/lFVFCR8KDq6by12gysW
	 qk/X9/78v0MYTZizmUzH0XVHDqU7gcGwFzfp62X12ksckQsMSuMT8e/txdWN+MVn4c
	 oqTyqf6DDFAbZ5KmOa5gOyUrlGOEqSI77NcdO7eM67aXMj/XyFBwB67XyHGG8s6YxG
	 BlMbZuErvqt9OvDPWplwoAc7HlDtK+Utry7DH4HMDQU2bMsDLQVXL/kyDDkLXz1AvO
	 GQ+3nVxB3zWIg==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-549946c5346so2127809e87.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Mar 2025 04:51:56 -0700 (PDT)
X-Gm-Message-State: AOJu0Ywy5ydm85pxvN4o7hrbP4oxGGZjzNyhW5Ny5K2oAaWwHTr5TmRR
	Lb6/1qiQH1LM5QGntIvWsrrwN7X6cvsylarmazVnOuc51BrnbkTaOm532NZEGY3J8NC8DsA4ezb
	grvZrUwsOLHsDZmVc2D3m8AUQc4s=
X-Google-Smtp-Source: AGHT+IGZwG23LSKDwbFRzIvvEwuUo3B3xL3r/jW2ZAT5lj6gyBDYGG0I8aXmYnv5DcPT3nyswncibmZgIjOy72LGVW8=
X-Received: by 2002:a05:6512:1598:b0:549:5769:6ad8 with SMTP id
 2adb3069b0e04-54ad6470a7dmr1026055e87.4.1742557914374; Fri, 21 Mar 2025
 04:51:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z9zupEU1itUXzaMn@gondor.apana.org.au>
In-Reply-To: <Z9zupEU1itUXzaMn@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 21 Mar 2025 12:51:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGz=nFchp683XqTvKFxLWXebvxMW496awB95L8JUwxytg@mail.gmail.com>
X-Gm-Features: AQ5f1JoN_RaVwSjKibkf-Xacz2l5IrP0lj4Dol6wtlpAlra1w3HLpE-4OV9EqUE
Message-ID: <CAMj1kXGz=nFchp683XqTvKFxLWXebvxMW496awB95L8JUwxytg@mail.gmail.com>
Subject: Re: [PATCH] crypto: arm/ghash-ce - Remove SIMD fallback code path
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 21 Mar 2025 at 05:44, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Remove the obsolete fallback code path for SIMD and remove the
> cryptd-based ghash-ce algorithm.  Rename the shash algorithm to
> ghash-ce.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  arch/arm/crypto/ghash-ce-glue.c | 197 ++------------------------------
>  1 file changed, 8 insertions(+), 189 deletions(-)
>

Are shashes only callable in task or softirq context?

> diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
> index dab66b520b6e..aabfcf522a2c 100644
> --- a/arch/arm/crypto/ghash-ce-glue.c
> +++ b/arch/arm/crypto/ghash-ce-glue.c
> @@ -55,10 +55,6 @@ struct ghash_desc_ctx {
>         u32 count;
>  };
>
> -struct ghash_async_ctx {
> -       struct cryptd_ahash *cryptd_tfm;
> -};
> -
>  asmlinkage void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
>                                        u64 const h[][2], const char *head);
>
> @@ -78,34 +74,12 @@ static int ghash_init(struct shash_desc *desc)
>  static void ghash_do_update(int blocks, u64 dg[], const char *src,
>                             struct ghash_key *key, const char *head)
>  {
> -       if (likely(crypto_simd_usable())) {
> -               kernel_neon_begin();
> -               if (static_branch_likely(&use_p64))
> -                       pmull_ghash_update_p64(blocks, dg, src, key->h, head);
> -               else
> -                       pmull_ghash_update_p8(blocks, dg, src, key->h, head);
> -               kernel_neon_end();
> -       } else {
> -               be128 dst = { cpu_to_be64(dg[1]), cpu_to_be64(dg[0]) };
> -
> -               do {
> -                       const u8 *in = src;
> -
> -                       if (head) {
> -                               in = head;
> -                               blocks++;
> -                               head = NULL;
> -                       } else {
> -                               src += GHASH_BLOCK_SIZE;
> -                       }
> -
> -                       crypto_xor((u8 *)&dst, in, GHASH_BLOCK_SIZE);
> -                       gf128mul_lle(&dst, &key->k);
> -               } while (--blocks);
> -
> -               dg[0] = be64_to_cpu(dst.b);
> -               dg[1] = be64_to_cpu(dst.a);
> -       }
> +       kernel_neon_begin();
> +       if (static_branch_likely(&use_p64))
> +               pmull_ghash_update_p64(blocks, dg, src, key->h, head);
> +       else
> +               pmull_ghash_update_p8(blocks, dg, src, key->h, head);
> +       kernel_neon_end();
>  }
>
>  static int ghash_update(struct shash_desc *desc, const u8 *src,
> @@ -206,162 +180,13 @@ static struct shash_alg ghash_alg = {
>         .descsize               = sizeof(struct ghash_desc_ctx),
>
>         .base.cra_name          = "ghash",
> -       .base.cra_driver_name   = "ghash-ce-sync",
> -       .base.cra_priority      = 300 - 1,
> +       .base.cra_driver_name   = "ghash-ce",
> +       .base.cra_priority      = 300,
>         .base.cra_blocksize     = GHASH_BLOCK_SIZE,
>         .base.cra_ctxsize       = sizeof(struct ghash_key) + sizeof(u64[2]),
>         .base.cra_module        = THIS_MODULE,
>  };
>
> -static int ghash_async_init(struct ahash_request *req)
> -{
> -       struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> -       struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
> -       struct ahash_request *cryptd_req = ahash_request_ctx(req);
> -       struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
> -       struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
> -       struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
> -
> -       desc->tfm = child;
> -       return crypto_shash_init(desc);
> -}
> -
> -static int ghash_async_update(struct ahash_request *req)
> -{
> -       struct ahash_request *cryptd_req = ahash_request_ctx(req);
> -       struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> -       struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
> -       struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
> -
> -       if (!crypto_simd_usable() ||
> -           (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
> -               memcpy(cryptd_req, req, sizeof(*req));
> -               ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
> -               return crypto_ahash_update(cryptd_req);
> -       } else {
> -               struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
> -               return shash_ahash_update(req, desc);
> -       }
> -}
> -
> -static int ghash_async_final(struct ahash_request *req)
> -{
> -       struct ahash_request *cryptd_req = ahash_request_ctx(req);
> -       struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> -       struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
> -       struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
> -
> -       if (!crypto_simd_usable() ||
> -           (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
> -               memcpy(cryptd_req, req, sizeof(*req));
> -               ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
> -               return crypto_ahash_final(cryptd_req);
> -       } else {
> -               struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
> -               return crypto_shash_final(desc, req->result);
> -       }
> -}
> -
> -static int ghash_async_digest(struct ahash_request *req)
> -{
> -       struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> -       struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
> -       struct ahash_request *cryptd_req = ahash_request_ctx(req);
> -       struct cryptd_ahash *cryptd_tfm = ctx->cryptd_tfm;
> -
> -       if (!crypto_simd_usable() ||
> -           (in_atomic() && cryptd_ahash_queued(cryptd_tfm))) {
> -               memcpy(cryptd_req, req, sizeof(*req));
> -               ahash_request_set_tfm(cryptd_req, &cryptd_tfm->base);
> -               return crypto_ahash_digest(cryptd_req);
> -       } else {
> -               struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
> -               struct crypto_shash *child = cryptd_ahash_child(cryptd_tfm);
> -
> -               desc->tfm = child;
> -               return shash_ahash_digest(req, desc);
> -       }
> -}
> -
> -static int ghash_async_import(struct ahash_request *req, const void *in)
> -{
> -       struct ahash_request *cryptd_req = ahash_request_ctx(req);
> -       struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> -       struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
> -       struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
> -
> -       desc->tfm = cryptd_ahash_child(ctx->cryptd_tfm);
> -
> -       return crypto_shash_import(desc, in);
> -}
> -
> -static int ghash_async_export(struct ahash_request *req, void *out)
> -{
> -       struct ahash_request *cryptd_req = ahash_request_ctx(req);
> -       struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
> -
> -       return crypto_shash_export(desc, out);
> -}
> -
> -static int ghash_async_setkey(struct crypto_ahash *tfm, const u8 *key,
> -                             unsigned int keylen)
> -{
> -       struct ghash_async_ctx *ctx = crypto_ahash_ctx(tfm);
> -       struct crypto_ahash *child = &ctx->cryptd_tfm->base;
> -
> -       crypto_ahash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
> -       crypto_ahash_set_flags(child, crypto_ahash_get_flags(tfm)
> -                              & CRYPTO_TFM_REQ_MASK);
> -       return crypto_ahash_setkey(child, key, keylen);
> -}
> -
> -static int ghash_async_init_tfm(struct crypto_tfm *tfm)
> -{
> -       struct cryptd_ahash *cryptd_tfm;
> -       struct ghash_async_ctx *ctx = crypto_tfm_ctx(tfm);
> -
> -       cryptd_tfm = cryptd_alloc_ahash("ghash-ce-sync", 0, 0);
> -       if (IS_ERR(cryptd_tfm))
> -               return PTR_ERR(cryptd_tfm);
> -       ctx->cryptd_tfm = cryptd_tfm;
> -       crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
> -                                sizeof(struct ahash_request) +
> -                                crypto_ahash_reqsize(&cryptd_tfm->base));
> -
> -       return 0;
> -}
> -
> -static void ghash_async_exit_tfm(struct crypto_tfm *tfm)
> -{
> -       struct ghash_async_ctx *ctx = crypto_tfm_ctx(tfm);
> -
> -       cryptd_free_ahash(ctx->cryptd_tfm);
> -}
> -
> -static struct ahash_alg ghash_async_alg = {
> -       .init                   = ghash_async_init,
> -       .update                 = ghash_async_update,
> -       .final                  = ghash_async_final,
> -       .setkey                 = ghash_async_setkey,
> -       .digest                 = ghash_async_digest,
> -       .import                 = ghash_async_import,
> -       .export                 = ghash_async_export,
> -       .halg.digestsize        = GHASH_DIGEST_SIZE,
> -       .halg.statesize         = sizeof(struct ghash_desc_ctx),
> -       .halg.base              = {
> -               .cra_name       = "ghash",
> -               .cra_driver_name = "ghash-ce",
> -               .cra_priority   = 300,
> -               .cra_flags      = CRYPTO_ALG_ASYNC,
> -               .cra_blocksize  = GHASH_BLOCK_SIZE,
> -               .cra_ctxsize    = sizeof(struct ghash_async_ctx),
> -               .cra_module     = THIS_MODULE,
> -               .cra_init       = ghash_async_init_tfm,
> -               .cra_exit       = ghash_async_exit_tfm,
> -       },
> -};
> -
> -
>  void pmull_gcm_encrypt(int blocks, u64 dg[], const char *src,
>                        struct gcm_key const *k, char *dst,
>                        const char *iv, int rounds, u32 counter);
> @@ -759,14 +584,9 @@ static int __init ghash_ce_mod_init(void)
>         err = crypto_register_shash(&ghash_alg);
>         if (err)
>                 goto err_aead;
> -       err = crypto_register_ahash(&ghash_async_alg);
> -       if (err)
> -               goto err_shash;
>
>         return 0;
>
> -err_shash:
> -       crypto_unregister_shash(&ghash_alg);
>  err_aead:
>         if (elf_hwcap2 & HWCAP2_PMULL)
>                 crypto_unregister_aeads(gcm_aes_algs,
> @@ -776,7 +596,6 @@ static int __init ghash_ce_mod_init(void)
>
>  static void __exit ghash_ce_mod_exit(void)
>  {
> -       crypto_unregister_ahash(&ghash_async_alg);
>         crypto_unregister_shash(&ghash_alg);
>         if (elf_hwcap2 & HWCAP2_PMULL)
>                 crypto_unregister_aeads(gcm_aes_algs,
> --
> 2.39.5
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
