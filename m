Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE42213EC7
	for <linux-crypto@vger.kernel.org>; Thu,  7 Nov 2024 17:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731000066; cv=none; b=IGOIDws7WjowVtnEiYKZ+J+twHvAZzIZzq9it76N+vD/uSnbvMHTE4rjT7assVqj1KuBzSOzNq8K+Q+34nzO2ya5WSBzzdndxTFODooTysABUvbwdhdSg/JJxCaG08wys4I/RKDfgmW7jM6ybTRHpkNCObVpq8+P5Cwb0d0Sx9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731000066; c=relaxed/simple;
	bh=0zCoFmJYgYo/tSlajPVLld81TqvQbDZfGaZSRZazZaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gbm3lA9J1BdpvUJLSFB1uIFfgN2Z3tKxMeOlryXv2mPNUkKaD7ZxD7Y0khuTKmExW/EXEJDcrjFm+tmeaiW2AoQGto9Luq9PLGEqy3FHoMyz+6WsPO2/pWtD3vKElFv6cxegpsbI6jtSyclzH9AUaS+l6xULc4Ih6mOL8HZPBUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=pwWO4jze; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="pwWO4jze"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4608e389407so13702831cf.2
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2024 09:21:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1731000061; x=1731604861; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4EDkZwm2vH1Rfs2q/4+97N3BGn7nXQVDPU+vRKi/18w=;
        b=pwWO4jzeiS50abKgdPOp5ONflowFDfwqSexacAzdoJnPtHwCcYT3NsT17A37s1aT0m
         5Y59ZdUP7IcbY8gfgqzZA5lEvHQIHS0RkFjIlNtLmhnuOuQqz62IigkjEUSX7X/qbE4G
         PqWH6wtzc9YJYWMREupi8ylPkomcT/Lh0iffUl+ff23LXL37gseDjoM9h4+K1Y+MaB9d
         F3vtfryGzw4BKla6LRpK1FUClmjMN9xdMQkivPV/3rVDA1G5Mx2ukM/OojzpeCpRMPU+
         DyStP8SJYJtN1eDru/uPTCbnpK0b5Npbfsb7mjBiP3tTHMfDpOI3SDrnCWky87Hvc4DW
         +65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731000061; x=1731604861;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4EDkZwm2vH1Rfs2q/4+97N3BGn7nXQVDPU+vRKi/18w=;
        b=uIsnNohKvdh2Eb7iYWEHhDiEo59HMGftjqE2/Tlmus0uPamq5UHx7oCBiMOIopL51N
         hmjdNyVplvzyrMqRXmdexmnBdShfLi308hRTpvrLG1k/UExmKxQzzTeOotdihtCn0BKM
         LeB8861zk33CZUJVP6LWb9akutlcOTaU2Y1aoYZDNG9ptedAfUBmlCvImFE9hVGEiJ/h
         oE3bBUhy/iZTYUJrgK7jdeJjilluL0iA6PK0BOvkYvSvA84qZAlx4H2SbGk5rwov8Uia
         pMP1aiE37Rpju3D+OsxBdUOjqtqLWA03I6Smdyp/bO97zB0GY4oSkt1JgIC0uBu/Pb2V
         om+g==
X-Forwarded-Encrypted: i=1; AJvYcCWuaIYJMcMvlwfzEyhRYsRCeDIL4zbqMNXFDv0xphgwWDB9QjGASwI6IpPh3p279abcqaPeTAapxbZ97VM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjFPo5uVtokSadE8Jlhf5ncoR00a8U0Re7KUwCefT3S6zu7huX
	MXm3+ZsRXyLugfocJ0FXM8LNnHvq4crLMRKm05GTLWl8siO6Tnk11/d5A+km9iM=
X-Google-Smtp-Source: AGHT+IGMBxBmaRVXV1gmv6bff7nihVzZndZ5J0qZZby4MV+WSgKWk5uxN1e8nfazxKcLIom6drRc5g==
X-Received: by 2002:a05:6214:4411:b0:6d3:66fb:ea7c with SMTP id 6a1803df08f44-6d39d9283admr1605646d6.2.1731000061523;
        Thu, 07 Nov 2024 09:21:01 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:da5e:d3ff:fee7:26e7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d396638ea4sm9578286d6.124.2024.11.07.09.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 09:20:59 -0800 (PST)
