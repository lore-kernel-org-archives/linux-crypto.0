Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748420;
	b=hPLmUDfbU7wIVLxaLgCP7wGhBlieCXArHoSKZlYhlHLG+CF+FOseo+4Fq+LgWNuQj966
	 B9SLb3fkbxu3bZ69lvkgP+Hdht2v2kpX1L/Z4u8sPspeaoFnMIv/3bdyI9/lbzBCHcXka
	 wUZKZNP6MXvx4F6NAdN5bW16HZ0xItFSbiaWNgzwmRQ1yRCkyu9hJMLwGohdcjkaBG7KS
	 XgmIx38LQgDSMPI+eieWmScKs4C5uWfp/KYJ5zQWr7RbjQO2b9aLIArAS+Z42OPeMH1Yz
	 Rulh5HZdLX7MaRPuicYot1GjLrbuOL0rpU2zRryrqmT3VVSy5xupGud8B1EAvu8EpFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748420;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=iZY2pymESxMUDNG2zpkim6DbnJ8AGBQ1GDyjTeqHZ0s=;
	b=ddveEXeZ0ZJbTjjiStRV2BLo8xylIKHr06Z/5VBeG9AQItAqVmN7wzeEk+nNWTHGfFHd
	 3yZ3wduTOp8dYZO9ISig/FkWGA5mUtXGDdbko6VQMM8GJpWj0AdcFQIHcHx0WsohhTfzq
	 SNswlHmn7W+0oiMEtw0VkqmfXc+3lMlmkoZOhw3gTpJ00dVnx9p6zgPBGlfpspOUS69nf
	 jrZVxo8eRKJe6FcmJ2tzqhds7J3yFSLOI0HxK5b4R/oFTyhJL47Hx/YvNQk4xNpPYYWeV
	 4VnOdOPWcHshUfrdxYl0dPhrV9xG1PoZA0kDlzF+ZPdippxS4RN0UA1iO4wAoKh8R3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rz6t6pxq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFF6606A326
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 23:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rz6t6pxq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 723E91F00A1A;
	Tue,  3 Nov 2026 23:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793748419;
	bh=iZY2pymESxMUDNG2zpkim6DbnJ8AGBQ1GDyjTeqHZ0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rz6t6pxqTjZLVuw/ZLzenQteF01ZGlLC5jJKKvKz1mGJQBJ81hxmZsIwlrJRBwvCI
	 QOws9L930ZxQvCo0f/1lz6FIkAYp3hJo9hACuu4XSKcpkrxB84KdjZhugI/iP6oh+A
	 FKboivqDSUea0oQ3///p4os7RFpmEHKEi6d08impevOkzTTRKD7FtkwlphopYnpWgV
	 cudihJhynQZyoL0wVGtrsDvKAnQG39wSEt1MxlQn6yK5jZXJtvp3g+iqumusjG1Naw
	 Q5Vw5gCZIC+Yx8VTfVDfM0F66M6r216bMDPtRQsLF/B4gLhUWSHPBa28dbPT+o+ZEz
	 ck7B7y5PsuUJw==
Date: Tue, 3 Nov 2026 15:26:57 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: gf128hash: Hide selection mask values from
 compilers
Message-ID: <20261103232657.GI2281@quark>
References: <20261031052149.201983-1-ebiggers@kernel.org>
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
In-Reply-To: <20261031052149.201983-1-ebiggers@kernel.org>

On Fri, Oct 30, 2026 at 10:21:49PM -0700, Eric Biggers wrote:
> Hide selection mask values from compilers, so that they cannot see that
> they are used to select between two values and potentially generate a
> secret-dependent branch.  This is not known to be happening here, but we
> might as well be extra careful.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/gf128hash.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
