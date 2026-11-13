Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575237;
	b=iaMHnAez0+AbjWbq22B7CVNsect51KJ4/J15Ud/1l13QEVUHqyJPibR8mrbka6kWEiVG
	 uSDwUvHnOLf2vX5P7BdjHyd7VRR8qsJ3jp/rgBGcLBPkPzeTWujNwBznUL+CcikcDVKFU
	 tTvj2aaFwRoKUmQjfpqL1RbM7x6pxvDxp+6END0P0HfLemSnORmKfFpUmaMU29pOK52DX
	 qm8uYGAf+KXTju4K7HK2USgjtLUS9O7RAvW64OT8SAh8A6/VX1izddt5j+gsDitaUltWB
	 2yMXN44g2vu6XATwyMAjbG9r/6H4By41getbKE3KsAdXvLGDehk61YYVBzGmMxPZIgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575237;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=DUGPFr5Wh/Z+vIMfALoBdOXy7jgFXRU3APLIkgC69Nk=;
	b=NHiJ1J2TU1oXnpb8tv0RBhqT243bBaynsVUKP5XydnxVJYatx1WCTiyCSC3NWcr8bFa6
	 bsxfCWK7okMq/fKdDmpma6fxP2Ntw4DlMcUbeZzaruI0vEPLb+8iHMK3ZW8/EgYImEfcH
	 uXYJ/zYjpaRd8zqBcyP6BXPZwhr8uNOVADH5Wce6TLSqCPQtPKUXHXjSTIFBe+qjjvWa4
	 /nCRPcu6ANVkzTeTtTQyQ+nyuonsI409CqlTKXuf8z1rCtHsrjwpZlyEoUZc1Ccs/WOcN
	 /0YCRnLSX8YKgb7RjISzq356xVpMvpUOJDuimZkwXq6axaT76pG57m49nP8dpO5pKWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=i9FKclK7;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1A9606A8B3;
	Fri, 13 Nov 2026 13:07:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A1A9606A8B3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=i9FKclK7
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DUGPFr5Wh/Z+vIMfALoBdOXy7jgFXRU3APLIkgC69Nk=; 
	b=i9FKclK7kLg8xe+iH2b16KBBcNUI/qbiMcgavMaGB2McNiME3fHg2pZd/jhx/8j3b/KU7sEyX+p
	8twfM5Cqgj69R5W/VF5DcguXckWD9NHYqrmKo2qbji/JE/coFGjBJPAmyQCeA1jFQjv4OIUa1oKU+
	Bi4GiDzkj4IwRbTIND7Qsxlau4kv+uuMhYRkNRn7ZtQVoq4jipdeS0ZoXUSC7gdw1Lk4mlOgTZ42p
	qAcS988v7Au45pXVLv0loVq54ro0wCqfEydbPDE91znHT8GEjsxIO94SCFkYxXEgMAktqt+xWVkS2
	PAe42mTDHe7/BeAESf7F2kNwqJ4mNG48aZ7w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqzp-0000000EfKa-3ayM;
	Fri, 13 Nov 2026 21:07:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:07:13 +0800
Date: Fri, 13 Nov 2026 21:07:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
	Tero Kristo <t-kristo@ti.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sa2ul - remove redundant 0x prefixes
Message-ID: <avcLgY4l37b8a7UJ@gondor.apana.org.au>
References: <20261103213242.480649-2-blum@kernel.org>
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
In-Reply-To: <20261103213242.480649-2-blum@kernel.org>

On Tue, Nov 03, 2026 at 10:32:43PM +0100, Thorsten Blum wrote:
> The %pad format specifier already includes the 0x prefix. Remove the
> redundant prefixes to avoid printing 0x0x.
> 
> Also remove the duplicate colon from the security context dump message.
> 
> Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
> Fixes: 2dc53d004745 ("crypto: sa2ul - add sha1/sha256/sha512 support")
> Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/crypto/sa2ul.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
