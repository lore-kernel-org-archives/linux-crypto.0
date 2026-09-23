Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736513DA7C8;
	Wed, 23 Sep 2026 08:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153498; cv=none; b=cjEhMXWbfiGGHuHDew6nYZBWupJTsnUPNOV2v7WuxQG1+qA2+GQ0SF2f8FuGeNw1PPqEhXC2d8Erjvg1MawG0PgxT3ux00TeITEB8sT22nwe8aLx7EhXivlUbYImesIv5dtXOS08CP/OqCW5O2wCSbl/FUMXZjw+I4YQx+dgyIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153498; c=relaxed/simple;
	bh=aLBKXpvZfTJo04HN3N5ORd0DcQXkSlyryzEwQns2YgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G4WcGpeLHKbRyhiZyEw7gc5Cdmx67F/yuEUW1+PiF9r0hOozi8IX3mFzs56WhL5KJUgugVr6Fu5kCfUWuEIW6eka+67wWfqSilhGlRzmL87svXZikqEyZaJrUo98zRnd9afrXYy0D9n2KxTcVsX8HrruD6LtLWysvUdChXaCNZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jxSZQ79m; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jxSZQ79m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=tZJAnZPXTSm7jOQD+71qvk/FhQ2GHWrOBjTeZD59zj0=; 
	b=jxSZQ79mboIhc5KsS5kh99j44cUqrgDrCz5wmnpbVitirrg8ncw589szpy6SWxKTsLZeFacHy1O
	KvTbe4skwKuTNjXmoPBY2Z5cY0pGRswM8A4Nn4JToZ63Y4iuuTOis+9YVk0lb8ZR0pjEMGYI1QPJs
	miMVGK9w/dIZNfEAZRHjbYtYh8Vgm65cHB6loV47bDRKnpK8it5MkiEi0990bR1x/xIklh15ACKlR
	7Zrgbqfeg1QWcnTHfqcXEYBp2onQ9NTngCdGVISMpk227TADiM2Sd97x4C4VxdVBmOK0d03VGT3qo
	ZY+4FfMx1unXb8wrWxdjuQ//ZSRcgx/izjJg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9IhL-0000000GyEG-1kdQ;
	Wed, 23 Sep 2026 16:51:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:51:27 +1000
Date: Wed, 23 Sep 2026 18:51:27 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: davem@davemloft.net, clabbe@baylibre.com, skhan@linuxfoundation.org,
	me@brighamcampbell.com, jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] crypto: amlogic: Fix IRQ handler return value and
 fallthrough logic
Message-ID: <arOTD-JgF-kQRLfP@gondor.apana.org.au>
References: <20260918115950.9121-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918115950.9121-1-raizudeen.kerneldev@gmail.com>

On Fri, Sep 18, 2026 at 05:29:50PM +0530, Mohamad Raizudeen wrote:
> In meson_irq_handler(), when an interrupt matches a flow but the status
> register is empty, the driver prints an error but doesn't return. It
> falls through the loop and incorrectly prints an `unknown irq` message.
> 
> Fix this by returning immediately. For empty status registers, return
> IRQ_NONE instead of IRQ_HANDLED to avoid masking spurious interrupts and
> allow the kernel to detect interrupt storms. Also use
> dev_err_ratelimited() to prevent console lockups during an interrupt
> storm.
> 
> Additionally, the handler returned IRQ_HANDLED for genuinely unknown
> interrupts. Return IRQ_NONE instead for unhandled interrupts.
> 
> Cc: stable@vger.kernel.org
> Fixes: 48fe583fe5417 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
> I have addressed the IRQ specific issues in this v3. The other
> pre-exisiting issues mentioned by Sashiko are already addressed in my
> separate patch.
> 
> Changes in v3:
> - Revert accidental clock management changes that were squashed into v2.
> 
> Changes in v2:
> - Return IRQ_NONE instead of IRQ_HANDLED when status register is empty
>   to avoid masking spurious interrupts.
> - Use dev_err_ratelimited() to prevent console lockups.
> 
> Link to v2: https://lore.kernel.org/all/20260918110504.7207-1-raizudeen.kerneldev@gmail.com/T/
> 
>  drivers/crypto/amlogic/amlogic-gxl-core.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
