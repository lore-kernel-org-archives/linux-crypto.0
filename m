Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168219;
	b=IjYrVfUTMzRu5aYA5R5R9wrCx/6jfGOeGrwiyWEwMU9XOqJlI8JAas3k2Q9NE4f7bNXG
	 kLMkZMOXogGLKkKfaDqdkXdgm+lWhBrJ2n2Ocqbv6ARzwSyPtyhJ9ztiIIDQSrRv6iKRv
	 tUS+HBxnz1w63IFKuUa/vTRwZBu7V9STn8Fb2b1OD5Gk6iW9bh3cCL+RgHuKIefEssmtU
	 FSKIO5JDJLuKjisIPNOyelajqHg95qKXMIuBzEGCy0fmVlxYvbc5HEfNJgHccDaYu3EN0
	 EvoEjJ+yVWeRgqz2J6B1GgLG0ZriVML6RLYDp8jtHxE3FRdVziIMEb4OW6LoC9vhb5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168219;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=F8y3ngxftG0ENPhoLrdIy/L2Ib00nYENk3A0Xinf4Y8=;
	b=Gxqcc+zTxTZ4FjOlsDFQhlCQxdIR+eee182H2F8T2i8woLh8ZkTQWjCYTS1RnQlIQWSl
	 MtB8iY6YmtJerrw10Ju3AhxhGjiGDTGB1W+EvYcQymWX3Vqu/ngwZ8tWCjqjWTalK/1nT
	 in3R0WHqdkVgIc8+7ia8IcIi8I4bxsPY5KvI9QZn91L9PvxqxX2SNUmzjXdI8K6M7LEK4
	 ufq9k8c/4m2QTzuaj0XApwY1hOgUCkvJGZS6TIdZIpzEMsKUFHuIEcof4yAAFzG7+H1Ix
	 pGhv+sKGP8H5rgDc9asXhYpS9i1dLkMVjbEJohDHooq3ESNjMMlNbImYrdsUMguKk4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="SXQ/CEAk";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D0B606A325;
	Fri, 20 Nov 2026 09:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41D0B606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=SXQ/CEAk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=F8y3ngxftG0ENPhoLrdIy/L2Ib00nYENk3A0Xinf4Y8=; 
	b=SXQ/CEAkEl4P6uDfTOq0HyKwpyL6AD4/eU5WMfxxtOWIvNdlkDTETKXyvFUADi2/hbAbOVQ6fzW
	9W8jUDDDZ5PPfNRTmCGsvk3+Dkj4Z5eB1s9MVrDcIdQPaMj8ajBVomlee2zujyxQ9FDAKB62y2qHK
	Bhe35QFgOXPigP6wDgCz/8TwOyrQv+34h+PgoW+5yPkmNyDIW1zG6IFbUKQaBEt/0oy9zm+5z14ou
	wWQskJeK+WvItIUql5WR6YO2Sids11jh1G4Z3UBgOnSoEwgrZsJ56pFz80YFPLEWVcuej/A2Lv9R7
	iPHYLJrEbOLRAW0QtpsdIWoXCt/9e9SxZtOw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xULG0-0000000HYYw-1Bsn;
	Fri, 20 Nov 2026 17:50:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2026 17:50:12 +0800
Date: Fri, 20 Nov 2026 17:50:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: aiyengar1990@gmail.com
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: sun8i-ce - Add AES-XTS for the H616
Message-ID: <awAX1GM9UHkGkgPk@gondor.apana.org.au>
References: <20261110-sun8i-ce-h616-xts-v2-1-0b99efabc1d8@gmail.com>
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
In-Reply-To: <20261110-sun8i-ce-h616-xts-v2-1-0b99efabc1d8@gmail.com>

