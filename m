Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E4A16419
	for <linux-crypto@vger.kernel.org>; Thu,  7 Nov 2024 18:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731005629; cv=none; b=D30phTjnFh54iugzkaFsJCMxQ7TtIwpewYH9Sgu9+CyO1gb924GqQrHL14mD8uNPQmpKMV8tMf8VDtRJjShEjJYU+Q53gjVXx3JpSDRb9KPI+i4pkMdUlzBOmw1l8auBIPd7I7wZhkEnxbGATMLr+j/RDU1Eyf7zO50FwllY04Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731005629; c=relaxed/simple;
	bh=Ozj9RiksTd04ePC/pn/8Uh282iT8Mr215DPOANye0Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WTeOWCQ+E2n31Hdn1ae8btE9e8uJ+h2/TidAw3epPERwUeeqgHh880pWfxlTgteIq43xYn14/U5LCTTp3+LUEwWkRUuREqQ0VbtyALD4XingTwI4RlbPh5YlJvBTE2RYYEv7N36ObvJM/1VDYyRo736RcIuaDDxp/bFzgRPRnp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=I5W1Jtvq; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="I5W1Jtvq"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7b153047b29so86918985a.3
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2024 10:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1731005626; x=1731610426; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l1CuDjKsYRjEGFe+TKoRAgWlmPg/3uy1Ak3gO25I4Jg=;
        b=I5W1JtvqYMl6DNeyU0mmZchuKOHARnhwVJbSMBI+XoBRBwPXC+Q1k71MMw+McsBVHq
         jyWk67oy64C3GqIuLBWZ8CaaLc7/15BMc/MKiI2iPGnIOAHH8RqTHG+Ewllt7e2h6mA6
         J3QmxysUowagKrmFQHRKtLxhymRCjO1VcXEerc+wVbCKwi/PE5KjzkcRQFRp/poJJky+
         BBjFdvnrktc6taEFfJmB3CRv0UJBwu5kONS+wgEBip8h9pkRHHmXepSyjfsXJH2XQiOJ
         5NO9IlLDnopgBhlTJoThI0Jfqnqa7XMgAQooZ173ziJ0wUEH9tL2br+btAxTQK3FxV++
         lVpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731005626; x=1731610426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l1CuDjKsYRjEGFe+TKoRAgWlmPg/3uy1Ak3gO25I4Jg=;
        b=nDkc5UxzPiKrEuK/Fezj1LWiiWZ5a32jzZDajUbTySsTdLtO8lPIDRgmqCtCYJ9Hx/
         i8CX4itYpHzOcLWaJrZ/qjWMklIsk/NhiF5jfxTjSXc0HqqsipMt2wtCiqmPreJNVbfC
         4TCPNm1imuM+YsV/IGgd3hhxAbldnnwKLxcT9yF0XZ+m31euFCb74IRYZCc4E9tGyVNf
         UDtd8SiaDIlagbWF7UvgJYv49t0+98RAaRm+cwjhgAnjm6FqYVH50o9t7EMNgFKLOBYu
         TnpK69hK5Cq+jKUxQ3uXur1WiTz5Z00VG2/M5mERmP9PwqW5Jm6r3gsQfN5EQvMWty5D
         0uRw==
X-Forwarded-Encrypted: i=1; AJvYcCVSqooVYFUZYXzH7s96g18eSsRB915oLHqNiHqRB5f0X/RxPhRvmN/uERetEHyNKQRqWSBBB8y269gv4KM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyplwiN2xEBqBYU7jmol231w8ESjHsXOpEto27PsG/Ff/RNVwtF
	enS3KYUnN2rCSag0NUBkH80rrdthO+aGZr+0E3MmX7m4tCwWJKbEkN0YsUyeBPM=
X-Google-Smtp-Source: AGHT+IFQA72Bggxxtu7CiC4RsRBOrNujGGLDPSKH3I4JgK7r308sntvvm3Fz4x0toz4RRZuo0ReGdA==
X-Received: by 2002:a05:620a:1908:b0:7b1:3b5e:4b50 with SMTP id af79cd13be357-7b331eb107dmr31913285a.19.1731005625679;
        Thu, 07 Nov 2024 10:53:45 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:da5e:d3ff:fee7:26e7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b32ac427cfsm89472585a.30.2024.11.07.10.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2024 10:53:44 -0800 (PST)
