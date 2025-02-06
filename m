Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B011A8403;
	Thu,  6 Feb 2025 18:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738868130; cv=none; b=GDudWPeANW+J3+9dgDwE4nQcmm7Pt7CiRcnF4jUZ7VC57WHWDO5YWEst/RWb8N4N8oXekMtlb7DFOn/Ut6WdcePhcs7LoxopcKDE4k/fQ3hco5CEMvcvvuMhMVsx+a/QPjLLZlZFAzstvjaD+lGw8oOoKU+jG+eQjW5uUjxjDW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738868130; c=relaxed/simple;
	bh=zkkxyfIG0OOmQntw88Fk9AnTma1lswnzVnPyXdNOqdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=beZ6C0D288a0ocZ8bFv6sdj4HANa02aS7bsxc5tzrL4YXRfYAqL1v5/teVpDQvHKi8EKQIpRyls2G4ThaBvDxGVcj1/MCQ9D4QJK8zLZ/1Q0eadQA6QlYPd55gOTrI+soG0hEI5jU06jO23xuaau11thO8Dv3kYKXBuYneAuQo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vscQJhMA; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vscQJhMA"
Date: Thu, 6 Feb 2025 18:55:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1738868125;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IE2TFxPKO+IrHATrEX31PKxXzRPzX1be6OBA9ZsVKKY=;
	b=vscQJhMAY8Noh8UAlAt6IUGXd+ej7jSsulqMPFHwxE7ssjb5WRhbWMYhqFOz7e39315g4L
	dwtAE0zr262rNkeRVQ0PNZPOl5XVRC73L2/FpsO0cWrYWtRgAckOuwD3pW/T6hRmnrgtEl
	L5KMr7JTVkZ+QyyYFAlp+BQZXyVrMYQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, 21cnbao@gmail.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v6 12/16] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Message-ID: <Z6UFlV2B47vgpXgt@google.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
 <20250206072102.29045-13-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206072102.29045-13-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 05, 2025 at 11:20:58PM -0800, Kanchana P Sridhar wrote:
> This patch adds support for the per-CPU acomp_ctx to track multiple
> compression/decompression requests. The zswap_cpu_comp_prepare() cpu

nit: s/cpu/CPU

> onlining code will check if the compressor supports batching. If so, it
> will allocate the necessary batching resources.
> 
> However, zswap does not use more than one request yet. Follow-up patches
> will actually utilize the multiple acomp_ctx requests/buffers for batch
> compression/decompression of multiple pages.
> 
> The newly added ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used
> for batching. There is no extra memory usage for compressors that do not
> support batching.

That's not entirely accurate, there's a tiny bit of extra overhead to
allocate the arrays. It can be avoided, but I am not sure it's worth the
complexity.

> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 132 +++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 98 insertions(+), 34 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index a2baceed3bf9..dc7d1ff04b22 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -78,6 +78,16 @@ static bool zswap_pool_reached_full;
>  
>  #define ZSWAP_PARAM_UNSET ""
>  
> +/*
> + * For compression batching of large folios:
> + * Maximum number of acomp compress requests that will be processed
> + * in a batch, iff the zswap compressor supports batching.
> + * This limit exists because we preallocate enough requests and buffers
> + * in the per-cpu acomp_ctx accordingly. Hence, a higher limit means higher
> + * memory usage.
> + */
> +#define ZSWAP_MAX_BATCH_SIZE 8U
> +
>  static int zswap_setup(void);
>  
>  /* Enable/disable zswap */
> @@ -143,9 +153,10 @@ bool zswap_never_enabled(void)
>  
>  struct crypto_acomp_ctx {
>  	struct crypto_acomp *acomp;
> -	struct acomp_req *req;
> +	struct acomp_req **reqs;
> +	u8 **buffers;
> +	unsigned int nr_reqs;
>  	struct crypto_wait wait;
> -	u8 *buffer;
>  	struct mutex mutex;
>  	bool is_sleepable;
>  };
> @@ -821,15 +832,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
>  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
>  	struct crypto_acomp *acomp = NULL;
> -	struct acomp_req *req = NULL;
> -	u8 *buffer = NULL;
> -	int ret;
> +	unsigned int nr_reqs = 1;
> +	int ret = -ENOMEM;
> +	int i;
>  
> -	buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
> -	if (!buffer) {
> -		ret = -ENOMEM;
> -		goto fail;
> -	}
> +	acomp_ctx->buffers = NULL;
> +	acomp_ctx->reqs = NULL;
> +	acomp_ctx->nr_reqs = 0;
>  
>  	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
>  	if (IS_ERR(acomp)) {
> @@ -839,12 +848,30 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  		goto fail;
>  	}
>  
> -	req = acomp_request_alloc(acomp);
> -	if (!req) {
> -		pr_err("could not alloc crypto acomp_request %s\n",
> -		       pool->tfm_name);
> -		ret = -ENOMEM;
> +	if (acomp_has_async_batching(acomp))
> +		nr_reqs = min(ZSWAP_MAX_BATCH_SIZE, crypto_acomp_batch_size(acomp));

Do we need to check acomp_has_async_batching() here? Shouldn't
crypto_acomp_batch_size() just return 1 if batching is not supported?

> +
> +	acomp_ctx->buffers = kcalloc_node(nr_reqs, sizeof(u8 *), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!acomp_ctx->buffers)
> +		goto fail;
> +
> +	for (i = 0; i < nr_reqs; ++i) {
> +		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
> +		if (!acomp_ctx->buffers[i])
> +			goto fail;
> +	}
> +
> +	acomp_ctx->reqs = kcalloc_node(nr_reqs, sizeof(struct acomp_req *), GFP_KERNEL, cpu_to_node(cpu));
> +	if (!acomp_ctx->reqs)
>  		goto fail;
> +
> +	for (i = 0; i < nr_reqs; ++i) {
> +		acomp_ctx->reqs[i] = acomp_request_alloc(acomp);
> +		if (!acomp_ctx->reqs[i]) {
> +			pr_err("could not alloc crypto acomp_request reqs[%d] %s\n",
> +			       i, pool->tfm_name);
> +			goto fail;
> +		}
>  	}
>  
>  	/*
> @@ -853,6 +880,13 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	 * again resulting in a deadlock.
>  	 */
>  	mutex_lock(&acomp_ctx->mutex);

I had moved all the acomp_ctx initializations under the mutex to keep
its state always fully initialized or uninitialized for anyone holding
the lock. With this change, acomp_ctx->reqs will be set to non-NULL
before the mutex is held and the acomp_ctx is fully initialized.

The code in the compression/decompression path uses acomp_ctx->reqes to
check if the acomp_ctx can be used. While I don't believe it's currently
possible for zswap_cpu_comp_prepare() to race with these paths, I did
this to be future proof. I don't want the code to end up initializing
some of the struct under the lock and some of it without it.

So I think there's two options here:
- Do the due diligence check that holding the mutex is not required when
  initializing acomp_ctx here, and remove the mutex locking here
  completely.
- Keep the initializations in the lock critical section (i.e. allocate
  everything first, then initialize under the lock).

> +
> +	/*
> +	 * The crypto_wait is used only in fully synchronous, i.e., with scomp
> +	 * or non-poll mode of acomp, hence there is only one "wait" per
> +	 * acomp_ctx, with callback set to reqs[0], under the assumption that
> +	 * there is at least 1 request per acomp_ctx.
> +	 */
>  	crypto_init_wait(&acomp_ctx->wait);
>  
>  	/*
> @@ -860,20 +894,33 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
>  	 * won't be called, crypto_wait_req() will return without blocking.
>  	 */
> -	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +	acomp_request_set_callback(acomp_ctx->reqs[0], CRYPTO_TFM_REQ_MAY_BACKLOG,
>  				   crypto_req_done, &acomp_ctx->wait);
>  
> -	acomp_ctx->buffer = buffer;
> +	acomp_ctx->nr_reqs = nr_reqs;
>  	acomp_ctx->acomp = acomp;
>  	acomp_ctx->is_sleepable = acomp_is_async(acomp);
> -	acomp_ctx->req = req;
>  	mutex_unlock(&acomp_ctx->mutex);
>  	return 0;
>  
>  fail:
> +	if (acomp_ctx->buffers) {
> +		for (i = 0; i < nr_reqs; ++i)
> +			kfree(acomp_ctx->buffers[i]);
> +		kfree(acomp_ctx->buffers);
> +		acomp_ctx->buffers = NULL;
> +	}
> +
> +	if (acomp_ctx->reqs) {
> +		for (i = 0; i < nr_reqs; ++i)
> +			if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
> +				acomp_request_free(acomp_ctx->reqs[i]);
> +		kfree(acomp_ctx->reqs);
> +		acomp_ctx->reqs = NULL;
> +	}
> +
>  	if (acomp)
>  		crypto_free_acomp(acomp);
> -	kfree(buffer);
>  	return ret;
>  }
>  
> @@ -883,14 +930,31 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
>  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
>  
>  	mutex_lock(&acomp_ctx->mutex);
> +
>  	if (!IS_ERR_OR_NULL(acomp_ctx)) {
> -		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> -			acomp_request_free(acomp_ctx->req);
> -		acomp_ctx->req = NULL;
> +		int i;
> +
> +		if (acomp_ctx->reqs) {
> +			for (i = 0; i < acomp_ctx->nr_reqs; ++i)
> +				if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
> +					acomp_request_free(acomp_ctx->reqs[i]);
> +			kfree(acomp_ctx->reqs);
> +			acomp_ctx->reqs = NULL;
> +		}
> +
> +		if (acomp_ctx->buffers) {
> +			for (i = 0; i < acomp_ctx->nr_reqs; ++i)
> +				kfree(acomp_ctx->buffers[i]);
> +			kfree(acomp_ctx->buffers);
> +			acomp_ctx->buffers = NULL;
> +		}
> +

The code here seems to be almost exactly like the failure path in
zswap_cpu_comp_prepare(), would it be better to put it in a helper?

>  		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
>  			crypto_free_acomp(acomp_ctx->acomp);
> -		kfree(acomp_ctx->buffer);
> +
> +		acomp_ctx->nr_reqs = 0;
>  	}
> +
>  	mutex_unlock(&acomp_ctx->mutex);
>  
>  	return 0;
> @@ -903,7 +967,7 @@ static struct crypto_acomp_ctx *acomp_ctx_get_cpu_lock(struct zswap_pool *pool)
>  	for (;;) {
>  		acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
>  		mutex_lock(&acomp_ctx->mutex);
> -		if (likely(acomp_ctx->req))
> +		if (likely(acomp_ctx->reqs))
>  			return acomp_ctx;
>  		/*
>  		 * It is possible that we were migrated to a different CPU after
> @@ -935,7 +999,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	u8 *dst;
>  
>  	acomp_ctx = acomp_ctx_get_cpu_lock(pool);
> -	dst = acomp_ctx->buffer;
> +	dst = acomp_ctx->buffers[0];
>  	sg_init_table(&input, 1);
>  	sg_set_page(&input, page, PAGE_SIZE, 0);
>  
> @@ -945,7 +1009,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	 * giving the dst buffer with enough length to avoid buffer overflow.
>  	 */
>  	sg_init_one(&output, dst, PAGE_SIZE * 2);
> -	acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SIZE, dlen);
> +	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, PAGE_SIZE, dlen);
>  
>  	/*
>  	 * it maybe looks a little bit silly that we send an asynchronous request,
> @@ -959,8 +1023,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>  	 * but in different threads running on different cpu, we have different
>  	 * acomp instance, so multiple threads can do (de)compression in parallel.
>  	 */
> -	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
> -	dlen = acomp_ctx->req->dlen;
> +	comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);
> +	dlen = acomp_ctx->reqs[0]->dlen;
>  	if (comp_ret)
>  		goto unlock;
>  
> @@ -1011,19 +1075,19 @@ static void zswap_decompress(struct zswap_entry *entry, struct folio *folio)
>  	 */
>  	if ((acomp_ctx->is_sleepable && !zpool_can_sleep_mapped(zpool)) ||
>  	    !virt_addr_valid(src)) {
> -		memcpy(acomp_ctx->buffer, src, entry->length);
> -		src = acomp_ctx->buffer;
> +		memcpy(acomp_ctx->buffers[0], src, entry->length);
> +		src = acomp_ctx->buffers[0];
>  		zpool_unmap_handle(zpool, entry->handle);
>  	}
>  
>  	sg_init_one(&input, src, entry->length);
>  	sg_init_table(&output, 1);
>  	sg_set_folio(&output, folio, PAGE_SIZE, 0);
> -	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, PAGE_SIZE);
> -	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait));
> -	BUG_ON(acomp_ctx->req->dlen != PAGE_SIZE);
> +	acomp_request_set_params(acomp_ctx->reqs[0], &input, &output, entry->length, PAGE_SIZE);
> +	BUG_ON(crypto_wait_req(crypto_acomp_decompress(acomp_ctx->reqs[0]), &acomp_ctx->wait));
> +	BUG_ON(acomp_ctx->reqs[0]->dlen != PAGE_SIZE);
>  
> -	if (src != acomp_ctx->buffer)
> +	if (src != acomp_ctx->buffers[0])
>  		zpool_unmap_handle(zpool, entry->handle);
>  	acomp_ctx_put_unlock(acomp_ctx);
>  }
> -- 
> 2.27.0
> 
