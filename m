Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AB011185
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 08:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742113492; cv=none; b=G5rHptXiGqBDMblwBrv4AWNDbhCEQuZGVI0GxRxjUQM7WqjAS39DVK+a/ZMiRv8h/wDv69GqYgRTgIOrwQ2hbCugKCRbzwyGkSp4EJuBur0kfpd3rm7ty/EKX05Ub5sAUuYCOVsdRB79gPfADj5GMz1sZyjI9jrTCNxr0smUMOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742113492; c=relaxed/simple;
	bh=zsOc0OO8X2UIT8CImZpvT0S6DKd+K3OFdVfTiQuSP0M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iDmpY8Hunbg5LtUcGvKi5ls67aJ8DmN4p9MAg+VphTOQqkn9FSdu6Zg+lZBZAxi8wDVJOd2BbxcDa6HwnquvkEolfolsAlf9lqc994y26SyeD4SeIfPodODEqoykXslBYBjxmbDsLp3IuQQATfKTuhIZTUMCHxUxysbEzCb+EsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E1Q6ugIS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E1Q6ugIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B0CC4CEE9
	for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 08:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742113491;
	bh=zsOc0OO8X2UIT8CImZpvT0S6DKd+K3OFdVfTiQuSP0M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E1Q6ugISVrPJ6c+/kU1ujBZHXaTLocA3J6x894a4p9AwyeB9c3cjC5cKWwcWp3IOI
	 nIvhuI4TmLHwddsnV6Us+mp46C9gJuNFMRERdLaH9oT4Ejtqbpy7zQBfIhQv1DpKX3
	 +5JtuysU2AXFdcu6kwbIgJHWjzXgIc5R8NrrJADLWjJiIqPcvojuSSCqX1suwgVRxN
	 PNlgtnHVSLYeGUmz4Ee1jE0aKrkgl0NUsq634uxjGjuc6DbabVanAXy/CD0ivQyCwa
	 s1kQ5pjwEJcVYNNNdVTP2EcXtiPgPrQyFOEhSDoSrMvGXZ0KaoHK/Jr17LMnE/z0pN
	 /NMnPUDb8hVwg==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54963160818so4156010e87.2
        for <linux-crypto@vger.kernel.org>; Sun, 16 Mar 2025 01:24:51 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz/NjmTIUi+FNExDwr0DeU/veCUwJFo3H8J5Tdo7dOPOl7728yZ
	nHlWWubbfxYFThR6lWmH2gKPcYWVVPn1b3gRlWapBVtpn5uEvWGOlRRYGdjMIilUeP/dL8osE9o
	VdPVa5qB0Lns/yNQliMHi2UhD3cs=
X-Google-Smtp-Source: AGHT+IESuGp3eeqftQ9cswx0GaFYVZRf7IP7jdXpSWkxzrjdew2rhLV51u2f79/YwSHAK5EKXJDfmtIyOPfPSr5V4Uw=
X-Received: by 2002:a05:6512:2394:b0:549:5a9c:93a9 with SMTP id
 2adb3069b0e04-549c39af913mr3149844e87.51.1742113489562; Sun, 16 Mar 2025
 01:24:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250316045747.249992-1-ebiggers@kernel.org>
