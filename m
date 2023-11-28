Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5654A20F3
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 03:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bXn+gVLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AB4C433C8;
	Tue, 28 Nov 2023 03:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701143792;
	bh=WjCFklQtOqf81uorIGsoppOMkx+RH2HrsqXNbDg296w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bXn+gVLYClewyVh4gauMobUQySkuWPZlNWRXYOqVBZOndYo80wvV+QXyKy7lyRrXR
	 P4x9KxE+Z8BGAKzNtvE0/hUH/xuy7ochY4+j0gjlFgZ2VE/vE279bsx2IAZNTO5DBm
	 t3jCbNSguAnMBfYueuZjUNc8nD2BkCjQXWEtZ1JkjLxSsayyR7ocfEVeLgUVKikHXJ
	 Vsc4X4CjHaWvrzML0PPVbtfvUS0qcqWJalReTbX1zcbdUXv7gZkj4I6amM46ne/rSl
	 XUjxBqTprF5Zbw01ztPhc37bJLmpAsaP1un28ub4bE/jHdgojhy3fr5nJcx57Up0nV
	 1z10T2CiJb9Wg==
Date: Mon, 27 Nov 2023 19:56:30 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	conor.dooley@microchip.com, ardb@kernel.org, heiko@sntech.de,
	phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 04/13] RISC-V: crypto: add Zvkned accelerated AES
 implementation
Message-ID: <20231128035630.GG1463@sol.localdomain>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-5-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127070703.1697-5-jerry.shih@sifive.com>

On Mon, Nov 27, 2023 at 03:06:54PM +0800, Jerry Shih wrote:
> +int riscv64_aes_setkey(struct crypto_aes_ctx *ctx, const u8 *key,
> +		       unsigned int keylen)
> +{
> +	int ret;
> +
> +	ret = aes_check_keylen(keylen);
> +	if (ret < 0)
> +		return -EINVAL;
> +
> +	/*
> +	 * The RISC-V AES vector crypto key expanding doesn't support AES-192.
> +	 * Use the generic software key expanding for that case.
> +	 */
> +	if ((keylen == 16 || keylen == 32) && crypto_simd_usable()) {
> +		/*
> +		 * All zvkned-based functions use encryption expanding keys for both
> +		 * encryption and decryption.
> +		 */
> +		kernel_vector_begin();
> +		rv64i_zvkned_set_encrypt_key(key, keylen, ctx);
> +		kernel_vector_end();
> +	} else {
> +		ret = aes_expandkey(ctx, key, keylen);
> +	}

rv64i_zvkned_set_encrypt_key() does not initialize crypto_aes_ctx::key_dec.
So, decryption results will be incorrect if !crypto_simd_usable() later.

> +static int aes_setkey(struct crypto_tfm *tfm, const u8 *key,
> +		      unsigned int keylen)

It's best to avoid generic-sounding function names like this that could collide
with functions in crypto/ or lib/crypto/.  A better name for this function, for
example, would be aes_setkey_zvkned().

> diff --git a/arch/riscv/crypto/aes-riscv64-zvkned.pl b/arch/riscv/crypto/aes-riscv64-zvkned.pl
> new file mode 100644
> index 000000000000..303e82d9f6f0
> --- /dev/null
> +++ b/arch/riscv/crypto/aes-riscv64-zvkned.pl
[...]
> +L_enc_128:
[...]
> +L_enc_192:
[...]
> +L_enc_256:

There's some severe source code duplication going on in the AES assembly, with
the three AES variants having separate source code.  You can just leave this
as-is since this is what was merged into OpenSSL and we are borrowing that for
now, but I do expect that we'll want to clean this up later.

- Eric
