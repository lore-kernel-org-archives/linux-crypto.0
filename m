Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8057D44A3FF;
	Fri,  2 Oct 2026 08:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790929372; cv=none; b=uRrzx6DvM2mUk0R2FFw+beYVR2d+VuJVJvDm9RSUFxCPMHoluB0Lrwp2Oi5s6dzdG6OzHaqm68f/MAkJspTe1CBBUrNh5WdPp8y6pCaXwdo4qHqoBZQScfsJIm9hV4bXqWZUSRGoEoS+8OLdtEhll8yjUsr00/PavjO1bjQuKcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790929372; c=relaxed/simple;
	bh=4m11iMv9bOecIJDPB0+FdW9kJy69slLmSQL0lnPQ2E8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gwGLL9LeTWl1qqrOch18YK3LYcij7j708E1PkMYHJ96Loro2BfGtmJz4sHOJMxw3NB4p1luNdsShIy0bmYM3uRTSN15UjaFdpsUsxO1B04RavYjEIl8cFXJGSljniJIVaTCyzvD4dWADJZhvaTOs2NfCnvbMK64wNFbWG2RmR4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=WY+d0LJZ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="WY+d0LJZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=0PWBOAxh6pB7yhyuxCFuZWO6P8AnQ9qs3MPE/RqHYsc=; 
	b=WY+d0LJZDoCgQ3bUFxOJ7aME+oR4uwFqTy1VSx8d1HhSHu0OXzaaQdIRDTnJ/8sOkFD4tSI4RD/
	HfjcuxcfrPKV5E6QAXLkCvQGDlNM1EbdXQFqnC1Ds1jSOU1A7UPlVQ8ezAKSAbf4sf9C3cqvn7kZh
	ljA/d5MmOsysbttYJ/+9nNxnC3Oce+wgCc51jck5+QuTwIZbARxHx4+Cu2dEhdUUzQBtb6yBhWKc7
	M87cVBz4eAQd0muXmsZNiO8Uf4ouXfV5Ay30tucjv5eaOM0GmYESAgty0BjP334L+YC6uXebaA073
	jXueFzfHiYiBhQq8aCN5SYbyuXnh9JsDk6TQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCYXR-00000002mcO-45Rh;
	Fri, 02 Oct 2026 16:22:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 18:22:41 +1000
Date: Fri, 2 Oct 2026 18:22:41 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Cyrille Pitchen <cyrille.pitchen@atmel.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel: handle authenc requests without plaintext
Message-ID: <ar9p0Z7wA-5TDQA7@gondor.apana.org.au>
References: <20260922051705.15329-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922051705.15329-1-kmehltretter@gmail.com>

On Tue, Sep 22, 2026 at 07:17:04AM +0200, Karl Mehltretter wrote:
> Authenc permits a nonempty associated-data string with no plaintext.  The
> Atmel driver accepts such a request, has SHA process the associated data,
> and then unconditionally asks AES DMA to transfer zero bytes.  The Atmel
> DMA engines reject the zero-length descriptor, so the valid request fails,
> normally with -ENOMEM.
> 
> Skip the AES transfer when textlen is zero and proceed directly to SHA
> finalization.
> 
> Once an HMAC transform has cached its inner and outer states, SHA can
> complete this path synchronously.  The forced ahash completion callback
> then invokes the AES finalizer through a void function and discards its
> return value.  This loses -EBADMSG for a mismatched tag and reports
> successful decryption.
> 
> For synchronous SHA completion, release the SHA device without invoking
> the ahash callback and call the AES finalizer directly.  Its result then
> propagates through the synchronous call chain.  Keep the existing callback
> path for asynchronous completion.
> 
> On a SAM9X75, the unpatched driver failed valid AAD-only requests and
> returned success for a bad tag after the transform had been used once. With
> this change, bad tags return -EBADMSG for both fresh and reused transforms.
> 
> Fixes: 89a82ef87e01 ("crypto: atmel-authenc - add support to authenc(hmac(shaX), Y(aes)) modes")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  drivers/crypto/atmel-aes.c |  2 ++
>  drivers/crypto/atmel-sha.c | 14 ++++++++++++++
>  2 files changed, 16 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
