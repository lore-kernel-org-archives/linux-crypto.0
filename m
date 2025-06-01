Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BF23C38;
	Sun,  1 Jun 2025 09:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748768652; cv=none; b=Gla+oIHQcakXuxqfQvx7geWGGE+Z/adOnCkXgg9a9jRT0uEL3wh2P/M3pwsXDGQKXFayKnV3oNT2cLthMASAWsiiDapTAZDWwzt91ru1U8C3V5buTsQsM7G1g4eIMH7JRSYk3CChJzuAowiFQ6Bnm18aglHsok67AejeipUWUF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748768652; c=relaxed/simple;
	bh=1FBnoHXzf/SEJxTiJtrawhxy4l2suncrfen4dm5fUdY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S6LmgXVbJ9WVH2V/X0m2+eWhr2NJYCluO/GF3oMzntWxsT5Y+R499hgsEdBOv/+5SkAWMcJbSE5DbQ9lZVYhToO17B2dkp0foUnFgpX3Eq1S+1JsGIzIfkHmInB2XdlyQYEuFQSSqx75FSVlttDotoNZ0BePHdCYKNBl6dnzrpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ss65yud7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ss65yud7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4BCC4CEE7;
	Sun,  1 Jun 2025 09:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748768651;
	bh=1FBnoHXzf/SEJxTiJtrawhxy4l2suncrfen4dm5fUdY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ss65yud7rC3zuf/5+t1tFq6gQQJ8vR+V/75+pGdhTc0oxERZ83IrerZyJKXpJjCey
	 nZsAMVQ0kBCxTBO8VtdhRpeUCqWhbuf6AtZr/okPYtcaPur1FS3BiesJ8ZY2tAqkhT
	 BYs7TzW77QG/WISB5sZzQghwviKZvJSoAvXS8ftmRmIQkhfjL3qlUJb7BE8PSQlbQ5
	 usbzefh5LQCR/rGMC0ZgpPPezsj/pbMOFErAvHy0w4E1Sg1xRVSYNjhwnVCSkcP3LI
	 ik0dcKF5nQDKZcyRCpuGddIuBb+WalwQDJnlg7NrO/SbaGhlAgXsa9WqPPhyuELUHO
	 ozjixbh9vY7QQ==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5532f6d184eso4407204e87.0;
        Sun, 01 Jun 2025 02:04:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWxQzsD1IfbOee8Gx2NC0GZd6v0oVZji0Riabp2UhUme0vXZ8kDr70ZrAotHvCqoFezqGe8tJXR6k6MPP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsZa33bSQ+jYRfB6v5P5k8+TJujxbNaym4Svyia7tfb1vmRxrT
	dQEjerXBY8G+4GRB1BkC+L3F5UcrIFRLHPlr4d6p/BOzBLtrcXDnSzhpxEWngLUJVljA/KuXPLG
	0k1HOu9KjWeHMfocVWl3apffEjHxN7l8=
X-Google-Smtp-Source: AGHT+IFsqHn50uNK88yIcMCHj/JEuHNgrQxZpabdILktqXtb0RaHLaHUTVaNSZMFoAQAI/WyKODH1bNdklza46wlQa8=
X-Received: by 2002:a05:6512:1328:b0:54e:81ec:2c83 with SMTP id
 2adb3069b0e04-5533b8f412cmr2974471e87.18.1748768649922; Sun, 01 Jun 2025
 02:04:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250531204244.24648-1-ebiggers@kernel.org>
