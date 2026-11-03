Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748448;
	b=aVuIRx6zHfd3YGREApMTiUgp1pStEFfChH5oY0jl1U2s5G2MjyUMPrD6WWcf5XVmwHFm
	 ea++eq8U3pq7j3kmHrQ86cRey5JQcNtKpbwNFTocH9quPQZQ18/154yBlfDga493zp2Ri
	 QT0Qo6bq0fY1Y2ZA4FajRp9tGlg/cpC9UDKHOGxnKCt5c3aoElkwJ0RJcCYrTx3N6H1K1
	 /f88N3xvIy9qvGzUMHiteHT9xiL2CnV0b8+et3c6cSM0QV+VpN03hz6exjaVHnfIwHH/A
	 TL4zSjdTVaXf+AmzsspToCIzIc7uEC2h3iBy2+S7q+nxB+RpJlUuWq0LxRjD5ZYOHNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748448;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=GS3dHwXvndcPKYeuijXe6bXyVybE++moIwoOoWXjt6w=;
	b=I5naveV1yztaCY2nRkD7ElYyW3G7AO2XbPsuPHWoIOYV5JzTgEO8DQC5Lom5tlAfrHbT
	 mc5Wl6s9zmujLZf+V4pzWstKJJ9F8ChfFT8eZNC2tAHsB9DepLd+7QjSt/ZSG00pQ8XlC
	 yM7UzZ5Ta8JAuT2e6hwQ7q6FHbDViXBWYOlSgBOSzaSqLBQ6699qmhVxA5qN83xIxyoZk
	 faihFA7FfhLNniEH/JZR+nSAjivvcutueMdqdDH8GXPEoxOPWIITY+Ow85fd46VT70jno
	 lhrtT+FkposHs+hUni0h1OanTAnXXgKY2CIpcxvFUfKp2lUrmd3RbnAaZYDmiWD5pIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GzO8AYZn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C67A606A31B
	for <linux-crypto@vger.kernel.org>; Tue,  3 Nov 2026 23:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GzO8AYZn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177A71F000C1;
	Tue,  3 Nov 2026 23:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793748448;
	bh=GS3dHwXvndcPKYeuijXe6bXyVybE++moIwoOoWXjt6w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GzO8AYZnUDANC2YtRAPOwzQTMypSFNt8UAIG8TZHlEqJWXQx0T2Q+nV6GmYWlTe88
	 uSva4I4zNpHHj76Fgeq+/aOoLRSUVXUUrbtI0HbolP/tU6lGWpBo70lymREvmuw+mB
	 igQiALRfKurncQOWcU+RNDzCQ50QzYP/DMO1Rys8TUoEEgmzyG5msSRMGoyunXZecX
	 RmdTN6BimOPTKTpjt3u9CzxVPlukiyF6Uzr1omtGymt0vsf65zr6PnvFKcfULrVbVD
	 SryikLyMg4kFUbC258RcuzZhJPTRehwk8HritRsC5PzvenCRkugPyoal1CkDC1KAFF
	 HNygrrc7gyOUQ==
Date: Tue, 3 Nov 2026 15:27:26 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: gf128mul: Hide selection mask values from
 compilers
Message-ID: <20261103232726.GJ2281@quark>
References: <20261031052154.202008-1-ebiggers@kernel.org>
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
In-Reply-To: <20261031052154.202008-1-ebiggers@kernel.org>

On Fri, Oct 30, 2026 at 10:21:54PM -0700, Eric Biggers wrote:
> Hide selection mask values from compilers, so that they cannot see that
> they are used to select between two values and potentially generate a
> secret-dependent branch.  This is not known to be happening here, but we
> might as well be extra careful.
> 
> For the cases where the selected values are only 0x87 and 0, change the
> type of the mask to 'unsigned long' so that the compiler is not forced
> to materialize it in a register pair on 32-bit architectures.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  include/crypto/gf128mul.h | 25 +++++++++----------------
>  1 file changed, 9 insertions(+), 16 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
