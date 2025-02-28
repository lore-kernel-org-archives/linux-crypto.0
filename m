Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E5D1B4250
	for <linux-crypto@vger.kernel.org>; Fri, 28 Feb 2025 15:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740758217; cv=none; b=U6gmpOPTVG9lLdpUe5rLj2n3zdCamiMPSAKuPg1C8mKU/xEYM+urZA51PmBCUGnP4pAqUCdJ0uMPsv0kOCk+WsyUVGAgquxyOaN3udm4elXSMKmywopJ/qDKBueGEoIugyZ2rOyf4kAHa7CDDNwjeoA4rgXkGBqFzIbqpJaPvQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740758217; c=relaxed/simple;
	bh=poWNCj5xMSlpbSrDe5ZEIFaXwVdfgabe4T/iGvOcgII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ifRi1TtG5rg7vQGGeTByiID+LTL/J8zvfnV5kmliM4PVb4WgVZfhFVnoR2msV3lU5CECBjA9yBWgH9X5BQbYyJ39hPXqyYEiIan5JgngOl998tpMgMdKW0tKXeqXqnbgCSxfzit26AGjRu9X2k7jHe+LJmdtapGHc8b1Pe/QC6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UTN4PPD9; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UTN4PPD9"
Date: Fri, 28 Feb 2025 15:56:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740758212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w32+r2cAmTHBJrdauH2LehW60U9RaeZZJ4Z4Qx1e26c=;
	b=UTN4PPD9K6cdNA/dBhCcBrpZof1Zqc7KlN7i3SuhOuwZftLiV+lsdhBvtet/SU8Sdn9AAy
	+TpHF4BS9yWckHz+3LBj31fOavq0ph1JB7e6vCiMQIOMnXhrcmgl+dnR4PTiRkNK7AHn3n
	400MXHtEuv0R4MteybvvfflrQv7Vufk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8Hcur3T82_FiONj@google.com>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
 <Z8CquB-BZrP5JFYg@google.com>
 <20250227183847.GB1613@sol.localdomain>
 <Z8DcmK4eECXp3aws@google.com>
 <Z8FwFJ4iMLuvo3Jj@gondor.apana.org.au>
 <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8GH7VssQGR1ujHV@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 28, 2025 at 05:54:53PM +0800, Herbert Xu wrote:
> On Fri, Feb 28, 2025 at 04:13:08PM +0800, Herbert Xu wrote:
> >
> > I'll respin this.
> 
> FWIW this is what the interface looks like.  Does it look OK?
> Longer term hardware offload drivers should handle these non-DMA
> pointers directly by having their own buffers.  For the time being
> I'm simply redirecting these to a software fallback.
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 2b5a2398a9be..2fd241c65f80 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -994,30 +994,16 @@ static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  
>  	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
>  	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
> -	/*
> -	 * If zpool_map_handle is atomic, we cannot reliably utilize its mapped buffer
> -	 * to do crypto_acomp_decompress() which might sleep. In such cases, we must
> -	 * resort to copying the buffer to a temporary one.
> -	 * Meanwhile, zpool_map_handle() might return a non-linearly mapped buffer,
> -	 * such as a kmap address of high memory or even ever a vmap address.
> -	 * However, sg_init_one is only equipped to handle linearly mapped low memory.
> -	 * In such cases, we also must copy the buffer to a temporary and lowmem one.
> -	 */
> -	if ((acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) ||
> -	    !virt_addr_valid(src)) {
> -		memcpy(acomp_ctx->buffer, src, entry->length);
> -		src = acomp_ctx->buffer;
> -		zpool_unmap_handle(zpool, entry->handle);
> -	}
> -
>  	dst = kmap_local_folio(folio, 0);
> -	acomp_request_set_virt(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);
> +	if (!zpool_can_sleep_mapped(zpool) || !virt_addr_valid(src))

Why is the acomp_ctx->is_sleepable check no longer needed?

Also, the zpool_can_sleep_mapped() cases will go away soon-ish, so I was
kinda hoping that the !virt_addr_valid() case goes away too and is
handled internally in the crypto library. Right now the problem is that
virt_to_page() is used to get the underlying page, which doesn't work
for kmap addresses.

> +		acomp_request_set_nondma(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);
> +	else
> +		acomp_request_set_virt(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);
>  	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
>  	kunmap_local(dst);
>  	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
>  
> -	if (src != acomp_ctx->buffer)
> -		zpool_unmap_handle(zpool, entry->handle);
> +	zpool_unmap_handle(zpool, entry->handle);
>  	acomp_ctx_put_unlock(acomp_ctx);
>  }
> 
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
