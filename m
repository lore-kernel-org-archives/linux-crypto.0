Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA3A217460
	for <linux-crypto@vger.kernel.org>; Thu,  7 Nov 2024 18:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731003395; cv=none; b=Kljg2RaiuxyQen132lEhl2lcWHecCj0/XrnaqN2lSGsoLqklY+Pwqt9JblFrIxDeswr+WpUr4Yi3dlDInbg24W/GKv+kO7sqYxt7KzO4A0HeeQBp8HrAARTZPePwCkbbR0SPwtAagrA0xAEx/L/CcLv3UYsyMTXOI9j44uXBt8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731003395; c=relaxed/simple;
	bh=TNSvQr92VWQPFIT2bRAB1EKLGKC4ptx4ATsF6e6OW8w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IApnZKWuqTDXZtYWEqH66uHB11yKuUlBTpEHxvHDGZw1YHTl8CAKL1kIo/aW2v1jNg0MG9hI/kykI1gVuunF5qriWfInm4aDgi94MYevPowpSSenKU5nHT2r1FwZ/Ha/BDGGv4KL8myTmGbqlPtbDuRywGGHAtYRhRahs09/Qzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=MZRCH3QW; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="MZRCH3QW"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6d382664fadso7634536d6.2
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2024 10:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1731003391; x=1731608191; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LT3GIhZWy3LXsRY3e6h3hL2tN1+NJNn1KDxPTV/jnhg=;
        b=MZRCH3QWeO63aOD4dhq3xA4GbcVFl20WB1g8rIaDP7kVs2aoMoktnOM0SEU1aJcw66
         92V0mQPsY3QbjdPhxh1+AppQD3byxg4Qmtmsf+UbGYBB32l5byNU0te8rxtJ6oXCuVSp
         juW9sOLJqRUvr53MnL52As5xYaHzJ8VE4jeE/FlGsNWICKxVUNqLTejHSrYQLNgeDb7Q
         QwvrFfWnVdw6KYNd6wRZ7pMewWxtlcBecnnoddZX3ybBQYkmeKiHQtPgcJjWWge2r1bu
         YtpHYHTWSmWf5E/AqUl3vEn0kbEuKSFDg7pAGtGOkr0OeqYIRcdUBf0vhheOJRvQiQDq
         zLnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731003391; x=1731608191;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LT3GIhZWy3LXsRY3e6h3hL2tN1+NJNn1KDxPTV/jnhg=;
        b=Ih4/j1qAKtuBlxw6rJ3LSdZbvLpuxORMIWSEPaaqOKJ0mZAJg89Hs29WWDCHfSEMeW
         GFXsUD6opTbRbhuOn0mmQCLHhh1bA2+nX7v36oCRQoNhP5/EzppyfDSMrxf+PRN7AoCP
         MfHIVU98VQsiDOZSHRBcPz0tlTgM3/Xp1CNySEEfT4UJ9oFz7UWPyrZywsUdK0uv91vo
         FStp7mRZZ5Zd5aiQOUDihucRkOK55H/7iL+bmxwue9LJ5UOoQgKGPj1I3EOTkuctfzHn
         TnlKC0vkn5+CctazsP9FDBI0gjpljY26p74IRHcbmmzeYK2+Xo7FjBd5RJ7w6nb0+dVh
         8EQw==
X-Forwarded-Encrypted: i=1; AJvYcCW4k+vEXd0gLlyIsWQxAP6d2VLhSASakTdwx1MjJrrCNeIxTe7hNvV7D1AIjsG/HRSqaHP/NtMBUtrQaho=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo7wBWsV0tGYFpZiSduUrD+3tI2M3yoNKOcXGzvRiBTdx7KeMJ
	BmV1w3GLxGXVRuqpesJ2dRLIWs7TmAMsM04Nz1hDL1Bsk2ERSPFnc48vEvIMM14=
