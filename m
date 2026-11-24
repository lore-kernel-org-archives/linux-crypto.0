Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795563155;
	b=yAkvCJBud4JxeultypVP+UAgRTc2Z0WUKcC6xvJMuxydHrffM6EiHBDuwsFrN7RqP3u/
	 kMoNxDFhd48GMtqHwcyqyatwlLdNbMIu/Kd+0xqc0/MU728uLHBbIFiWs4BaQtyQ5SaJG
	 txykVr6FuNQ5idEq9bxfSQJkAmDOUflsnwFepdoD6PNS36dsw76RhR0ShI3YTkDeUBYzS
	 gxrX78BxPVEKiigqV+UWYzafAopKzcU6OYTmP9ufOOEjGI5LDSRLWIPA6LeOaA0rbOCKv
	 dgYolASpfRw8MPtsKYW+zWNvRDyIJJTOuyW7HYBkBDEvmH6bWRC4zEe6YPDOGLV9DEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795563155;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=gi4Ftpc5XMxzZWOeZaYRXZNeDLmeakg5h29RFm8Nz0s=;
	b=q9cShdjHnsxnq/xGaa+B0rb53Zhl6pWqaaoAmMBf2JyoSTkbalVCoIvj2KJICRz2D4rv
	 TWXa5r0H8w39Ndmn4CpdoMXMX7XFB0jSORl1EgHOCJKn65KKsIxjOiZyTjTSQ9q7DzldL
	 zzkCOf8uJY3PzioROrOsgw+9nP5WE8CELgg1FdKtWiJ9sVtTcmaeoyn19dZREV7f/jPwp
	 /kX+ilsdqkBZNLfmTVqi/NARfmZNAvtdPrHyZkQDY7H4Bwa8sNfUH7MaQMfLYWAE7PG/b
	 ZAMpe4fbxPZaAlZVRWRYORa0rTc3HD0a2PBXW7Bq8B+kU6rdXaH7DWBmT117jO0U3yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PHra+moW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B09606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 23:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PHra+moW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B211F000C6;
	Tue, 24 Nov 2026 23:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795563154;
	bh=gi4Ftpc5XMxzZWOeZaYRXZNeDLmeakg5h29RFm8Nz0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PHra+moWzP76yp9snfBetlNPjm+dNPh9GQCNnkazVITwIf/5Vu7pz5FPChOJrKscq
	 kZu3gN804xJ0dmamI7k18co02limrC2X9dqJDsB32fmxZmHtOvQokpcYBRJmyswEFd
	 Wmyc+pPwZNMHcoDY5oeIgkFfEvEXVQQkIKWxUc6wo5t++NnEQOFWxM1nSyNRtDI+Wv
	 RhHV1ywFvtY5u4CriyWcvNDR+toc5i95GRptFOhiiVwdxRopelFKw0h78iNLmbe6jc
	 dTW4w5FDrGbqFCiwkMgHtQYBPhjMPN5anQ+tTm/V9eFMaeKwh5O0txSBhTyZpfLjQe
	 ribqhm5ucjhgQ==
Date: Tue, 24 Nov 2026 15:32:32 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: sm3: De-bloat sm3_block_generic()
Message-ID: <20261124233232.GF2001@quark>
References: <20261124085914.268803-1-ebiggers@kernel.org>
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
In-Reply-To: <20261124085914.268803-1-ebiggers@kernel.org>

On Tue, Nov 24, 2026 at 12:59:14AM -0800, Eric Biggers wrote:
> sm3_block_generic() previously unrolled all 64 rounds, resulting in
> 13049 bytes of .text in lib/crypto/sm3.o, plus a 256-byte K[64] round
> constant table even though all round 0-15 constants are rotations of
> one value and all round 16-63 constants are rotations of one value.
> 
> Therefore, roll up rounds 16-63 into 3 iterations of 16 rounds each, and
> generate the round constants on the fly via rotations.
> 
> This reduces the .text size of lib/crypto/sm3.o from 13049 bytes to 7843
> bytes (a 40% reduction) and removes the 256-byte K[] table.  A benchmark
> of this code showed no significant change in speed.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/sm3.c | 143 ++++++++++++++++-------------------------------
>  1 file changed, 48 insertions(+), 95 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
