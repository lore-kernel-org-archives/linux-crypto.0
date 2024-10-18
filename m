Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB231917EE;
	Fri, 18 Oct 2024 23:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729295780; cv=none; b=MXGPL8vbQq7nIWjMsbm1mLhTT2jUKrdBv/FlHF86+mSLT9c57LWTxinzQG8t+iTzSQWRwAZ1Gt5nKnl6vGdpYfAmaI7YS0ljYi68i8WOGrCJ9ZC+01BFCClv3hSFvnIpSvkqtjG/0tNbzJUn8tUFArZ1QQT+MENfStxKDW4xbtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729295780; c=relaxed/simple;
	bh=T+fck0FKE7KEsi6QVW88MImDd340gpAGDdrA780Mp+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pFOyzF+Oimkp3BbK/puojJIl0RmC1jO0+eJ2aj3s1ggpV0aMtV4uY8R5wNN1wv+dD2b/CIf4SRv/r4kUNYYx28QygcH71V0YquMmgimxNg3/QBXtgFzZzcmSUL9TqnWu5MeEKDJM9WayHU7IgPfrNC08H99QfotXWRu0WK3BGO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9UGa620; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9UGa620"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013AEC4CEC3;
	Fri, 18 Oct 2024 23:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729295780;
	bh=T+fck0FKE7KEsi6QVW88MImDd340gpAGDdrA780Mp+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S9UGa620VSwNCDAaA9nRPPBBCFnlXXzqehxpGzXt4J7hiWp0fUhOxOjXMPJtcsEkJ
	 6JbiuZtXv/nUeo9New77lOgv1o1uWW2GQXwA1wW0PK24DYlzKyFqWj57+HOkFBrRi/
	 PE6yKEfifMu/T/LGopqT3/AOcPOTL2hiJedsr2MdMlLPlWgo/GCxTeKUkl9/xLD3vZ
	 Q5CEHgfzvB6FM2gvKjuoeZSieUomwWCC6ZO//EN/bFPzaetzfplfxA516ScH9qbf1r
	 pvkxX/OJLiziFZOIHBTzo+eLgYdLk8KyROU6oyhNsVy3vzEbuBXXrCq9V5LbIRrtuE
	 VNfZTihGI5+FA==
Date: Fri, 18 Oct 2024 16:56:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	will@kernel.org, catalin.marinas@arm.com,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v4 3/3] arm64/crc32: Implement 4-way interleave using
 PMULL
Message-ID: <20241018235618.GB2589@sol.localdomain>
References: <20241018075347.2821102-5-ardb+git@google.com>
 <20241018075347.2821102-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018075347.2821102-8-ardb+git@google.com>

On Fri, Oct 18, 2024 at 09:53:51AM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Now that kernel mode NEON no longer disables preemption, using FP/SIMD
> in library code which is not obviously part of the crypto subsystem is
> no longer problematic, as it will no longer incur unexpected latencies.
> 
> So accelerate the CRC-32 library code on arm64 to use a 4-way
> interleave, using PMULL instructions to implement the folding.
> 
> On Apple M2, this results in a speedup of 2 - 2.8x when using input
> sizes of 1k - 8k. For smaller sizes, the overhead of preserving and
> restoring the FP/SIMD register file may not be worth it, so 1k is used
> as a threshold for choosing this code path.
> 
> The coefficient tables were generated using code provided by Eric. [0]
> 
> [0] https://github.com/ebiggers/libdeflate/blob/master/scripts/gen_crc32_multipliers.c
> 
> Cc: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/lib/crc32-glue.c |  48 ++++
>  arch/arm64/lib/crc32.S      | 231 +++++++++++++++++++-
>  2 files changed, 276 insertions(+), 3 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

> +	if (len >= min_len && cpu_have_named_feature(PMULL) && crypto_simd_usable()) {

Using crypto_simd_usable() here causes a build error when CRYPTO_ALGAPI2=m.
https://lore.kernel.org/linux-crypto/20241018235343.425758-1-ebiggers@kernel.org
will fix that.

- Eric
