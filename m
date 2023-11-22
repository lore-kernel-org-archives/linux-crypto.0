Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257814409
	for <linux-crypto@vger.kernel.org>; Wed, 22 Nov 2023 01:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QvdIFPLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076F8C433C8;
	Wed, 22 Nov 2023 01:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700617338;
	bh=BNdihuo6rMnCzk1/H6PiwRe9wn5OD68XRMeNziQ7hKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QvdIFPLM2XOIWcKAqJ/k3h+HTLKJW8KwrJsH1YD42WUtYML5oTfWjgYZcPZqhktiL
	 ObmedCPih8bwLUhsNhT7IswXr4Fi3AlH4ekgn5ym+RCQpj9W5CAxJxkRevjyowspz/
	 UgIBvI6egKKR6JWAUHeAKI09Zs4LeZ/R7SNXL1Qqxy38Fa2/18SzxWYHl082RI+fUq
	 SdiZelsghStv/d3IlXC40lRpsGVtOI+baigtMua9K2aTokV6OMkzfxM+TR0Y4NfBc7
	 LD3+QEnTT4w5zzmG0kciJ+1V688wsVUUFYhZvstXKPYpxNBp6MA7wPfj9iqp9BN0Sy
	 20wWeFKRPGiaA==
Date: Tue, 21 Nov 2023 17:42:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	andy.chiu@sifive.com, greentime.hu@sifive.com,
	conor.dooley@microchip.com, guoren@kernel.org, bjorn@rivosinc.com,
	heiko@sntech.de, ardb@kernel.org, phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 07/12] RISC-V: crypto: add Zvkg accelerated GCM GHASH
 implementation
Message-ID: <20231122014216.GI2172@sol.localdomain>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-8-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025183644.8735-8-jerry.shih@sifive.com>

On Thu, Oct 26, 2023 at 02:36:39AM +0800, Jerry Shih wrote:
> +struct riscv64_ghash_context {
> +	be128 key;
> +};
> +
> +struct riscv64_ghash_desc_ctx {
> +	be128 shash;
> +	u8 buffer[GHASH_BLOCK_SIZE];
> +	u32 bytes;
> +};

I recommend calling the first struct 'riscv64_ghash_tfm_ctx', and making the
pointers to it be named 'tctx'.  That would more clearly distinguish it from the
desc_ctx / dctx.

> +
> +typedef void (*ghash_func)(be128 *Xi, const be128 *H, const u8 *inp,
> +			   size_t len);
> +
> +static inline void ghash_blocks(const struct riscv64_ghash_context *ctx,
> +				struct riscv64_ghash_desc_ctx *dctx,
> +				const u8 *src, size_t srclen, ghash_func func)
> +	if (crypto_simd_usable()) {
> +		kernel_vector_begin();
> +		func(&dctx->shash, &ctx->key, src, srclen);
> +		kernel_vector_end();

The indirection to ghash_func is unnecessary, since the only value is
gcm_ghash_rv64i_zvkg.

This also means that ghash_update() should be folded into ghash_update_zvkg(),
and ghash_final() into ghash_final_zvkg().

> +	} else {
> +		while (srclen >= GHASH_BLOCK_SIZE) {
> +			crypto_xor((u8 *)&dctx->shash, src, GHASH_BLOCK_SIZE);
> +			gf128mul_lle(&dctx->shash, &ctx->key);
> +			srclen -= GHASH_BLOCK_SIZE;
> +			src += GHASH_BLOCK_SIZE;
> +		}
> +	}

The assembly code uses the equivalent of the following do-while loop instead:

        do {
                srclen -= GHASH_BLOCK_SIZE;
        } while (srclen);

I.e., it assumes the length here is nonzero and a multiple of 16, which it is.

To avoid confusion, I recommend making the C code use the same do-while loop.


>        const struct riscv64_ghash_context *ctx =
>               crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));

crypto_tfm_ctx(crypto_shash_tfm(tfm)) should be crypto_shash_ctx(tfm)

> +static int ghash_final(struct shash_desc *desc, u8 *out, ghash_func func)
> +{
> +	const struct riscv64_ghash_context *ctx =
> +		crypto_tfm_ctx(crypto_shash_tfm(desc->tfm));
> +	struct riscv64_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
> +	int i;
> +
> +	if (dctx->bytes) {
> +		for (i = dctx->bytes; i < GHASH_BLOCK_SIZE; i++)
> +			dctx->buffer[i] = 0;
> +
> +		ghash_blocks(ctx, dctx, dctx->buffer, GHASH_BLOCK_SIZE, func);
> +		dctx->bytes = 0;
> +	}
> +

Setting dctx->bytes above is unnecessary.

> +static int ghash_init(struct shash_desc *desc)
> +{
> +	struct riscv64_ghash_desc_ctx *dctx = shash_desc_ctx(desc);
> +
> +	*dctx = (struct riscv64_ghash_desc_ctx){};
> +
> +	return 0;
> +}
> +
> +static int ghash_update_zvkg(struct shash_desc *desc, const u8 *src,
> +			     unsigned int srclen)
> +{
> +	return ghash_update(desc, src, srclen, gcm_ghash_rv64i_zvkg);
> +}
> +
> +static int ghash_final_zvkg(struct shash_desc *desc, u8 *out)
> +{
> +	return ghash_final(desc, out, gcm_ghash_rv64i_zvkg);
> +}
> +
> +static int ghash_setkey(struct crypto_shash *tfm, const u8 *key,
> +			unsigned int keylen)
> +{
> +	struct riscv64_ghash_context *ctx =
> +		crypto_tfm_ctx(crypto_shash_tfm(tfm));
> +
> +	if (keylen != GHASH_BLOCK_SIZE)
> +		return -EINVAL;
> +
> +	memcpy(&ctx->key, key, GHASH_BLOCK_SIZE);
> +
> +	return 0;
> +}
> +
> +static struct shash_alg riscv64_ghash_alg_zvkg = {
> +	.digestsize = GHASH_DIGEST_SIZE,
> +	.init = ghash_init,
> +	.update = ghash_update_zvkg,
> +	.final = ghash_final_zvkg,
> +	.setkey = ghash_setkey,

IMO it's helpful to order the shash functions as follows, both in their
definitions and their fields in struct shash_alg:

    setkey
    init
    update
    final

That matches the order in which they're called.

- Eric