X-Google-Smtp-Source: AGHT+IEtGIPkFNfIe3ZLKSC/bfgLuayig4eF10hn6pDIwuPddRsvkklThlidE4dnzDL2R+b2quJ1XQ==
X-Received: by 2002:a05:6214:5992:b0:6ce:2357:8a36 with SMTP id 6a1803df08f44-6d39cf9b6f2mr14196506d6.7.1731003391475;
        Thu, 07 Nov 2024 10:16:31 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:da5e:d3ff:fee7:26e7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6d3961f4a0fsm10136816d6.41.2024.11.07.10.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 10:16:30 -0800 (PST)
Date: Thu, 7 Nov 2024 13:16:26 -0500
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
Subject: Re: [PATCH v3 13/13] mm: zswap: Compress batching with Intel IAA in
 zswap_store() of large folios.
Message-ID: <20241107181626.GF1172372@cmpxchg.org>
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-14-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106192105.6731-14-kanchana.p.sridhar@intel.com>

On Wed, Nov 06, 2024 at 11:21:05AM -0800, Kanchana P Sridhar wrote:
> If the system has Intel IAA, and if sysctl vm.compress-batching is set to
> "1", zswap_store() will call crypto_acomp_batch_compress() to compress up
> to SWAP_CRYPTO_BATCH_SIZE (i.e. 8) pages in large folios in parallel using
> the multiple compress engines available in IAA hardware.
> 
> On platforms with multiple IAA devices per socket, compress jobs from all
> cores in a socket will be distributed among all IAA devices on the socket
> by the iaa_crypto driver.
> 
> With deflate-iaa configured as the zswap compressor, and
> sysctl vm.compress-batching is enabled, the first time zswap_store() has to
> swapout a large folio on any given cpu, it will allocate the
> pool->acomp_batch_ctx resources on that cpu, and set pool->can_batch_comp
> to BATCH_COMP_ENABLED. It will then proceed to call the main
> __zswap_store_batch_core() compress batching function. Subsequent calls to
> zswap_store() on the same cpu will go ahead and use the acomp_batch_ctx by
> checking the pool->can_batch_comp status.
> 
> Hence, we allocate the per-cpu pool->acomp_batch_ctx resources only on an
> as-needed basis, to reduce memory footprint cost. The cost is not incurred
> on cores that never get to swapout a large folio.
> 
> This patch introduces the main __zswap_store_batch_core() function for
> compress batching. This interface represents the extensible compress
> batching architecture that can potentially be called with a batch of
> any-order folios from shrink_folio_list(). In other words, although
> zswap_store() calls __zswap_store_batch_core() with exactly one large folio
> in this patch, we can reuse this interface to reclaim a batch of folios, to
> significantly improve the reclaim path efficiency due to IAA's parallel
> compression capability.
> 
> The newly added functions that implement batched stores follow the
> general structure of zswap_store() of a large folio. Some amount of
> restructuring and optimization is done to minimize failure points
> for a batch, fail early and maximize the zswap store pipeline occupancy
> with SWAP_CRYPTO_BATCH_SIZE pages, potentially from multiple
> folios. This is intended to maximize reclaim throughput with the IAA
> hardware parallel compressions.
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  include/linux/zswap.h |  84 ++++++
>  mm/zswap.c            | 625 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 709 insertions(+)
> 
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 9ad27ab3d222..6d3ef4780c69 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -31,6 +31,88 @@ struct zswap_lruvec_state {
>  	atomic_long_t nr_disk_swapins;
>  };
>  
> +/*
> + * struct zswap_store_sub_batch_page:
> + *
> + * This represents one "zswap batching element", namely, the
> + * attributes associated with a page in a large folio that will
> + * be compressed and stored in zswap. The term "batch" is reserved
> + * for a conceptual "batch" of folios that can be sent to
> + * zswap_store() by reclaim. The term "sub-batch" is used to describe
> + * a collection of "zswap batching elements", i.e., an array of
> + * "struct zswap_store_sub_batch_page *".
> + *
> + * The zswap compress sub-batch size is specified by
> + * SWAP_CRYPTO_BATCH_SIZE, currently set as 8UL if the
> + * platform has Intel IAA. This means zswap can store a large folio
> + * by creating sub-batches of up to 8 pages and compressing this
> + * batch using IAA to parallelize the 8 compress jobs in hardware.
> + * For e.g., a 64KB folio can be compressed as 2 sub-batches of
> + * 8 pages each. This can significantly improve the zswap_store()
> + * performance for large folios.
> + *
> + * Although the page itself is represented directly, the structure
> + * adds a "u8 batch_idx" to represent an index for the folio in a
> + * conceptual "batch of folios" that can be passed to zswap_store().
> + * Conceptually, this allows for up to 256 folios that can be passed
> + * to zswap_store(). If this conceptual number of folios sent to
> + * zswap_store() exceeds 256, the "batch_idx" needs to become u16.
> + */
> +struct zswap_store_sub_batch_page {
> +	u8 batch_idx;
> +	swp_entry_t swpentry;
> +	struct obj_cgroup *objcg;
> +	struct zswap_entry *entry;
> +	int error; /* folio error status. */
> +};
> +
> +/*
> + * struct zswap_store_pipeline_state:
> + *
> + * This stores state during IAA compress batching of (conceptually, a batch of)
> + * folios. The term pipelining in this context, refers to breaking down
> + * the batch of folios being reclaimed into sub-batches of
> + * SWAP_CRYPTO_BATCH_SIZE pages, batch compressing and storing the
> + * sub-batch. This concept could be further evolved to use overlap of CPU
> + * computes with IAA computes. For instance, we could stage the post-compress
> + * computes for sub-batch "N-1" to happen in parallel with IAA batch
> + * compression of sub-batch "N".
> + *
> + * We begin by developing the concept of compress batching. Pipelining with
> + * overlap can be future work.
> + *
> + * @errors: The errors status for the batch of reclaim folios passed in from
> + *          a higher mm layer such as swap_writepage().
> + * @pool: A valid zswap_pool.
> + * @acomp_ctx: The per-cpu pointer to the crypto_acomp_ctx for the @pool.
> + * @sub_batch: This is an array that represents the sub-batch of up to
> + *             SWAP_CRYPTO_BATCH_SIZE pages that are being stored
> + *             in zswap.
> + * @comp_dsts: The destination buffers for crypto_acomp_compress() for each
> + *             page being compressed.
> + * @comp_dlens: The destination buffers' lengths from crypto_acomp_compress()
> + *              obtained after crypto_acomp_poll() returns completion status,
> + *              for each page being compressed.
> + * @comp_errors: Compression errors for each page being compressed.
> + * @nr_comp_pages: Total number of pages in @sub_batch.
> + *
> + * Note:
> + * The max sub-batch size is SWAP_CRYPTO_BATCH_SIZE, currently 8UL.
> + * Hence, if SWAP_CRYPTO_BATCH_SIZE exceeds 256, some of the
> + * u8 members (except @comp_dsts) need to become u16.
> + */
> +struct zswap_store_pipeline_state {
> +	int *errors;
> +	struct zswap_pool *pool;
> +	struct crypto_acomp_ctx *acomp_ctx;
> +	struct zswap_store_sub_batch_page *sub_batch;
> +	struct page **comp_pages;
> +	u8 **comp_dsts;
> +	unsigned int *comp_dlens;
> +	int *comp_errors;
> +	u8 nr_comp_pages;
> +};

