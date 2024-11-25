Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30F91547DE;
	Mon, 25 Nov 2024 08:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732521687; cv=none; b=Mf5TP1PSwDw7K32R4xOJcgCczon7lhDjlHNvLBmv+BfqPn+lz/kR4/n/SLEyg6R8+mXFpFgIA6aAJm/6ul/uNJgOjTLMSxZgOe3JPvPmdpldGeDnlEytzMIEKGLuy1HF2b2LWuTtpKJwQ1LFfKcDRnjH66bfNTIUUnEyMPyjpzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732521687; c=relaxed/simple;
	bh=7i26vOpaYieZsxdxzoMbvSBe5Be3es8Xmwgmvf588lc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JOhqX8RI0y6vA7I49+neLX2oTNR80Rha6/07yxJzzjyQyBEzrhPP7lugILMzIPDkJ1MHR226FUUkVzYJUixqv05nOm96afcWTi6frMla/VDQFeexWEOmkOXsjmKDNfjqFyXl8k6y/qscgWV0hfez81FnivtmdZQ+eyO99NhzJac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FHumMjuc; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FHumMjuc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732521686; x=1764057686;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7i26vOpaYieZsxdxzoMbvSBe5Be3es8Xmwgmvf588lc=;
  b=FHumMjuc3JWsotIyEXg7UV3EYFhLDugIR9BqoTmOFI546kNgywInP2E1
   LGXGuurZrwMiFdM5TtFM2CfEaZZQOzLCb6M15Vzz5X6TiU6T/qP5oW2ri
   imbdPB0GHx1YhScBeZN8pxaS1GKwvj9nLsJypily+xMRBtaHj216967Ks
   SQ5ms892Khc8rN2BRrCX+lhBhSWKdmOesvJDjOGv0PrWe0Arv6s5bwXSE
   c2dXPDWgnRA3zXP2atCczX7l5/cGHg9BenyShbI4s1x96vGEmF1FcYBPx
   dTAOKNFOoog2rqicrwMIuJGlN4NaEgynQg96Ax84ZI2dLIzsTOYHJ9uG7
   w==;
X-CSE-ConnectionGUID: X3wFlVGIQ92Biwn2j1/a6w==
X-CSE-MsgGUID: 7EuSjY0dT4ittUZWPJM7HQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11266"; a="20204244"
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="20204244"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 00:01:15 -0800
X-CSE-ConnectionGUID: BdJQhWoLRdKzvBk4KOhjUw==
X-CSE-MsgGUID: YvlplLARTTuA3ELMC0WUlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,182,1728975600"; 
   d="scan'208";a="96112053"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 25 Nov 2024 00:01:09 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tFU1q-00063f-19;
	Mon, 25 Nov 2024 08:01:06 +0000
Date: Mon, 25 Nov 2024 16:00:49 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, yosryahmed@google.com, nphamcs@gmail.com,
	chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, ying.huang@intel.com, 21cnbao@gmail.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v4 10/10] mm: zswap: Compress batching with Intel IAA in
 zswap_batch_store() of large folios.
Message-ID: <202411251534.ETkkSgz6-lkp@intel.com>
References: <20241123070127.332773-11-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241123070127.332773-11-kanchana.p.sridhar@intel.com>

Hi Kanchana,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 5a7056135bb69da2ce0a42eb8c07968c1331777b]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-Sridhar/crypto-acomp-Define-two-new-interfaces-for-compress-decompress-batching/20241125-110412
base:   5a7056135bb69da2ce0a42eb8c07968c1331777b
patch link:    https://lore.kernel.org/r/20241123070127.332773-11-kanchana.p.sridhar%40intel.com
patch subject: [PATCH v4 10/10] mm: zswap: Compress batching with Intel IAA in zswap_batch_store() of large folios.
config: x86_64-buildonly-randconfig-003-20241125 (https://download.01.org/0day-ci/archive/20241125/202411251534.ETkkSgz6-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241125/202411251534.ETkkSgz6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411251534.ETkkSgz6-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/zswap.c:18:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/x86/include/asm/cacheflush.h:5:
   In file included from include/linux/mm.h:2211:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   In file included from mm/zswap.c:40:
   In file included from mm/internal.h:13:
   include/linux/mm_inline.h:47:41: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
      47 |         __mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
         |                                    ~~~~~~~~~~~ ^ ~~~
   include/linux/mm_inline.h:49:22: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
      49 |                                 NR_ZONE_LRU_BASE + lru, nr_pages);
         |                                 ~~~~~~~~~~~~~~~~ ^ ~~~
