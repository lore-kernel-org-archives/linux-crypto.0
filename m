Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E633F660F;
	Fri,  4 Sep 2026 09:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788513212; cv=none; b=Nw9a7Y88UiN+y3k5zSx5eWqe9OHrhNGEU6tjJmq2AaYkNzVsTRTuan5YsUVtvsstOoUMgW3iQIvKifFIHUBKud7X2E63lXMeSAQNLI3QqxN4FFLsWwd2UV4L0vMAs0Ev22a5/4wvmTmYY3m7YhvfeIqNO/VyX72Gigp10Z3NaJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788513212; c=relaxed/simple;
	bh=PNgOuWR3hWZ+geE3VJR3KqNxizclly7v01wx9I/J1iI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEpKOLyMAWQlcf83WHaNCrA7i4m0lC/3xRcBCsiFmyF98ksai5+hCRqgizQdexpZAa1IAQoZSIEKr6CUiX8E+RrqJ/zbp5zkK4pxuVHP6n87h6KrxGSwtq+TRxeRYxmOkgfTRfDZjEFmG937D7DcbPyF6ACrbonOw+PWWypVglM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=W6sLDSIt; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="W6sLDSIt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=UiVtkh2Fc0czoI1SWhtXl+HBkwpgO0Sq6mnpA6bemS0=; 
	b=W6sLDSItViY0Y5J7VKqwskPi9RJSPXUlfpIRTvFbdPrHRWvAJkKUUF1eIInXtq+tskjJotvJHVD
	J6NbZdTFYDF9nM7R3eE0h54xu1J5EuiyWICdIrGeonCx1Kov7ztsYQElurBRCllGLYCC7oTsKaj1p
	QgqXDzrh6cnK+bj14aGcXkgs9ea3IVUkfZ4LdVNo4ZW0x3wmayq34rLlK7eYmFupgqkrpbRegDw1T
	gCLx/SJm0YicQGwYq7HemMUElhmIfZkS6rj7eQvswrNfs0W1hQTQOd18v80xz2HxkkcBpBUMge/4a
	6UBxdgYf7qzAt5K4N2A4RoMgMJEyIlcn2E2A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2PzB-0000000AmH4-2Mqv;
	Fri, 04 Sep 2026 17:13:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:13:25 +1000
Date: Fri, 4 Sep 2026 19:13:25 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] crypto: amcc - fix missing DMA memory barriers in
 descriptor handling
Message-ID: <apqLtd_LlMvzb6Mf@gondor.apana.org.au>
References: <20260811044738.160653-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811044738.160653-1-rosenp@gmail.com>

On Mon, Aug 10, 2026 at 09:47:38PM -0700, Rosen Penev wrote:
> Fix two memory ordering bugs in the AMCC crypto driver:
> 
> 1. In crypto4xx_bh_tasklet_cb(), add a dma_rmb() between reading the
>    PD_CTL_PE_DONE bit (with READ_ONCE) and reading the descriptor and DMA
>    buffer data in crypto4xx_pd_done().  Without it, the CPU on a
>    weakly-ordered architecture could read stale descriptor data before the
>    hardware's writes are globally visible.
> 
> 2. In crypto4xx_build_pd(), add a dma_wmb() before writing
>    PD_CTL_HOST_READY to ensure all descriptor and SA data is visible to
>    the device before the ownership handover bit.  Also fix the descriptor
>    field ordering: pd_ctl_len.w must be written before pd_ctl.w (which
>    contains HOST_READY), not after, to prevent the hardware from fetching
>    uninitialized length data.
> 
> Fixes: f6c48b76daa6 (crypto: amcc - Add crypto4xx-aead cryptographic
>   AEAD accelerator driver)
> Cc: stable@vger.kernel.org
> Assisted-by: opencode:big-pickle
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v2: add descriptions for write barriers.
>  drivers/crypto/amcc/crypto4xx_core.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
> index fd010bfb7020..4b0ce165c198 100644
> --- a/drivers/crypto/amcc/crypto4xx_core.c
> +++ b/drivers/crypto/amcc/crypto4xx_core.c
> @@ -876,11 +876,17 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
>  		}
>  	}
>  
> +	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
> +	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
> +
> +	/* make the pd_ctl_len and pd_uinfo->state writes above visible to
> +	 * the device before the HOST_READY handover write below, so the
> +	 * device never fetches a descriptor with stale length/state bits
> +	 */
> +	dma_wmb();
>  	pd->pd_ctl.w = PD_CTL_HOST_READY |
>  		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
>  			PD_CTL_HASH_FINAL : 0);
> -	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
> -	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
>  
>  	wmb();
>  	/* write any value to push engine to read a pd */

I would've thought that the hardware is only able to start reading
after this wmb() and the subsequent writes.  If this isn't the case
then plesae explain how the whole sequence works.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
