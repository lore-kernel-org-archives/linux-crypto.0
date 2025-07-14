Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2D71DF963;
	Mon, 14 Jul 2025 05:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752470708; cv=none; b=BJzPNbc35AqGY0eoiswVlGm7nXhi/gYVL2EObLrtoUdgG6rj7zrJ1XoM/vla6OONkop+INui7XkEUuAMRKHd6PmAldqQ3iyq/w/4W74iR1mJ/2UaxxHHacxyy1T7NOqmHFYnTeKTZeewQIEua3TSGfMDlM/PdvkfOdKNeyc4TGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752470708; c=relaxed/simple;
	bh=d73cam3gCMUQG+CE2C/1Vbt+EH/YHEJHFnOFWnM1G9I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LXlAwwSt38yNqbcnzK5ETvHl9cP7fKSFoXlbupQsQVHYlat7jeiVornzN+AWVI/OAiwCa5ASDTJ5HssA9oWnnl5PUE4LIn62mE5hf0EWee+gU7jn9UOxhCfm6oIC5V2WUYWzglOTwlYcYCQ4AOjqLYdhRxfdnZBBe1R4NiTR3ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwOaR83A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwOaR83A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7888AC4CEF7;
	Mon, 14 Jul 2025 05:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752470707;
	bh=d73cam3gCMUQG+CE2C/1Vbt+EH/YHEJHFnOFWnM1G9I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XwOaR83AuAuDFPdt8MPGel+5pdkfsOJl8hyO6e3Y7JuGSFrCfSD386/y5iZkhbEOO
	 xxJ+N/DcbZ3Vvgrq1caVDcZ3YxzkN9cdsraBhH//Pnp+EX4PTbJfY+24tQF//IYITp
	 aCVYOzUk40reXP4O+iFVfgtMb3HkX7UOwzHix6nTubxVShuAGnhaIs8UEUqDUUO5bk
	 teCCzcLgu8tnzBDraIGFgp8JcT1BgE9XM7qP6sw/YVpGWPZMMXJAAhvLsgX+19QP2r
	 NI4pz2w+WPP0Thhcq+imOyleIHtSwea8dw2hpQy0a9zzd0PSggy+eWt6JkIJKx1/7o
	 1bt1cJmHcYPGg==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-558fc8f0750so4652680e87.2;
        Sun, 13 Jul 2025 22:25:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV8WSzMctFnmj12mJs4HA+jGXmEHx9Uwhxi6aPaI2cj9yAswMrJUtmn5FB3Yp21AW3/eY7z7EDqR/3A+cw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNeJY9L2HdXcNNICnQlAnpnQkr6jm02RweQsS1IlYZubXygr8O
	G6+WW4AaRYOyNJ5fQYCFmKhvFD3eXpd5vjiD+XwjSEgEVV1J20yyBj+dqlvNg1DLJB2zm36mHbb
	a5Epuf3cZ+u/e25tVCgeBeNqjaYK4YPU=
X-Google-Smtp-Source: AGHT+IFEyx82S9gp31nfiQxZnLlGUM9qiE7PqZNqoT71If4NTyNPCxKYpd43wmXrm/vM9l24DZbKMoBGJnJGljIc26c=
X-Received: by 2002:a05:6512:401a:b0:553:2633:8a64 with SMTP id
 2adb3069b0e04-55a044e4afcmr2792912e87.23.1752470705759; Sun, 13 Jul 2025
 22:25:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250711215844.41715-1-ebiggers@kernel.org>
