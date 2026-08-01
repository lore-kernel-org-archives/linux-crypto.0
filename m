Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D543232BF24;
	Sat,  1 Aug 2026 06:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785566277; cv=none; b=NhvIP5aUsyc1RDpOjvXWOopifF7aQmOpBSon5/EpFO10QSf1+PDKAjJLCgW+VE3HsTnMfGLA8AZk8SvL6KxiBQk/ZSYco6gcMbIA/DMm+v5Zb5ZOgPU9B+UDcEBVv48OZOSgvEmxrjhm6OFAGEyuo7V4ocuFjd28nwzA+p8Fy6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785566277; c=relaxed/simple;
	bh=1RDZmT/kS0KFC+9rNt2wvTATXiq502viz8PdaPVBZXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fuxZRgudHEFxJIEmyzsxy8S32di6RmlGePdMiOauSagoM0vuPPuR2ZGxja+Ff+d/oKkcTaEqanwpREbrs/uAmEvfdoAQZoQj3oYC4KSPOZLlb+2wslhs6zpd7TI6oJb2zCaYC0WgnGePI8D9RhnEy+An5mu45nsPf1lijT93okE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Cs2qS1IJ; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Cs2qS1IJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=A8LvQdS8Pj1q8fc7C1zUYWf8H3KJfOVv18nl+GhEBZw=; 
	b=Cs2qS1IJjnos+ihwzJh4ZYphgHJGN0AY1Pk5D8kGTdbHtyD2TQxlb7SgtPh4HcEl/Y2q1RjxVUy
	vKvE7pWHBnlJZSW+5pVFwIu+zdkCQROktV4xAdpT8Hw57rhWZSK80eEH1Ra2bC3CS/5DHuF/OdrBc
	sH9va4/PkvaQqSYXmp2Fiv34HDziQEC32tCduRaUz44vv681qEdm94r+Z9iQhl8PDDzF6Qh/nqy6Z
	zy1ujqihT+HLNxgOnULrictWKcf2D6AXJHGU8UyYNH+M/qmjwdc87olqyKK2LWDkdDRsl4yBQKAup
	eEvw+EQLhBerNcxTGUm03itXPf/pgHWWa/Jg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wq3Lm-000000015kP-1Vm1;
	Sat, 01 Aug 2026 14:37:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 01 Aug 2026 16:37:38 +1000
Date: Sat, 1 Aug 2026 16:37:38 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Changwei Zou <changwei.zou@canonical.com>
Cc: lukas@wunner.de, Martin.Kepplinger-Novakovic@ginzinger.com,
	davem@davemloft.net, ignat@linux.win, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, martink@posteo.de
Subject: Re: [PATCH v5] crypto: rsassa-pkcs1 - Avoid cacheline sharing with
 underlying driver
Message-ID: <am2UMhd5CAhDiKBF@gondor.apana.org.au>
References: <20260731024446.786329-1-changwei.zou@canonical.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731024446.786329-1-changwei.zou@canonical.com>

On Fri, Jul 31, 2026 at 12:44:46PM +1000, Changwei Zou wrote:
> out_buf is used as a DMA buffer for the RSA verification operation.
> If it is not aligned to CRYPTO_DMA_ALIGN, cacheline sharing
> problems (data corruption) would occur on CPUs with DMA-incoherent caches,
> leading to -EKEYREJECTED.
> 
> Rename out_buf to buf, as it serves as both the input and output buffer.
> Add a buf_ptr pointer to track its position.
> 
> Allocate the buffer separately via kmalloc(), which guarantees cacheline
> alignment on architectures without fully coherent DMA.
> This acts as a defensive measure, and avoids the need for an extra copy
> in the underlying driver, which should check alignment before supplying
> buffers to the hardware.
> 
> The intermittent error 'Key was rejected by service' on i.MX8 with CAAM
> can be triggered when loading signed kernel modules.
> 
>     for i in $(seq 1 100); do
>         sudo modprobe xfs 2>&1 && echo "SUCCESS on attempt $i" \
>         && sudo rmmod xfs || echo "FAILED on attempt $i"
>     done
> 
> Signed-off-by: Changwei Zou <changwei.zou@canonical.com>
> ---
>  crypto/rsassa-pkcs1.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)

In the Crypto API we don't ask the user to provide aligned data.

In general it's the driver's responsibility to ensure proper
alignment.  Which driver are we talking about here?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
