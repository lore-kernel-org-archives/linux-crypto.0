Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794087838;
	b=vulcaGXd1fv8Qx9VWDW+JQ8hIEiBYu6F4Ka5NiliSK5WARiN8a7spqa3/CPr2QyauEQp
	 3SH48Uip30M0ALpAOUdmOhYoc9YDzVi28ExoyqSRhzq5OkeMX3ofkqgiAGqcoMZ+D/5HO
	 ZmenktJEZEy8GvoAll9iC7V0mkbKK/4ioHKiMTiD5PtPFumuVxLekaNwy+3rteZj9ES84
	 XFAl3/Edb512lHPr4Q0b9Dop6Qsiuu4SNjrPJFL1YFPLGTgGsXvgmTPE2Pa8iIyj4jXBw
	 nFFJ/JlGX5BYj6sbSfTA2QqnHpYDPkaXwQ7YebqJ1kdR3DZ+Ph9VCbUeDCnR71ItZoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794087838;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Yeq9A7b0LSn9xu/qZLXbpRaNEdQjL0QdyvJUsqYhZCM=;
	b=cTRa7/OTEEzOHdFoCqY4nJ/kPRur+jXtP2J5K0jjfQyw+Jk+jurl++Tsyk/8L00v4DPd
	 Eztwcu3TpJwYEghDjYWKC/9P0e+Z7QfpizYYP1r9xLXjqfcrmqXlT11WveZflme0Rbunr
	 HvUTUcfkK8H2N1UIqBmP1MlbUnntwOMeVRsTklg/0wn0xx2WCEFQThBePRAW0eBJjVpAM
	 5+2B8+81aKk+Osv2K5Fi03LCLOdxg8cRNjkIpuK4kmo54VoWB/XxZfPRRcnwfBwz//NOl
	 YDyNJ3fl9cO7o0C+L6r3rUY7bd9YpdBP/9quNqejHkI9wnE9cFKlTt2i8+MyzT8lceQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mE9Qnrmd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51235606A326
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 21:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mE9Qnrmd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BDE1F008A1;
	Sat,  7 Nov 2026 21:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087837;
	bh=Yeq9A7b0LSn9xu/qZLXbpRaNEdQjL0QdyvJUsqYhZCM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mE9QnrmdzgZs3MgzgdyT0qCzX6sOZiODd9NcIaKQ5dW42ygtq+G5DwnDcGR7n5oJH
	 O9HGw/Iy2l27JkQ1Fv1TS4u//hdB5bnyCcWn/5crEfl8JR28Gn9BZKdCCpccIlfD2C
	 xpLePw9qiJ6qS7EreMOzh9VeRaDNkUSwXIzJBkpooGjCEZCYXATjChuA0tH5nGrpd9
	 noT+Zb9O4HGJSApNHpI5X+TeYj7Sy9Tpu1yiwnCHG4qy1r7OJW+aJL3SrmylmItv4Y
	 R62djnJcvhYDIjUjXR5P6LDhikMLA+GajYMxa3CIy4krqenzxQGd+6g67Zzyfy+oO7
	 6IJSo3FpTkEuA==
Date: Sat, 7 Nov 2026 13:43:56 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Improve interleaving in
 chacha_8block_xor_avx512vl()
Message-ID: <20261107214356.GF137269@quark>
References: <20261104061209.143901-1-ebiggers@kernel.org>
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
In-Reply-To: <20261104061209.143901-1-ebiggers@kernel.org>

On Tue, Nov 03, 2026 at 10:12:09PM -0800, Eric Biggers wrote:
> The 'VL == 64' case has an optimization that eliminates some 'vmovdqa64'
> instructions, but it was not carried over to the 'VL == 32' case.  Do
> so, and make most of the code that interleaves 64-bit words shared.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/chacha-avx512-x86_64.S | 77 ++++++++++-----------------
>  1 file changed, 27 insertions(+), 50 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
