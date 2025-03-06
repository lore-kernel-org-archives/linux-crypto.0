Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2589342A8C
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 20:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741291274; cv=none; b=QTF2ZKINh0IU1qXN0Cr+SX2YNpv+csz/Eic3HzD67IGbP+k8poFkA1LFhv9cqR8zaYHBu8xL3BTYqqaYrTQahW1El4P0TChin7L4MZ8w7IICgzksomWtFtJ2+5Q0JwyABvpdkfPgt6nGMb4OoQd8VsjdiTloS/QQbHG65gyCvBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741291274; c=relaxed/simple;
	bh=p3D36DfA6Q0ab8MTdVKveItYTB107li6XDhZ7rP21fU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RVtC0Sj+J54R05tjzrpkhtuIF3e/hr/El5zKK4u4yS1WOjlJsk8KtOCqLTDRNsiVpW6uv5vyzG3U7fRjnXLbOoFlrm8+ayXbI7rJwDeZU0afNH55bcJ0yrR9nLeTv7n6UU3PCe1wZubvNH4nvP6XAieUStzbHzuZBzlwYnP77L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G7Iolmsw; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G7Iolmsw"
Date: Thu, 6 Mar 2025 20:00:58 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741291269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KIQjkd+El4xk0mW5CsC/gYtOwzQYTEyP0qN+CtiWc2Y=;
	b=G7IolmswqePx/eqlqvXsVVauUbL96WQHy2/ONPb50ME3/+r34UmLYN5mHQUbBnHHOKV9gl
	rCSRKAYPr6hYZMWnAJ4Jq77npiF9+OF7AWBXSAgub073C8SXhTgcj+5s0Fj8fEkCTkrbIJ
	1PdZjwsg24HBUN4JjKGeWnK+4bGkLHE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v8 13/14] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
Message-ID: <Z8n--rF3H2-uWhEc@google.com>
References: <20250303084724.6490-1-kanchana.p.sridhar@intel.com>
 <20250303084724.6490-14-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303084724.6490-14-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 03, 2025 at 12:47:23AM -0800, Kanchana P Sridhar wrote:
> This patch adds support for the per-CPU acomp_ctx to track multiple
> compression/decompression requests and multiple compression destination
> buffers. The zswap_cpu_comp_prepare() CPU onlining code will get the
> maximum batch-size the compressor supports. If so, it will allocate the
> necessary batching resources.
> 
> However, zswap does not use more than one request yet. Follow-up patches
> will actually utilize the multiple acomp_ctx requests/buffers for batch
> compression/decompression of multiple pages.
> 
> The newly added ZSWAP_MAX_BATCH_SIZE limits the amount of extra memory used
> for batching. There is a small extra memory overhead of allocating the
> "reqs" and "buffers" arrays for compressors that do not support batching.

That's two pointers per-CPU (i.e. 16 bytes on x86_64), right? Please
call that out in the commit log.

> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 99 +++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 69 insertions(+), 30 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index cff96df1df8b..fae59d6d5147 100644
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

That's too verbose. Let's do something like:

/* Limit the batch size to limit per-CPU memory usage for reqs and buffers */
#define ZSWAP_MAX_BATCH_SIZE 8U

