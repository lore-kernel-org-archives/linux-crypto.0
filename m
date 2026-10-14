Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD6B550DC1;
	Wed, 14 Oct 2026 15:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791992583; cv=none; b=ZS4T0x2dD7ovvLCT8hpnD9YXdCX2yQmt0M4UioHhG+kkeZdA9S5wZYABjxr+yLm4HiaThBx4g/z4InHZXTN2ptd5+fnqINgLJcWxzLenh1T+4+Dh2YbaVsoE+9OcRdVtJ9kJDOX5Pk6CJyNwUNbABdWrMeK+XEvHTLDKTJRX0u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791992583; c=relaxed/simple;
	bh=y8CvCf0j720DBOOvGBswPWAtRcIxqm90FUdb7UEbwpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aisk0TLYshOJnIEm1qJT3Xnv+rxxftfE57ULUlCdHOsY0WEFYS66HgsrL4YjK/216ROfbDMXwYj+bP4zlOv+xJNZvEEN3N+G0Kq5DMtpa8WhVXRzegBta01Nvd8XDPOlwMC920SCGcnf3PFZP1pS+dKKlBbHufL8NOVVf5Wqyg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YrjPYeeo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YrjPYeeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191461F000C4;
	Wed, 14 Oct 2026 15:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791992579;
	bh=x5flC3L20m+iLt4xEeRpaLTdVCyzEflv5E4h1ZeBXs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YrjPYeeoYntaT08ARzU9b0Pbs4033S8tl+zqqJfkVR9SmHq6tep9wn/bN+e8dmId4
	 j/Ub7bQiOEsOq1Vk4gYOQbq7Xdm14IoxOCxQAzKFGgHieHy2nKx1VjkWfjC6wS4u7+
	 JrIm4p/VrMHAOPVk6VA8Ypz9nsbNWdPrVA8DjRUmKNrtubtDOfOmthw/QHlWnc9Jgk
	 P/xclEupRT/t60X7JZasdjWrginJzHVLppkwQ4J7IMO2oh30MCgulPbOS3WK3+lBuy
	 inE4EgVlTw5ebQJU/dAR0cCIGxpwceXM94z9C6nm4DfB8wuPbaaHkro0XHwNv8qsKQ
	 zR4fp5qBo5bvA==
Date: Wed, 14 Oct 2026 15:42:57 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 7/8] mm: zswap: Optimally place members of struct
 zswap_pool, struct zswap_entry.
Message-ID: <as-izeIj5bP01bna@google.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-8-kanchanapsridhar2026@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008182814.27450-8-kanchanapsridhar2026@gmail.com>

On Thu, Oct 08, 2026 at 11:28:13AM -0700, Kanchana P. Sridhar wrote:
> Place and align the members of struct zswap_pool and struct zswap_entry
> such that members used together in compress/decompress hot paths are
> able to share the same cacheline. Minimize holes within these structs
> while doing so.
> 
> Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> ---
>  mm/zswap.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 8ae67fd10522..ade84ac4076e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -160,11 +160,11 @@ struct crypto_acomp_ctx {
>  struct zswap_pool {
>  	struct zs_pool *zs_pool;
>  	struct crypto_acomp_ctx __percpu *acomp_ctx;
> -	u8 compr_batch_size;
>  	struct percpu_ref ref;
> -	struct rcu_work release_rwork;
> -	struct hlist_node node;
>  	u8 idx;
> +	u8 compr_batch_size;
> +	struct hlist_node node;
> +	struct rcu_work release_rwork;

compr_batch_size is added by this series, why not just add it before idx
to begin with?

>  	char tfm_name[CRYPTO_MAX_ALG_NAME];
>  };
>  
> @@ -202,10 +202,10 @@ static struct shrinker *zswap_shrinker;
>   *              logic if referenced is unset. See comments in the shrinker
>   *              section for context.
>   * nid - NUMA node id of the page for which this is the zswap entry.
> - * pool_idx - id of the zswap_pool that the entry's data is in.
>   * handle - zsmalloc allocation handle that stores the compressed page data
>   * objcg - the obj_cgroup that the compressed memory is charged to
>   * lru - handle to the pool's lru used to evict pages.
> + * pool_idx - id of the zswap_pool that the entry's data is in.
>   */
>  struct zswap_entry {
>  	swp_entry_t swpentry;
> @@ -214,10 +214,10 @@ struct zswap_entry {
>  		bool referenced:1;
>  	};
>  	int nid;
> -	u8 pool_idx;
>  	unsigned long handle;
>  	struct obj_cgroup *objcg;
>  	struct list_head lru;
> +	u8 pool_idx;

As mentioned previously, this needs to be packed with the length.

>  };
>  
>  /*
> -- 
> 2.39.5
> 
