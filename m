Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD911F5831
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 18:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740679874; cv=none; b=Y4ucpXvroiV0zi3mF2jrxZsQbCr/YXb9evoVrUI0fz2LmBH8E9lBGDlZdoO5XbpvdBfvibqh32UikZ8Szxp/6Qy4XC8rDCQ14gLHaYRnQQypLzzxgV80OL7pdmHzi39M8ymsFBWDpCqGF67QpmXzz/XOOrhyRHKwUXJa7X8ZU1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740679874; c=relaxed/simple;
	bh=/qmPog0J3Z1xqKeHn8D5f6Cifg4hVB5717+jvOcyW8k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mo/qx3eSkT/nxdWF4mWQsMyh6stAFfoH3hg6nf7OIlYK0oHRHQ7aan0phq9XU2zKCywjUq84Ogtm2wWWYuf5VVo6XShNiwuEHuiHDXUnQQeVlL8EemXKxjzcod9zl7cysJdScqiGuHXZqqJMo7OhjqhwFCtzWMu71LCrCxXNt4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZwyyxpOe; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZwyyxpOe"
Date: Thu, 27 Feb 2025 18:11:04 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740679868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Vha+HdJ4Dr83Xx3BxpIJutRU0kj2A2mEZsUp/xMp81E=;
	b=ZwyyxpOee2tTFOQbjqjwolk+7pC7JwCaXFN15Gq8QL5sngiZ7asHtHk5+753QYb93UaGzE
	R9/5SInf5z9Y/F20jqCIqJYXHQD9dQVxosNm0J6r3f3qiQv44aiia1CPMOTZUpqvaAEXdI
	CoW+tlNY6xmfDDh3VyYM/XmCgiDJ4q4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
Message-ID: <Z8CquB-BZrP5JFYg@google.com>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
 <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153c340a52090f2ff82f8f066203186a932d3f99.1740651138.git.herbert@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

On Thu, Feb 27, 2025 at 06:15:09PM +0800, Herbert Xu wrote:
> Use the acomp virtual address interface.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

I can't speak to the rest of the series, but I like what this patch is
doing in zswap. Together with the recent zsmalloc changes, we should be
able to drop the alternative memcpy path completely, without needing to
use kmap_to_page() or removing the warning the highmem code.

Thanks for doing this!

> ---
>  mm/zswap.c | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 6504174fbc6a..2b5a2398a9be 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -925,27 +925,20 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  			   struct zswap_pool *pool)
>  {
>  	struct crypto_acomp_ctx *acomp_ctx;
> -	struct scatterlist input, output;
>  	int comp_ret = 0, alloc_ret = 0;
>  	unsigned int dlen = PAGE_SIZE;
>  	unsigned long handle;
>  	struct zpool *zpool;
> +	const u8 *src;
>  	char *buf;
>  	gfp_t gfp;
>  	u8 *dst;
>  
>  	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
> +	src = kmap_local_page(page);
>  	dst = acomp_ctx->buffer;
> -	sg_init_table(&input, 1);
> -	sg_set_page(&input, page, PAGE_SIZE, 0);
>  
> -	/*
> -	 * We need PAGE_SIZE * 2 here since there maybe over-compression case,
> -	 * and hardware-accelerators may won't check the dst buffer size, so
> -	 * giving the dst buffer with enough length to avoid buffer overflow.
> -	 */
> -	sg_init_one(&output, dst, PAGE_SIZE * 2);
> -	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
> +	acomp_request_set_virt(acomp_ctx->req, src, dst, PAGE_SIZE, dlen);
>  
>  	/*
>  	 * it maybe looks a little bit silly that we send an asynchronous request,
> @@ -960,6 +953,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	 * acomp instance, so multiple threads can do (de)compression in parallel.
>  	 */
>  	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
> +	kunmap_local(src);
>  	dlen = acomp_ctx->req->dlen;
>  	if (comp_ret)
>  		goto unlock;
> @@ -994,9 +988,9 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  {
>  	struct zpool *zpool = entry->pool->zpool;
> -	struct scatterlist input, output;
>  	struct crypto_acomp_ctx *acomp_ctx;
>  	u8 *src;
> +	u8 *dst;
>  
>  	acomp_ctx = acomp_ctx_get_cpu_lock(entry->pool);
>  	src = zpool_map_handle(zpool, entry->handle, ZPOOL_MM_RO);
> @@ -1016,11 +1010,10 @@ static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  		zpool_unmap_handle(zpool, entry->handle);
>  	}
>  
> -	sg_init_one(&input, src, entry->length);
> -	sg_init_table(&output, 1);
> -	sg_set_folio(&output, folio, PAGE_SIZE, 0);
> -	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
> +	dst = kmap_local_folio(folio, 0);
> +	acomp_request_set_virt(acomp_ctx->req, src, dst, entry->length, PAGE_SIZE);
>  	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
> +	kunmap_local(dst);
>  	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
>  
>  	if (src != acomp_ctx->buffer)
> -- 
> 2.39.5
> 
