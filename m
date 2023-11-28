Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1776679FF
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 04:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UgG2OmKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FF1C433C8;
	Tue, 28 Nov 2023 04:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701145505;
	bh=393VLQEt4vyW6mXZn3SVeUaSptJZ9Z0HCv/6wrn7U2Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UgG2OmKRc5L3umGA0uU9/vhqiiWipuXcQGdSaRnR+puCrVVUEC51wtFrssi0XAK9W
	 1bRAhEun1WNkQ9xm5nTJ15vVcrcE1e5qh9blYfTrGiIeScvg5jU6TuNUjnv63Zx1Uv
	 rncPG5OqHI3hvL1nT+mJGiMpH79zyAl7PSgjPX3qBzVEKXBksyk0jYPOnaKObP7gwF
	 oPeauCSQYZqFW27/49jwsSwjqgvhnpRd+vPDCjHHW12QkU3zJF+fFSkSCkpbRYZUR0
	 aAjx54Ryy27Fmniq9u9DBrDyUFTa7R+Dpv72zMv/0XnbR/zZCJuUGBtu53m5LaR8/W
	 pYHN2UlnN+/dA==
Date: Mon, 27 Nov 2023 20:25:03 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	conor.dooley@microchip.com, ardb@kernel.org, heiko@sntech.de,
	phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 13/13] RISC-V: crypto: add Zvkb accelerated ChaCha20
 implementation
Message-ID: <20231128042503.GL1463@sol.localdomain>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-14-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127070703.1697-14-jerry.shih@sifive.com>

On Mon, Nov 27, 2023 at 03:07:03PM +0800, Jerry Shih wrote:
> +config CRYPTO_CHACHA20_RISCV64

Can you call this kconfig option just CRYPTO_CHACHA_RISCV64?  I.e. drop the
"20".  The ChaCha family of ciphers includes more than just ChaCha20.

The other architectures do use "CHACHA20" in their equivalent option, even when
they implement XChaCha12 too.  But that's for historical reasons -- we didn't
want to break anything by renaming the kconfig options.  For a new option we
should use the more general name from the beginning, even if initially only
ChaCha20 is implemented (which is fine).

> +static int chacha20_encrypt(struct skcipher_request *req)

riscv64_chacha_crypt(), please.  chacha20_encrypt() is dangerously close to
being the same name as chacha20_crypt() which already exists in crypto/chacha.h.

> +static inline bool check_chacha20_ext(void)
> +{
> +	return riscv_isa_extension_available(NULL, ZVKB) &&
> +	       riscv_vector_vlen() >= 128;
> +}

Just to double check: your intent is to simply require VLEN >= 128 for all the
RISC-V vector crypto code, even when some might work with a shorter VLEN?  I
don't see anything in chacha-riscv64-zvkb.pl that assumes VLEN >= 128, for
example.  I think it would even work with VLEN == 32.

I think requiring VLEN >= 128 anyway makes sense so that we don't have to worry
about validating the code with shorter VLEN.  And "application processors" are
supposed to have VLEN >= 128.  But I just wanted to make sure this is what you
intended too.

- Eric