In-Reply-To: <20250531204244.24648-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 1 Jun 2025 11:03:57 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGf6op6TRcK7w2xQV9aUQzydRd0dfxFmsMDXqpTNB9PbA@mail.gmail.com>
X-Gm-Features: AX0GCFsHFCEGM3SUNSEb9ExS7v0xYIcT9gbNqz7vVj7N_YYnyVSMKLBfD2LtMrg
Message-ID: <CAMj1kXGf6op6TRcK7w2xQV9aUQzydRd0dfxFmsMDXqpTNB9PbA@mail.gmail.com>
Subject: Re: [PATCH] crypto: inside-secure - remove crc32 support
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Antoine Tenart <atenart@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 31 May 2025 at 22:43, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The crc32 acceleration in the inside-secure driver is accessible only as
> an asynchronous hash.  However, there seems to be no corresponding user
> of crc32 in the kernel that supports asynchronous hashes.  Therefore,
> this code seems to be unused.
>
> The patch that added this code provided no justification for its
> inclusion.  All devicetree bindings for this accelerator are for arm64;
> arm64 CPUs often have CRC or PMULL instructions, which already
> accelerate crc32 very well.  And these actually work with the crc32
> users in the kernel, unlike this driver which doesn't.
>

CRC instructions are mandatory in the ARM architecture revision v8.1,
and the only known core that does not implement them is the long
obsolete APM X-Gene.

