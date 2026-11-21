Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795290554;
	b=uSHDvwal2sG1CU5mAKxGcgvSNE6CNuSejX39LBJ2CSPXtqVFXffbQGudjjRIT2nNyuxy
	 yNf/3LXjh0rz1MJSSd9dbuWzHbshCfdo8Efyt6iovLocp+0ScQGHGuoKHw6FDtzdTnUdT
	 h2WVdltxJ23aZiOLgQdLDN5X6IVpYWO5BUWqxsODH8znPE1BzcY0oYL6jVc6GIjNzNz+p
	 BumFyxNTLF8E9c3ZME5fRuyd0iVUdGBEqyN5+/zP2FWMUYdwK87zbt/gglSxnePPQryO2
	 ObSJ1FlS3feM8ng4bamXeC9AKmBpRaLgb78P0ddykbDYvZynRNl37AACA7KH9DhTYPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795290554;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LI7WNa26rUwyPFniRmupPeMT9Z7ApM/S3vAe0l+cWN4=;
	b=La8a6z5WcmlB1C1Q68NOtaoMZDzaRho/DdAZO5whLWae6LKbZgFW4Ch5fFuRHl/FsEuT
	 8cZXnT+AbQgcejQwS8/Rp8o9McsX3muPPORpuKhC/W+HK+ysgOrU84+Gq4qjqWWJXO44a
	 UDpD8vimK8Dp5RjP2h47Xvrz6XWacatsLCmgndpv5Hzf6C8BluAmotNqPJQedeenV8f/3
	 vB9zILF8QsGkr5xjeT0F+/gNKA4tOvGrxItmoIPXjj0hZRoLm2CinKxDP9YCaTwpXbXgH
	 nmt6j8gT9B9S9Ls7ac+iXMYMemBrDw1UGvrgDTElNsyhr16weVeUeU28g3IqYji/bng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IF9xP7nZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C038A606A320
	for <linux-crypto@vger.kernel.org>; Sat, 21 Nov 2026 19:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IF9xP7nZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C86CF1F000C4;
	Sat, 21 Nov 2026 19:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290554;
	bh=LI7WNa26rUwyPFniRmupPeMT9Z7ApM/S3vAe0l+cWN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IF9xP7nZUyHvmr9Ru+MrgEm04EPaED7yzCqJ3NVfVb795vG2CjRxFvsAt2R+CutZ1
	 ACEOuzrbvLVBkTxWV17TFMvnLAqA8bK4xVNfZ2dbtXsHK0ZjoOPAh89F0R2TFJf8Y/
	 Im9OVsMUCTclbaya8crjamWrgTFnNoh7PPlmaYczBCpdVgDX3AfNVgWAiYVwAeF8On
	 GJ9vYVEm+h7bMhleExDhlwukMaGCKmBxMsV54xILv/Vq5QCq/jzBV/tHkx1MhYy9vY
	 RWtXlYfJmxAe9LyetAW/S7yogKhzMAELZEqEQyw1a793ZZOpazF5juv0trRVGdyKfK
	 hITParLlL9q4Q==
Date: Sat, 21 Nov 2026 11:49:12 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Emanuele Rocca <emanuele.rocca@arm.com>
Subject: Re: [PATCH] lib/crypto: arm64/sm3: Use assembler for sm3 instructions
Message-ID: <20261121194912.GB1975@quark>
References: <20261114211019.80609-1-ebiggers@kernel.org>
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
In-Reply-To: <20261114211019.80609-1-ebiggers@kernel.org>

On Sat, Nov 14, 2026 at 01:10:19PM -0800, Eric Biggers wrote:
> All supported assemblers (binutils 2.30 and later, and clang 17.0.1 and
> later) support the sm3 instructions now.
> 
> Therefore, drop the use of '.inst' in sm3-ce-core.S and just have the
> assembler generate the instructions.
> 
> This requires adding '.arch armv8.2-a+sm4'.  (Yes, the assemblers want
> sm4, not sm3.)  I also tried just '.arch_extension sm4', but that
> doesn't work with binutils 2.40 and earlier because they consider sm3 to
> depend on armv8.2-a or later (and this file isn't built with
> -march=armv8.2-a or later).  This was fixed in binutils 2.41 commit
> 205e4380c800, but the kernel currently supports binutils 2.30 and later.
> 
> No change in the resulting .text section with either binutils or clang.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is intended to be taken through libcrypto-next
> 
>  lib/crypto/arm64/sm3-ce-core.S | 41 +++++++---------------------------
>  1 file changed, 8 insertions(+), 33 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
