Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7761563CB
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 04:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730261759; cv=none; b=UcXejuE3hiK5kw9Vcjrp51RC54MR3NfsZTUVZug8Ac1j67jwmQqeJ3UrWGWKNkszBTEFx0BxheO2o+z9QJlHIhCrJtOslOkTdN17VGnSO0KiNowIZ+2mT8IK//saGR144t2p52GtHqVVumm94eQNNJiD4qfSE/epFbRyjq5g/9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730261759; c=relaxed/simple;
	bh=o4QMNINshMdeE54Ikmn/fVeslMwC6VMHBKeT0bsQGQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L5AVKt+1WHbcXGRK2W/v3XIo6PUWc1Gc0RWkWPVOhEaNf4R7lfiwDExiqn1g6jR1KEn2xcIdt6GT8PIEDQBvOhRmWxR8gFGWwtUygOOy3lZtXjKd48D8G0279hPjXaRS2UHUaVDZ6Jc2HMcIKBCAkxlCWfnAEgEm5Sb8dAoTkec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UrT04Qnj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UrT04Qnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C33C4CEC7;
	Wed, 30 Oct 2024 04:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730261758;
	bh=o4QMNINshMdeE54Ikmn/fVeslMwC6VMHBKeT0bsQGQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UrT04QnjqJdWe6taNkLHz5sNSOMujexhTn9lrkSvnhsF6R8TI9GMu2VY9M67YaTOu
	 jBgY63OMgmEX9eh7gJylEdWF/gtuEs2jGOdt/zLmsMwb7I9e7bkbKVwk73wCgB9RhP
	 AJuXyz/XMDhhEop/5cQuVtaCJpbwG1jRBBZqWlbGersh/HLGCpI3AX/N/ESsPLEoqI
	 43itpkwhBUM0dilJSLg455zH68bHSlRYhL831nRPNPjqCMUz37TzMcX5+ADrfKB4ur
	 xs0dB3j5hX+8y3CKZlEbzDYbhaYE1xYenJdOdYBLhohQ2XsnwbfzCm+bbEDeXhUZO/
	 rc4bhJCb1vEXQ==
Date: Tue, 29 Oct 2024 21:15:57 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, keescook@chromium.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 3/6] crypto: arm64/crct10dif - Remove remaining 64x64
 PMULL fallback code
Message-ID: <20241030041557.GC1489@sol.localdomain>
References: <20241028190207.1394367-8-ardb+git@google.com>
 <20241028190207.1394367-11-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241028190207.1394367-11-ardb+git@google.com>

On Mon, Oct 28, 2024 at 08:02:11PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> The only remaining user of the fallback implementation of 64x64
> polynomial multiplication using 8x8 PMULL instructions is the final
> reduction from a 16 byte vector to a 16-bit CRC.
> 
> The fallback code is complicated and messy, and this reduction has very
> little impact on the overall performance, so instead, let's calculate
> the final CRC by passing the 16 byte vector to the generic CRC-T10DIF
> implementation.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/crct10dif-ce-core.S | 237 +++++---------------
>  arch/arm64/crypto/crct10dif-ce-glue.c |  15 +-
>  2 files changed, 64 insertions(+), 188 deletions(-)

For CRCs of short messages, doing a fast reduction from 128 bits can be quite
important.  But I agree that when only a 8x8 => 16 carryless multiplication is
available, it can't really be optimized, and just falling back to the generic
implementation is the right approach in that case.

> diff --git a/arch/arm64/crypto/crct10dif-ce-core.S b/arch/arm64/crypto/crct10dif-ce-core.S
> index 8d99ccf61f16..1db5d1d1e2b7 100644
[...]
>  	ad		.req	v14
> -
> -	k00_16		.req	v15
> -	k32_48		.req	v16
> +	bd		.req	v15
>  
>  	t3		.req	v17
>  	t4		.req	v18
> @@ -91,117 +89,7 @@
>  	t8		.req	v22
>  	t9		.req	v23

ad, bd, and t9 are no longer used.

> +	// Use Barrett reduction to compute the final CRC value.
> +	pmull2		v1.1q, v1.2d, fold_consts.2d	// high 32 bits * floor(x^48 / G(x))

v0.2d was accidentally replaced with v1.2d above, which is causing a self-test
failure in crct10dif-arm64-ce.

Otherwise this patch looks good; thanks!

- Eric
