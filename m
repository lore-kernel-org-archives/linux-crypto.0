Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748353;
	b=WpEj5pCJls+CfiDlxJGWOhEuhy6ffsrXCRjZJ5+LzFr7aUbIsXoZgfntQ3oDx+GKI8Mg
	 7XL1M61oIELJqHFhoUPZMsxdODX/QaoLdsnD3TUIMBzBeKDnHXg1Zqfh1sfUB6HMjH+2/
	 pgWpWIqvyoffyA1lLKrvNNoZK9LgbOq8epScatxFziUKnXzXcUrDPzQZcE3KDSZidBhEg
	 aqU+6umQGPmDHUrWcAHLo6n+Jn+DZTIzT+tzjIZjleQViAVP2t4iPt1Mkac29MZ9JyffE
	 e+vp9oftGo15IzQO8Im4em8R7QdQmDSt/qboqYnpaDSTJhQkJ7B5lM2oGeKGFLLxPVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748353;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=MSPzdMheDulypKbX0z8o2XtuCDGADb4p+rjryHe1lpU=;
	b=xxlknxhJUshoGsi9PLhSgwvgiBHmuH6JVi6+7AEYe7MjHFy+DDZYnY0hTmVboq3vhoRq
	 piCEEYOHxCLtE/UOjUVjJNymg+5Ub/Va5vXNb//3WQxNC4tfj6Q2kWYeTVXDM/5RS51gi
	 CIK81fi1fiy4/8pChC3Zn/p4t+UAVJ1el1IpepM+R4FzFIq8nYYcWmtRYHsQ5GQ+FLg9W
	 l1YpC67Dd0PqYlD2CPQuzebi0UU1YiF48EBmmQoL4feS/8by22xM1avc6r2JiUhM1pGRJ
	 dglhjYD5TxxfwSxRSl2S/4Xh4pWYxFgJBizVzRA2bNzNP1eTYPo4FDd3TrR1losGePw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LeRicrCh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7FB606A32E;
	Tue,  3 Nov 2026 23:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LeRicrCh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E471F0093A;
	Tue,  3 Nov 2026 23:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793748352;
	bh=MSPzdMheDulypKbX0z8o2XtuCDGADb4p+rjryHe1lpU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LeRicrChqbqLdcqyGjYIKfB0qWtvr+5gcM4X0tGgV1P3aVln0go+kKCZb6R7dHg18
	 n6YFI2y9MD1YxLFhpKkhVIZz55g2jLlbP274Do9jeix0yEQ2y6WbrJF1NNOC2WLp3j
	 xlDQ0SL1y0erA5qv3DUZ8eyYsTuQiaIJfa25WzYsF9zj+wLwPsdWDOQJJneKEZZ1h7
	 mvSr4rsnJ/JoSafUgnEX/tamSKoRg3rmj+v2dv9+igICql4Hv7gzVglDx1t9bbu0AT
	 QgBHueLpFJIaIZF6WSttc/lRNsmO6JFVk0QL6AhpOH7b4AT7c6GI1BHeT9Q/P2lqH+
	 RWv5+qzOM+tcg==
Date: Tue, 3 Nov 2026 15:25:50 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: ardb@kernel.org, Jason@zx2c4.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: aes: use memzero_explicit() instead of
 memset()
Message-ID: <20261103232550.GF2281@quark>
References: <20261028142636.5888-1-raizudeen.kerneldev@gmail.com>
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
In-Reply-To: <20261028142636.5888-1-raizudeen.kerneldev@gmail.com>

On Wed, Oct 28, 2026 at 07:56:36PM +0530, Mohamad Raizudeen wrote:
> aes_gcm_decrypt() and aes_ccm_decrypt() use plain memset() to wipe the
> output buffer when authentication fails. But the compiler can optimize
> that wipe away, so use memzero_explicit() instead of memset().
> 
> This matches every other sensitive wipes in this file, which already
> uses memzero_explicit() for keystream blocks, tmp buffers, ctx
> teardowns.
> 
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
>  lib/crypto/aes.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

I added the following note:

   [EB: I'm applying this mainly so this doesn't get flagged as an
        inconsistency again.  The main purpose of the zeroing here is just
        so the caller doesn't accidentally use the data, which a plain
        memset() is perfectly fine for. ]

- Eric
