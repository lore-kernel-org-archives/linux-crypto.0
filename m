Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795552428;
	b=eTd/BnaDdgf9QkcMXy6dNcIM77zXtfSA0+XEotqz8AyF1iDls2gBlWK859OXoPnDzPJv
	 4UXMgC9s914AkKPY3DXHtoeYUhVkw3hh1Za2r9V/iNi66dcSg95hcvucmvg0mLsnPatl+
	 RqYRbtL0AK+J5q0axTy2PoOiuqvm85ol/70cExR4PKLvBl7+6K627rx6yOdryO7EG5rdK
	 XSpejGLN8EHe0C1ZxuZKL323gGDIhqOcaK4DgzrBPPZDsQ/n6LFRcydvkCrnhfYVU8/bR
	 PHuO7tu4xKoK5e9Da3cnS7+h95ryHU2qfWdoGJ8xRYnFpzYQPEsK46ZbDtDcMqkGd1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795552428;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=b8mrNZU+NJxNOuP8jPk4+n6FlHXsHl4SnmM69KIW5+c=;
	b=SkCZixfpQWzR0adqgveV1QUxxiH6SI22r6grfLCv8zO6NRoyRmB8g7QKnXKcXN9G4DR0
	 5yRIQqe1ner8eQU5/yQrp7TFDxhL3YpbjTrO01sJWKBlsh5zar2cGWk3gtfDTXztO/sFE
	 Yrv+cswecl7bmUGHg+zX/2v/MSTk8F2pcKP+zm88vcgpi7EwDZpRRB7IAJA8hbdYqQu69
	 6mr4e8pt/lF0XLTd+JrPdDGIZDFfp0Ch5ILfSQkQLoia7S1Hx7xH+bplPOeUfiDO0u4tk
	 pxd3RHtJoMG9tiP1d+RZbkH7vW+wzl0J/pUbfVTFMGnUGf94SJxDjhI+OQth1puJaGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFAcTeWf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6825B606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 20:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HFAcTeWf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8321F000C6;
	Tue, 24 Nov 2026 20:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795552427;
	bh=b8mrNZU+NJxNOuP8jPk4+n6FlHXsHl4SnmM69KIW5+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HFAcTeWfMcYcxpXXEi9qUZ/uhEGMPtPRRMHI+c++dww+gEpWE+SpglHfMg1W3acps
	 V0jDYu8YPafofLWnNQupVJQqNT0SHYg2OO4fFr+M1KEKyEgudh1nr+BCFdqGYs/N4w
	 wUOWiVF0O9ZRwovDNH6QjAntjmeaMoNlLNKRHGXa0Groel0Z9etgJIyvQlu4CIA0pC
	 u/g5l55q4TWb940BwDklwyqk62L0dD7wnZl1Z+DL8nGZJKqJF9GSOPeHGKijLI9qZV
	 /xPTgJO4yzFxsFwccl4Ez3u88gyE+KObRPxxaTzZwSIDAZ6+oUB5cecHXMfGUk9878
	 OKO7GOosToNqQ==
Date: Tue, 24 Nov 2026 20:33:46 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH 0/8] lib/crypto: De-bloat and optimize sha512-ssse3-asm.S
Message-ID: <20261124203346.GC2227373@google.com>
References: <20261122022030.296468-1-ebiggers@kernel.org>
 <1a78f7c9-59de-4ac4-8adf-aee0538d813c@app.fastmail.com>
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
In-Reply-To: <1a78f7c9-59de-4ac4-8adf-aee0538d813c@app.fastmail.com>

On Tue, Nov 24, 2026 at 12:27:22PM +0100, Ard Biesheuvel wrote:
> I gave this a spin on my Sandy Bridge machine, which indeed takes a 20%
> performance hit from removing the AVX version.

Thanks for confirming the expected 20% from
"lib/crypto: x86/sha2: Drop one-off implementations for Sandy/Ivy Bridge"
(https://lore.kernel.org/linux-crypto/20261115080900.216434-1-ebiggers@kernel.org/)

I still think we should take that patch anyway, for all the reasons
given in the commit message.  Do you agree?

It just doesn't make sense to still be maintaining two entire asm files
just for Sandy/Ivy Bridge.  Especially for SHA-2, which such legacy
systems (mostly desktop/laptop) are unlikely to be using in a
performance-critical way in the kernel.  If it was e.g. AES-XTS, that
would be more worthwhile since people actually do use dm-crypt.

If we do keep the files, IMO we'd still need to fix the excessive
unrolling, excessive stack frame lacking zeroization, and incorrect
enablement on CPUs that don't need the shld hack.

> These changes regress it by another 3-4%

That's unfortunate.  Would you be able to test the performance after
just patches 1-2?  Those are the most important ones, which I think are
worthwhile anyway even if there's a marginal throughput decrease in a
warm cache microbenchmark loop.

The other patches in the series I don't mind dropping if they don't help
in the microbenchmark.  "lib/crypto: x86/sha512: Keep W[t]+K[t] in %xmm5
instead of stack" in particular I think is suspect, based on what I
measured when trying to remove frame_WK from the AVX2 code.  It is
annoying that we have to store anything on the stack at all, though.

- Eric
