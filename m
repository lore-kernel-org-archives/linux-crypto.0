Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7824F3B71AC;
	Fri, 16 Oct 2026 07:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135693; cv=none; b=DO6YntYMWtirCFO7Tn0hxGt5k6iilnwTDJMUd7ZXmqyT8ihwon5GX73LCTM+i8utYmAVuowORBVSmLnoAqHND4npSGenI3VezduXhSKyfwQNHVLa1+wzqe300QelWinPI562ws96PDpymM168hgbprxbROs1qWLgC+HQ/CS0C0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135693; c=relaxed/simple;
	bh=pHg9+lolAmubqOV/Ch5uwJU2KgAwWiC5ngTYHia4CgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EX3LDbDl3MtczCAHiExYUNPBautviyFQU8rKSp4j/WSYoH16cMZg6qzYpJFLF5GlU7fdHHQbVPo59oqZAeNerrEeuiZX12rSV3R7as9odaQVyRIiBCTVKIKLWJdomOzGboz8OUopoINqrpFYz5qL+tfdbYgo5o1nH3WGVrOwIDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZTt0AcQ3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZTt0AcQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49991F000C4;
	Fri, 16 Oct 2026 07:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792135691;
	bh=cxKxHO2MCyzxbgYAzs8LlnDp9zqcep7qEmycS6UkohI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZTt0AcQ3YuGFOHgTRdduzRZUPs4E63uas086PQN5dE8SweHEvqrG7JMSyn73Q3HJ5
	 sckJ1vYU/xT32subvoCoj8Tgfh2q3PbjOY1uNh4pV9yLcHBPT7iwQGZQC/KZIrrmro
	 u0EQPoVySrIJIAmzAArWed6ou5ZuqJb2ht7Dqs/JVL/9o3ijTYg6toTYYmV6sRrO7X
	 iNs7B5pPp8pFIzEtX0aW7OszmysgSP4RyGnC2FGHgpESD9Er4YmvCniA3yROyUvXJQ
	 bbIGcy7riKMy7zVpuaNJgsYvVsGF48XkHfL2HlmDW6eJBd00PEW3lMK5JwTEIjyHmI
	 wECA8NMDh+qfw==
Date: Fri, 16 Oct 2026 00:28:09 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Vladimir Kukharenko <vladimir@genproof.com>
Subject: Re: [PATCH 0/2] lib/crypto: Use size_t lengths for Poly1305 and
 ChaCha
Message-ID: <20261016072809.GA3049@sol>
References: <20261014152604.323310-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014152604.323310-1-ebiggers@kernel.org>

On Wed, Oct 14, 2026 at 05:26:02PM +0200, Eric Biggers wrote:
> This series upgrades the Poly1305 and ChaCha functions to use size_t
> lengths, matching the rest of the crypto library.
> 
> It also fixes the (not currently reached) handling of lengths above
> S32_MAX bytes, and (not currently known to matter in practice) the
> assembly functions depending on unspecified high register bits.
> 
> This more comprehensively addresses the issues identified in
> https://lore.kernel.org/r/20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com
> 
> This series is targeting libcrypto-next.
> 
> Eric Biggers (2):
>   lib/crypto: poly1305: Use size_t length
>   lib/crypto: chacha: Use size_t length

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
