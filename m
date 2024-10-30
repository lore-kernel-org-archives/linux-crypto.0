Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1103D6B
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 04:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730260914; cv=none; b=quSh4PUqQr4FDjEjb9VHoC6UYm6hf037sVlQZD9JAkchsvj0sjZxqcoiGxDXXPZBndL9FCaEn00uA3oTRPFiwGgOIXaBw+FjjP+xVsYt+SuU0AlYZp9tQ4p0l1vYuHPt5CAEPciXDNc/RQVpqZj7ayg96sxnib/1oYEgZo1Y7/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730260914; c=relaxed/simple;
	bh=uVky3tQI3j+KiXifNE+KmZt4WDI0UX160uUiPA8t9Rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GIceoEqwbqPfBflJARChnf9sEnba23lhSoPW3ok57tcU751JTp1udjujZfGwEgZ3Ko4PBtOHmUtSKAnHw1F6/BZkrFXbZ+aV9zXQIDzTOors5bmLAFBAnvtnUTVB346AhqXJlj+WSlYq8Ofp2jkNGsGf5t+5AojwAl2UdcUD/tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kj+bYJy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kj+bYJy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3371C4CEC7;
	Wed, 30 Oct 2024 04:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730260914;
	bh=uVky3tQI3j+KiXifNE+KmZt4WDI0UX160uUiPA8t9Rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kj+bYJy3boFJiIhoSSDCdm7Fh/Uo4Uc/lAObeG/rX0l5fmVxKpC7LZDiUcj2NqsQR
	 Jz6ULUohdpw28HpHKUDO1m9/PVT58nUrghkL9J7GuUrepIAfNlSHPTtAQSnoHokHx9
	 cmPiJH7EVwhJquE6qbzt+mwThkd4sz2TmVbUYT6d2YbCpmUFvn4uA/KdKFtEMZtuBt
	 ZH9CdhioJ/bpkgtWla66teyic0VHCYnidSX8N79EsB20tlPzS8gShKSnZjTVRjzn/l
	 uQq4Zy96n4KkoveHP22dfHNy6ILQ9Vic/6S70HqKS1ojHnYCUzbwxg6C31W8RFuzrO
	 V9epqklXdPa1A==
Date: Tue, 29 Oct 2024 21:01:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, keescook@chromium.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 2/6] crypto: arm64/crct10dif - Use faster 16x64 bit
 polynomial multiply
Message-ID: <20241030040152.GB1489@sol.localdomain>
References: <20241028190207.1394367-8-ardb+git@google.com>
 <20241028190207.1394367-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028190207.1394367-10-ardb+git@google.com>

On Mon, Oct 28, 2024 at 08:02:10PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The CRC-T10DIF implementation for arm64 has a version that uses 8x8
> polynomial multiplication, for cores that lack the crypto extensions,
> which cover the 64x64 polynomial multiplication instruction that the
> algorithm was built around.
> 
> This fallback version rather naively adopted the 64x64 polynomial
> multiplication algorithm that I ported from ARM for the GHASH driver,
> which needs 8 PMULL8 instructions to implement one PMULL64. This is
> reasonable, given that each 8-bit vector element needs to be multiplied
> with each element in the other vector, producing 8 vectors with partial
> results that need to be combined to yield the correct result.
> 
> However, most PMULL64 invocations in the CRC-T10DIF code involve
> multiplication by a pair of 16-bit folding coefficients, and so all the
> partial results from higher order bytes will be zero, and there is no
> need to calculate them to begin with.
> 
> Then, the CRC-T10DIF algorithm always XORs the output values of the
> PMULL64 instructions being issued in pairs, and so there is no need to
> faithfully implement each individual PMULL64 instruction, as long as
> XORing the results pairwise produces the expected result.
> 
> Implementing these improvements results in a speedup of 3.3x on low-end
> platforms such as Raspberry Pi 4 (Cortex-A72)
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/crct10dif-ce-core.S | 71 +++++++++++++++-----
>  1 file changed, 54 insertions(+), 17 deletions(-)

Thanks, this makes sense.

> +SYM_FUNC_START_LOCAL(__pmull_p8_16x64)
> +	ext		t6.16b, t5.16b, t5.16b, #8
> +
> +	pmull		t3.8h, t7.8b, t5.8b
> +	pmull		t4.8h, t7.8b, t6.8b
> +	pmull2		t5.8h, t7.16b, t5.16b
> +	pmull2		t6.8h, t7.16b, t6.16b
> +
> +	ext		t8.16b, t3.16b, t3.16b, #8
> +	eor		t4.16b, t4.16b, t6.16b
> +	ext		t7.16b, t5.16b, t5.16b, #8
> +	ext		t6.16b, t4.16b, t4.16b, #8
> +	eor		t8.8b, t8.8b, t3.8b
> +	eor		t5.8b, t5.8b, t7.8b
> +	eor		t4.8b, t4.8b, t6.8b
> +	ext		t5.16b, t5.16b, t5.16b, #14
> +	ret
> +SYM_FUNC_END(__pmull_p8_16x64)

A few comments in the above function would be really helpful.

- Eric
