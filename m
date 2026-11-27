Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795806291;
	b=NARiIdPWm56IM6GCyzh1T7vC4EuGd+5G0fNFfFqP+yLTCRSbOLMUs0PR2JX4hQIF0QOZ
	 HdAzfNlR61R7z975QUjUr61wZOCTD2ZrO2xN21aUs/EKWm2bCHVyycRLwUjqiq5X8pP3R
	 /lh4tvISAjUcrOZuLL068yJQbzY7UbuvWsaD7YUf2ba0+j8lnPSGQAMEQNSPZ2VCeqXqp
	 e39iGnaCvO+UC9M7SzfxeClmRxKi061hELyIq2G8z4k/tsmYDlo9EEEpVhoM8DE6sjbCL
	 2+vL4HG1ew1FWHx/aQmxWb3RmwLnjuOCgOEImvkV3mFuejG2ZemlxxkpJbkSP0Oy4kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795806291;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=1T/hxa1T0OQ5L4RB3hNQ93dAwWEtUDesGp/ezdZTtNU=;
	b=et6TOTd4nRJqmS9zpoLgbKAb3Rbe+jd6g39jAi9cx+Upa8JcgB2K/SbvdcOH9YiXOu44
	 Y4lBAXOIk7KiyB/jyFfy9f6vyWJaeCBquap/J+kWJPR1KTeEcqZdcM/H/k1Croz28Isjh
	 dmK46dlR9iq+zXb91uCJEwLnSVix1NywrWty7s2DcIznE+W+aw1Rf4rbuksc6mCQAXkdJ
	 zcxSUFvfRkPHRjl7SDI7s2IExoQKcNBcrwlbm+3nqLKrOwyVA3K32JwwqAltYJheumUtM
	 sogakfhY43q1TcHZiXcyQ6mykvopwGl05FGGvD55NQwJ8qelIGKMbedpwR+u4fzmq6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oERaHfLk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90C3606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 19:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oERaHfLk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E13A1F00898;
	Fri, 27 Nov 2026 19:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795806291;
	bh=1T/hxa1T0OQ5L4RB3hNQ93dAwWEtUDesGp/ezdZTtNU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oERaHfLkF4vLo0sy6Tfor+l6DUTcCV+1tmBrrFpezL1NMB/u9qSAyBBRmvR3XEON4
	 f10t08JDMkw0gD03bZ4JaJQVSAGo9IvoortxzWJkrdHOj7Qcb7SAxf5FUT4CFPNvzl
	 QFwexGH1i7Xn8sgIDQH11qBXZIhtjsxpNoH3vOYJfwQCwDVUSUko9SQs5k8S0wIrJB
	 HTbM9AHcAFhQawheC3g8zB4wmChhFQ94UYvdPBxGTuFN/IGwRTVyhFeFwPOB7KWY/t
	 QnrShAe4TI5/eUIDfD7y5tgeMpAIezHqTRJN9784baJRGhRu6DUSWt1UoeQl9/dDIz
	 70IPI+ZiAyeww==
Date: Fri, 27 Nov 2026 11:04:48 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, x86@kernel.org
Subject: Re: [PATCH] lib/crypto: x86/sha512-ssse3: Roll up rounds and reduce
 stack usage
Message-ID: <20261127190448.GA8300@quark>
References: <20261125043159.192004-1-ebiggers@kernel.org>
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
In-Reply-To: <20261125043159.192004-1-ebiggers@kernel.org>

On Tue, Nov 24, 2026 at 08:31:59PM -0800, Eric Biggers wrote:
> Currently, sha512_transform_ssse3() unrolls all 80 SHA-512 rounds,
> producing 13.4 KB of text.  It also stores all 80 message schedule words
> in a 640-byte stack buffer, which wasn't being zeroized on exit either.
> 
> Shrink both of these to more reasonable sizes (4.7 KB of text, and a
> 136-byte stack buffer that's zeroized on exit) by doing rounds 14
> through 77 in a loop that does 4 iterations of 16 rounds each, and by
> using a circular buffer to hold the message schedule words.
> 
> The circular buffer works well because each message schedule word in
> SHA-512 is computed only from words in the last 16 words.  The number of
> rounds per iteration is set to 16 to match the circular buffer size.
> (It's also a multiple of 8, which is how often the state cycles around.)
> 
> The message schedule could also be stored in XMM registers, but that
> approach was found to add additional overhead on older CPUs.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This is an alternative to the series
> https://lore.kernel.org/linux-crypto/20261122022030.296468-1-ebiggers@kernel.org/
> It does 16 rounds per iteration instead of 8, and it replaces the huge
> on-stack buffer with a circular buffer instead of with XMM registers.
> This hopefully avoids any measurable regression on older CPUs, while
> still achieving the two main cleanups.
> 
>  lib/crypto/x86/sha512-ssse3-asm.S | 157 +++++++++++++++++-------------
>  1 file changed, 92 insertions(+), 65 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
