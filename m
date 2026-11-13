Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575444;
	b=DoYnKKn70u3oIg7rMeORQLJ3MmcBjRif34EFUebu7Ht6qnMRCT1xoUcsToQ7psjYJnHf
	 eyr08T5bRXPCtoI0VVNOSmL81gQCc8dMoiyqRgITSUCcyjvXIFCZkuPRF/9K9zkBdsgoR
	 vCHnjORR/AMTHi6mYKEqf7A6jHBsn4YuBx+PP9j9PVsSvwPJdPSSWsS92q3oeoWBbOtxm
	 ohd4M60Xk8WuHlEo3khEiDkAfbr0AYzOekYx3aVVU8RD8W/v4QjT7ka4MVLhGXCQLuMxK
	 +uUrLjSlxPWmjyAxiybOsfkwpt93/9oUL9nxU8crUYGVLub4d3rHv+BMw/WsNEuX0Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575444;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=UGOxoRNSfHEnbUMGAa0kQHhxwEo/ZMAj5RmH7SI98p4=;
	b=5cgGQZVKBwkZoQx/vzuXaWemgBrXt/sryn2gsoiM8h9pWTaD07FpOm4TFzsF8BBugBtT
	 YVi3Uc5NLlh5nZCu4kc6u38Wsr4t32NpaJSkAAikN2aGjw83sMY8gUF+OV5gMuFmRVjTe
	 oULwj/9rB+oi/p06e9XW6U8wJf2dsT8sCinmbkjNO1TPdssvfZThP0yod9KWxt2a1JJaY
	 mx1jnQcev6+oD3B/4tSEzz4gzscCFhqPTzRo/9Z8yRQ8YaQNe2wLhuwImOkSikyrRN77H
	 xeQ+PDble5p2tcBmOCIIScXseOz2O7/hPb56+b2dj32I5tnB2eoWX7YjyhJ62T8I8Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=quCmY2Fk;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B180D606A338;
	Fri, 13 Nov 2026 13:10:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B180D606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=quCmY2Fk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=UGOxoRNSfHEnbUMGAa0kQHhxwEo/ZMAj5RmH7SI98p4=; 
	b=quCmY2Fk44wltT1SW8m2cAz/GyeHvLDs7vn8NEV8m7Ctey3IOf8WYJ7f8IoInD6VRI7cpB30zim
	C81YvWBTycD6TBHD7Y18cop4q2H9S+s0hO19vUlPMjI8mTdRe5by2+GriRzTeGX8m6rh/XZNjRxTD
	WwGHlcohn+wN1Qhcog5FCoEAxzlC3lNhleJWqLZ039tI6fWRyKiY5R4mzpO5q625sg1G3j8s9yO2Q
	LirKmeSN9W3+H1ytoV4/SjbxBRdUsd5TVlmcqlw2fOrU8Jf1uuwRfqXRlLINBjIOjxkI8HTGn+D7i
	7gsdJdbaVXGSDYarv1qUDtCSnvPf8tXQOMJw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRr39-0000000EfOz-2C5L;
	Fri, 13 Nov 2026 21:10:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:10:39 +0800
Date: Fri, 13 Nov 2026 21:10:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Xiang Lei <leixiang@kylinos.cn>
Cc: Wei Liu <liuwei@kylinos.cn>, stable@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Olivia Mackall <olivia@selenic.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	virtualization@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: virtio - fix copy_data() handling of partial reads
Message-ID: <avcMT4v5mo4XT493@gondor.apana.org.au>
References: <20261105071736.65932-1-leixiang@kylinos.cn>
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
In-Reply-To: <20261105071736.65932-1-leixiang@kylinos.cn>

On Thu, Nov 05, 2026 at 03:17:33PM +0800, Xiang Lei wrote:
> vi->data_avail is decremented on each read, so it holds the remaining
> bytes rather than the total length. Subtracting vi->data_idx from it
> again in commit e3046eeada29 ("hwrng: virtio: clamp device-reported
> used.len at copy_data()") undercounts the bytes left after a partial
> read. This can leave vi->data_avail nonzero without queuing a new
> request, causing virtio_read() to hang on have_data.
> 
> Clamp vi->data_avail to sizeof(vi->data) - vi->data_idx instead.
> 
> Fixes: e3046eeada29 ("hwrng: virtio: clamp device-reported used.len at copy_data()")
> Tested-by: Wei Liu <liuwei@kylinos.cn>
> Cc: stable@vger.kernel.org
> Signed-off-by: Xiang Lei <leixiang@kylinos.cn>
> ---
>  drivers/char/hw_random/virtio-rng.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
