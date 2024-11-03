Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A8B15854D;
	Sun,  3 Nov 2024 10:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730631513; cv=none; b=GuSq3pMwgdlW1DMaqcRPESftvN0YqIllcPQ+O5Mv6l1KlnMVuDjzI17TeBM/BkLM3PHP8wmmp2XBwPcX3JoymrJGZIBg+SDNHWM1TnTfc5vW5tx6HG/1QQGV2WPzs6UcfHKnunxMRTw/4dfn+mdnPfd44hU2YgSj23l3UIfRkQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730631513; c=relaxed/simple;
	bh=v35xY16BvilLfauKTnDlNzDUfjrPghceHw0igyFPsaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dVBrOwL3es/8UZE5zIvI85OFWmO/kp9KllT8oWhpczo5+DYRdbXawWZehFzr0vua1J40ptDPCc1O2zXxSqIv7e7kqjbZXtE5TS09M0blsPDV2JmikvE0zt4Mt30dyyH57qiBvfIW/sy8UggvX33SivjvPXeydY3tXjsKje4ZfGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=khbJ5rsW; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="khbJ5rsW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730631510; x=1762167510;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v35xY16BvilLfauKTnDlNzDUfjrPghceHw0igyFPsaY=;
  b=khbJ5rsWX+CrNjKyL3F9l/dIeLOCW0deHZK96p0bMaVps4iH/L/Un6AK
   nRSVgDGXCLupBu30It+kYbNB0P/0ZNLPQ+bz0kBZGIxXUsSsOs2NWBZrq
   ilXw5uXitR9lZbpe/CfrFKB5KWmujLaFzZIEIswLnS7F3Q24RA23hm6Dn
   qvFwVTaHxBoXmjDQaTRP4rRflXVWmbhRz6bAeriHE8KZs7hry8xBI7rVg
   qvYiMHsrOGgSHKQzcOuJKMpoUsk8YrSPw8BpewrEVhfustZhN8/CohVyj
   mH6YY5mY1tvT7bPwa3R9uD8w8Jq5+iCB1LmRWDwpA2Z7PEXf/ugIjEjWj
   g==;
X-CSE-ConnectionGUID: q4j9PShRQDiVvuR4KGvmcA==
X-CSE-MsgGUID: lVJr42SSRY6HWH0pX9f7iA==
X-IronPort-AV: E=McAfee;i="6700,10204,11244"; a="41733403"
X-IronPort-AV: E=Sophos;i="6.11,255,1725346800"; 
   d="scan'208";a="41733403"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 02:58:29 -0800
X-CSE-ConnectionGUID: MbTZ5hGMR1iIyXEJIN7V5A==
X-CSE-MsgGUID: /hNUM7r/TyGgJqFSAyaimA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,255,1725346800"; 
   d="scan'208";a="114193069"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 03 Nov 2024 02:58:23 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t7YJI-000ju7-0N;
	Sun, 03 Nov 2024 10:58:20 +0000
Date: Sun, 3 Nov 2024 18:57:28 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, yosryahmed@google.com, nphamcs@gmail.com,
	chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, ying.huang@intel.com, 21cnbao@gmail.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com, zanussi@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v2 08/13] mm: zswap: acomp_ctx mutex lock/unlock
 optimizations.
Message-ID: <202411031829.7KQDfJy1-lkp@intel.com>
References: <20241103032111.333282-9-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241103032111.333282-9-kanchana.p.sridhar@intel.com>

Hi Kanchana,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 5c4cf96cd70230100b5d396d45a5c9a332539d19]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-Sridhar/crypto-acomp-Define-two-new-interfaces-for-compress-decompress-batching/20241103-112337
base:   5c4cf96cd70230100b5d396d45a5c9a332539d19
patch link:    https://lore.kernel.org/r/20241103032111.333282-9-kanchana.p.sridhar%40intel.com
patch subject: [PATCH v2 08/13] mm: zswap: acomp_ctx mutex lock/unlock optimizations.
config: hexagon-allmodconfig (https://download.01.org/0day-ci/archive/20241103/202411031829.7KQDfJy1-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 639a7ac648f1e50ccd2556e17d401c04f9cce625)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241103/202411031829.7KQDfJy1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411031829.7KQDfJy1-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/zswap.c:18:
   In file included from include/linux/highmem.h:10:
   In file included from include/linux/mm.h:2211:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   In file included from mm/zswap.c:18:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:548:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     548 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:561:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     561 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   In file included from mm/zswap.c:18:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:574:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     574 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   In file included from mm/zswap.c:18:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from ./arch/hexagon/include/generated/asm/hardirq.h:1:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/hexagon/include/asm/io.h:328:
   include/asm-generic/io.h:585:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     585 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:595:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     595 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:605:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     605 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   In file included from mm/zswap.c:40:
   In file included from mm/internal.h:13:
   include/linux/mm_inline.h:47:41: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
      47 |         __mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
         |                                    ~~~~~~~~~~~ ^ ~~~
   include/linux/mm_inline.h:49:22: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
      49 |                                 NR_ZONE_LRU_BASE + lru, nr_pages);
         |                                 ~~~~~~~~~~~~~~~~ ^ ~~~
