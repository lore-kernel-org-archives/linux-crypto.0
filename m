Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793043616;
	b=ndg6iW9AP6aVYkF8nQJWwY3c2Lch2ty39pPCH96SHIIqiFaFwJ3Qs1h6/40a6DsljAGR
	 GZcPj2rMVkSsE5ftmFdEkAp5rSQ1qxc2uvTrUgqGQRPaeeZkfXIxPM8v+vkVn0RjOTVgT
	 pD4QMXy5XAG/Uw4FQt517eAQIHsUVdC/dzHzflynSw/SMWVWtscXpH2VRyEj9qAzzY3yp
	 0t+4cQz5jdRoCmfz7zFDZDm28f+2ILK4AuYcsuDGgUeXwtmfpK+OpS6Sba/S7OqgZybUX
	 236nS8R5fOeSNltQ7eNEjNDAHBwKleqrkGgF3pWcz2Msd/9+jF5V0mYI/s7H0nGpHkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793043616;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5zeSAVyul8PribcuBt1yupgPNfcXDczgj3KI8imKVjY=;
	b=eWNU1YzTztBF5HrycdBDyg2ZsUlmX1YeDF8gRvjPe+MfNJ0Be1hKloiLBtuULkzIOwKb
	 Xp0qBlZyXlEAuXXvNYZQKFqnxeWQnfw8LYkE+EXoxclPAJYpypLXWwKBemlR/TXgPyn1A
	 TYEmiMKDgn5Ufk5N3jW9HFbnpZzO9reiN15DNUSta6WMXP2Q4O/BnWytmHvMd1hK3TUIu
	 zKNNboocY+0o+0HUcoXa3ZJWalGPlTWgBp2WVPe3GZMZFe6SQz2IwbNRe302/liAUyjWr
	 I0zMu0ZVZSnNn5rW5CwPH92U/NvoOJOolLdO90pM6jLJj1B9jSSFW5q8K+kVhfhX9Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ecH0GVtd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 8F639606A329
	for <linux-crypto@vger.kernel.org>; Mon, 26 Oct 2026 19:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ecH0GVtd
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DD6881F01825;
	Mon, 26 Oct 2026 19:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793043616;
	bh=5zeSAVyul8PribcuBt1yupgPNfcXDczgj3KI8imKVjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ecH0GVtdfEmlUEp2Gs0nsfnDvNJHNJAntBbCMOzMyN62Z2w/5jUEVmPs4vSoh3ogr
	 EiRScIn5DCqvby7STCsv2nRAXFCCIY5voBBNmFnoBghwaJL+Dk1i637QSvtG1tAlAS
	 A7ZVzLA1SlKDIvjfkhGO4gHmo4tqITu0ZmfoB8sl7uG8gWqaVZLN0dFTrHaeV1lNGn
	 iOVhLjdCk7KWGxlzh27wxPpAUNAbmExUn7BIhiBh+fUcq8SF4f2ss4bAJ34142IJLW
	 9/gBdKfT9h8oeFt7Ee3XqeWMJpv4s7Skw2ZgUox2jd5g2ZrkPRTZ8GHCu9CBFbzUMR
	 UZsCXRrzXhY1g==
Date: Mon, 26 Oct 2026 21:40:12 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: stdrng - Mitigate FIPS RNG failures
Message-ID: <at-snHAJ69YzcMTc@kernel.org>
References: <20261026183332.11402-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026183332.11402-1-ebiggers@kernel.org>

On Mon, Oct 26, 2026 at 11:33:32AM -0700, Eric Biggers wrote:
> If the kernel is booted with fips=1 and jitterentropy fails its health
> check, crypto_stdrng_get_bytes() can return an error and leave its
> output buffer uninitialized.
> 
> While the fallibility of the FIPS RNG is by design, leaving the output
> buffer uninitialized lacks practical defense-in-depth, as callers can
> forget to check the error code.  For example, the TPM2 driver didn't
> check the error code from ECDH private key generation
> (https://lore.kernel.org/r/20261025211119.138277-1-ebiggers@kernel.org/).
> Thus, fips=1 mode (ironically) caused a vulnerability.
> 
> Mitigate such bugs by filling the buffer with get_random_bytes_wait() in
> case of failure.  This helps in practice.  (For FIPS certifiability it
> makes no difference, as no "approved" entropy is claimed on failure.)
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Agree with the "practical DoD" part.

> ---
> 
> This applies on top of
> https://lore.kernel.org/linux-crypto/20261018204618.104876-1-ebiggers@kernel.org/
> 
>  crypto/drbg.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index faa39045bdc6b..f3fed6ded5b5f 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -561,10 +561,20 @@ int __crypto_stdrng_get_bytes(void *buf, size_t len)
>  
>  	err = crypto_get_default_rng();
>  	if (err)
> -		return err;
> +		goto out;
>  
>  	err = crypto_drbg_get_bytes(crypto_default_rng, buf, len, NULL, 0);
>  	crypto_put_default_rng();
> +
> +out:
> +	/*
> +	 * On failure, fill the buffer using the normal Linux RNG rather than
> +	 * leave it uninitialized.  This provides practical defense-in-depth for
> +	 * callers that forget to check the error code.  (It makes no difference
> +	 * for FIPS certifications; no entropy is claimed on failure anyway.)
> +	 */
> +	if (err)
> +		get_random_bytes_wait(buf, len);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(__crypto_stdrng_get_bytes);
> 
> base-commit: 666d66df25253070cb297cb920b0bcfcfe5eb871
> prerequisite-patch-id: 4c318ab271fa6443e9fe0ac47537515cc2dc6999
> prerequisite-patch-id: 5992995f4dea89d9332b0e33ca1248e3dd672bd8
> prerequisite-patch-id: c38f29a49c34d0fdfdc8466fd64c3d69fb4f0626
> prerequisite-patch-id: 424590a4282a04c94a095d4f059ac0d3a8af44b1
> prerequisite-patch-id: b5e762e41f7f6a68e70f6540ab07ff2a23ae6880
> prerequisite-patch-id: bc08a9f0be6e4f1e25c0e6ab0881f39df60aa632
> prerequisite-patch-id: 487bd5a23a597d190e2794e178266fcb6fc92849
> prerequisite-patch-id: 3c6f92ab77fee4702702f8760514a1bb55a409cb
> prerequisite-patch-id: 1536028517d2aa0bcbc4ec601c18cd8cf5f7d0ad
> prerequisite-patch-id: cb214555f3c44cf2a2e610adfbf60311a3647aa5
> prerequisite-patch-id: cc0998aae8d75e7b09562f8623c132bc21e77a2b
> prerequisite-patch-id: 351a1bcfe1ac87d42c5aa46b867f291aba49caa0
> prerequisite-patch-id: f71bbeee6d6644ca1b464e22f4df891bab45680f
> prerequisite-patch-id: 2f726ebd0df8d5a420cf4a870e0b6973248bf6be
> -- 
> 2.56.0
> 


Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

Br, Jarkko
