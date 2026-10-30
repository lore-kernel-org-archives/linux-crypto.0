Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384031;
	b=yWiloAROyLYGO/u1feFJN0XVTWRDfQNXiGAltXmRuVKLERSZFy421c5hMBalhJoK+uUh
	 0LHLO6wcQJ+6NZIs4gyto+wwzrXcMwHvBDRvVvBitmey4WYppru4jDGskS/WBbKzC5QZH
	 sLMwShH7O2oHCKZ0zcbR6rVh/V4mPerUOw0s5zVtngOc3fN8wy3EMiBcdlQAKsEXlNBGO
	 tJZZ/S4DPI0CcDeEkSTMcEpBqpeq4YIbQPKFFh2zbooR8KrziXO1u7IfmSa6zXT9x1MHO
	 wcjLoYwr2vrRLGr+GkF9uvYThuxzprq7ocDwVDOLXtWAPUBjnmzqJ9/b0XNl/7zeM5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384031;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=TLJ5zvt6XQ4N580Lnu4hr75e3hC05r8aLp9y3tXKnsc=;
	b=IdF4e8ZNHwuVAIo2hQwBrn5ULftMrufvsjocfZaVcRM0ueDZdpEBlbC5rGlKknxAzq2O
	 ah+s4nfidgmB1OQutVBu1CozyYRoBbXVwVENTdevZC+WK4lH4hAYIYLZQkQTbqS0J8Jei
	 mgdxb2zoeu1z+MfFxLrm0Je6BTJpjiJSQUl5kmZe5gJ4bRocnK7RLiWoITe2WS9iZFZVJ
	 jWrMBinUsAM6uft/O26vlivnMxRW1JWhMJNGXYTf2zGy3BUi7aUPpMcy1ur2liUNLU0BD
	 3ftXM5CEzdi3JnTY+GhtDS5JGI9qE0Vueua2W2xWzJ1DM7pJQwad4Fn1cPPH2FuK3lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MODJJa2e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1155606A31A;
	Fri, 30 Oct 2026 18:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MODJJa2e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2A51F000C1;
	Fri, 30 Oct 2026 18:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793384030;
	bh=TLJ5zvt6XQ4N580Lnu4hr75e3hC05r8aLp9y3tXKnsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MODJJa2ekdgmyCh+soaz4U8SxEmebTvcgNssCXk3r2M8orRzmrsQoh1Efs4NI5WeF
	 RDPNwVUXJ93sDqV2fsqgodFA7Z0fK5vYQX78QQAtc5C+aRGNIuecsM4+JAYQeozlru
	 H5yb3mxodJ9ZML1mtBXJ63Gfwm6xeLLD0JvlxkQ1YXCYsH34mnEaJ/dYd0bR19Jd1m
	 nd+6d89HfZ0SPw2DquO38AcprbMNarINYS2v+sCpheXjh17+8s0HPVH/KjPDrVbcsS
	 RlcZ9p0N6WnRm7WSTS61mQ1DzjQHT7wUpzou8WOySUX7ZIO++2imc51Z5ZJT9W7fg5
	 xScdwv+sL8c8A==
Date: Fri, 30 Oct 2026 18:13:48 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-crypto@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next 1/5] net/rxrpc: Add local FCrypt-PCBC
 implementation
Message-ID: <20261030181348.GA2500145@google.com>
References: <20260428024400.123337-2-ebiggers@kernel.org>
 <sashiko-outbox-190323@kernel.org>
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
In-Reply-To: <sashiko-outbox-190323@kernel.org>

On Fri, Oct 30, 2026 at 04:53:34AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] Missing export of `fcrypt_preparekey` causes a module build failure for the KUnit test.
> --

This was addressed in the version that was actually merged. 

It's not clear why these emails are being sent just now.

- Eric