Date: Thu, 7 Nov 2024 12:20:56 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, yosryahmed@google.com,
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, ying.huang@intel.com, 21cnbao@gmail.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com, zanussi@kernel.org,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Subject: Re: [PATCH v3 09/13] mm: zswap: Modify struct crypto_acomp_ctx to be
 configurable in nr of acomp_reqs.
Message-ID: <20241107172056.GC1172372@cmpxchg.org>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-10-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106192105.6731-10-kanchana.p.sridhar@intel.com>

On Wed, Nov 06, 2024 at 11:21:01AM -0800, Kanchana P Sridhar wrote:
> Modified the definition of "struct crypto_acomp_ctx" to represent a
> configurable number of acomp_reqs and the required number of buffers.
> 
> Accordingly, refactored the code that allocates/deallocates the acomp_ctx
> resources, so that it can be called to create a regular acomp_ctx with
> exactly one acomp_req/buffer, for use in the the existing non-batching
> zswap_store(), as well as to create a separate "batching acomp_ctx" with
> multiple acomp_reqs/buffers for IAA compress batching.
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 149 ++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 107 insertions(+), 42 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 3e899fa61445..02e031122fdf 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -143,9 +143,10 @@ bool zswap_never_enabled(void)
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
> @@ -241,6 +242,11 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
>  	pr_debug("%s pool %s/%s\n", msg, (p)->tfm_name,		\
>  		 zpool_get_type((p)->zpool))
>  
> +static int zswap_create_acomp_ctx(unsigned int cpu,
> +				  struct crypto_acomp_ctx *acomp_ctx,
> +				  char *tfm_name,
> +				  unsigned int nr_reqs);

This looks unnecessary.

