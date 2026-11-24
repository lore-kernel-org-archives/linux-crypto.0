Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795563121;
	b=NrU+3jOmRnsNYm46LQpE/h73c+x8ro3UPAGGceGDHcXc2vzb5wOyGbyrC9BSQBcsETuh
	 iDcmf0IHHLnS9WqqFQYp9lL4s/jExRuoMI404TPnRR5fd05dQZttFr7nVmpg4lGa2qZuv
	 Pknaq/7gojzG+axAMxxl5kVj3W9e1ALhtcl1+9zwAxxRjcnYMF+eroIW8+cwDzYuxTa/4
	 x5N4mXZhKIGp1CHn4JvcSnGpNephpcy2Pn/2iTEqNI6YiwVDUN8ef5WxtWfZ6m55tJk+R
	 1U2Kq3TByg2tRizgfGwfx72hS5jynfwKsBUnzPPOLtLiDq150bN7PADj63kzSLfD2aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795563121;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=EGDGtSa6Q1KfM6hxcQCWm0sbULs1jiCb4T0r8bQPEFg=;
	b=sieCcO1SzB5lZGkG2pKETGprcqYapZZJQX6ERwFC9/fJ6YN3ppuROFcleMXOaRy5llkt
	 62x1cRvKMtUWmKl/ZuCHRopryFn97igHZ8depp71PFj1NOcT9bFSBCs7zXavYSmEXz4gO
	 Od79nuCf7G2uM68EiFEEXhaT74cz3+9PhOXaNvW2OqmCSen5A8ZEvgWWxpctTxQb2NfsH
	 +NBGTRi8wtnICSkxRsq0K7x2zoFX2FMAtP5/moUgY/fokdknqKaufOf9PbdSutKbBPcG4
	 XLGXmLaSJ0c8+qTbPhhTU+rl4s3aE6CRaNjNt2MfHNkBJb9tcaTkm+bvhAbh3ab3Q8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ByNsagaI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5879606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 23:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ByNsagaI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8E41F000C0;
	Tue, 24 Nov 2026 23:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795563121;
	bh=EGDGtSa6Q1KfM6hxcQCWm0sbULs1jiCb4T0r8bQPEFg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ByNsagaIaUGa7NPWEP+2x1L+jWm+UcPi0pkG1GPNfL28oFsV5MvlH+tLkuRTQAgw9
	 wLgRZC1bM0haqf11g81GO5Lm4PG/hGr8NJPJlT8o1cRoArDUgzWb10E6ybPtSmlcRU
	 vsz03J1wUzjVcXrUSW/rx/MZuMLsQE0AUqy0l9UAHyEDQqhNDG1jkuKluwVJW/rc1s
	 rXYLdqxW/ivjaLblMo5EkNzxzyoAXryJ6KswyJTeqc1JvgeXZpPTP7kjEHaq8DEOD5
	 VexIP5pm+0mjjbgBuNjhyR7eBUiHxbsRUcudwUGwmNjcVrK1JqIqNdG4LLozJ661WQ
	 sTMXuUV8/5odA==
Date: Tue, 24 Nov 2026 15:31:59 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH v2] lib/crypto: x86/sm3: De-bloat sm3-avx-asm_64.S
Message-ID: <20261124233159.GE2001@quark>
References: <20261124083736.247567-1-ebiggers@kernel.org>
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
In-Reply-To: <20261124083736.247567-1-ebiggers@kernel.org>

On Tue, Nov 24, 2026 at 12:37:36AM -0800, Eric Biggers wrote:
> sm3_transform_avx() previously unrolled all 64 rounds, resulting in 9567
> bytes of .text and making it currently the second largest object file in
> lib/crypto/x86/.  Additionally, all 64 round constants were inlined as
> immediates, despite the fact that all round 0-15 constants are rotations
> of one value, and all round 16-63 constants are rotations of one value.
> 
> Therefore:
> 
>   - Roll up rounds 16-63 into 4 iterations, each doing 12 rounds.
> 
>     12 is chosen because it's the least common multiple of the 4-round
>     rotation period of the scalar state registers and the 6-round
>     alternation period of the two XW stack slots.
> 
>   - Generate the round constant for each of rounds 1-15 and 17-63 by
>     just rotating the previous round constant.
> 
> This requires one extra GPR (KREG) for the round constant, which also
> serves to terminate the rounds 16-63 loop when it reaches the "round 64"
> value.  Free up %rdx for KREG by replacing RNBLKS with an end-of-data
> pointer stored on the stack, terminating the block loop when RDATA
> reaches it.
> 
> The .text of sm3-avx-asm_64.o shrinks from 9567 bytes to 4257 bytes, a
> 56% reduction.  Performance is unchanged to within 0.2% on AMD Ryzen 9
> 9950X (Zen 5), measured using the benchmark in sm3_kunit.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> v2: Avoided spilling RDATA and RNBLKS to the stack by using different
>     methods to terminate the loops.
> 
>  lib/crypto/x86/sm3-avx-asm_64.S | 236 +++++++++-----------------------
>  1 file changed, 68 insertions(+), 168 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
