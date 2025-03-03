Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654091F4619;
	Mon,  3 Mar 2025 11:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741000074; cv=none; b=b/HgmEQe3S8GTgPNiGcQJmVixMDnevDxtv2aFz+B+4U0jIqq2uvzrtlX7oV39gRPeqGIgSsQGquN6O7MCiLo3Lqv4rTJfIoqByiyhUrv93PSGu2S1sfoY+cP9oiPVKO+xrYbSP8dtOSGyYr0xyV0ErCpaZRDtIPakRmjeYlPtFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741000074; c=relaxed/simple;
	bh=DJ2wnRWfHhmjvv6CL+4i9zBDgCl/ENX8yayea55YkkI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MhIY02TyBvHTK6MlFc6egA8N3dVQrgtklLCjK8hi5YdjXAJNWUvOKNyYeZXWk9PRzGbAZ56bkVEC8gkfmb0XaRtSz34+urftSA6HaZUsNP1AsqkMLt4dkGzjBTO+rByYH3NQTeE13/Zrb9noWlykVVLlgYdeZtf1f49K3R5nMrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UctT2fIg; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UctT2fIg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741000072; x=1772536072;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DJ2wnRWfHhmjvv6CL+4i9zBDgCl/ENX8yayea55YkkI=;
  b=UctT2fIghMFvD6SygEh01AL+mS07biyzG/f0cvD85JYiKSN4ZX/MMLVB
   iAsm3E5BR78JBTpsGarQI+dAHqwt3CKXcT7tPCk5/dVGp0719L9cxdbln
   WAX62WfbKSbmYngQvM+uFRyjL8IaRdMMQ2YQYYSTbzoeHCxvOZxxvegNu
   WBZXfJsNLA1PqP+acCLn68OYvwAmjrLBPlwj809BY1N1ZlQ/jTm6853Ut
   mcvOwv7HcD3eQhT+IobpH7joLPdPvlPBoAzE9Y7DavxhPmKXFFLs8Y+rA
   w/YizZOlJUsTBL3kTrvg2sMOaDFYTLmKP68nWuYaL2tBRoW/y2PxqTmIn
   A==;
X-CSE-ConnectionGUID: 98laiCvLTiuRRg/D5/OlIQ==
X-CSE-MsgGUID: gdQbMMeNRGqeK0yHBmZMIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="42062437"
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="42062437"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 03:07:52 -0800
X-CSE-ConnectionGUID: AYxTZ/JERWm2mJzhMfMIAQ==
X-CSE-MsgGUID: 2DISxNRkSCeBfeF8JX8vRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,329,1732608000"; 
   d="scan'208";a="141190254"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 03 Mar 2025 03:07:47 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tp3eC-000IOE-27;
	Mon, 03 Mar 2025 11:07:44 +0000
Date: Mon, 3 Mar 2025 19:07:21 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, yosry.ahmed@linux.dev, nphamcs@gmail.com,
	chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com
Cc: oe-kbuild-all@lists.linux.dev, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com, kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v8 14/14] mm: zswap: Compress batching with request
 chaining in zswap_store() of large folios.
Message-ID: <202503031843.GyX5ZVrC-lkp@intel.com>
References: <20250303084724.6490-15-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303084724.6490-15-kanchana.p.sridhar@intel.com>

Hi Kanchana,

kernel test robot noticed the following build errors:

