Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794088121;
	b=UhxLJ2hiLzt4fWsPgH6bOvFeDUXaZiukFcoTlkioYmjAzbJuNALPt3Z2ZxKYx96YUALU
	 S9baYhJ5uBUJNGFMpdrRnkPbAmHonAnplhhGz6gUC4NuTlxo24Sdj7r8+sdhcERkt0ROv
	 YNAlrbJipyK2Tne8bh1UwRMpbgRvltWqH9awFmtaTQ08wHC/CwRzF+tVXw6wrsZlH8eF2
	 lyjNsNr64D0v24ISKfd+gk5GjD3O50afThtOPJwX+kDnu65KY4FDOF55YlPPihqU8/azN
	 Lm0fPKci7BDQDfx0VNCX5upRE/V1FzqEV6jCWTieBFBQ/rKvkTUfstVPCdzVD0jmrsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794088121;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wwYvm2bDM8aSjVqV04xi/hd2ryIALcISEFIbJN3M/0E=;
	b=dm2Cb8BwUooFw8ySx/s732o4YSD3E/ELe3HMWP1OnpolF5UGx/0PQpT+H7DSBtWQuAX1
	 QmngO6d+niLc4znoIyk1OOsLca8W+amA6gkMzYLI1w7Dgbqt7LpxEunf/3g11MQQHcDyt
	 vGMFSXXI+ZfLiNhMpdmA6Yfsh55yd/cGJjdmSv5n3/5ynMYXNIy9xGIoq9GKNvNvrieXy
	 BErnCqFlxijVh7nQNg01LR1QgFXK9+Q+76UopQRJSxO01vrWT78RdBzBfQvUwhfcigMaA
	 q94hPIWztJ4jR1+dCO1nsZL9U2XjwngFCO5lwCN7KsmDuYtKGTXpW5BDiC8fJW1nI5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=idCqqtOD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A2D606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 21:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=idCqqtOD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA0541F0089F;
	Sat,  7 Nov 2026 21:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794088120;
	bh=wwYvm2bDM8aSjVqV04xi/hd2ryIALcISEFIbJN3M/0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=idCqqtODRLQg+cM4UQ9WyuRq2UT1fRpsAqgF+Y3+sI/0Vu0noF0OuoVKopWuvk5Ki
	 1QuEyMMv3BfeBTHs3PVYNp1bBW0BiPUNo0VlohzI4gfJfmLZbuWl05r0lDBujBzChs
	 Kg4hK5SF42ecLr5KE5amQ5GUuW3/wbqw1jK8cN6LSrvdjLyWvLyJYAfzNYxEnCec3p
	 AHEXLoYTCgfqkiQb9StIGEJC9QIRsza6hxQ+3DDlha3jkZuiS3+QS0azq3+cuhImVs
	 l28bbZ0/8jG0Oi3pmB8aKm799msyhjbCzZ33rK5wz4IflUIrbmDYWT4+Gf1f+qky6M
	 d9osuMjIbNPww==
Date: Sat, 7 Nov 2026 13:48:39 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Simplify chacha_dosimd()
Message-ID: <20261107214839.GH137269@quark>
References: <20261104081604.302414-1-ebiggers@kernel.org>
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
In-Reply-To: <20261104081604.302414-1-ebiggers@kernel.org>

On Wed, Nov 04, 2026 at 12:16:04AM -0800, Eric Biggers wrote:
> - Use if-else statements to make the logic clearer, eliminate excessive
>   not-taken branches for certain lengths (e.g., 16-block aligned
>   lengths), and consolidate a lot of the counter increments.
> 
> - Eliminate the unnecessary chacha_advance() function.
>   DIV_ROUND_UP(bytes, CHACHA_BLOCK_SIZE) is just as good.
>   The min() clamp did nothing.
> 
> - Don't pass a length greater than N blocks to the assembly functions
>   that process N blocks.  They all accepted it and just processed the
>   first N blocks anyway, but there's no need to rely on that.
> 
> The behavior is unchanged for every length.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/chacha.h | 128 +++++++++++++++++-----------------------
>  1 file changed, 54 insertions(+), 74 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