Date: Thu, 7 Nov 2024 13:53:40 -0500
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
Message-ID: <20241107185340.GG1172372@cmpxchg.org>
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
> +static void zswap_zpool_store_sub_batch(
> +	struct zswap_store_pipeline_state *zst)

There is a zswap_store_sub_batch() below, which does something
completely different. Naming is hard, but please invest a bit more
time into this to make this readable.

> +{
> +	u8 i;
> +
> +	for (i = 0; i < zst->nr_comp_pages; ++i) {
> +		struct zswap_store_sub_batch_page *sbp = &zst->sub_batch[i];
> +		struct zpool *zpool;
> +		unsigned long handle;
> +		char *buf;
> +		gfp_t gfp;
> +		int err;
> +
> +		/* Skip pages that had compress errors. */
> +		if (sbp->error)
> +			continue;
> +
> +		zpool = zst->pool->zpool;
> +		gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
> +		if (zpool_malloc_support_movable(zpool))
> +			gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
> +		err = zpool_malloc(zpool, zst->comp_dlens[i], gfp, &handle);
> +
> +		if (err) {
> +			if (err == -ENOSPC)
> +				zswap_reject_compress_poor++;
> +			else
> +				zswap_reject_alloc_fail++;
> +
> +			/*
> +			 * An error should be propagated to other pages of the
> +			 * same folio in the sub-batch, and zpool resources for
> +			 * those pages (in sub-batch order prior to this zpool
> +			 * error) should be de-allocated.
> +			 */
> +			zswap_store_propagate_errors(zst, sbp->batch_idx);
> +			continue;
> +		}
> +
> +		buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
> +		memcpy(buf, zst->comp_dsts[i], zst->comp_dlens[i]);
> +		zpool_unmap_handle(zpool, handle);
> +
> +		sbp->entry->handle = handle;
> +		sbp->entry->length = zst->comp_dlens[i];
> +	}
> +}
> +
> +/*
> + * Returns true if the entry was successfully
> + * stored in the xarray, and false otherwise.
> + */
> +static bool zswap_store_entry(swp_entry_t page_swpentry,
> +			      struct zswap_entry *entry)
> +{
> +	struct zswap_entry *old = xa_store(swap_zswap_tree(page_swpentry),
> +					   swp_offset(page_swpentry),
> +					   entry, GFP_KERNEL);
> +	if (xa_is_err(old)) {
> +		int err = xa_err(old);
> +
> +		WARN_ONCE(err != -ENOMEM, "unexpected xarray error: %d\n", err);
> +		zswap_reject_alloc_fail++;
> +		return false;
> +	}
> +
> +	/*
> +	 * We may have had an existing entry that became stale when
> +	 * the folio was redirtied and now the new version is being
> +	 * swapped out. Get rid of the old.
> +	 */
> +	if (old)
> +		zswap_entry_free(old);
> +
> +	return true;
> +}
> +
> +static void zswap_batch_compress_post_proc(
> +	struct zswap_store_pipeline_state *zst)
> +{
> +	int nr_objcg_pages = 0, nr_pages = 0;
> +	struct obj_cgroup *objcg = NULL;
> +	size_t compressed_bytes = 0;
> +	u8 i;
> +
> +	zswap_zpool_store_sub_batch(zst);
> +
> +	for (i = 0; i < zst->nr_comp_pages; ++i) {
> +		struct zswap_store_sub_batch_page *sbp = &zst->sub_batch[i];
> +
> +		if (sbp->error)
> +			continue;
> +
> +		if (!zswap_store_entry(sbp->swpentry, sbp->entry)) {
> +			zswap_store_propagate_errors(zst, sbp->batch_idx);
> +			continue;
> +		}
> +
> +		/*
> +		 * The entry is successfully compressed and stored in the tree,
> +		 * there is no further possibility of failure. Grab refs to the
> +		 * pool and objcg. These refs will be dropped by
> +		 * zswap_entry_free() when the entry is removed from the tree.
> +		 */
> +		zswap_pool_get(zst->pool);
> +		if (sbp->objcg)
> +			obj_cgroup_get(sbp->objcg);
> +
> +		/*
> +		 * We finish initializing the entry while it's already in xarray.
> +		 * This is safe because:
> +		 *
> +		 * 1. Concurrent stores and invalidations are excluded by folio
> +		 *    lock.
> +		 *
> +		 * 2. Writeback is excluded by the entry not being on the LRU yet.
> +		 *    The publishing order matters to prevent writeback from seeing
> +		 *    an incoherent entry.
> +		 */
> +		sbp->entry->pool = zst->pool;
> +		sbp->entry->swpentry = sbp->swpentry;
> +		sbp->entry->objcg = sbp->objcg;
> +		sbp->entry->referenced = true;
> +		if (sbp->entry->length) {
> +			INIT_LIST_HEAD(&sbp->entry->lru);
> +			zswap_lru_add(&zswap_list_lru, sbp->entry);
> +		}
> +
> +		if (!objcg && sbp->objcg) {
> +			objcg = sbp->objcg;
> +		} else if (objcg && sbp->objcg && (objcg != sbp->objcg)) {
> +			obj_cgroup_charge_zswap(objcg, compressed_bytes);
> +			count_objcg_events(objcg, ZSWPOUT, nr_objcg_pages);
> +			compressed_bytes = 0;
> +			nr_objcg_pages = 0;
> +			objcg = sbp->objcg;
> +		}
> +
> +		if (sbp->objcg) {
> +			compressed_bytes += sbp->entry->length;
> +			++nr_objcg_pages;
> +		}
> +
> +		++nr_pages;
> +	} /* for sub-batch pages. */
> +
> +	if (objcg) {
> +		obj_cgroup_charge_zswap(objcg, compressed_bytes);
> +		count_objcg_events(objcg, ZSWPOUT, nr_objcg_pages);
> +	}
> +
> +	atomic_long_add(nr_pages, &zswap_stored_pages);
> +	count_vm_events(ZSWPOUT, nr_pages);
> +}
> +
> +static void zswap_store_sub_batch(struct zswap_store_pipeline_state *zst)
> +{
> +	u8 i;
> +
> +	for (i = 0; i < zst->nr_comp_pages; ++i) {
> +		zst->comp_dsts[i] = zst->acomp_ctx->buffers[i];
> +		zst->comp_dlens[i] = PAGE_SIZE;
> +	} /* for sub-batch pages. */
> +
> +	/*
> +	 * Batch compress sub-batch "N". If IAA is the compressor, the
> +	 * hardware will compress multiple pages in parallel.
> +	 */
> +	zswap_compress_batch(zst);
> +
> +	zswap_batch_compress_post_proc(zst);

The control flow here is a mess. Keep loops over the same batch at the
same function level. IOW, pull the nr_comp_pages loop out of
zswap_batch_compress_post_proc() and call the function from the loop.

Also give it a more descriptive name. If that's hard to do, then
you're probably doing too many different things in it. Create
functions for a specific purpose, don't carve up sequences at
arbitrary points.

My impression after trying to read this is that the existing
zswap_store() sequence could be a subset of the batched store, where
you can reuse most code to get the pool, charge the cgroup, allocate
entries, store entries, bump the stats etc. for both cases. Alas, your
naming choices make it a bit difficult to be sure.

Please explore this direction. Don't worry about the CONFIG symbol for
now, we can still look at this later.

Right now, it's basically

	if (special case)
		lots of duplicative code in slightly different order
	regular store sequence

and that isn't going to be maintainable.

Look for a high-level sequence that makes sense for both cases. E.g.:

	if (!zswap_enabled)
		goto check_old;

	get objcg

	check limits

	allocate memcg list lru

	for each batch {
		for each entry {
			allocate entry
			acquire objcg ref
			acquire pool ref
		}
		compress
		for each entry {
			store in tree
			add to lru
			bump stats and counters
		}
	}

	put objcg

	return true;

check_error:
	...

and then set up the two loops such that they also makes sense when the
folio is just a single page.
