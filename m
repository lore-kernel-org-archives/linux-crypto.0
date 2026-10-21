Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792616151;
	b=d3rBdsy2lDE7CWPBnj2q0KgGH7TTIjBhs22xvnQTc19FSkcWIF7HlVmNW9KYrbmgk+cS
	 hgrCjDhlxlJ9z4k4IQv1KiLrgeFFStJUJH493hrL8FCE6yMmfixEUbYhZYraKbB0Ns1OV
	 CxNQsNXouH475FZeFJOA4pVlJ4lrpecKYZwopVipxdS51lMecmNUqUw5ARXrEnd3LCS49
	 erXLq6Xd19/9yhWTU1nTYcPlBSbtMLWht0GUjLxP41GeIewQb6qxYDCa6AZePmcR4X88/
	 NfZM9mQYCrnlH/EI0pxKVqyMcvbW+1bIYG+4rne0vUvKXAaVQhBOcUgjXnghdTdORAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792616151;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=+kHDcFKAebWh/fdaiF4B4Hir8cR5mfAXxhXutVdjX+Q=;
	b=NC+oQlxjub8i/O7/Ztvj1fvDDDjhMTEJFVuaUi3RCZTTrbkivMUbinlyXI5w/YbITi/T
	 2TC4ZHSCBtMubz5BHWPdsxpx+Mz/eWKCAth15KSDFOFWcmEf6z2znyB5+zkx+2Y1eFbUi
	 uTe7NwXKTRcial7cNEsXbxOsj96eBtU3eztz48ZQIKV7uuBQs8bvM0auAmrd6JpGnbiGi
	 mUu8124nxd7uC2fIEM+iIPc3fApTUQYgih33BqD44k/XD886WQF3EyslEK4btNCVr8bAw
	 Kw+Xbf/0xTVWENYWuKCKzYvAvgLZh3NkgTyUTYEW6vVVKhtPN98K8Fy0+SjGITLuQ1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BBgXk45F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3C5606A319;
	Wed, 21 Oct 2026 20:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BBgXk45F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE77C1F000C2;
	Wed, 21 Oct 2026 20:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792616150;
	bh=+kHDcFKAebWh/fdaiF4B4Hir8cR5mfAXxhXutVdjX+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BBgXk45Fp8UyQsZiq6asJKNdBkBH38swbY26we2W5tTohLpus+1NYQOL8k0JSMCAq
	 cZkxWURhsH+3kYr4QKmAhfKq2dZKAtCSJ2m4VBH4opoywKtPnx7EGLWHKdizz96Ap/
	 56jphQMSmC6o28TXTJV43FQ9PZrGUZ/FV/deEPq7KL/p4wjAPrK+ao3a+Dlp3mXWXv
	 HgnfWSYoM6MU9S7uMYQZDGhFlo8bulmmq+Ei71kYyByEKut1BQGUn5aAm0a91D0vOa
	 MNFt7KwtBG9GZNSGwDpUBzIWuXcElGjqyh+RGF08B02xJfqP8lbnMcpIda9PXkQMUr
	 ONsmHI7FWvccA==
Date: Wed, 21 Oct 2026 20:55:48 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Artem Dinaburg <artem@trailofbits.com>
Cc: stable@vger.kernel.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, ldy3087146292@gmail.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	n05ec@lzu.edu.cn, tomapufckgml@gmail.com, yifanwucs@gmail.com,
	yuantan098@gmail.com
Subject: Re: [PATCH 6.6.y] crypto: af_alg - limit RX SG extraction by receive
 buffer budget
Message-ID: <20261021205548.GB2210933@google.com>
References: <20261021175405.1542-1-artem@trailofbits.com>
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
In-Reply-To: <20261021175405.1542-1-artem@trailofbits.com>

On Wed, Oct 21, 2026 at 01:54:05PM -0400, Artem Dinaburg wrote:
> [ Backport to 6.6.y: Add braces to the older block-size conditional so the
>   new short-block error check and existing rounding remain under the same
>   condition. ]
> Signed-off-by: Artem Dinaburg <artem@trailofbits.com>

Seems this was already done in 7e345de2e69475430af85e09210795d8eb8e719c,
which is the same custom backport diff.  It was recently released in
6.6.y without any public discussion.  Fortunately the backport looks
okay, I think.  Odd that the stable maintainers are applying custom
backports to the crypto/ directory without Cc'ing linux-crypto, though.

- Eric