> Remove this unnecessary code.
>
> Cc: Antoine Tenart <atenart@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>
> I'm planning to take this patch via the crc tree.
>
>  drivers/crypto/inside-secure/safexcel.c      |  1 -
>  drivers/crypto/inside-secure/safexcel.h      |  1 -
>  drivers/crypto/inside-secure/safexcel_hash.c | 92 +-------------------
>  3 files changed, 2 insertions(+), 92 deletions(-)
>
> diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
> index 9ca80d082c4fb..c3b2b22934b7e 100644
> --- a/drivers/crypto/inside-secure/safexcel.c
> +++ b/drivers/crypto/inside-secure/safexcel.c
> @@ -1216,11 +1216,10 @@ static struct safexcel_alg_template *safexcel_algs[] = {
>         &safexcel_alg_authenc_hmac_sha384_ctr_aes,
>         &safexcel_alg_authenc_hmac_sha512_ctr_aes,
>         &safexcel_alg_xts_aes,
>         &safexcel_alg_gcm,
>         &safexcel_alg_ccm,
> -       &safexcel_alg_crc32,
>         &safexcel_alg_cbcmac,
>         &safexcel_alg_xcbcmac,
>         &safexcel_alg_cmac,
>         &safexcel_alg_chacha20,
>         &safexcel_alg_chachapoly,
> diff --git a/drivers/crypto/inside-secure/safexcel.h b/drivers/crypto/inside-secure/safexcel.h
> index 0c79ad78d1c0a..0f27367a85fa2 100644
> --- a/drivers/crypto/inside-secure/safexcel.h
> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -957,11 +957,10 @@ extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha256_ctr_aes;
>  extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha384_ctr_aes;
>  extern struct safexcel_alg_template safexcel_alg_authenc_hmac_sha512_ctr_aes;
>  extern struct safexcel_alg_template safexcel_alg_xts_aes;
>  extern struct safexcel_alg_template safexcel_alg_gcm;
>  extern struct safexcel_alg_template safexcel_alg_ccm;
> -extern struct safexcel_alg_template safexcel_alg_crc32;
>  extern struct safexcel_alg_template safexcel_alg_cbcmac;
>  extern struct safexcel_alg_template safexcel_alg_xcbcmac;
>  extern struct safexcel_alg_template safexcel_alg_cmac;
>  extern struct safexcel_alg_template safexcel_alg_chacha20;
>  extern struct safexcel_alg_template safexcel_alg_chachapoly;
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index d2b632193bebb..fd34dc8f5707d 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -287,18 +287,12 @@ static int safexcel_handle_req_result(struct safexcel_crypto_priv *priv,
>
>                         *should_complete = false; /* Not done yet */
>                         return 1;
>                 }
>
> -               if (unlikely(sreq->digest == CONTEXT_CONTROL_DIGEST_XCM &&
> -                            ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_CRC32)) {
> -                       /* Undo final XOR with 0xffffffff ...*/
> -                       *(__le32 *)areq->result = ~sreq->state[0];
> -               } else {
> -                       memcpy(areq->result, sreq->state,
> -                              crypto_ahash_digestsize(ahash));
> -               }
> +               memcpy(areq->result, sreq->state,
> +                      crypto_ahash_digestsize(ahash));
>         }
>
>         cache_len = safexcel_queued_len(sreq);
>         if (cache_len)
>                 memcpy(sreq->cache, sreq->cache_next, cache_len);
> @@ -1879,92 +1873,10 @@ struct safexcel_alg_template safexcel_alg_hmac_md5 = {
>                         },
>                 },
>         },
>  };
>
> -static int safexcel_crc32_cra_init(struct crypto_tfm *tfm)
> -{
> -       struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(tfm);
> -       int ret = safexcel_ahash_cra_init(tfm);
> -
> -       /* Default 'key' is all zeroes */
> -       memset(&ctx->base.ipad, 0, sizeof(u32));
> -       return ret;
> -}
> -
> -static int safexcel_crc32_init(struct ahash_request *areq)
> -{
> -       struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
> -       struct safexcel_ahash_req *req = ahash_request_ctx_dma(areq);
> -
> -       memset(req, 0, sizeof(*req));
> -
> -       /* Start from loaded key */
> -       req->state[0]   = cpu_to_le32(~ctx->base.ipad.word[0]);
> -       /* Set processed to non-zero to enable invalidation detection */
> -       req->len        = sizeof(u32);
> -       req->processed  = sizeof(u32);
> -
> -       ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_CRC32;
> -       req->digest = CONTEXT_CONTROL_DIGEST_XCM;
> -       req->state_sz = sizeof(u32);
> -       req->digest_sz = sizeof(u32);
> -       req->block_sz = sizeof(u32);
> -
> -       return 0;
> -}
> -
> -static int safexcel_crc32_setkey(struct crypto_ahash *tfm, const u8 *key,
> -                                unsigned int keylen)
> -{
> -       struct safexcel_ahash_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
> -
> -       if (keylen != sizeof(u32))
> -               return -EINVAL;
> -
> -       memcpy(&ctx->base.ipad, key, sizeof(u32));
> -       return 0;
> -}
> -
> -static int safexcel_crc32_digest(struct ahash_request *areq)
> -{
> -       return safexcel_crc32_init(areq) ?: safexcel_ahash_finup(areq);
> -}
> -
> -struct safexcel_alg_template safexcel_alg_crc32 = {
> -       .type = SAFEXCEL_ALG_TYPE_AHASH,
> -       .algo_mask = 0,
> -       .alg.ahash = {
> -               .init = safexcel_crc32_init,
> -               .update = safexcel_ahash_update,
> -               .final = safexcel_ahash_final,
> -               .finup = safexcel_ahash_finup,
> -               .digest = safexcel_crc32_digest,
> -               .setkey = safexcel_crc32_setkey,
> -               .export = safexcel_ahash_export,
> -               .import = safexcel_ahash_import,
> -               .halg = {
> -                       .digestsize = sizeof(u32),
> -                       .statesize = sizeof(struct safexcel_ahash_export_state),
> -                       .base = {
> -                               .cra_name = "crc32",
> -                               .cra_driver_name = "safexcel-crc32",
> -                               .cra_priority = SAFEXCEL_CRA_PRIORITY,
> -                               .cra_flags = CRYPTO_ALG_OPTIONAL_KEY |
> -                                            CRYPTO_ALG_ASYNC |
> -                                            CRYPTO_ALG_ALLOCATES_MEMORY |
> -                                            CRYPTO_ALG_KERN_DRIVER_ONLY,
> -                               .cra_blocksize = 1,
> -                               .cra_ctxsize = sizeof(struct safexcel_ahash_ctx),
> -                               .cra_init = safexcel_crc32_cra_init,
> -                               .cra_exit = safexcel_ahash_cra_exit,
> -                               .cra_module = THIS_MODULE,
> -                       },
> -               },
> -       },
> -};
> -
>  static int safexcel_cbcmac_init(struct ahash_request *areq)
>  {
>         struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
>         struct safexcel_ahash_req *req = ahash_request_ctx_dma(areq);
>
>
> base-commit: 4cb6c8af8591135ec000fbe4bb474139ceec595d
> --
> 2.49.0
>
