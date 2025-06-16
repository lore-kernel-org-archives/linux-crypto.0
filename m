Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65ED29408
	for <linux-crypto@vger.kernel.org>; Mon, 16 Jun 2025 01:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750037006; cv=none; b=QWCM3NPQW953YA/eNwac7lkaRJGRcqUGn8EKog29+s842Opg3epbbOrIML6ht0LIg71hlYTygqlY1B5IIkL9dobJIqQ42mu+e9jFSAgm0oIThD2Nq15q1Ow9dnZHbfcT55NSsBnZ19Bw3Vb6n2FQwKDwqz3WO95egZ8218gYf1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750037006; c=relaxed/simple;
	bh=G1pV7btLJSiQL1M1/mWU2jPJQ5xuPsXav5hm0rdP7rE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZrvaYcFcAAuqGjkxUdCztWHBZkhOe3GGSFvR+eYfhrR2Zc+NZ8aMhF0+U5QDbcjTrxAUTN0J6I1dG4swys0gf0AWB7EVHO9snzelSR1P0rZZ46wGpgqag27WqRKU/mL2R3dGp9fsfvcWCdb1z5CPl4o5Sdp3YgsJIJ5Og0kan9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TJHnasiA; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TJHnasiA"
Date: Sun, 15 Jun 2025 21:23:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750036995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gz+GUsAUy8ZmZMfWIFNxOOMGCIQ1fx8CdVDZ+HKxXIM=;
	b=TJHnasiAJbvnyH8es6MgCm2OMRASqzF9CUJ8HgIT1sEjp6rYfaL338ev5rAG2E2HziQ3YI
	z9Sl5aZUi/vXZ48WAWehXNg4Mfe2Vm7OJyKbq6YL4Xa2ngWpgyLURJ10WWVmnpjBOEBojR
	J2ERRChEzKb2iW9sm8AGiNFKnlEiOHo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, "Jason A . Donenfeld " <Jason@zx2c4.com>, 
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] lib/crypto/poly1305: Fix arm64's poly1305_blocks_arch()
Message-ID: <zjzuypgma6p5dme5dh4iyh6a3km6qhsydelubdf2jvbsykyywf@4incsw36xqxh>
References: <20250616010654.367302-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616010654.367302-1-ebiggers@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Sun, Jun 15, 2025 at 06:06:54PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> For some reason arm64's Poly1305 code got changed to ignore the padbit
> argument.  As a result, the output is incorrect when the message length
> is not a multiple of 16 (which is not reached with the standard
> ChaCha20Poly1305, but bcachefs could reach this).  Fix this.
> 
> Fixes: a59e5468a921 ("crypto: arm64/poly1305 - Add block-only interface")
> Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks for the quick fix :)

Tested-by: Kent Overstreet <kent.overstreet@linux.dev>

> ---
>  arch/arm64/lib/crypto/poly1305-glue.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/lib/crypto/poly1305-glue.c b/arch/arm64/lib/crypto/poly1305-glue.c
> index 6a661cf048213..c9a74766785bd 100644
> --- a/arch/arm64/lib/crypto/poly1305-glue.c
> +++ b/arch/arm64/lib/crypto/poly1305-glue.c
> @@ -36,18 +36,18 @@ void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
>  	if (static_branch_likely(&have_neon)) {
>  		do {
>  			unsigned int todo = min_t(unsigned int, len, SZ_4K);
>  
>  			kernel_neon_begin();
> -			poly1305_blocks_neon(state, src, todo, 1);
> +			poly1305_blocks_neon(state, src, todo, padbit);
>  			kernel_neon_end();
>  
>  			len -= todo;
>  			src += todo;
>  		} while (len);
>  	} else
> -		poly1305_blocks(state, src, len, 1);
> +		poly1305_blocks(state, src, len, padbit);
>  }
>  EXPORT_SYMBOL_GPL(poly1305_blocks_arch);
>  
>  bool poly1305_is_arch_optimized(void)
>  {
> 
> base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
> -- 
> 2.49.0
> 