>> mm/zswap.c:2315:8: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    2315 |                         if (memcg_list_lru_alloc(memcg, &zswap_list_lru, GFP_KERNEL)) {
         |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/zswap.c:2335:8: note: uninitialized use occurs here
    2335 |                 if (!ret && zswap_pool_reached_full)
         |                      ^~~
   mm/zswap.c:2315:4: note: remove the 'if' if its condition is always false
    2315 |                         if (memcg_list_lru_alloc(memcg, &zswap_list_lru, GFP_KERNEL)) {
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    2316 |                                 mem_cgroup_put(memcg);
         |                                 ~~~~~~~~~~~~~~~~~~~~~~
    2317 |                                 goto put_objcg;
         |                                 ~~~~~~~~~~~~~~~
    2318 |                         }
         |                         ~
   mm/zswap.c:2310:7: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    2310 |                 if (zswap_check_limits())
         |                     ^~~~~~~~~~~~~~~~~~~~
   mm/zswap.c:2335:8: note: uninitialized use occurs here
    2335 |                 if (!ret && zswap_pool_reached_full)
         |                      ^~~
   mm/zswap.c:2310:3: note: remove the 'if' if its condition is always false
    2310 |                 if (zswap_check_limits())
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
    2311 |                         goto put_objcg;
         |                         ~~~~~~~~~~~~~~
   mm/zswap.c:2303:8: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    2303 |                         if (shrink_memcg(memcg)) {
         |                             ^~~~~~~~~~~~~~~~~~~
   mm/zswap.c:2335:8: note: uninitialized use occurs here
    2335 |                 if (!ret && zswap_pool_reached_full)
         |                      ^~~
   mm/zswap.c:2303:4: note: remove the 'if' if its condition is always false
    2303 |                         if (shrink_memcg(memcg)) {
         |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~
    2304 |                                 mem_cgroup_put(memcg);
         |                                 ~~~~~~~~~~~~~~~~~~~~~~
    2305 |                                 goto put_objcg;
         |                                 ~~~~~~~~~~~~~~~
    2306 |                         }
         |                         ~
   mm/zswap.c:2295:11: note: initialize the variable 'ret' to silence this warning
    2295 |                 bool ret;
         |                         ^
         |                          = 0
   6 warnings generated.


vim +2315 mm/zswap.c

  2216	
  2217	/*
  2218	 * Store a large folio and/or a batch of any-order folio(s) in zswap
  2219	 * using IAA compress batching API.
  2220	 *
  2221	 * This the main procedure for batching within large folios and for batching
  2222	 * of folios. Each large folio will be broken into sub-batches of
  2223	 * SWAP_CRYPTO_BATCH_SIZE pages, the sub-batch pages will be compressed by
  2224	 * IAA hardware compress engines in parallel, then stored in zpool/xarray.
  2225	 *
  2226	 * This procedure should only be called if zswap supports batching of stores.
  2227	 * Otherwise, the sequential implementation for storing folios as in the
  2228	 * current zswap_store() should be used. The code handles the unlikely event
  2229	 * that the zswap pool changes from batching to non-batching between
  2230	 * swap_writepage() and the start of zswap_batch_store().
  2231	 *
  2232	 * The signature of this procedure is meant to allow the calling function,
  2233	 * (for instance, swap_writepage()) to pass a batch of folios @batch
  2234	 * (the "reclaim batch") to be stored in zswap.
  2235	 *
  2236	 * @batch and @errors have folio_batch_count(@batch) number of entries,
  2237	 * with one-one correspondence (@errors[i] represents the error status of
  2238	 * @batch->folios[i], for i in folio_batch_count(@batch)). Please also
  2239	 * see comments preceding "struct zswap_batch_store_sub_batch" definition
  2240	 * above.
  2241	 *
  2242	 * The calling function (for instance, swap_writepage()) should initialize
  2243	 * @errors[i] to a non-0 value.
  2244	 * If zswap successfully stores @batch->folios[i], it will set @errors[i] to 0.
  2245	 * If there is an error in zswap, it will set @errors[i] to -EINVAL.
  2246	 *
  2247	 * @batch: folio_batch of folios to be batch compressed.
  2248	 * @errors: zswap_batch_store() error status for the folios in @batch.
  2249	 */
  2250	void zswap_batch_store(struct folio_batch *batch, int *errors)
  2251	{
  2252		struct zswap_batch_store_sub_batch sub_batch;
  2253		struct zswap_pool *pool;
  2254		u8 i;
  2255	
  2256		/*
  2257		 * If zswap is disabled, we must invalidate the possibly stale entry
  2258		 * which was previously stored at this offset. Otherwise, writeback
  2259		 * could overwrite the new data in the swapfile.
  2260		 */
  2261		if (!zswap_enabled)
  2262			goto check_old;
  2263	
  2264		pool = zswap_pool_current_get();
  2265	
  2266		if (!pool) {
  2267			if (zswap_check_limits())
  2268				queue_work(shrink_wq, &zswap_shrink_work);
  2269			goto check_old;
  2270		}
  2271	
  2272		if (!pool->can_batch) {
  2273			for (i = 0; i < folio_batch_count(batch); ++i)
  2274				if (zswap_store(batch->folios[i]))
  2275					errors[i] = 0;
  2276				else
  2277					errors[i] = -EINVAL;
  2278			/*
  2279			 * Seems preferable to release the pool ref after the calls to
  2280			 * zswap_store(), so that the non-batching pool cannot be
  2281			 * deleted, can be used for sequential stores, and the zswap pool
  2282			 * cannot morph into a batching pool.
  2283			 */
  2284			zswap_pool_put(pool);
  2285			return;
  2286		}
  2287	
  2288		zswap_batch_reset(&sub_batch);
  2289		sub_batch.pool = pool;
  2290	
  2291		for (i = 0; i < folio_batch_count(batch); ++i) {
  2292			struct folio *folio = batch->folios[i];
  2293			struct obj_cgroup *objcg = NULL;
  2294			struct mem_cgroup *memcg = NULL;
  2295			bool ret;
  2296	
  2297			VM_WARN_ON_ONCE(!folio_test_locked(folio));
  2298			VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
  2299	
  2300			objcg = get_obj_cgroup_from_folio(folio);
  2301			if (objcg && !obj_cgroup_may_zswap(objcg)) {
  2302				memcg = get_mem_cgroup_from_objcg(objcg);
  2303				if (shrink_memcg(memcg)) {
  2304					mem_cgroup_put(memcg);
  2305					goto put_objcg;
  2306				}
  2307				mem_cgroup_put(memcg);
  2308			}
  2309	
  2310			if (zswap_check_limits())
  2311				goto put_objcg;
  2312	
  2313			if (objcg) {
  2314				memcg = get_mem_cgroup_from_objcg(objcg);
> 2315				if (memcg_list_lru_alloc(memcg, &zswap_list_lru, GFP_KERNEL)) {
  2316					mem_cgroup_put(memcg);
  2317					goto put_objcg;
  2318				}
  2319				mem_cgroup_put(memcg);
  2320			}
  2321	
  2322			/*
  2323			 * By default, set zswap error status in "errors" to "success"
  2324			 * for use in swap_writepage() when this returns. In case of
  2325			 * errors encountered in any sub-batch in which this folio's
  2326			 * pages are batch-compressed, a negative error number will
  2327			 * over-write this when zswap_batch_cleanup() is called.
  2328			 */
  2329			errors[i] = 0;
  2330			ret = zswap_batch_comp_folio(folio, errors, i, objcg, &sub_batch,
  2331						     (i == folio_batch_count(batch) - 1));
  2332	
  2333	put_objcg:
  2334			obj_cgroup_put(objcg);
  2335			if (!ret && zswap_pool_reached_full)
  2336				queue_work(shrink_wq, &zswap_shrink_work);
  2337		} /* for batch folios */
  2338	
  2339		zswap_pool_put(pool);
  2340	
  2341	check_old:
  2342		for (i = 0; i < folio_batch_count(batch); ++i)
  2343			if (errors[i])
  2344				zswap_delete_stored_entries(batch->folios[i]);
  2345	}
  2346	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
