Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14C540DFA7;
	Tue,  5 May 2026 09:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777973250; cv=none; b=oxaFdWzqKfUgMJ1WQYYBpIDEgj+UXCk80OkaRkuo/a6naKLXHV+mZcQR2Qzt3RXziP2hlTbCbeGXlId+HqPi7ulCBbp6YQlrXrJXONlge+xIN/y+ZxuOLoFnP3J2UmXPewGTS4ybus9847GZpxJitBefFtT1IiOoP6B+ZKQO0oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777973250; c=relaxed/simple;
	bh=6cDJz+g/aJYdg5ND5lXRiP2Om/zKysRVBFDj3f8sm4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oghvc12hp+0pbs2RQcoTtfh4scYjxd1wJzf6ILRdYNcPUY/tV1XLQxtGNkHx6PKaCU++Nvzw33m8VKnr0nYjREbDlv4aUPfKPU4gqv0RwfdGPuKxFOQReOQyz4ecfh/6RpwSSEtOhMvI/IrNSebaUMN3YWSCF9kOBk6xMtuu4yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=sG7AklXy; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="sG7AklXy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+AXtKqd4hursGhJ7ysYyzDvc1qaibPoD+s00h+TaKbc=; 
	b=sG7AklXyvYyiQ8BjEyZUNeNRuNCC6x8wSTQp9Tm0d2USXuCdoLyN9JR1KpsDmk3DekpI78YI4SV
	6Vudpfk9UQe/BDZCJnaOy5WkC4CzHxVIENTeOI5Ht4f90U+4tQRxnvUX91NsoBZvwOxJZGFZM/6Kl
	UE2hee1Ft4vEOBv7UDxSNCQ+MZDl5dBKJ8ooyfgv0VITLu6Z3fsiKaWR53ORD/RehxswOGBsD9SBy
	AyBbLaOReKgF02y++3pxwn434vmaDUP9yhn2f5xWZM6w7p+5Xi9sajndJbSzHE7/fwFwucpDUkjqL
	QJjl84ERj25t0eQbpzt0vpU7oq4b6ocwVChA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKC3Y-00BNtc-10;
	Tue, 05 May 2026 17:27:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 17:27:08 +0800
Date: Tue, 5 May 2026 17:27:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lothar Rubusch <l.rubusch@gmail.com>
Cc: thorsten.blum@linux.dev, davem@davemloft.net,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev, ardb@kernel.org, linusw@kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] crypto: atmel-sha204a - fix blocking and
 non-blocking rng logic
Message-ID: <afm37IhzvsAQCZj1@gondor.apana.org.au>
References: <20260426212947.24757-1-l.rubusch@gmail.com>
 <20260426212947.24757-2-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260426212947.24757-2-l.rubusch@gmail.com>

On Sun, Apr 26, 2026 at 09:29:47PM +0000, Lothar Rubusch wrote:
> The blocking and non-blocking paths were failing to provide valid entropy
> due to improper buffer management. Reading the buffer starting from byte 1,
> only fetch the 32 bytes of random data from the return message.
> 
> Tested on an Atmel SHA204A device.
> 
> Before (here for blocking), tests showed repeatedly reading reduced bytes.
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@..........|
> 00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00000020
> 
> After, the result will be similar to the following:
> $ head -c 32 /dev/hwrng | hexdump -C
> 00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h....n.i|
> 00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;.....ESL.|
> 00000020
> 
> Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
> ---
>  drivers/crypto/atmel-sha204a.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