[auto build test ERROR on 5f089a9aa987ccf72df0c6955e168e865f280603]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-Sridhar/crypto-acomp-Add-synchronous-asynchronous-acomp-request-chaining/20250303-164927
base:   5f089a9aa987ccf72df0c6955e168e865f280603
patch link:    https://lore.kernel.org/r/20250303084724.6490-15-kanchana.p.sridhar%40intel.com
patch subject: [PATCH v8 14/14] mm: zswap: Compress batching with request chaining in zswap_store() of large folios.
config: csky-randconfig-002-20250303 (https://download.01.org/0day-ci/archive/20250303/202503031843.GyX5ZVrC-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250303/202503031843.GyX5ZVrC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503031843.GyX5ZVrC-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/zswap.c: In function 'zswap_batch_compress':
>> mm/zswap.c:1166:25: error: implicit declaration of function 'prefetchw' [-Wimplicit-function-declaration]
    1166 |                         prefetchw(entries[j]);
         |                         ^~~~~~~~~


vim +/prefetchw +1166 mm/zswap.c

  1053	
  1054	/*
  1055	 * Unified code paths for compressors that do and do not support
  1056	 * batching. This procedure will compress multiple @nr_pages in @folio,
  1057	 * starting from @index.
  1058	 * If @batching is set to true, it will create a request chain for
  1059	 * compression batching. It is assumed that the caller has verified
  1060	 * that the acomp_ctx->nr_reqs is at least @nr_pages.
  1061	 * If @batching is set to false, it will process each page sequentially.
  1062	 * In both cases, if all compressions were successful, it will proceed
  1063	 * to store the compressed buffers in zpool.
  1064	 */
  1065	static bool zswap_batch_compress(struct folio *folio,
  1066					 long index,
  1067					 unsigned int nr_pages,
  1068					 struct zswap_entry *entries[],
  1069					 struct zswap_pool *pool,
  1070					 struct crypto_acomp_ctx *acomp_ctx,
  1071					 bool batching)
  1072	{
  1073		struct scatterlist inputs[ZSWAP_MAX_BATCH_SIZE];
  1074		struct scatterlist outputs[ZSWAP_MAX_BATCH_SIZE];
  1075		struct zpool *zpool = pool->zpool;
  1076		int acomp_idx = 0, nr_to_store = 1;
  1077		unsigned int i, j;
  1078		int err = 0;
  1079		gfp_t gfp;
  1080	
  1081		lockdep_assert_held(&acomp_ctx->mutex);
  1082	
  1083		gfp = __GFP_NORETRY | __GFP_NOWARN | __GFP_KSWAPD_RECLAIM;
  1084		if (zpool_malloc_support_movable(zpool))
  1085			gfp |= __GFP_HIGHMEM | __GFP_MOVABLE;
  1086	
  1087		for (i = 0; i < nr_pages; ++i) {
  1088			struct page *page = folio_page(folio, index + i);
  1089	
  1090			sg_init_table(&inputs[acomp_idx], 1);
  1091			sg_set_page(&inputs[acomp_idx], page, PAGE_SIZE, 0);
  1092	
  1093			/*
  1094			 * Each dst buffer should be of size (PAGE_SIZE * 2).
  1095			 * Reflect same in sg_list.
  1096			 */
  1097			sg_init_one(&outputs[acomp_idx], acomp_ctx->buffers[acomp_idx], PAGE_SIZE * 2);
  1098			acomp_request_set_params(acomp_ctx->reqs[acomp_idx], &inputs[acomp_idx],
  1099						 &outputs[acomp_idx], PAGE_SIZE, PAGE_SIZE);
  1100	
  1101			if (batching) {
  1102				/* Add the acomp request to the chain. */
  1103				if (likely(i))
  1104					acomp_request_chain(acomp_ctx->reqs[acomp_idx], acomp_ctx->reqs[0]);
  1105				else
  1106					acomp_reqchain_init(acomp_ctx->reqs[0], 0, crypto_req_done,
  1107							    &acomp_ctx->wait);
  1108	
  1109				if (i == (nr_pages - 1)) {
  1110					/* Process the request chain. */
  1111					err = crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);
  1112	
  1113					/*
  1114					 * Get the individual compress errors from request chaining.
  1115					 */
  1116					for (j = 0; j < nr_pages; ++j) {
  1117						if (unlikely(acomp_request_err(acomp_ctx->reqs[j]))) {
  1118							err = -EINVAL;
  1119							if (acomp_request_err(acomp_ctx->reqs[j]) == -ENOSPC)
  1120								zswap_reject_compress_poor++;
  1121							else
  1122								zswap_reject_compress_fail++;
  1123						}
  1124					}
  1125					/*
  1126					 * Request chaining cleanup:
  1127					 *
  1128					 * - Clear the CRYPTO_TFM_REQ_CHAIN bit on acomp_ctx->reqs[0].
  1129					 * - Reset the acomp_ctx->wait to notify acomp_ctx->reqs[0].
  1130					 */
  1131					acomp_reqchain_clear(acomp_ctx->reqs[0], &acomp_ctx->wait);
  1132					if (unlikely(err))
  1133						return false;
  1134					j = 0;
  1135					nr_to_store = nr_pages;
  1136					goto store_zpool;
  1137				}
  1138	
  1139				++acomp_idx;
  1140				continue;
  1141			} else {
  1142				err = crypto_wait_req(crypto_acomp_compress(acomp_ctx->reqs[0]), &acomp_ctx->wait);
  1143	
  1144				if (unlikely(err)) {
  1145					if (err == -ENOSPC)
  1146						zswap_reject_compress_poor++;
  1147					else
  1148						zswap_reject_compress_fail++;
  1149					return false;
  1150				}
  1151				j = i;
  1152				nr_to_store = 1;
  1153			}
  1154	
  1155	store_zpool:
  1156			/*
  1157			 * All batch pages were successfully compressed.
  1158			 * Store the pages in zpool.
  1159			 */
  1160			acomp_idx = -1;
  1161			while (nr_to_store--) {
  1162				unsigned long handle;
  1163				char *buf;
  1164	
  1165				++acomp_idx;
> 1166				prefetchw(entries[j]);
  1167				err = zpool_malloc(zpool, acomp_ctx->reqs[acomp_idx]->dlen, gfp, &handle);
  1168	
  1169				if (unlikely(err)) {
  1170					if (err == -ENOSPC)
  1171						zswap_reject_compress_poor++;
  1172					else
  1173						zswap_reject_alloc_fail++;
  1174	
  1175					return false;
  1176				}
  1177	
  1178				buf = zpool_map_handle(zpool, handle, ZPOOL_MM_WO);
  1179				memcpy(buf, acomp_ctx->buffers[acomp_idx], acomp_ctx->reqs[acomp_idx]->dlen);
  1180				zpool_unmap_handle(zpool, handle);
  1181	
  1182				entries[j]->handle = handle;
  1183				entries[j]->length = acomp_ctx->reqs[acomp_idx]->dlen;
  1184				++j;
  1185			}
  1186		}
  1187	
  1188		return true;
  1189	}
  1190	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
