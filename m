Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793964418;
	b=e3H4vYtPcwpY5b0ivpBazEe0R5VyRSP7CdoC156z0aA65l1XFWvsv+kgjHoGNvcfs18o
	 /kICkt6bK41Aa3738caE3WckV6bUzdhmxAgHhBuNPccF+a0KiaSn4D9ZcljRI09IDAmYO
	 fFhgXXbvmWTtCpRzE2eliIsgwYNPAKIUkS/F4KfvO+9wKXwCbq2YHpxXsIl8MVFQhnuDx
	 9zvHQiQ6z61BoniKKpacX8RD5vFA+krGNhpqQTbWvNEFWUAiBsSYZ6TlHzjYvkkgBL7I3
	 1NxM3mnnaIsmgGlHLAPw/zLQ0jcgmDPEMfUFV+22FDA//5pL6J7RPD3egwmlnVAqCbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793964418;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=gtDHs1lK4UDCMDSlXDMGlo5f6T+XxW7/J9Yz5EktHQU=;
	b=zr4LSy224XZWglJsnM49xHy158ScLg8176Aho4YGrvWCPDLhloFZbsCqluPHOGn1MLdV
	 AJCZV6I07I4HL56Ffo8N82R33zIMMON18v3PWJZHgPpCEhKH8HFHHxOlZ8tAkQOZpKyu6
	 t2lg2S/2SbOfVJ2QjKRCpAksTUvZgtuiyddGMbHcs9cTHSYMPhG+Q9zt2qr+FPpi3QPgV
	 d5JMf3IkpGY91+CNZsSoM6l/iF+aO2JsZjOv85ZLAADvuO5gYOeHpzQWcnJ9wgIXKdh/e
	 MSmaPSZGDGxmd8mKPnRN8KEGCXqlKoodk1qKm/3EacRnGr/Uj72fh3JdIhIX0qe0BEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=DdHQCcU6;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2917D606A334;
	Fri,  6 Nov 2026 11:26:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2917D606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=DdHQCcU6
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=gtDHs1lK4UDCMDSlXDMGlo5f6T+XxW7/J9Yz5EktHQU=; 
	b=DdHQCcU6YPxvGwl1wli+KwUUpFXxW4VFrsRZJUgK1PeBdTNIVQOs3PlQNgDnmYIv7IsqXKw2OHk
	rcvOjB/kO6uv/XiC98PkpFawrxv07H6iu1Kdyj1f1Lg2/z0YtH2j4YwyX5qJ1XwjnbOXKrdjrNiPo
	KUg4iyRsV/BddPxadus3nlADkTumofiUgY+tTwyFO79aGYNIIf83VttduwB7jcXrUuqaRlIdPB6ZU
	eFc6daBPpEoUTPv0zJV2TxXzhQSlSKo+/QVSnnBZFSvbiQ5ojshT/Ev8xekz2wlFJJFknK2HPcSTY
	z2X2fzIttt4027GRmMvakerxJ40SO+xLC56A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPI5u-0000000Br1T-1Qpz;
	Fri, 06 Nov 2026 19:26:55 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:26:54 +0800
Date: Fri, 6 Nov 2026 19:26:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Hadar Gat <hadar.gat@arm.com>, Olivia Mackall <olivia@selenic.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: cctrng - fix destination offset in cctrng_read()
Message-ID: <au25fpJBNt1lSLPI@gondor.apana.org.au>
References: <20261015103933.337335-2-blum@kernel.org>
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
In-Reply-To: <20261015103933.337335-2-blum@kernel.org>

On Thu, Oct 15, 2026 at 12:39:34PM +0200, Thorsten Blum wrote:
> cctrng_read() copies random data in two steps when a read wraps around
> the end of the circular buffer.
> 
> Use the correct destination offset for the second copy instead of
> overwriting the start of the destination buffer.
> 
> Fixes: a583ed310bb6 ("hwrng: cctrng - introduce Arm CryptoCell driver")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/cctrng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