>> mm/zswap.c:1529:7: warning: variable 'acomp_ctx' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    1529 |                 if (memcg_list_lru_alloc(memcg, &zswap_list_lru, GFP_KERNEL)) {
         |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/zswap.c:1560:16: note: uninitialized use occurs here
    1560 |         mutex_unlock(&acomp_ctx->mutex);
         |                       ^~~~~~~~~
   mm/zswap.c:1529:3: note: remove the 'if' if its condition is always false
    1529 |                 if (memcg_list_lru_alloc(memcg, &zswap_list_lru, GFP_KERNEL)) {
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1530 |                         mem_cgroup_put(memcg);
         |                         ~~~~~~~~~~~~~~~~~~~~~~
    1531 |                         goto put_pool;
         |                         ~~~~~~~~~~~~~~
    1532 |                 }
         |                 ~
   mm/zswap.c:1496:36: note: initialize the variable 'acomp_ctx' to silence this warning
    1496 |         struct crypto_acomp_ctx *acomp_ctx;
         |                                           ^
         |                                            = NULL
   10 warnings generated.


vim +1529 mm/zswap.c

ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1491  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1492  bool zswap_store(struct folio *folio)
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1493  {
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1494  	long nr_pages = folio_nr_pages(folio);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1495  	swp_entry_t swp = folio->swap;
68dac3aa759e32 Kanchana P Sridhar 2024-11-02  1496  	struct crypto_acomp_ctx *acomp_ctx;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1497  	struct obj_cgroup *objcg = NULL;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1498  	struct mem_cgroup *memcg = NULL;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1499  	struct zswap_pool *pool;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1500  	size_t compressed_bytes = 0;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1501  	bool ret = false;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1502  	long index;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1503  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1504  	VM_WARN_ON_ONCE(!folio_test_locked(folio));
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1505  	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1506  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1507  	if (!zswap_enabled)
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1508  		goto check_old;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1509  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1510  	objcg = get_obj_cgroup_from_folio(folio);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1511  	if (objcg && !obj_cgroup_may_zswap(objcg)) {
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1512  		memcg = get_mem_cgroup_from_objcg(objcg);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1513  		if (shrink_memcg(memcg)) {
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1514  			mem_cgroup_put(memcg);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1515  			goto put_objcg;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1516  		}
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1517  		mem_cgroup_put(memcg);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1518  	}
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1519  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1520  	if (zswap_check_limits())
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1521  		goto put_objcg;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1522  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1523  	pool = zswap_pool_current_get();
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1524  	if (!pool)
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1525  		goto put_objcg;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1526  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1527  	if (objcg) {
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1528  		memcg = get_mem_cgroup_from_objcg(objcg);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30 @1529  		if (memcg_list_lru_alloc(memcg, &zswap_list_lru, GFP_KERNEL)) {
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1530  			mem_cgroup_put(memcg);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1531  			goto put_pool;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1532  		}
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1533  		mem_cgroup_put(memcg);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1534  	}
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1535  
68dac3aa759e32 Kanchana P Sridhar 2024-11-02  1536  	acomp_ctx = raw_cpu_ptr(pool->acomp_ctx);
68dac3aa759e32 Kanchana P Sridhar 2024-11-02  1537  	mutex_lock(&acomp_ctx->mutex);
68dac3aa759e32 Kanchana P Sridhar 2024-11-02  1538  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1539  	for (index = 0; index < nr_pages; ++index) {
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1540  		struct page *page = folio_page(folio, index);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1541  		ssize_t bytes;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1542  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1543  		bytes = zswap_store_page(page, objcg, pool);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1544  		if (bytes < 0)
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1545  			goto put_pool;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1546  		compressed_bytes += bytes;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1547  	}
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1548  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1549  	if (objcg) {
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1550  		obj_cgroup_charge_zswap(objcg, compressed_bytes);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1551  		count_objcg_events(objcg, ZSWPOUT, nr_pages);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1552  	}
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1553  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1554  	atomic_long_add(nr_pages, &zswap_stored_pages);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1555  	count_vm_events(ZSWPOUT, nr_pages);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1556  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1557  	ret = true;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1558  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1559  put_pool:
68dac3aa759e32 Kanchana P Sridhar 2024-11-02  1560  	mutex_unlock(&acomp_ctx->mutex);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1561  	zswap_pool_put(pool);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1562  put_objcg:
f4840ccfca25db Johannes Weiner    2022-05-19  1563  	obj_cgroup_put(objcg);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1564  	if (!ret && zswap_pool_reached_full)
4ea3fa9dd2e9c5 Yosry Ahmed        2024-04-13  1565  		queue_work(shrink_wq, &zswap_shrink_work);
f576a1e80c3a97 Chengming Zhou     2024-02-09  1566  check_old:
f576a1e80c3a97 Chengming Zhou     2024-02-09  1567  	/*
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1568  	 * If the zswap store fails or zswap is disabled, we must invalidate
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1569  	 * the possibly stale entries which were previously stored at the
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1570  	 * offsets corresponding to each page of the folio. Otherwise,
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1571  	 * writeback could overwrite the new data in the swapfile.
f576a1e80c3a97 Chengming Zhou     2024-02-09  1572  	 */
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1573  	if (!ret) {
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1574  		unsigned type = swp_type(swp);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1575  		pgoff_t offset = swp_offset(swp);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1576  		struct zswap_entry *entry;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1577  		struct xarray *tree;
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1578  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1579  		for (index = 0; index < nr_pages; ++index) {
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1580  			tree = swap_zswap_tree(swp_entry(type, offset + index));
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1581  			entry = xa_erase(tree, offset + index);
f576a1e80c3a97 Chengming Zhou     2024-02-09  1582  			if (entry)
796c2c23e14e75 Chris Li           2024-03-26  1583  				zswap_entry_free(entry);
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1584  		}
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1585  	}
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1586  
ccacfbe8c6963d Kanchana P Sridhar 2024-09-30  1587  	return ret;
2b2811178e8555 Seth Jennings      2013-07-10  1588  }
2b2811178e8555 Seth Jennings      2013-07-10  1589  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