In-Reply-To: <20250316045747.249992-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Sun, 16 Mar 2025 09:24:38 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGnSxQBjd9qn-6L3vqGZc1ZdtwAzGOnaN3tWmq0qJUp+g@mail.gmail.com>
X-Gm-Features: AQ5f1JrQgIinYO0EkLap2CT5xhHjimHDqgy9SriORHIRQ33etErxeo4wNqTb3E0
Message-ID: <CAMj1kXGnSxQBjd9qn-6L3vqGZc1ZdtwAzGOnaN3tWmq0qJUp+g@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/chacha - remove unused arch-specific init support
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 16 Mar 2025 at 05:57, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> All implementations of chacha_init_arch() just call
> chacha_init_generic(), so it is pointless.  Just delete it, and replace
> chacha_init() with what was previously chacha_init_generic().
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm/crypto/chacha-glue.c                    | 10 ++--------
>  arch/arm64/crypto/chacha-neon-glue.c             | 10 ++--------
>  arch/mips/crypto/chacha-glue.c                   | 10 ++--------
>  arch/powerpc/crypto/chacha-p10-glue.c            | 10 ++--------
>  arch/s390/crypto/chacha-glue.c                   |  8 +-------
>  arch/x86/crypto/chacha_glue.c                    | 10 ++--------
>  crypto/chacha_generic.c                          |  4 ++--
>  include/crypto/chacha.h                          | 11 +----------
>  tools/testing/crypto/chacha20-s390/test-cipher.c |  4 ++--
>  9 files changed, 16 insertions(+), 61 deletions(-)
>
> diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
> index cdde8fd01f8f9..50e635512046e 100644
> --- a/arch/arm/crypto/chacha-glue.c
> +++ b/arch/arm/crypto/chacha-glue.c
> @@ -74,16 +74,10 @@ void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
>                 kernel_neon_end();
>         }
>  }
>  EXPORT_SYMBOL(hchacha_block_arch);
>
> -void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
> -{
> -       chacha_init_generic(state, key, iv);
> -}
> -EXPORT_SYMBOL(chacha_init_arch);
> -
>  void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
>                        int nrounds)
>  {
>         if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon_usable() ||
>             bytes <= CHACHA_BLOCK_SIZE) {
> @@ -114,11 +108,11 @@ static int chacha_stream_xor(struct skcipher_request *req,
>         u32 state[16];
>         int err;
>
>         err = skcipher_walk_virt(&walk, req, false);
>
> -       chacha_init_generic(state, ctx->key, iv);
> +       chacha_init(state, ctx->key, iv);
>
>         while (walk.nbytes > 0) {
>                 unsigned int nbytes = walk.nbytes;
>
>                 if (nbytes < walk.total)
> @@ -164,11 +158,11 @@ static int do_xchacha(struct skcipher_request *req, bool neon)
>         struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
>         struct chacha_ctx subctx;
>         u32 state[16];
>         u8 real_iv[16];
>
> -       chacha_init_generic(state, ctx->key, req->iv);
> +       chacha_init(state, ctx->key, req->iv);
>
>         if (!IS_ENABLED(CONFIG_KERNEL_MODE_NEON) || !neon) {
>                 hchacha_block_arm(state, subctx.key, ctx->nrounds);
>         } else {
>                 kernel_neon_begin();
> diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
> index af2bbca38e70f..229876acfc581 100644
> --- a/arch/arm64/crypto/chacha-neon-glue.c
> +++ b/arch/arm64/crypto/chacha-neon-glue.c
> @@ -72,16 +72,10 @@ void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
>                 kernel_neon_end();
>         }
>  }
>  EXPORT_SYMBOL(hchacha_block_arch);
>
> -void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
> -{
> -       chacha_init_generic(state, key, iv);
> -}
> -EXPORT_SYMBOL(chacha_init_arch);
> -
>  void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
>                        int nrounds)
>  {
>         if (!static_branch_likely(&have_neon) || bytes <= CHACHA_BLOCK_SIZE ||
>             !crypto_simd_usable())
> @@ -108,11 +102,11 @@ static int chacha_neon_stream_xor(struct skcipher_request *req,
>         u32 state[16];
>         int err;
>
>         err = skcipher_walk_virt(&walk, req, false);
>
> -       chacha_init_generic(state, ctx->key, iv);
> +       chacha_init(state, ctx->key, iv);
>
>         while (walk.nbytes > 0) {
>                 unsigned int nbytes = walk.nbytes;
>
>                 if (nbytes < walk.total)
> @@ -149,11 +143,11 @@ static int xchacha_neon(struct skcipher_request *req)
>         struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
>         struct chacha_ctx subctx;
>         u32 state[16];
>         u8 real_iv[16];
>
> -       chacha_init_generic(state, ctx->key, req->iv);
> +       chacha_init(state, ctx->key, req->iv);
>         hchacha_block_arch(state, subctx.key, ctx->nrounds);
>         subctx.nrounds = ctx->nrounds;
>
>         memcpy(&real_iv[0], req->iv + 24, 8);
>         memcpy(&real_iv[8], req->iv + 16, 8);
> diff --git a/arch/mips/crypto/chacha-glue.c b/arch/mips/crypto/chacha-glue.c
> index d1fd23e6ef844..f6fc2e1079a19 100644
> --- a/arch/mips/crypto/chacha-glue.c
> +++ b/arch/mips/crypto/chacha-glue.c
> @@ -18,26 +18,20 @@ asmlinkage void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src,
>  EXPORT_SYMBOL(chacha_crypt_arch);
>
>  asmlinkage void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds);
>  EXPORT_SYMBOL(hchacha_block_arch);
>
> -void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
> -{
> -       chacha_init_generic(state, key, iv);
> -}
> -EXPORT_SYMBOL(chacha_init_arch);
> -
>  static int chacha_mips_stream_xor(struct skcipher_request *req,
>                                   const struct chacha_ctx *ctx, const u8 *iv)
>  {
>         struct skcipher_walk walk;
>         u32 state[16];
>         int err;
>
>         err = skcipher_walk_virt(&walk, req, false);
>
> -       chacha_init_generic(state, ctx->key, iv);
> +       chacha_init(state, ctx->key, iv);
>
>         while (walk.nbytes > 0) {
>                 unsigned int nbytes = walk.nbytes;
>
>                 if (nbytes < walk.total)
> @@ -65,11 +59,11 @@ static int xchacha_mips(struct skcipher_request *req)
>         struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
>         struct chacha_ctx subctx;
>         u32 state[16];
>         u8 real_iv[16];
>
> -       chacha_init_generic(state, ctx->key, req->iv);
> +       chacha_init(state, ctx->key, req->iv);
>
>         hchacha_block(state, subctx.key, ctx->nrounds);
>         subctx.nrounds = ctx->nrounds;
>
>         memcpy(&real_iv[0], req->iv + 24, 8);
> diff --git a/arch/powerpc/crypto/chacha-p10-glue.c b/arch/powerpc/crypto/chacha-p10-glue.c
> index 7c728755852e1..d8796decc1fb7 100644
> --- a/arch/powerpc/crypto/chacha-p10-glue.c
> +++ b/arch/powerpc/crypto/chacha-p10-glue.c
> @@ -55,16 +55,10 @@ void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
>  {
>         hchacha_block_generic(state, stream, nrounds);
>  }
>  EXPORT_SYMBOL(hchacha_block_arch);
>
> -void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
> -{
> -       chacha_init_generic(state, key, iv);
> -}
> -EXPORT_SYMBOL(chacha_init_arch);
> -
>  void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
>                        int nrounds)
>  {
>         if (!static_branch_likely(&have_p10) || bytes <= CHACHA_BLOCK_SIZE ||
>             !crypto_simd_usable())
> @@ -93,11 +87,11 @@ static int chacha_p10_stream_xor(struct skcipher_request *req,
>
>         err = skcipher_walk_virt(&walk, req, false);
>         if (err)
>                 return err;
>
> -       chacha_init_generic(state, ctx->key, iv);
> +       chacha_init(state, ctx->key, iv);
>
>         while (walk.nbytes > 0) {
>                 unsigned int nbytes = walk.nbytes;
>
>                 if (nbytes < walk.total)
> @@ -135,11 +129,11 @@ static int xchacha_p10(struct skcipher_request *req)
>         struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
>         struct chacha_ctx subctx;
>         u32 state[16];
>         u8 real_iv[16];
>
> -       chacha_init_generic(state, ctx->key, req->iv);
> +       chacha_init(state, ctx->key, req->iv);
>         hchacha_block_arch(state, subctx.key, ctx->nrounds);
>         subctx.nrounds = ctx->nrounds;
>
>         memcpy(&real_iv[0], req->iv + 24, 8);
>         memcpy(&real_iv[8], req->iv + 16, 8);
> diff --git a/arch/s390/crypto/chacha-glue.c b/arch/s390/crypto/chacha-glue.c
> index f8b0c52e77a4f..920e9f0941e75 100644
> --- a/arch/s390/crypto/chacha-glue.c
> +++ b/arch/s390/crypto/chacha-glue.c
> @@ -39,11 +39,11 @@ static int chacha20_s390(struct skcipher_request *req)
>         struct skcipher_walk walk;
>         unsigned int nbytes;
>         int rc;
>
>         rc = skcipher_walk_virt(&walk, req, false);
> -       chacha_init_generic(state, ctx->key, req->iv);
> +       chacha_init(state, ctx->key, req->iv);
>
>         while (walk.nbytes > 0) {
>                 nbytes = walk.nbytes;
>                 if (nbytes < walk.total)
>                         nbytes = round_down(nbytes, walk.stride);
> @@ -67,16 +67,10 @@ void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
>         /* TODO: implement hchacha_block_arch() in assembly */
>         hchacha_block_generic(state, stream, nrounds);
>  }
>  EXPORT_SYMBOL(hchacha_block_arch);
>
> -void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
> -{
> -       chacha_init_generic(state, key, iv);
> -}
> -EXPORT_SYMBOL(chacha_init_arch);
> -
>  void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src,
>                        unsigned int bytes, int nrounds)
>  {
>         /* s390 chacha20 implementation has 20 rounds hard-coded,
>          * it cannot handle a block of data or less, but otherwise
> diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
> index 7b3a1cf0984be..8bb74a2728798 100644
> --- a/arch/x86/crypto/chacha_glue.c
> +++ b/arch/x86/crypto/chacha_glue.c
> @@ -131,16 +131,10 @@ void hchacha_block_arch(const u32 *state, u32 *stream, int nrounds)
>                 kernel_fpu_end();
>         }
>  }
>  EXPORT_SYMBOL(hchacha_block_arch);
>
> -void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv)
> -{
> -       chacha_init_generic(state, key, iv);
> -}
> -EXPORT_SYMBOL(chacha_init_arch);
> -
>  void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
>                        int nrounds)
>  {
>         if (!static_branch_likely(&chacha_use_simd) || !crypto_simd_usable() ||
>             bytes <= CHACHA_BLOCK_SIZE)
> @@ -167,11 +161,11 @@ static int chacha_simd_stream_xor(struct skcipher_request *req,
>         struct skcipher_walk walk;
>         int err;
>
>         err = skcipher_walk_virt(&walk, req, false);
>
> -       chacha_init_generic(state, ctx->key, iv);
> +       chacha_init(state, ctx->key, iv);
>
>         while (walk.nbytes > 0) {
>                 unsigned int nbytes = walk.nbytes;
>
>                 if (nbytes < walk.total)
> @@ -209,11 +203,11 @@ static int xchacha_simd(struct skcipher_request *req)
>         struct chacha_ctx *ctx = crypto_skcipher_ctx(tfm);
>         u32 state[CHACHA_STATE_WORDS] __aligned(8);
>         struct chacha_ctx subctx;
>         u8 real_iv[16];
>
> -       chacha_init_generic(state, ctx->key, req->iv);
> +       chacha_init(state, ctx->key, req->iv);
>
>         if (req->cryptlen > CHACHA_BLOCK_SIZE && crypto_simd_usable()) {
>                 kernel_fpu_begin();
>                 hchacha_block_ssse3(state, subctx.key, ctx->nrounds);
>                 kernel_fpu_end();
> diff --git a/crypto/chacha_generic.c b/crypto/chacha_generic.c
> index ba7fcb47f9aa0..1fb9fbd302c6f 100644
> --- a/crypto/chacha_generic.c
> +++ b/crypto/chacha_generic.c
> @@ -19,11 +19,11 @@ static int chacha_stream_xor(struct skcipher_request *req,
>         u32 state[16];
>         int err;
>
>         err = skcipher_walk_virt(&walk, req, false);
>
> -       chacha_init_generic(state, ctx->key, iv);
> +       chacha_init(state, ctx->key, iv);
>
>         while (walk.nbytes > 0) {
>                 unsigned int nbytes = walk.nbytes;
>
>                 if (nbytes < walk.total)
> @@ -52,11 +52,11 @@ static int crypto_xchacha_crypt(struct skcipher_request *req)
>         struct chacha_ctx subctx;
>         u32 state[16];
>         u8 real_iv[16];
>
>         /* Compute the subkey given the original key and first 128 nonce bits */
> -       chacha_init_generic(state, ctx->key, req->iv);
> +       chacha_init(state, ctx->key, req->iv);
>         hchacha_block_generic(state, subctx.key, ctx->nrounds);
>         subctx.nrounds = ctx->nrounds;
>
>         /* Build the real IV */
>         memcpy(&real_iv[0], req->iv + 24, 8); /* stream position */
> diff --git a/include/crypto/chacha.h b/include/crypto/chacha.h
> index 5bae6a55b3337..f8cc073bba41b 100644
> --- a/include/crypto/chacha.h
> +++ b/include/crypto/chacha.h
> @@ -60,12 +60,11 @@ static inline void chacha_init_consts(u32 *state)
>         state[1]  = CHACHA_CONSTANT_ND_3;
>         state[2]  = CHACHA_CONSTANT_2_BY;
>         state[3]  = CHACHA_CONSTANT_TE_K;
>  }
>
> -void chacha_init_arch(u32 *state, const u32 *key, const u8 *iv);
> -static inline void chacha_init_generic(u32 *state, const u32 *key, const u8 *iv)
> +static inline void chacha_init(u32 *state, const u32 *key, const u8 *iv)
>  {
>         chacha_init_consts(state);
>         state[4]  = key[0];
>         state[5]  = key[1];
>         state[6]  = key[2];
> @@ -78,18 +77,10 @@ static inline void chacha_init_generic(u32 *state, const u32 *key, const u8 *iv)
>         state[13] = get_unaligned_le32(iv +  4);
>         state[14] = get_unaligned_le32(iv +  8);
>         state[15] = get_unaligned_le32(iv + 12);
>  }
>
> -static inline void chacha_init(u32 *state, const u32 *key, const u8 *iv)
> -{
> -       if (IS_ENABLED(CONFIG_CRYPTO_ARCH_HAVE_LIB_CHACHA))
> -               chacha_init_arch(state, key, iv);
> -       else
> -               chacha_init_generic(state, key, iv);
> -}
> -
>  void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src,
>                        unsigned int bytes, int nrounds);
>  void chacha_crypt_generic(u32 *state, u8 *dst, const u8 *src,
>                           unsigned int bytes, int nrounds);
>
> diff --git a/tools/testing/crypto/chacha20-s390/test-cipher.c b/tools/testing/crypto/chacha20-s390/test-cipher.c
> index 8141d45df51aa..35ea65c54ffa5 100644
> --- a/tools/testing/crypto/chacha20-s390/test-cipher.c
> +++ b/tools/testing/crypto/chacha20-s390/test-cipher.c
> @@ -64,11 +64,11 @@ static int test_lib_chacha(u8 *revert, u8 *cipher, u8 *plain)
>                 print_hex_dump(KERN_INFO, "iv:  ", DUMP_PREFIX_OFFSET,
>                                16, 1, iv, 16, 1);
>         }
>
>         /* Encrypt */
> -       chacha_init_arch(chacha_state, (u32*)key, iv);
> +       chacha_init(chacha_state, (u32 *)key, iv);
>
>         start = ktime_get_ns();
>         chacha_crypt_arch(chacha_state, cipher, plain, data_size, 20);
>         end = ktime_get_ns();
>
> @@ -79,11 +79,11 @@ static int test_lib_chacha(u8 *revert, u8 *cipher, u8 *plain)
>                                (data_size > 64 ? 64 : data_size), 1);
>
>         pr_info("lib encryption took: %lld nsec", end - start);
>
>         /* Decrypt */
> -       chacha_init_arch(chacha_state, (u32 *)key, iv);
> +       chacha_init(chacha_state, (u32 *)key, iv);
>
>         start = ktime_get_ns();
>         chacha_crypt_arch(chacha_state, revert, cipher, data_size, 20);
>         end = ktime_get_ns();
>
>
> base-commit: d2d072a313c1817a0d72d7b8301eaf29ce7f83fc
> --
> 2.49.0
>
>