> +
>  /*********************************
>  * pool functions
>  **********************************/
> @@ -813,69 +819,128 @@ static void zswap_entry_free(struct zswap_entry *entry)
>  /*********************************
>  * compressed storage functions
>  **********************************/
> -static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> +static int zswap_create_acomp_ctx(unsigned int cpu,
> +				  struct crypto_acomp_ctx *acomp_ctx,
> +				  char *tfm_name,
> +				  unsigned int nr_reqs)
>  {
> -	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> -	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
>  	struct crypto_acomp *acomp;
> -	struct acomp_req *req;
> -	int ret;
> +	int ret = -ENOMEM;
> +	int i, j;
>  
> +	acomp_ctx->nr_reqs = 0;
>  	mutex_init(&acomp_ctx->mutex);
>  
> -	acomp_ctx->buffer = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
> -	if (!acomp_ctx->buffer)
> -		return -ENOMEM;
> -
> -	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> +	acomp = crypto_alloc_acomp_node(tfm_name, 0, 0, cpu_to_node(cpu));
>  	if (IS_ERR(acomp)) {
>  		pr_err("could not alloc crypto acomp %s : %ld\n",
> -				pool->tfm_name, PTR_ERR(acomp));
> -		ret = PTR_ERR(acomp);
> -		goto acomp_fail;
> +				tfm_name, PTR_ERR(acomp));
> +		return PTR_ERR(acomp);
>  	}
> +
>  	acomp_ctx->acomp = acomp;
>  	acomp_ctx->is_sleepable = acomp_is_async(acomp);
>  
> -	req = acomp_request_alloc(acomp_ctx->acomp);
> -	if (!req) {
> -		pr_err("could not alloc crypto acomp_request %s\n",
> -		       pool->tfm_name);
> -		ret = -ENOMEM;
> +	acomp_ctx->buffers = kmalloc_node(nr_reqs * sizeof(u8 *),
> +					  GFP_KERNEL, cpu_to_node(cpu));
> +	if (!acomp_ctx->buffers)
> +		goto buf_fail;
> +
> +	for (i = 0; i < nr_reqs; ++i) {
> +		acomp_ctx->buffers[i] = kmalloc_node(PAGE_SIZE * 2,
> +						     GFP_KERNEL, cpu_to_node(cpu));
> +		if (!acomp_ctx->buffers[i]) {
> +			for (j = 0; j < i; ++j)
> +				kfree(acomp_ctx->buffers[j]);
> +			kfree(acomp_ctx->buffers);
> +			ret = -ENOMEM;
> +			goto buf_fail;
> +		}
> +	}
> +
> +	acomp_ctx->reqs = kmalloc_node(nr_reqs * sizeof(struct acomp_req *),
> +				       GFP_KERNEL, cpu_to_node(cpu));
> +	if (!acomp_ctx->reqs)
>  		goto req_fail;
> +
> +	for (i = 0; i < nr_reqs; ++i) {
> +		acomp_ctx->reqs[i] = acomp_request_alloc(acomp_ctx->acomp);
> +		if (!acomp_ctx->reqs[i]) {
> +			pr_err("could not alloc crypto acomp_request reqs[%d] %s\n",
> +			       i, tfm_name);
> +			for (j = 0; j < i; ++j)
> +				acomp_request_free(acomp_ctx->reqs[j]);
> +			kfree(acomp_ctx->reqs);
> +			ret = -ENOMEM;
> +			goto req_fail;
> +		}
>  	}
> -	acomp_ctx->req = req;
>  
> +	/*
> +	 * The crypto_wait is used only in fully synchronous, i.e., with scomp
> +	 * or non-poll mode of acomp, hence there is only one "wait" per
> +	 * acomp_ctx, with callback set to reqs[0], under the assumption that
> +	 * there is at least 1 request per acomp_ctx.
> +	 */
>  	crypto_init_wait(&acomp_ctx->wait);
>  	/*
>  	 * if the backend of acomp is async zip, crypto_req_done() will wakeup
>  	 * crypto_wait_req(); if the backend of acomp is scomp, the callback
>  	 * won't be called, crypto_wait_req() will return without blocking.
>  	 */
> -	acomp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +	acomp_request_set_callback(acomp_ctx->reqs[0], CRYPTO_TFM_REQ_MAY_BACKLOG,
>  				   crypto_req_done, &acomp_ctx->wait);
>  
> +	acomp_ctx->nr_reqs = nr_reqs;
>  	return 0;
>  
>  req_fail:
> +	for (i = 0; i < nr_reqs; ++i)
> +		kfree(acomp_ctx->buffers[i]);
> +	kfree(acomp_ctx->buffers);
> +buf_fail:
>  	crypto_free_acomp(acomp_ctx->acomp);
> -acomp_fail:
> -	kfree(acomp_ctx->buffer);
>  	return ret;
>  }
>  
> -static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
> +static void zswap_delete_acomp_ctx(struct crypto_acomp_ctx *acomp_ctx)
>  {
> -	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> -	struct crypto_acomp_ctx *acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> -
>  	if (!IS_ERR_OR_NULL(acomp_ctx)) {
> -		if (!IS_ERR_OR_NULL(acomp_ctx->req))
> -			acomp_request_free(acomp_ctx->req);
> +		int i;
> +
> +		for (i = 0; i < acomp_ctx->nr_reqs; ++i)
> +			if (!IS_ERR_OR_NULL(acomp_ctx->reqs[i]))
> +				acomp_request_free(acomp_ctx->reqs[i]);
> +		kfree(acomp_ctx->reqs);
> +
> +		for (i = 0; i < acomp_ctx->nr_reqs; ++i)
> +			kfree(acomp_ctx->buffers[i]);
> +		kfree(acomp_ctx->buffers);
> +
>  		if (!IS_ERR_OR_NULL(acomp_ctx->acomp))
>  			crypto_free_acomp(acomp_ctx->acomp);
> -		kfree(acomp_ctx->buffer);
> +
> +		acomp_ctx->nr_reqs = 0;
> +		acomp_ctx = NULL;
>  	}
> +}
> +
> +static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
> +{
> +	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> +	struct crypto_acomp_ctx *acomp_ctx;
> +
> +	acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> +	return zswap_create_acomp_ctx(cpu, acomp_ctx, pool->tfm_name, 1);
> +}
> +
> +static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
> +{
> +	struct zswap_pool *pool = hlist_entry(node, struct zswap_pool, node);
> +	struct crypto_acomp_ctx *acomp_ctx;
> +
> +	acomp_ctx = per_cpu_ptr(pool->acomp_ctx, cpu);
> +	zswap_delete_acomp_ctx(acomp_ctx);
>  
>  	return 0;
>  }

There are no other callers to these functions. Just do the work
directly in the cpu callbacks here like it used to be.

Otherwise it looks good to me.
