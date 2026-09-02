Received: from mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6151047F786
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 17:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788369429; cv=none; b=RkOHniDT1RZCArcnMUOLyJGQgrnNqCkzMN6VhnhVkSzc44clSFpVUr4wbgmrkgtY4XVy/EvSeyob/UEFzTMhjr8izWTPB89WFDaL/+KSKzxWTB27J3EwnAfHoGANlo6an/jC3PMmqcjBB0wSyeInkw5NQVSUoIOyHCHvB1T8lvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788369429; c=relaxed/simple;
	bh=kbN2T3HRxTE8CcU7FkVYnjiHCvTMBx8FujkNyQbwo6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u7x0/vJGySCKrlsg9w+eBpzEmiZifdnflSNavXjF5WD6tTcqCBXsy0687EfOVdwhDILXzzwz2pXWZHKNGAJ/2Wxs+IkQ2vzSLpU/7kP0yTVg6/k3CgTLefpqLqXZM54X/S517n+oOH86IXJK5L8bqsrNmNX5wcLQGPw+JUpQ+yA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mJISh18u; arc=none smtp.client-ip=91.218.175.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mJISh18u"
X-Envelope-To: linux-crypto@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=kbN2T3HRxTE8CcU7FkVYnjiHCvTMBx8FujkNyQbwo6o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788369424; v=1; x=1788974224;
 b=mJISh18usSyksGynG0cxc4RIvEDwxbD6UZO69me3t4fCYcBkAmhFblRH4MCX8MCclmC7v3ET
 pvDcw9yrjAovso+kk3C6MLJEbCisS7NOzPaHAr/3PGhpHYA/wOo/i1vEgrFTenEwTKWrGmfibHg
 xnUSzwLfKPw8DyAEK3Y3wukI=
X-Envelope-To: linux-crypto@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 29a99734ea6f9c70;
	Wed, 02 Sep 2026 17:17:04 +0000
X-Mizu-Trace-ID: 29a99734ea6f9c70
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 19:16:57 +0200
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel-tdes - sync output bounce buffer before DMA
Message-ID: <aphaCSSkk_pDjyqz@linux.dev>
References: <20260829045316.92931-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829045316.92931-1-kmehltretter@gmail.com>

On Sat, Aug 29, 2026 at 06:53:16AM +0200, Karl Mehltretter wrote:
> The slow path DMAs into a bounce buffer mapped once at probe with
> DMA_FROM_DEVICE.  On reuse, nothing invalidates the CPU cache for it
> before the DMA writes, so the copy-out can read stale data.
> 
> This was hidden by the copy-out calling dma_sync_single_for_device()
> instead of dma_sync_single_for_cpu(): on ARM the misplaced for_device call
> invalidates the cache, which is exactly what the missing pre-DMA sync
> should have done.  Commit c8a9a647532f ("crypto: atmel-tdes - fix DMA sync
> direction") corrected that call.  On ARM926 dma_unmap_area is a no-op, so
> for_cpu does not invalidate and the SAM9X60 and SAM9X7 parts lost their
> only invalidate.
> 
> With CONFIG_CRYPTO_SELFTESTS=y all four DES/TDES algorithms now fail on
> SAM9X75:
> 
>   alg: skcipher: atmel-ecb-tdes encryption test failed (wrong result) on
>   test vector 2, cfg="unaligned buffer, offset=1"
> 
> Sync the output buffer for the device before starting the DMA, in both
> the PDC and DMA engine paths.
> 
> Fixes: c8a9a647532f ("crypto: atmel-tdes - fix DMA sync direction")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
> Tested on top of:
> 
>   crypto: atmel-tdes - zero-initialize device state
>   https://lore.kernel.org/r/20260829035821.67220-1-kmehltretter@gmail.com/
> 
> Without that fix, on the tested SAM9X75 the DES/TDES self-tests hang on
> their first requests before reaching this test vector, so the failure
> fixed here is not observable on an otherwise unpatched tree.
> 
> The two patches are independent and apply in either order.
> 
>  drivers/crypto/atmel-tdes.c | 4 ++++
>  1 file changed, 4 insertions(+)

The code change looks correct to me.

However, I find the first two paragraphs of the changelog difficult to
understand. Could you please reword those and consistently use full
function names with trailing parentheses?

Thanks,
Thorsten
