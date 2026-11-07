Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794087988;
	b=OvszVa4/zLfSx4QQDVGi4oWuse8nl2dc2LqEfSxQPozrHUewWxKMWB2zYUV7C42iz9It
	 S8b0mCXoZTqw4niZE3pyP9sdOqFG1GilcNE9aqUNxh3QSBak785K2JmYcUrGkRl2t6XcF
	 3hs041I8qAEbH5Zd6ePiWXG8UE1BD9lDZcEsLXZ/sy6qMs7bDFF8KGfTdc7trw/e547YR
	 lw1o9b+ohMx+KBygjyfLB1ntBSZIDJiql9Fzk58ptGUefThGpyfxa6IsJAxp2cLSyp77o
	 g608cVUevB2KhfJ6gFYee24A3nS9o6REU3iyY1nCzv4wy80Meih4OGQGg0HMrzJreZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794087988;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Ci1N2kfhdtRSKxLzXsA0RrUggCfToIHFsBC/ksL93b8=;
	b=NQJFOnTC8YfYLSzE7Y27mZljj1hVKx3zqtvrvEEoFM0rxuUSViEr2eFNtlAybpbhqy61
	 QYGSi8eH3OO6DQdfB9FUu0FFNNg9jp7CzDmJ835eDQsjw84SEWUmaUH90BCA4U4Y6thDL
	 2lwn4+7KtCZX97qei69cXeYwiyYPxOQXQRuIBd7BAA67B5HEtV9gTQ4TBl65h4xe98XVy
	 oPMtv7xf/9G3jKJTDoQsj1f0bcxJW5KEhMUJM+mA9FdLgwVT3/E++SO0ixx+iQlhSyLLM
	 XKI31bPi5uwdIg4TshexKUynM53Xm34WgnMr+F+V3ZZjh4KyNNgKzDAeAm06xEVSjRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AZeJwUOb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8CA606A32D
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 21:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AZeJwUOb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597211F0089F;
	Sat,  7 Nov 2026 21:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087987;
	bh=Ci1N2kfhdtRSKxLzXsA0RrUggCfToIHFsBC/ksL93b8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AZeJwUOb886qHiitIKMr38RFI9JQCcOk5PHbF3nUWiNNV1Cz6+B7zhVd85ODWV+zp
	 iYDMQNg7mRySuNMqup8BwsHn0BZVjONyQkAVfo4h3UcXqJ60LZOXY4/HlGK7/6f3Yl
	 GkEkL1SNfZK5mrFcl2hrEfuTnL9VpmyAXr1jrpkQ5ScyMpVSUGCRd+7/BfpOyAyO0F
	 1cfikxNBEuht93Xo0tD2nrkkzUOmPrY1/QF7N/xGdLdNkVVycmvrY5OPpw9Rdh0rMW
	 iynmXkWxEjEYstGkdCptt1q+6SMdV4hQipps2VIsjucQb8gYVFkLmw8jOq8DtoEYPU
	 hp5/DNig7uX+A==
Date: Sat, 7 Nov 2026 13:46:26 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Avoid overly-narrow keystream
 XORs
Message-ID: <20261107214626.GG137269@quark>
References: <20261104065703.247316-1-ebiggers@kernel.org>
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
In-Reply-To: <20261104065703.247316-1-ebiggers@kernel.org>

On Tue, Nov 03, 2026 at 10:57:03PM -0800, Eric Biggers wrote:
> chacha_2block_xor_avx2(), chacha_4block_xor_avx2(),
> chacha_2block_xor_avx512vl(), and chacha_4block_xor_avx512vl() currently
> XOR the data with the keystream 128 bits at a time.  This is
> unnecessarily narrow; the same functions already use 256-bit vectors
> elsewhere.  Do it 256 bits at a time instead, which is more efficient.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/chacha-avx2-x86_64.S   | 220 +++++++++-----------------
>  lib/crypto/x86/chacha-avx512-x86_64.S | 220 +++++++++-----------------
>  2 files changed, 150 insertions(+), 290 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
