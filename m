Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794087260;
	b=mXxIMGa7KEn7fPGXMnWQ/OP0q8XHS1eBJsBj3ikw/F7wn/dRggXu+6l+gHLur2SRFmew
	 pdpk9sbNqNcu2SnCwOuryKLroYN0hq2VgfaUTzgFVogDRXi4FmEm6b1NqCEYYTqKbLqM8
	 jWz2N9ETbbvFPRZk3JCcAOtmnHxpOPMuYKPdR+e1kO/723+166VCeHqInZQAXWL/3QQDc
	 0WLg36DEqJqrZnOYC2RexNpJlPQ6NMCmfW1jdva/ftCEt5RiON8J6SklFi3rsfSFdkFp2
	 S4DmbWdUIGPL8dxyuddyosi/b3BzKH/9COq6tjZnvIQakSZFO83FDDr0cm7dgo/puZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794087260;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1rUq8wd3X80C8mXGrrALT29sY2dlIbvmN+EvfEtmNyA=;
	b=mlufKFP+MM8IJHZzIglt9fs1QkUEgFEubn9279lL5tYxJ8EjTU+ZQTbk7sz09kDm4AiK
	 lhb+PyD+/SVVTcF7LEGDseNP43d+Ec0DfPJJgE0I2j+qWurWmWADRsDuEFqqXmyOk1uUm
	 BEjAlWJP7ake1An6fuF1Aanyoxqvo6wyOjTqUC7UqnVa+vGc8j+mS90SnApEEcViDMTUJ
	 mkUw859Wdj7g0agGd6mXP0gpmZ5aYJdOWkFyGqz3ZsVHk7HHKje6E9ROwyep0i1qGrQut
	 UpX7aVWPnu9eemmmP1sKjSGGpKyBnb+J79+ZyoDChvpaPTog0I/Z0g+O5DB+9/Grnxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S8vpX5A7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F6E606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 21:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S8vpX5A7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE44C1F0089F;
	Sat,  7 Nov 2026 21:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087260;
	bh=1rUq8wd3X80C8mXGrrALT29sY2dlIbvmN+EvfEtmNyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S8vpX5A72hyO7pb4JPv7TMsccxRmobQVMM+PwHPjcRDe3VJm0IXTdLF1TwjI0tWmI
	 w3OSQi3G1ZtbOyxbDlI8X0qFda3PRnHemk8fr2J701JvzEXzHdBG013np/QbUdGNd4
	 WZ29WkhUd6GP7BNyX6CZb91mQOWeTDm1HltmAWGagpcLge5cWbNGuS2BxzlfO4AFA9
	 bMpZVuFxtbzyqt0ey5R/AcmDjr7VT4ATcA8w2ZgrJN+mMJT4cI68sqaY0IGISacFuO
	 +RWoIlT2FdvBOyMXv4jrJ4tSqG5GzYxWZEE+N3/Qn+rFWasQ2Oma6lb5tsXkTbC93Q
	 MmTe9kYiKtFsw==
Date: Sat, 7 Nov 2026 13:34:18 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH 1/3] lib/crc: x86: Opt out of initializing MXCSR and 387
 state
Message-ID: <20261107213418.GB137269@quark>
References: <20261105005523.84925-1-ebiggers@kernel.org>
 <20261105005523.84925-2-ebiggers@kernel.org>
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
In-Reply-To: <20261105005523.84925-2-ebiggers@kernel.org>

On Wed, Nov 04, 2026 at 04:55:21PM -0800, Eric Biggers wrote:
> The CRC code using "kernel-mode FPU" is integer code that does not use
> any MMX or x87 instructions.  To the extent that float-domain
> instructions are used at all, they are only moves and shuffles, neither
> of which raises SIMD floating-point exceptions or depends on MXCSR.
> 
> Therefore, there's no need to initialize MXCSR or the 387 FPU state.
> 
> Opt out of this initialization by using kernel_fpu_begin_mask(0) instead
> of kernel_fpu_begin().  This eliminates an 'ldmxcsr' instruction in
> every kernel-mode FPU section, reducing overhead, which matters most for
> short input lengths.  On 32-bit kernels it also eliminates 'fninit'.
> 
> A precedent for this optimization can be found in
> commit a58db7ad80e8 ("netfilter: nft_set_pipapo_avx2: Skip LDMXCSR, we
> don't need a valid MXCSR state").
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crc/x86/crc-pclmul-template.h | 18 +++++++++---------
>  lib/crc/x86/crc32.h               |  2 +-
>  2 files changed, 10 insertions(+), 10 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

Reviews and acks appreciated!

- Eric
