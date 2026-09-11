Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693A230C157;
	Fri, 11 Sep 2026 05:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789103665; cv=none; b=R9a47MqNBBEqWgPuuwcZE2fnkjXCgDmR0VmV8T9MkRKGPfUQSxDQwfAkXze0X8uznm6zkCxvU5rglkC5HmoecGaHBzr5yM9Og+XBV48GaYlOAan24ud09S9aPLiVUZpHCxHKmCez65dp4BdU/Ck0peIULM3tRIzBDdxirxutCM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789103665; c=relaxed/simple;
	bh=IKV2TImPRHHUHlZqCcpRaWmmNquObO9k4YBKNpn75j8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKMRPTDCWZg4/m6yI3RZDZy5ukL6nuErRNt2NNB507wzvRdsuNQS4TUdEYfUYiC6Td8nVC41SiaNgCz1VtSotQ1VuluV2R1XHYX9EnvCsw0KCJKva5sxhK1TfYuCCu89vWLayDzRbQkfbS+E0nwB31FHGzVMPWcK4ITEDsN+8IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=H1JQt/U5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="H1JQt/U5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1+xY5QPHr/IOqkEDcXfU4kirKBllz5ddpdORVXBfRBs=; 
	b=H1JQt/U5qeQ4l5pgkCrThdNzM+VGzhdKTCUCQjxmSwipKmYIxD1DDuKzUKX8a0BNojDOLKl28Uv
	4RKN4+EVelSC3bwSe7OcohPwu3cPhp8pbUFXDrEhhGgleWAZGxfaOYOQbeXIMSZJz65sR4RKQ/1JR
	xDVI/j4Wpeld3O8AdumCH2kc3toYha/MQiGqTi6xTHbHjDQZoBE3IJ85nFakuqMHcWhbuQKebRN9U
	TD1L0rvkwZpxUfhkKL7NO8pc90TJaPHC1EFdFYmwf6EgNX97vLDhFwjGjxLaYK0lQCFE+khHuIz+h
	YrBSGwYLgBaUalBTiBOt0+pn3NZbo77rtxPg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x4taY-0000000Ctvz-2Vl8;
	Fri, 11 Sep 2026 13:14:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Sep 2026 15:14:14 +1000
Date: Fri, 11 Sep 2026 15:14:14 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Cc: clabbe@baylibre.com, davem@davemloft.net, skhan@linuxfoundation.org,
	me@brighamcampbell.com, jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: amlogic: Fix DMA memory leak in cipher error
 path
Message-ID: <aqOOJoA2mVT9270l@gondor.apana.org.au>
References: <20260822084509.26385-1-raizudeen.kerneldev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822084509.26385-1-raizudeen.kerneldev@gmail.com>

On Sat, Aug 22, 2026 at 02:15:08PM +0530, Mohamad Raizudeen wrote:
> A DMA memory leak occurs in meson_cipher() on the mapping error paths.
> The driver jumps to the end of the function without unmapping the
> previously mapped source scatterlist and key/IV buffer when the
> destination apping fails.
> 
> Additionally, a memory leak occurs when a scatterlist mapping succeeds
> but the returned count exceeds the driver's MAXDESC limit. In this case,
> the driver rejects the mapping without unmapping it. The BIDIRECTIONAL
> mapping branch also lacks the required 'MAXDESC -3' upper bound check.
> 
> Fix this by introducing proper error labels, error_src and error_keyiv
> and unmap resources immediately inside the calidation checks to ensure
> all successfully mapped resources are cleaned up before returning the
> error.
> 
> Fixes: 48fe583fe541 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
> Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
> ---
> Changes in v2:
> - Add missing '> MAXDESC - 3' upper bound check for the BIDIRECTIONAL
>   scatterlist mapping branch.
> - Unmap scatterlists immediately inside the 'if' block when the count
>   exceeds MAXDESC - 3, because dma_map_sg() actually succeeds in this
>   case and the mapping must be undone.
> 
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c | 25 ++++++++++++++++-----
>  1 file changed, 20 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
