Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794089204;
	b=LVqvg5ccv3ua8//EKvJz3n4hPPWjhx/+/WLKTKbxaeoh14+HI/IGgvjtBAtPZGi45alA
	 34H8C/nw5rgM3W4hBv8sXAgWdcXRRYA4qO7JHdoId7NaVE19cTEkHwUWNdrCWZY4bZIp5
	 xMzu4Me6zOlqR1HGQy/l1RowidQzDZ/lpbm1oAZjhzo2zv0xMD9fkDER2UY8zfPBgW8HN
	 +LfqfXitBJmoUkR/yElV03fFwXwgqxvlvTyPwMhjq5vM8cW6e6wbKaVrJa3scYTGvXdo2
	 gqMiyF1hZOT9tC35LR0DJiWXrkq4HoWhv4F2O0z5cjcH07I7gUPCsI1xd/kolGIM6+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794089204;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=p2lxket6AddHUfxPLo2hqA+IUByArMD/ioSjhT1+1ug=;
	b=ofl9f7TqD49CFYvyNkWNnTw0301ckY5DUTExaKpzDthg82C77gIk2t12S6u5DPhQGPlb
	 X7hX5UFDJ9SpPVm+rOikDwnHKl/1GN4B7kkJRfSZ8raH4A4O0MDWRspXxPzcF1PVxbzJV
	 MF1wklO0GSgGHto2LzuMcrAbg0Kfmx5uSdFIL4KQ5dfHD8i3RuG5SCsRoOA0zm1LOGbOC
	 cSA1nRiR7zEDSeKPbij0CoF0Gp16cCJB/xMW+xp7eKTYnv4gjrZo4dxDesRCUjVv1ZZnC
	 +8UcaafqecsPyqOg0drWFX11Etvb6Y8QiZE4a/VxxNa1O+UmnYXjsuHZ/0A1WGOKiDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fu8CLSyM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2782606A32C
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 22:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fu8CLSyM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278A31F0089F;
	Sat,  7 Nov 2026 22:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794089203;
	bh=p2lxket6AddHUfxPLo2hqA+IUByArMD/ioSjhT1+1ug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fu8CLSyMW5CxOFJTqrSmWnvysGR3vLbivumEgSvAff0KKN2RoBAfHLu7CP/2q/cJJ
	 rw/YewFyr+Tvw8aCaroHtnicRVr82LMeWMrGSbbTbx0uyrvUQ5M6k8/UsBxGKZWDxB
	 eTUKzYvcyY/1h2ARrPZ8Y8c4PE1i71btNg225d4fDAO35Az+h0dHCc2uIo3Fdx2UDs
	 LHuZsHMtDj2xAqELw/6T+oYflFdr7iu+uxC0Erlr9RNEdDDM/048tqEMx0khL8lOYG
	 C/4CbU3wXbONR/l+EIRaU8oAH1ypzIBfUgj7tvWWr3+Z9ziL7ecdDoR1uaRUIrv00/
	 2ppnrz4aqOE6Q==
Date: Sat, 7 Nov 2026 14:06:41 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>,
	Antonio Quartulli <antonio@mandelbit.com>
Subject: Re: [PATCH] lib/crypto: tests: Add some additional lengths to the
 ChaCha benchmark
Message-ID: <20261107220641.GP137269@quark>
References: <20261104230626.87060-1-ebiggers@kernel.org>
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
In-Reply-To: <20261104230626.87060-1-ebiggers@kernel.org>

On Wed, Nov 04, 2026 at 03:06:26PM -0800, Eric Biggers wrote:
> All the benchmarked lengths below 1420 are multiples of the ChaCha block
> size, and all except 64 are a multiple of 4 blocks.  Add some additional
> lengths to cover a wider variety of situations.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/tests/chacha_kunit.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
