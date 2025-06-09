Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7C71CF7AF
	for <linux-crypto@vger.kernel.org>; Mon,  9 Jun 2025 20:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749500009; cv=none; b=eIPY1AT+ouo8ipXvVcm7iZCK45clX3UN546tzEC2motXkFQjXZRWSUp2lZAcBX8oenIPucuxQs16kgUWy/ob/cpzV0xI2CxfwSZqsP7Xkw0SdwyJ0XrdkgKKemrjtBf92AckV2wf4d+yIFElemgl4Uig8F0tg77xYpPHw3WRf+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749500009; c=relaxed/simple;
	bh=Us2N/NCViJOTrbWcEGQmIkQWyzzEmf6mDW8hu15e8a8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pk24uDWIvF0QIC0vuRipQUg48/PYJi7XAB5lI0GMFYwb7LQB55br+T84UBUy2oM1EYVO47mkHnnJ3WaB5oKrcTbeKyBoSBcvaii79ynYzgw+jHM4uNBwsS4Vz9qHzI89kIhfjzmwMWbEtyrtCWICdIRBUV6cW7rlF77j9dlydco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBHudaaA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBHudaaA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FE1C4CEEF;
	Mon,  9 Jun 2025 20:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749500008;
	bh=Us2N/NCViJOTrbWcEGQmIkQWyzzEmf6mDW8hu15e8a8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mBHudaaA4FyOfGmwQqHtLG8mku9PBc/04nNV5565X0ECQOc6/j3+GtYTm0h5ay5r8
	 4jAHuJe0gk/ISOvQXzdHK/jxbyUkzJ8dOr9b5k7LiNtc4RSSP2HrkgZf4yvoUUxn4L
	 ksBPGzIjOGhje3qjTKwjtnzFK33r8FWf1Z45ze9VrZpVko2E95tCO7qUg1FVhx9vZR
	 CWvd8/sMzP5CXS1csIjR5bSlBvPkaPlbWF1H7KJ8kWstmlVGoUAtVvTj6nvmMEr0nF
	 IZSK9K5i7ejbuKqzyeNXcGa/QBE6hUr1ApP/gqGNdGYgbeqb32OIkHjASCSMYebRas
	 Ns84xPQ5yqd6A==
Date: Mon, 9 Jun 2025 13:13:06 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org,
	herbert@gondor.apana.org.au, paul.walmsley@sifive.com,
	alex@ghiti.fr, appro@cryptogams.org, zhang.lyra@gmail.com
Subject: Re: [PATCH v3] crypto: riscv/poly1305 - import OpenSSL/CRYPTOGAMS
 implementation
Message-ID: <20250609201306.GD1255@sol>
References: <20250609074655.203572-3-zhihang.shao.iscas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609074655.203572-3-zhihang.shao.iscas@gmail.com>

On Mon, Jun 09, 2025 at 03:46:57PM +0800, Zhihang Shao wrote:
> From: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> 
> This is a straight import of the OpenSSL/CRYPTOGAMS Poly1305
> implementation for riscv authored by Andy Polyakov.
> The file 'poly1305-riscv.pl' is taken straight from this upstream
> GitHub repository [0] at commit 33fe84bc21219a16825459b37c825bf4580a0a7b,
> and this commit fixed a bug in riscv 64bit implementation.
> 
> [0] https://github.com/dot-asm/cryptogams

There are a couple minor differences between the CRYPTOGAMS file and the one in
this patch.  Please make sure those are documented.

> +config CRYPTO_POLY1305_RISCV
> +	tristate
> +	default CRYPTO_LIB_POLY1305
> +    select CRYPTO_ARCH_HAVE_LIB_POLY1305

Fix the indentation here.

> +void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
> +			  unsigned int len, u32 padbit)
> +{
> +	len = round_down(len, POLY1305_BLOCK_SIZE);
> +	poly1305_blocks(state, src, len, 1);
> +}
> +EXPORT_SYMBOL_GPL(poly1305_blocks_arch);

This is ignoring the padbit and forcing it to 1, so this will compute the wrong
Poly1305 value for messages with length not a multiple of 16 bytes.

chacha20poly1305-selftest still passes, so it must not test this case.  We need
to add a self-test for Poly1305 directly, ideally using KUnit.

- Eric
