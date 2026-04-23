Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C78F2505AA;
	Thu, 23 Apr 2026 08:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776931900; cv=none; b=qD6IYYS+jsBzrQsj4u+y3o91R99TjRhfIQhNTMz3pTIVxMl8zyCAOtKh2yFtb72yt28Z8AnHUTrRR/38SS36hIJl954zwyg6BpQZbmuVnlObrBY1fpcfGreJGDTsDY3GRALQCiL3JzrRjM1+jOiro5QRSwZZiuppA6jH3r0iYuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776931900; c=relaxed/simple;
	bh=X7qMHyUIcTR6sI2hQnb0ZdDWviuFox9rZp+I/nVstQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9BC6/kMly81rXEctjlnfdP//MC6tX+cqk6O/TOo9EbTVY5QNSodHCmUpaj5O2e1P/2IIJquRAL5z1S5DVzb5pEihs7DA716UJUOcPuMid1pvdT/xf9X7jfTLYf9KXGHhDBkdFPu2bhdiGtB0vYZqH4wDVSoYD/ebDR151kyyEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=UGcplMJW; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="UGcplMJW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DfCGKlwNf3gbn1SnAZgrVTttc3K70VeizSyG/plH/so=; 
	b=UGcplMJWZzlfolzxJ5ffP5ehhBXz6CL8iK6PtFizeAFLhT1Vaglu3sbYnegHpWeXwVceMY9JoW4
	r9LRS/qKebdQl6q30riZBy0c/fl6TaGSUQHFYW8fMzI8mCP5DXAzeXqy9RqPBxGCQCp0/z/MquBh6
	4+6CmdI1RMKjQb0s7GCdz9+pwHrSUjJn+uBrtP53sbphcK6BqIGwQkKNeT1OJr99Uf8eLJKRGQ/DY
	oIlo8wLJ3Z0YnpD5MACDzVK0yPyWqUTo+i3f0gA3VrWBSXg4kw5doUDlRh/MKboXgg3+hp33KkEMu
	mrLdghgHKPKSqqeOfrOypmftbvr7g6+NbXUw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wFp9Y-008AvE-1I;
	Thu, 23 Apr 2026 16:11:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Apr 2026 16:11:16 +0800
Date: Thu, 23 Apr 2026 16:11:16 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: clabbe@baylibre.com, linusw@kernel.org, kaloz@openwrt.org,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ixp4xx: Fix null-pointer dereference in
 chainup_buffers()
Message-ID: <aenUJLufZ5cK7DmQ@gondor.apana.org.au>
References: <20260421093917.1001688-1-ruoyuw560@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421093917.1001688-1-ruoyuw560@gmail.com>

On Tue, Apr 21, 2026 at 05:39:17PM +0800, Ruoyu Wang wrote:
> chainup_buffers() builds a linked list of buffer descriptors for a
> scatterlist. If dma_pool_alloc() fails while constructing the list, the
> current code sets buf to NULL and later dereferences it unconditionally
> at the end of the function:
> 
>   buf->next = NULL;
>   buf->phys_next = 0;
> 
> This can lead to a null-pointer dereference on allocation failure.
> 
> If the failure happens after part of the descriptor chain has already
> been allocated and DMA-mapped, the partially constructed chain also
> needs to be released.
> 
> Fix this by unwinding the partially constructed chain, resetting the
> caller-provided hook descriptor, and returning NULL on allocation
> failure.
> 
> Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
> ---
>  drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c | 24 +++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
> index fcc0cf4df637..63ef28cd5766 100644
> --- a/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
> +++ b/drivers/crypto/intel/ixp4xx/ixp4xx_crypto.c
> @@ -874,6 +874,11 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
>  		struct buffer_desc *buf, gfp_t flags,
>  		enum dma_data_direction dir)
>  {
> +	struct buffer_desc *first = buf;
> +
> +	first->next = NULL;
> +	first->phys_next = 0;
> +
>  	for (; nbytes > 0; sg = sg_next(sg)) {
>  		unsigned int len = min(nbytes, sg->length);
>  		struct buffer_desc *next_buf;
> @@ -883,10 +888,15 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
>  		nbytes -= len;
>  		ptr = sg_virt(sg);
>  		next_buf = dma_pool_alloc(buffer_pool, flags, &next_buf_phys);
> -		if (!next_buf) {
> -			buf = NULL;
> -			break;
> -		}
> +		if (!next_buf)
> +			goto err_unwind;
> +
> +		/*
> +		 * Keep the chain well-formed even on partial construction,
> +		 * so free_buf_chain() can safely unwind it on failure.
> +		 */
> +		next_buf->next = NULL;
> +		next_buf->phys_next = 0;
>  		sg_dma_address(sg) = dma_map_single(dev, ptr, len, dir);
>  		buf->next = next_buf;
>  		buf->phys_next = next_buf_phys;
> @@ -899,6 +909,12 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
>  	buf->next = NULL;
>  	buf->phys_next = 0;
>  	return buf;
> +
> +err_unwind:
> +	free_buf_chain(dev, first->next, first->phys_next);
> +	first->next = NULL;
> +	first->phys_next = 0;
> +	return NULL;

All callers of chainup_buffers try to unwind by calling free_buf_chain
too, although a couple of them might do so incorrectly.

It looks like the callers need the unwind path anyway, so perhaps
just fix up the callers so that their unwind paths actually work?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