In-Reply-To: <20250711215844.41715-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 14 Jul 2025 15:24:54 +1000
X-Gmail-Original-Message-ID: <CAMj1kXF2BEv1GvHdYOMRoq0_V03r27Yr6DTM-Rp3kR7OrgMn4A@mail.gmail.com>
X-Gm-Features: Ac12FXx7pfE1kHJp7t486C9KUBoxzoG1hBGoz40DIoxyJN7mA5bCVrvDh1u0kFQ
Message-ID: <CAMj1kXF2BEv1GvHdYOMRoq0_V03r27Yr6DTM-Rp3kR7OrgMn4A@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: sha2: Add hmac_sha*_init_usingrawkey()
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 12 Jul 2025 at 07:59, Eric Biggers <ebiggers@kernel.org> wrote:
>
> While the HMAC library functions support both incremental and one-shot
> computation and both prepared and raw keys, the combination of raw key
> + incremental was missing.  It turns out that several potential users of
> the HMAC library functions (tpm2-sessions.c, smb2transport.c,
> trusted_tpm1.c) want exactly that.
>
> Therefore, add the missing functions hmac_sha*_init_usingrawkey().
>
> Implement them in an optimized way that directly initializes the HMAC
> context without a separate key preparation step.
>
> Reimplement the one-shot raw key functions hmac_sha*_usingrawkey() on
> top of the new functions, which makes them a bit more efficient.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  include/crypto/sha2.h | 60 +++++++++++++++++++++++++++++++++++++++++++
>  lib/crypto/sha256.c   | 53 ++++++++++++++++++++++++++------------
>  lib/crypto/sha512.c   | 55 +++++++++++++++++++++++++++------------
>  3 files changed, 134 insertions(+), 34 deletions(-)
>
> diff --git a/include/crypto/sha2.h b/include/crypto/sha2.h
> index e0a08f6addd00..15e461e568cca 100644
> --- a/include/crypto/sha2.h
> +++ b/include/crypto/sha2.h
> @@ -245,10 +245,25 @@ static inline void hmac_sha224_init(struct hmac_sha224_ctx *ctx,
>                                     const struct hmac_sha224_key *key)
>  {
>         __hmac_sha256_init(&ctx->ctx, &key->key);
>  }
>
> +/**
> + * hmac_sha224_init_usingrawkey() - Initialize an HMAC-SHA224 context for a new
> + *                                 message, using a raw key
> + * @ctx: (output) the HMAC context to initialize
> + * @raw_key: the raw HMAC-SHA224 key
> + * @raw_key_len: the key length in bytes.  All key lengths are supported.
> + *
> + * If you don't need incremental computation, consider hmac_sha224_usingrawkey()
> + * instead.
> + *
> + * Context: Any context.
> + */
> +void hmac_sha224_init_usingrawkey(struct hmac_sha224_ctx *ctx,
> +                                 const u8 *raw_key, size_t raw_key_len);
> +
>  /**
>   * hmac_sha224_update() - Update an HMAC-SHA224 context with message data
>   * @ctx: the HMAC context to update; must have been initialized
>   * @data: the message data
>   * @data_len: the data length in bytes
> @@ -403,10 +418,25 @@ static inline void hmac_sha256_init(struct hmac_sha256_ctx *ctx,
>                                     const struct hmac_sha256_key *key)
>  {
>         __hmac_sha256_init(&ctx->ctx, &key->key);
>  }
>
> +/**
> + * hmac_sha256_init_usingrawkey() - Initialize an HMAC-SHA256 context for a new
> + *                                 message, using a raw key
> + * @ctx: (output) the HMAC context to initialize
> + * @raw_key: the raw HMAC-SHA256 key
> + * @raw_key_len: the key length in bytes.  All key lengths are supported.
> + *
> + * If you don't need incremental computation, consider hmac_sha256_usingrawkey()
> + * instead.
> + *
> + * Context: Any context.
> + */
> +void hmac_sha256_init_usingrawkey(struct hmac_sha256_ctx *ctx,
> +                                 const u8 *raw_key, size_t raw_key_len);
> +
>  /**
>   * hmac_sha256_update() - Update an HMAC-SHA256 context with message data
>   * @ctx: the HMAC context to update; must have been initialized
>   * @data: the message data
>   * @data_len: the data length in bytes
> @@ -595,10 +625,25 @@ static inline void hmac_sha384_init(struct hmac_sha384_ctx *ctx,
>                                     const struct hmac_sha384_key *key)
>  {
>         __hmac_sha512_init(&ctx->ctx, &key->key);
>  }
>
> +/**
> + * hmac_sha384_init_usingrawkey() - Initialize an HMAC-SHA384 context for a new
> + *                                 message, using a raw key
> + * @ctx: (output) the HMAC context to initialize
> + * @raw_key: the raw HMAC-SHA384 key
> + * @raw_key_len: the key length in bytes.  All key lengths are supported.
> + *
> + * If you don't need incremental computation, consider hmac_sha384_usingrawkey()
> + * instead.
> + *
> + * Context: Any context.
> + */
> +void hmac_sha384_init_usingrawkey(struct hmac_sha384_ctx *ctx,
> +                                 const u8 *raw_key, size_t raw_key_len);
> +
>  /**
>   * hmac_sha384_update() - Update an HMAC-SHA384 context with message data
>   * @ctx: the HMAC context to update; must have been initialized
>   * @data: the message data
>   * @data_len: the data length in bytes
> @@ -753,10 +798,25 @@ static inline void hmac_sha512_init(struct hmac_sha512_ctx *ctx,
>                                     const struct hmac_sha512_key *key)
>  {
>         __hmac_sha512_init(&ctx->ctx, &key->key);
>  }
>
> +/**
> + * hmac_sha512_init_usingrawkey() - Initialize an HMAC-SHA512 context for a new
> + *                                 message, using a raw key
> + * @ctx: (output) the HMAC context to initialize
> + * @raw_key: the raw HMAC-SHA512 key
> + * @raw_key_len: the key length in bytes.  All key lengths are supported.
> + *
> + * If you don't need incremental computation, consider hmac_sha512_usingrawkey()
> + * instead.
> + *
> + * Context: Any context.
> + */
> +void hmac_sha512_init_usingrawkey(struct hmac_sha512_ctx *ctx,
> +                                 const u8 *raw_key, size_t raw_key_len);
> +
>  /**
>   * hmac_sha512_update() - Update an HMAC-SHA512 context with message data
>   * @ctx: the HMAC context to update; must have been initialized
>   * @data: the message data
>   * @data_len: the data length in bytes
> diff --git a/lib/crypto/sha256.c b/lib/crypto/sha256.c
> index 808438d4f4278..8fa15165d23e8 100644
> --- a/lib/crypto/sha256.c
> +++ b/lib/crypto/sha256.c
> @@ -261,11 +261,12 @@ void sha256(const u8 *data, size_t len, u8 out[SHA256_DIGEST_SIZE])
>  }
>  EXPORT_SYMBOL(sha256);
>
>  /* pre-boot environment (as indicated by __DISABLE_EXPORTS) doesn't need HMAC */
>  #ifndef __DISABLE_EXPORTS
> -static void __hmac_sha256_preparekey(struct __hmac_sha256_key *key,
> +static void __hmac_sha256_preparekey(struct sha256_block_state *istate,
> +                                    struct sha256_block_state *ostate,
>                                      const u8 *raw_key, size_t raw_key_len,
>                                      const struct sha256_block_state *iv)
>  {
>         union {
>                 u8 b[SHA256_BLOCK_SIZE];
> @@ -281,33 +282,35 @@ static void __hmac_sha256_preparekey(struct __hmac_sha256_key *key,
>                 memcpy(derived_key.b, raw_key, raw_key_len);
>         }
>
>         for (size_t i = 0; i < ARRAY_SIZE(derived_key.w); i++)
>                 derived_key.w[i] ^= REPEAT_BYTE(HMAC_IPAD_VALUE);
> -       key->istate = *iv;
> -       sha256_blocks(&key->istate, derived_key.b, 1);
> +       *istate = *iv;
> +       sha256_blocks(istate, derived_key.b, 1);
>
>         for (size_t i = 0; i < ARRAY_SIZE(derived_key.w); i++)
>                 derived_key.w[i] ^= REPEAT_BYTE(HMAC_OPAD_VALUE ^
>                                                 HMAC_IPAD_VALUE);
> -       key->ostate = *iv;
> -       sha256_blocks(&key->ostate, derived_key.b, 1);
> +       *ostate = *iv;
> +       sha256_blocks(ostate, derived_key.b, 1);
>
>         memzero_explicit(&derived_key, sizeof(derived_key));
>  }
>
>  void hmac_sha224_preparekey(struct hmac_sha224_key *key,
>                             const u8 *raw_key, size_t raw_key_len)
>  {
> -       __hmac_sha256_preparekey(&key->key, raw_key, raw_key_len, &sha224_iv);
> +       __hmac_sha256_preparekey(&key->key.istate, &key->key.ostate,
> +                                raw_key, raw_key_len, &sha224_iv);
>  }
>  EXPORT_SYMBOL_GPL(hmac_sha224_preparekey);
>
>  void hmac_sha256_preparekey(struct hmac_sha256_key *key,
>                             const u8 *raw_key, size_t raw_key_len)
>  {
> -       __hmac_sha256_preparekey(&key->key, raw_key, raw_key_len, &sha256_iv);
> +       __hmac_sha256_preparekey(&key->key.istate, &key->key.ostate,
> +                                raw_key, raw_key_len, &sha256_iv);
>  }
>  EXPORT_SYMBOL_GPL(hmac_sha256_preparekey);
>
>  void __hmac_sha256_init(struct __hmac_sha256_ctx *ctx,
>                         const struct __hmac_sha256_key *key)
> @@ -315,10 +318,28 @@ void __hmac_sha256_init(struct __hmac_sha256_ctx *ctx,
>         __sha256_init(&ctx->sha_ctx, &key->istate, SHA256_BLOCK_SIZE);
>         ctx->ostate = key->ostate;
>  }
>  EXPORT_SYMBOL_GPL(__hmac_sha256_init);
>
> +void hmac_sha224_init_usingrawkey(struct hmac_sha224_ctx *ctx,
> +                                 const u8 *raw_key, size_t raw_key_len)
> +{
> +       __hmac_sha256_preparekey(&ctx->ctx.sha_ctx.state, &ctx->ctx.ostate,
> +                                raw_key, raw_key_len, &sha224_iv);
> +       ctx->ctx.sha_ctx.bytecount = SHA256_BLOCK_SIZE;
> +}
> +EXPORT_SYMBOL_GPL(hmac_sha224_init_usingrawkey);
> +
> +void hmac_sha256_init_usingrawkey(struct hmac_sha256_ctx *ctx,
> +                                 const u8 *raw_key, size_t raw_key_len)
> +{
> +       __hmac_sha256_preparekey(&ctx->ctx.sha_ctx.state, &ctx->ctx.ostate,
> +                                raw_key, raw_key_len, &sha256_iv);
> +       ctx->ctx.sha_ctx.bytecount = SHA256_BLOCK_SIZE;
> +}
> +EXPORT_SYMBOL_GPL(hmac_sha256_init_usingrawkey);
> +
>  static void __hmac_sha256_final(struct __hmac_sha256_ctx *ctx,
>                                 u8 *out, size_t digest_size)
>  {
>         /* Generate the padded input for the outer hash in ctx->sha_ctx.buf. */
>         __sha256_final(&ctx->sha_ctx, ctx->sha_ctx.buf, digest_size);
> @@ -374,29 +395,27 @@ EXPORT_SYMBOL_GPL(hmac_sha256);
>
>  void hmac_sha224_usingrawkey(const u8 *raw_key, size_t raw_key_len,
>                              const u8 *data, size_t data_len,
>                              u8 out[SHA224_DIGEST_SIZE])
>  {
> -       struct hmac_sha224_key key;
> -
> -       hmac_sha224_preparekey(&key, raw_key, raw_key_len);
> -       hmac_sha224(&key, data, data_len, out);
> +       struct hmac_sha224_ctx ctx;
>
> -       memzero_explicit(&key, sizeof(key));
> +       hmac_sha224_init_usingrawkey(&ctx, raw_key, raw_key_len);
> +       hmac_sha224_update(&ctx, data, data_len);
> +       hmac_sha224_final(&ctx, out);
>  }
>  EXPORT_SYMBOL_GPL(hmac_sha224_usingrawkey);
>
>  void hmac_sha256_usingrawkey(const u8 *raw_key, size_t raw_key_len,
>                              const u8 *data, size_t data_len,
>                              u8 out[SHA256_DIGEST_SIZE])
>  {
> -       struct hmac_sha256_key key;
> -
> -       hmac_sha256_preparekey(&key, raw_key, raw_key_len);
> -       hmac_sha256(&key, data, data_len, out);
> +       struct hmac_sha256_ctx ctx;
>
> -       memzero_explicit(&key, sizeof(key));
> +       hmac_sha256_init_usingrawkey(&ctx, raw_key, raw_key_len);
> +       hmac_sha256_update(&ctx, data, data_len);
> +       hmac_sha256_final(&ctx, out);
>  }
>  EXPORT_SYMBOL_GPL(hmac_sha256_usingrawkey);
>  #endif /* !__DISABLE_EXPORTS */
>
>  #ifdef sha256_mod_init_arch
> diff --git a/lib/crypto/sha512.c b/lib/crypto/sha512.c
> index d514721491ca0..d8062188be98a 100644
> --- a/lib/crypto/sha512.c
> +++ b/lib/crypto/sha512.c
> @@ -247,11 +247,12 @@ void sha512(const u8 *data, size_t len, u8 out[SHA512_DIGEST_SIZE])
>         sha512_update(&ctx, data, len);
>         sha512_final(&ctx, out);
>  }
>  EXPORT_SYMBOL_GPL(sha512);
>
> -static void __hmac_sha512_preparekey(struct __hmac_sha512_key *key,
> +static void __hmac_sha512_preparekey(struct sha512_block_state *istate,
> +                                    struct sha512_block_state *ostate,
>                                      const u8 *raw_key, size_t raw_key_len,
>                                      const struct sha512_block_state *iv)
>  {
>         union {
>                 u8 b[SHA512_BLOCK_SIZE];
> @@ -267,33 +268,35 @@ static void __hmac_sha512_preparekey(struct __hmac_sha512_key *key,
>                 memcpy(derived_key.b, raw_key, raw_key_len);
>         }
>
>         for (size_t i = 0; i < ARRAY_SIZE(derived_key.w); i++)
>                 derived_key.w[i] ^= REPEAT_BYTE(HMAC_IPAD_VALUE);
> -       key->istate = *iv;
> -       sha512_blocks(&key->istate, derived_key.b, 1);
> +       *istate = *iv;
> +       sha512_blocks(istate, derived_key.b, 1);
>
>         for (size_t i = 0; i < ARRAY_SIZE(derived_key.w); i++)
>                 derived_key.w[i] ^= REPEAT_BYTE(HMAC_OPAD_VALUE ^
>                                                 HMAC_IPAD_VALUE);
> -       key->ostate = *iv;
> -       sha512_blocks(&key->ostate, derived_key.b, 1);
> +       *ostate = *iv;
> +       sha512_blocks(ostate, derived_key.b, 1);
>
>         memzero_explicit(&derived_key, sizeof(derived_key));
>  }
>
>  void hmac_sha384_preparekey(struct hmac_sha384_key *key,
>                             const u8 *raw_key, size_t raw_key_len)
>  {
> -       __hmac_sha512_preparekey(&key->key, raw_key, raw_key_len, &sha384_iv);
> +       __hmac_sha512_preparekey(&key->key.istate, &key->key.ostate,
> +                                raw_key, raw_key_len, &sha384_iv);
>  }
>  EXPORT_SYMBOL_GPL(hmac_sha384_preparekey);
>
>  void hmac_sha512_preparekey(struct hmac_sha512_key *key,
>                             const u8 *raw_key, size_t raw_key_len)
>  {
> -       __hmac_sha512_preparekey(&key->key, raw_key, raw_key_len, &sha512_iv);
> +       __hmac_sha512_preparekey(&key->key.istate, &key->key.ostate,
> +                                raw_key, raw_key_len, &sha512_iv);
>  }
>  EXPORT_SYMBOL_GPL(hmac_sha512_preparekey);
>
>  void __hmac_sha512_init(struct __hmac_sha512_ctx *ctx,
>                         const struct __hmac_sha512_key *key)
> @@ -301,10 +304,30 @@ void __hmac_sha512_init(struct __hmac_sha512_ctx *ctx,
>         __sha512_init(&ctx->sha_ctx, &key->istate, SHA512_BLOCK_SIZE);
>         ctx->ostate = key->ostate;
>  }
>  EXPORT_SYMBOL_GPL(__hmac_sha512_init);
>
> +void hmac_sha384_init_usingrawkey(struct hmac_sha384_ctx *ctx,
> +                                 const u8 *raw_key, size_t raw_key_len)
> +{
> +       __hmac_sha512_preparekey(&ctx->ctx.sha_ctx.state, &ctx->ctx.ostate,
> +                                raw_key, raw_key_len, &sha384_iv);
> +       ctx->ctx.sha_ctx.bytecount_lo = SHA512_BLOCK_SIZE;
> +       ctx->ctx.sha_ctx.bytecount_hi = 0;
> +}
> +EXPORT_SYMBOL_GPL(hmac_sha384_init_usingrawkey);
> +
> +void hmac_sha512_init_usingrawkey(struct hmac_sha512_ctx *ctx,
> +                                 const u8 *raw_key, size_t raw_key_len)
> +{
> +       __hmac_sha512_preparekey(&ctx->ctx.sha_ctx.state, &ctx->ctx.ostate,
> +                                raw_key, raw_key_len, &sha512_iv);
> +       ctx->ctx.sha_ctx.bytecount_lo = SHA512_BLOCK_SIZE;
> +       ctx->ctx.sha_ctx.bytecount_hi = 0;
> +}
> +EXPORT_SYMBOL_GPL(hmac_sha512_init_usingrawkey);
> +
>  static void __hmac_sha512_final(struct __hmac_sha512_ctx *ctx,
>                                 u8 *out, size_t digest_size)
>  {
>         /* Generate the padded input for the outer hash in ctx->sha_ctx.buf. */
>         __sha512_final(&ctx->sha_ctx, ctx->sha_ctx.buf, digest_size);
> @@ -360,29 +383,27 @@ EXPORT_SYMBOL_GPL(hmac_sha512);
>
>  void hmac_sha384_usingrawkey(const u8 *raw_key, size_t raw_key_len,
>                              const u8 *data, size_t data_len,
>                              u8 out[SHA384_DIGEST_SIZE])
>  {
> -       struct hmac_sha384_key key;
> -
> -       hmac_sha384_preparekey(&key, raw_key, raw_key_len);
> -       hmac_sha384(&key, data, data_len, out);
> +       struct hmac_sha384_ctx ctx;
>
> -       memzero_explicit(&key, sizeof(key));
> +       hmac_sha384_init_usingrawkey(&ctx, raw_key, raw_key_len);
> +       hmac_sha384_update(&ctx, data, data_len);
> +       hmac_sha384_final(&ctx, out);
>  }
>  EXPORT_SYMBOL_GPL(hmac_sha384_usingrawkey);
>
>  void hmac_sha512_usingrawkey(const u8 *raw_key, size_t raw_key_len,
>                              const u8 *data, size_t data_len,
>                              u8 out[SHA512_DIGEST_SIZE])
>  {
> -       struct hmac_sha512_key key;
> -
> -       hmac_sha512_preparekey(&key, raw_key, raw_key_len);
> -       hmac_sha512(&key, data, data_len, out);
> +       struct hmac_sha512_ctx ctx;
>
> -       memzero_explicit(&key, sizeof(key));
> +       hmac_sha512_init_usingrawkey(&ctx, raw_key, raw_key_len);
> +       hmac_sha512_update(&ctx, data, data_len);
> +       hmac_sha512_final(&ctx, out);
>  }
>  EXPORT_SYMBOL_GPL(hmac_sha512_usingrawkey);
>
>  #ifdef sha512_mod_init_arch
>  static int __init sha512_mod_init(void)
>
> base-commit: e14ada7ed2e1dda5161051be1d2131b606c8ab96
> --
> 2.50.1
>