> +#define ZSWAP_MAX_BATCH_SIZE 8U
> +
>  static int zswap_setup(void);
>  
>  /* Enable/disable zswap */
> @@ -143,8 +153,8 @@ bool zswap_never_enabled(void)
>  
>  struct crypto_acomp_ctx {
>  	struct crypto_acomp *acomp;
> -	struct acomp_req *req;
> -	u8 *buffer;
> +	struct acomp_req **reqs;
> +	u8 **buffers;
>  	u8 nr_reqs;
>  	struct crypto_wait wait;
>  	struct mutex mutex;
> @@ -251,13 +261,22 @@ static void __zswap_pool_empty(struct percpu_ref *ref);
>  static void acomp_ctx_dealloc(struct crypto_acomp_ctx *acomp_ctx)
>  {
>  	if (!IS_ERR_OR_NULL(acomp_ctx) && acomp_ctx->nr_reqs) {
> +		u8 i;
> +
> +		if (acomp_ctx->reqs) {
> +			for (i = 0; i < acomp_ctx->nr_reqs; ++i)
> +				if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))

Hmm I just realized we check IS_ERR_OR_NULL() here for the requests, but
only a NULL check in zswap_cpu_comp_prepare(). We also check
IS_ERR_OR_NULL here for acomp, but only IS_ERR() in
zswap_cpu_comp_prepare().

This doesn't make sense. Would you be able to include a patch before
this one to make these consistent? I can also send a follow up patch.

> +					acomp_request_free(acomp_ctx->reqs[i]);

Please add braces for the for loop here for readability, since the body
has more than one line, even if it's technically not required.

> +			kfree(acomp_ctx->reqs);
> +			acomp_ctx->reqs = NULL;
> +		}
>  
> -		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> -			acomp_request_free(acomp_ctx->req);
> -		acomp_ctx->req = NULL;
> -
> -		kfree(acomp_ctx->buffer);
> -		acomp_ctx->buffer = NULL;
> +		if (acomp_ctx->buffers) {
> +			for (i = 0; i < acomp_ctx->nr_reqs; ++i)
> +				kfree(acomp_ctx->buffers[i]);
> +			kfree(acomp_ctx->buffers);
> +			acomp_ctx->buffers = NULL;
> +		}
>  
>  		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
>  			crypto_free_acomp(acomp_ctx->acomp);
> @@ -271,6 +290,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
>  	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
>  	int ret = -ENOMEM;
> +	u8 i;
>  
>  	/*
>  	 * Just to be even more fail-safe against changes in assumptions and/or
> @@ -292,22 +312,41 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  		goto fail;
>  	}
>  
> -	acomp_ctx->nr_reqs = 1;
> +	acomp_ctx->nr_reqs = min(ZSWAP_MAX_BATCH_SIZE,
> +				 crypto_acomp_batch_size(acomp_ctx->acomp));
>  
> -	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
> -	if (!acomp_ctx->req) {
> -		pr_err("could not alloc crypto acomp_request %s\n",
> -		       pool->tfm_name);
> -		ret = -ENOMEM;
> +	acomp_ctx->reqs = kcalloc_node(acomp_ctx->nr_reqs, sizeof(struct acomp_req *),
> +				       GFP_KERNEL, cpu_to_node(cpu));
> +	if (!acomp_ctx->reqs)
>  		goto fail;
> +
> +	for (i = 0; i < acomp_ctx->nr_reqs; ++i) {
> +		acomp_ctx->reqs[i] = acomp_request_alloc(acomp_ctx->acomp);
> +		if (!acomp_ctx->reqs[i]) {
> +			pr_err("could not alloc crypto acomp_request reqs[%d] %s\n",
> +				i, pool->tfm_name);
> +			goto fail;
> +		}
>  	}
>  
> -	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
> -	if (!acomp_ctx->buffer) {
> -		ret = -ENOMEM;
> +	acomp_ctx->buffers = kcalloc_node(acomp_ctx->nr_reqs, sizeof(u8 *),
> +					  GFP_KERNEL, cpu_to_node(cpu));
> +	if (!acomp_ctx->buffers)
>  		goto fail;
> +
> +	for (i = 0; i < acomp_ctx->nr_reqs; ++i) {
> +		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL,
> +						     cpu_to_node(cpu));
> +		if (!acomp_ctx->buffers[i])
> +			goto fail;
>  	}
>  
> +	/*
> +	 * The crypto_wait is used only in fully synchronous, i.e., with scomp
> +	 * or non-poll mode of acomp, hence there is only one "wait" per
> +	 * acomp_ctx, with callback set to reqs[0], under the assumption that
> +	 * there is at least 1 request per acomp_ctx.
> +	 */

I am not sure I understand. Does this say that we assume that scomp or
non-poll acomp will never use batching so having a single "wait" is
fine?

If so, this needs to be enforced at runtime or at least have a warning,
and not just mentioned in a comment, in case batching support is ever
added for these. Please clarify.

We should also probably merge the comments above crypto_init_wait() and
acomp_request_set_callback() now.

>  	crypto_init_wait(&acomp_ctx->wait);
>  
>  	/*
