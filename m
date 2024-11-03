Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD1815ADAB;
	Sun,  3 Nov 2024 10:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730629589; cv=none; b=qHG/NrbY44FTw8aj6pYsDLDjQ3PMfCiGR95bp2HYEXOyERozofQkIYuh4vx5ryOW/lPRVAdbnz5XTZIOcXxal4fT4kO7lOE2qnwUwA0RN6BUJObgt/7cNW2Y+r7Di5hLlaInQjxAwiOfXhXPGl1SOtTiNtS9eR6w48m4LYV/X+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730629589; c=relaxed/simple;
	bh=hggU8iw//CKWMghqP+CFbgGJoQIsXzMO3FH4JN14718=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tEW8aEXa4jx75FCj4GfrAy2OsKQI/eGyuRfSrGSklkAlUamId4GgAbjK+2uSQkwRdb5MIvG33t8s9M7RrBgL1lmmiGmlt2tDDIJlFIDGcTW2OEYLuCrj2oLLQTe1DnqGMszY8jNjmpQcr9tAAs7PonUGhsxAQBINmtjxbfI+qMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rn5LNRbK; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rn5LNRbK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730629588; x=1762165588;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hggU8iw//CKWMghqP+CFbgGJoQIsXzMO3FH4JN14718=;
  b=Rn5LNRbKuRGEqZmAfqcPUNwRUwYFBs8n5Shx462MRfmMs2w/Rda2hWE6
   pgiYilTds3Qt+K0V9cC5Rhb9UVzRWP7w2DQuDYYNBIvq5FGT1xaWw9g+q
   Si4rdnUiWCy0cph+3C3CN7hIOCylNC/7ifZF+6kOh36D+1h8YSaTmdbuX
   11ANGvsB3jscNq1xvDM7zIn1boZk32YMVuHCjdY6E1zsfdYYzl7ofvgzL
   SpKL+RPcJJSFoUDQrWqTTY4YHGhpL6KuVXLj6tLP1eDmtDakzEKDSR9fP
   +NTyf97/dq/KIA97wp26TY3pu/mFXZaOG08K0yU/JzamzcBjXLDiqoBTF
   A==;
X-CSE-ConnectionGUID: 4Lr3wGJ1TGel+yCZaI8d0A==
X-CSE-MsgGUID: ZkUJ1lCWSouqcIrGl/0yzw==
X-IronPort-AV: E=McAfee;i="6700,10204,11244"; a="29769890"
X-IronPort-AV: E=Sophos;i="6.11,255,1725346800"; 
   d="scan'208";a="29769890"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 02:26:27 -0800
X-CSE-ConnectionGUID: wab9ZlgNSEG10qGLoNGLWA==
X-CSE-MsgGUID: Y3rFFxGJScS6dt1WZG/4kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,255,1725346800"; 
   d="scan'208";a="87969312"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 03 Nov 2024 02:26:22 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t7XoJ-000jt7-1h;
	Sun, 03 Nov 2024 10:26:19 +0000
Date: Sun, 3 Nov 2024 18:25:26 +0800
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
Subject: Re: [PATCH v2 12/13] mm: Add sysctl vm.compress-batching switch for
 compress batching during swapout.
Message-ID: <202411031803.xNibgI5N-lkp@intel.com>
References: <20241103032111.333282-13-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241103032111.333282-13-kanchana.p.sridhar@intel.com>

Hi Kanchana,

kernel test robot noticed the following build errors:

[auto build test ERROR on 5c4cf96cd70230100b5d396d45a5c9a332539d19]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-Sridhar/crypto-acomp-Define-two-new-interfaces-for-compress-decompress-batching/20241103-112337
base:   5c4cf96cd70230100b5d396d45a5c9a332539d19
patch link:    https://lore.kernel.org/r/20241103032111.333282-13-kanchana.p.sridhar%40intel.com
patch subject: [PATCH v2 12/13] mm: Add sysctl vm.compress-batching switch for compress batching during swapout.
config: i386-buildonly-randconfig-002-20241103 (https://download.01.org/0day-ci/archive/20241103/202411031803.xNibgI5N-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241103/202411031803.xNibgI5N-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411031803.xNibgI5N-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/swap.c:17:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   In file included from mm/swap.c:26:
   include/linux/mm_inline.h:47:41: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
      47 |         __mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
         |                                    ~~~~~~~~~~~ ^ ~~~
   include/linux/mm_inline.h:49:22: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
      49 |                                 NR_ZONE_LRU_BASE + lru, nr_pages);
         |                                 ~~~~~~~~~~~~~~~~ ^ ~~~
>> mm/swap.c:51:14: error: expected identifier or '('
      51 | unsigned int compress_batching;
         |              ^
   include/linux/mm.h:88:27: note: expanded from macro 'compress_batching'
      88 | #define compress_batching 0
         |                           ^
>> mm/swap.c:1082:20: error: expression is not assignable
    1082 |         compress_batching = 0;
         |         ~~~~~~~~~~~~~~~~~ ^
   3 warnings and 2 errors generated.


vim +51 mm/swap.c

    49	
    50	/* Enable/disable compress batching during swapout. */
  > 51	unsigned int compress_batching;
    52	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