Why are these in the public header?

>  unsigned long zswap_total_pages(void);
>  bool zswap_store(struct folio *folio);
>  bool zswap_load(struct folio *folio);
> @@ -45,6 +127,8 @@ bool zswap_never_enabled(void);
>  #else
>  
>  struct zswap_lruvec_state {};
> +struct zswap_store_sub_batch_page {};
> +struct zswap_store_pipeline_state {};
> 
>  static inline bool zswap_store(struct folio *folio)
>  {
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 2af736e38213..538aac3fb552 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -255,6 +255,12 @@ static int zswap_create_acomp_ctx(unsigned int cpu,
>  				  char *tfm_name,
>  				  unsigned int nr_reqs);
>  
> +static bool __zswap_store_batch_core(
> +	int node_id,
> +	struct folio **folios,
> +	int *errors,
> +	unsigned int nr_folios);
> +

Please reorder the functions to avoid forward decls.

>  /*********************************
>  * pool functions
>  **********************************/
> @@ -1626,6 +1632,12 @@ static ssize_t zswap_store_page(struct page *page,
>  	return -EINVAL;
>  }
>  
> +/*
> + * Modified to use the IAA compress batching framework implemented in
> + * __zswap_store_batch_core() if sysctl vm.compress-batching is 1.
> + * The batching code is intended to significantly improve folio store
> + * performance over the sequential code.

This isn't helpful, please delete.

>  bool zswap_store(struct folio *folio)
>  {
>  	long nr_pages = folio_nr_pages(folio);
> @@ -1638,6 +1650,38 @@ bool zswap_store(struct folio *folio)
>  	bool ret = false;
>  	long index;
>  
> +	/*
> +	 * Improve large folio zswap_store() latency with IAA compress batching,
> +	 * if this is enabled by setting sysctl vm.compress-batching to "1".
> +	 * If enabled, the large folio's pages are compressed in parallel in
> +	 * batches of SWAP_CRYPTO_BATCH_SIZE pages. If disabled, every page in
> +	 * the large folio is compressed sequentially.
> +	 */

Same here. Reduce to "Try to batch compress large folios, fall back to
processing individual subpages if that fails."

> +	if (folio_test_large(folio) && READ_ONCE(compress_batching)) {
> +		pool = zswap_pool_current_get();

There is an existing zswap_pool_current_get() in zswap_store(), please
reorder the sequence so you don't need to add an extra one.

> +		if (!pool) {
> +			pr_err("Cannot setup acomp_batch_ctx for compress batching: no current pool found\n");

This is unnecessary.

> +			goto sequential_store;
> +		}
> +
> +		if (zswap_pool_can_batch(pool)) {

This function is introduced in another patch, where it isn't
used. Please add functions and callers in the same patch.

> +			int error = -1;
> +			bool store_batch = __zswap_store_batch_core(
> +						folio_nid(folio),
> +						&folio, &error, 1);
> +
> +			if (store_batch) {
> +				zswap_pool_put(pool);
> +				if (!error)
> +					ret = true;
> +				return ret;
> +			}
> +		}

Please don't future proof code like this, only implement what is
strictly necessary for the functionality in this patch. You're only
adding a single caller with nr_folios=1, so it shouldn't be a
parameter, and the function shouldn't have a that batch_idx loop.

> +		zswap_pool_put(pool);
> +	}
> +
> +sequential_store:
> +
>  	VM_WARN_ON_ONCE(!folio_test_locked(folio));
>  	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
>  
> @@ -1724,6 +1768,587 @@ bool zswap_store(struct folio *folio)
>  	return ret;
>  }
>  
> +/*
> + * Note: If SWAP_CRYPTO_BATCH_SIZE exceeds 256, change the
> + * u8 stack variables in the next several functions, to u16.
> + */
> +
> +/*
> + * Propagate the "sbp" error condition to other batch elements belonging to
> + * the same folio as "sbp".
> + */
> +static __always_inline void zswap_store_propagate_errors(
> +	struct zswap_store_pipeline_state *zst,
> +	u8 error_batch_idx)
> +{

Please observe surrounding coding style on how to wrap >80 col
function signatures.

Don't use __always_inline unless there is a clear, spelled out
performance reason. Since it's an error path, that's doubtful.

Please use a consistent namespace for all this:

CONFIG_ZSWAP_BATCH
zswap_batch_store()
zswap_batch_alloc_entries()
zswap_batch_add_folios()
zswap_batch_compress()

etc.

Again, order to avoid forward decls.

Try to keep the overall sequence of events between zswap_store() and
zswap_batch_store() similar as much as possible for readability.
