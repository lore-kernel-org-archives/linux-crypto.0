Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794088331;
	b=UHIJ7R60qShrbnYgt3HJ3zJkqsE7KRL8Kw/3q5l7ZgDGgPAmR/4lRqSB61wgOrz5gp86
	 d9ssGvOfieGWPoaUMvczC2mVYAwKrQJSa5kd0XVhHuo0cWOhAHoXd5/K8kMjt2zpPLlsh
	 7U5cjEXXxcedlUr4obBxGL3E0oWUwXfTDTxF2zz7mB2nYi9fmchfR5Ms+W/SJvMLBk6k2
	 dy1D0UUAnodpl3p95dyNYXjT7AnHeuS6L+6K/VrZ9hPlb0+Zk+/dH7RszMdGeLaQFqowT
	 cJD84M71iZ1wMiHhIjatfYYgfYI3V3Ha6slyeYVhTaz2zUTi7gvjgCC81NNz5DSbBJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794088331;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=j7XdAKJDOSBKiyAhBkN6T2HEwB+kHm1R+cJ4qfzJvsM=;
	b=xczQIwz29By8qFZ7t65AitaEO1VxjxDDvq7zKqITfh1aIvSBy3DLmp9InloP8n3hiXpB
	 9HAIZAz+0B3dfgP3JS+QDMAR2d9gAUFxqRwmpOh0UoDYw/fQEizX8p02HLIW616rRB27E
	 KHJouiG1rYbyde9Vj5oGpiGbRJ+8vtY1MK5e+pRtYkN7MEGkn+wduLWi0xuRi3T/nbPNJ
	 2r1RkMYu2ckdolnAp19ngw28KqA5aUQEoXfCFpae7VJVb6KCpkULTBik0r6Lfu6/1mO8w
	 f2Wo4H0osKAU1pnC8sNALi/nFJzdqDiFfwp+m+h4OX6ruEWtKH92uaj0m9PoTRylvCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lEI0VtMD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A81606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 21:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lEI0VtMD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76981F0089F;
	Sat,  7 Nov 2026 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794088331;
	bh=j7XdAKJDOSBKiyAhBkN6T2HEwB+kHm1R+cJ4qfzJvsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lEI0VtMD3mtRsoKGFn/7Tbz3nboLf6HoVWVk/U0NH3SeyL800QxMaLgSLhtlAbGvH
	 7EZ3K+qEWpIwz8Rs8eqYk8U1MVZEUVzsuFvtaxqgg++wT0/PNepae/ydh1bjRAIfLv
	 CIC2AcarR7ZbcUF8OPz+aZK/znIJKSvA28M/ZFgJEJmls7Fpq9dQerkOrFunOdNNMW
	 Ry4CoYt6tX0unoIKyV2yXyTNBPfCSIIFD0GmZayRMGiR6wzlKEAGglNj7js5O6X01a
	 DKCEalK/d8M5SMyFz1vRx9kNOqUu5zXl6AEUeMI8KttzGjkju8pCALuj1AfzFWQYBm
	 bfFgI7iSuawUg==
Date: Sat, 7 Nov 2026 13:52:09 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Eliminate more never-taken
 branches
Message-ID: <20261107215209.GI137269@quark>
References: <20261104225526.68557-1-ebiggers@kernel.org>
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
In-Reply-To: <20261104225526.68557-1-ebiggers@kernel.org>

On Wed, Nov 04, 2026 at 02:55:26PM -0800, Eric Biggers wrote:
> The x86_64 optimized ChaCha code has assembly functions that generate 1,
> 2, 4, 8, or 16 keystream blocks and XOR them with up to that number of
> data blocks.
> 
> However, to avoid unnecessary overhead, the 4, 8, and 16-block
> functions, and the AVX2 2-block function, are never called with a length
> that is supported by the next-smaller function (that is, <= N/2 blocks,
> or <= 1 block for the SSSE3 4-block function), since a smaller function
> is called to handle such cases instead.
> 
> As a result, all the branches in those assembly functions that handle
> XOR'ing fewer than that minimum number of data blocks are dead code.
> 
> Remove these branches to eliminate dead code and overhead.  Also rename
> the assembly functions to make it clear which cases they handle.
> 
> Some register moves in chacha_1to4blocks_ssse3() are also eliminated, as
> they were needed only because of the support for less than 1 block.
> 
> Note: many of the functions could use exclusive rather than inclusive
> lower bounds.  Inclusive is used for simplicity.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/chacha-avx2-x86_64.S   | 73 +++++++--------------
>  lib/crypto/x86/chacha-avx512-x86_64.S | 94 +++++++++------------------
>  lib/crypto/x86/chacha-ssse3-x86_64.S  | 51 ++++++---------
>  lib/crypto/x86/chacha.h               | 72 +++++++++++++-------
>  4 files changed, 119 insertions(+), 171 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