On Tue, Nov 10, 2026 at 06:25:05AM +0000, Arun Iyengar via B4 Relay wrote:
> From: Arun Iyengar <aiyengar1990@gmail.com>
> 
> The H616 crypto engine has a separate RAES unit (algorithm type 0x30)
> that does AES-ECB, AES-CBC and AES-XTS. Its XTS mode (symmetric mode
> 0b1001) takes the two keys back to back at the key address, the tweak
> at the IV address, and an xts_first/xts_last pair of flags that mark the
> first and the last block of a data unit. The key size field gives the
> size of one of the two keys: 128 or 256 bits, there is no 192-bit XTS.
> 
> Register xts(aes) for the H616: each request is one data unit, so both
> flags are set and the request IV is the tweak of its first block. XTS
> returns no IV, so the CBC write-back of the last block is skipped.
> Ciphertext stealing (lengths that are not a multiple of the block size)
> and two 192-bit keys go to the fallback, as do the requests that the
> existing checks already send there.
> 
> The engine is much slower at XTS than the CPU's ARMv8 AES instructions:
> 4 times slower for 64 KiB requests (213 against 861 MB/s), 8 times for
> 4 KiB and 17 times for 512 bytes. Register it below every CPU
> implementation of xts(aes) (priority 90), so that the CPU stays the
> default, for dm-crypt too, and the engine is only used when it is
> asked for by driver name.
> 
> The other variants get CE_ID_NOTSUPP for the new mode, so nothing
> changes for them.
> 
> Signed-off-by: Arun Iyengar <aiyengar1990@gmail.com>
> ---
> The H616 crypto engine can do AES-XTS in its separate RAES unit. This
> patch registers xts(aes) for the H616, below the CPU implementations
> because the engine is slower than the ARMv8 Crypto Extensions; it stays
> available by driver name (xts-aes-sun8i-ce) for users who want to
> offload the CPU.
> 
> Testing on an Orange Pi Zero2 (H616), v7.3-based kernel with this
> patch (sun8i-ce is unchanged between v7.3 and cryptodev-2.6):
> - the boot-time self-test of xts-aes-sun8i-ce passes, and the testmgr
>   vectors run on the engine (debugfs request counters);
> - 21 known-answer vectors (IEEE 1619 and generated, including
>   ciphertext stealing lengths, which go to the fallback) pass, and 3000
>   random requests (10% with misaligned buffers) give the same result as
>   xts-aes-ce;
> - dm-crypt with capi:xts-aes-sun8i-ce-plain64, 512 and 4096-byte
>   sectors: 48 MiB written and read back with matching sha256, and the
>   raw sectors decrypt with xts-aes-ce; with this priority, xts(aes)
>   and plain aes-xts-plain64 resolve to the CPU's xts-aes-ce;
> - the existing ECB/CBC ciphers, hashes and the TRNG still match their
>   software implementations.
> Throughput, engine against xts-aes-ce: 20/352 MB/s for 512-byte
> requests, 98/759 MB/s for 4 KiB, 213/861 MB/s for 64 KiB.
> 
> This patch was developed with Claude (Anthropic) as a
> coding assistant: it investigated the problem, wrote the code and
> the commit messages. I reviewed it, and it was tested on an
> Orange Pi Zero2 (H616) as described above.
> ---
> Changes in v2:
> - Select CRYPTO_XTS: the xts(aes) transform allocates an xts(aes)
>   fallback in sun8i_ce_cipher_init(), which fails without it (found by
>   the Sashiko AI review).
> - Link to v1: https://patch.msgid.link/20261110-sun8i-ce-h616-xts-v1-1-2fff3eb0807a@gmail.com
> 
> To: Corentin Labbe <clabbe.montjoie@gmail.com>
> To: Herbert Xu <herbert@gondor.apana.org.au>
> To: "David S. Miller" <davem@davemloft.net>
> To: Chen-Yu Tsai <wens@kernel.org>
> To: Jernej Skrabec <jernej.skrabec@gmail.com>
> To: Samuel Holland <samuel@sholland.org>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-sunxi@lists.linux.dev
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/allwinner/Kconfig                   |   1 +
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c    | 102 +++++++++++++++++----
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c  |  44 +++++++--
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h       |  21 ++++-
>  4 files changed, 142 insertions(+), 26 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
