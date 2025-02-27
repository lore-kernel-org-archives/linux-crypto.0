Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8331A8F63
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 02:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740623095; cv=none; b=LmnKbbS90O9HJqV+GfyF5ztxaDCN2ep35psA2NzmZ6Mz7QD3JwVUMACohZnfT7foYXjzHlbTj1uZc87NvvAgG5fQy3rVPzInCzgDJQhFA0VqNWjuGFMTQKUJxMLA8/h7XY1rZ4SAqeJDjUUo2s3g8H1+YviFmTI8GFVHGIV6v4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740623095; c=relaxed/simple;
	bh=TQZmTPuXrWsBWP0UxIH5CePpJDuK/lT0ld31ANrFZnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QZaivNgSezt3UNmVUz0c0aUmfUZHxOWfuYBx0Lko2WoOVLrf1cP1LEAgXnlUdIDfktxuDzwp3OTRjXlmd9rmqrz5rzElqTiDCNSi2Z0BTlY4rSbvoUNDUYXD2JGOGm8JvmekCuGvqybRC2+NW41bc2+jjBu6atGWe7bwqR4U5Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tKpN6NKg; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tKpN6NKg"
Message-ID: <08e2e50a-f289-4019-9d74-62ecc45473e3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740623089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GKRxFCKu4oxfV1QzoclFLAwqr7hAo95BPBl9HIQDinE=;
	b=tKpN6NKg6sJnT/SzcNzMIeFUIPKyWoXRe0iH44xHowIwU/Ny37tt8fimJE5m7BcPcOtea2
	qc6c81VOr1vWbV++NsLtU0KJFDBgbiE/kgExIxSUb3sKf9/r5uoC336vrmADpaCL9ITq/B
	k7Sgu+7h80pHH5nZi8V9RtUTEtnKBu4=
Date: Thu, 27 Feb 2025 10:24:40 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: zswap: fix crypto_free_acomp() deadlock in
 zswap_cpu_comp_dead()
To: Yosry Ahmed <yosry.ahmed@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com,
 syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20250226185625.2672936-1-yosry.ahmed@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Chengming Zhou <chengming.zhou@linux.dev>
In-Reply-To: <20250226185625.2672936-1-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 2025/2/27 02:56, Yosry Ahmed wrote:
> Currently, zswap_cpu_comp_dead() calls crypto_free_acomp() while holding
> the per-CPU acomp_ctx mutex. crypto_free_acomp() then holds scomp_lock
> (through crypto_exit_scomp_ops_async()).
> 
> On the other hand, crypto_alloc_acomp_node() holds the scomp_lock
> (through crypto_scomp_init_tfm()), and then allocates memory.
> If the allocation results in reclaim, we may attempt to hold the per-CPU
> acomp_ctx mutex.
> 
> The above dependencies can cause an ABBA deadlock. For example in the
> following scenario:
> 
> (1) Task A running on CPU #1:
>      crypto_alloc_acomp_node()
>        Holds scomp_lock
>        Enters reclaim
>        Reads per_cpu_ptr(pool->acomp_ctx, 1)
> 
> (2) Task A is descheduled
> 
> (3) CPU #1 goes offline
>      zswap_cpu_comp_dead(CPU #1)
>        Holds per_cpu_ptr(pool->acomp_ctx, 1))
>        Calls crypto_free_acomp()
>        Waits for scomp_lock
> 
> (4) Task A running on CPU #2:
>        Waits for per_cpu_ptr(pool->acomp_ctx, 1) // Read on CPU #1
>        DEADLOCK
> 
> Since there is no requirement to call crypto_free_acomp() with the
> per-CPU acomp_ctx mutex held in zswap_cpu_comp_dead(), move it after the
> mutex is unlocked. Also move the acomp_request_free() and kfree() calls
> for consistency and to avoid any potential sublte locking dependencies
> in the future.
> 
> With this, only setting acomp_ctx fields to NULL occurs with the mutex
> held. This is similar to how zswap_cpu_comp_prepare() only initializes
> acomp_ctx fields with the mutex held, after performing all allocations
> before holding the mutex.
> 
> Opportunistically, move the NULL check on acomp_ctx so that it takes
> place before the mutex dereference.
> 
> Fixes: 12dcb0ef5406 ("mm: zswap: properly synchronize freeing resources during CPU hotunplug")
> Reported-by: syzbot+1a517ccfcbc6a7ab0f82@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/67bcea51.050a0220.bbfd1.0096.GAE@google.com/
> Cc: <stable@vger.kernel.org>
> Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Looks good to me:

Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>

Thanks!

> ---
> 
> v1 -> v2:
> - Explained the problem more clearly in the commit message.
> - Moved all freeing calls outside the lock critical section.
> v1: https://lore.kernel.org/all/Z72FJnbA39zWh4zS@gondor.apana.org.au/
> 
> ---
>   mm/zswap.c | 30 ++++++++++++++++++++++--------
>   1 file changed, 22 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index ac9d299e7d0c1..adf745c66aa1d 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -881,18 +881,32 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
>   {
>   	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
>   	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> +	struct acomp_req *req;
> +	struct crypto_acomp *acomp;
> +	u8 *buffer;
> +
> +	if (IS_ERR_OR_NULL(acomp_ctx))
> +		return 0;
>   
>   	mutex_lock(&acomp_ctx->mutex);
> -	if (!IS_ERR_OR_NULL(acomp_ctx)) {
> -		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> -			acomp_request_free(acomp_ctx->req);
> -		acomp_ctx->req = NULL;
> -		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
> -			crypto_free_acomp(acomp_ctx->acomp);
> -		kfree(acomp_ctx->buffer);
> -	}
> +	req = acomp_ctx->req;
> +	acomp = acomp_ctx->acomp;
> +	buffer = acomp_ctx->buffer;
> +	acomp_ctx->req = NULL;
> +	acomp_ctx->acomp = NULL;
> +	acomp_ctx->buffer = NULL;
>   	mutex_unlock(&acomp_ctx->mutex);
>   
> +	/*
> +	 * Do the actual freeing after releasing the mutex to avoid subtle
> +	 * locking dependencies causing deadlocks.
> +	 */
> +	if (!IS_ERR_OR_NULL(req))
> +		acomp_request_free(req);
> +	if (!IS_ERR_OR_NULL(acomp))
> +		crypto_free_acomp(acomp);
> +	kfree(buffer);
> +
>   	return 0;
>   }
>   
