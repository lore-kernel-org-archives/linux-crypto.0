Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794085578;
	b=Dd1+RETukRCo7MLX/lAoLA5zCixZH+uDNgcRYyhFrtvlnwSM3FzU2Yis+OZdxGSriUGy
	 raHGVfoq06+vqgnL0Ftbx5ok7M/oeMVPNfTrJVffHUxKSS7a3LriX11cO+87z+3H068To
	 +R6CD0skEcHGuuJJ+9xB/y+al26YXEXMTz57Y8//lP0ApntWtK4Xgyv7ceVbaB1RwHvWF
	 y8Y7pQ9bronItdwK3BEnq8VHLPK0ntMZwT1nRmcsLT97/WNm/SCkEd/TWtYEaTr/ZDwZp
	 Ig+rtDfk7O5Ou4N8b2iE3fNYUP6jPgUfLwJFIALZQs/JsWggOleflnDj/RJThcSgWaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794085578;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=PY3HlUgix3k+zlQrFUTq25aPji5EUQUxBBduRz4gw0U=;
	b=AHDjI7ECCAhO3pmXB4pI8ANKHCaAOrz5kaIdy8VfGYVJFc8/Y7Qb+aluELsmjWSjzui8
	 NK3vtLzDzXcJb+nnQmVr7UR9U0GieIfVXbsrFs4M4SYIGOXTtk6KhWTic6ZIDQfl+xHfw
	 Sg2ENbH3jGAJ4LwSVaV5zwWmkbzdHcg0tf8yc+TM4aEX1njJ3Se6YrvTmG5rfB0hxMjI9
	 3SdLU2Oa/rH88dglVYInb4fnjIvaGkqXD7spAX55trWSd7GPL29VY7N8iXfWUFf21btP8
	 RgGI2WyxYO87KeuI0WLX+I1fYojdwTWwuJolnCBoRV+7VN+ZbLz63YvYsu1/NrMyz9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ScBjEg6E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F07606A32E
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 21:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ScBjEg6E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD43B1F008A1;
	Sat,  7 Nov 2026 21:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794085578;
	bh=PY3HlUgix3k+zlQrFUTq25aPji5EUQUxBBduRz4gw0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ScBjEg6ETO5L9u3VapA6mxjC2m9/7SAa3z7aHJKqegxNMMPe3LLlQjYt0hdxeKzSZ
	 VONO/UkC/zKRbt6ob2K2w7DmRWPrRFTINXLf2SbzR/0Gv70KYvb/lwoCPhkq0zVuMc
	 WBb6m9MbNiyHVGCAQ0huSQZg5tf7fmV9Aj6FR0/DGOQ9KgNI9aB21Jv0w4H+edwMhj
	 k1d5IKomsnUDFL6pSPh1+l91S4gXGMvNrfNCjDEaWnx7p9U9Wh10FZfOemR7cZTtEo
	 gvI/AwjnwuQUDANkNCqXw8ytzlc50dqo4i6FpRdgvfa8Xp+yfaq7D1Q4S8DwaN3aJF
	 vUqBrFZjxjQbw==
Date: Sat, 7 Nov 2026 13:06:16 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Antonio Quartulli <antonio@mandelbit.com>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH] lib/crypto: tests: Add some additional lengths to the
 ChaCha benchmark
Message-ID: <20261107210616.GI6049@quark>
References: <20261104230626.87060-1-ebiggers@kernel.org>
 <01247287-fa97-4f2b-8d9d-42b22c3511a4@mandelbit.com>
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
In-Reply-To: <01247287-fa97-4f2b-8d9d-42b22c3511a4@mandelbit.com>

On Thu, Nov 05, 2026 at 04:33:19PM +0100, Antonio Quartulli wrote:
> Nit: there's a tab between "256," and "511," while the rest of the
> array is aligned with spaces.

If it's removed, 'git clang-format' puts it back in.  It just happens to
be the only place where it does so here, due to the spacing.  We do
still override 'git clang-format' with manual formatting fairly often,
but I don't think it's worth it here.

- Eric
