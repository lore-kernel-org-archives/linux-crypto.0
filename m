Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C3B264634;
	Wed, 17 Sep 2025 05:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758085494; cv=none; b=TgkQLIOgCG8MPgIl/NQSs6lao3pJrfwpKuQBSRJy930WI/TN6vBgkr2IL/c22H93BUxxkuJCAksbq6g1UWT4moJEtIylAIdqBY5IvDjGq1/nxONkcCz5Bviy8DU/I5E4MG9hY87uNxs8ymxMAXNRl+LD5povd/K4BvAyvZYBGgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758085494; c=relaxed/simple;
	bh=X0Rfb5QCHwBe0RYYo786Yb7JEFiCMsaVK8QtiTrRVxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fom5xV4neeaMZHGeDy5NNTXhkwquVM9AGDl9v+0WQC1DW+gfYUo6kyMk3h5JnsdZST3FbT3ZG+ZSHSJTfO94kBBWdXi9TzLLfQdYfvzGPBTcjjIkIuS8mZr0DDpN+ssB/gNCHAEsYQe6byc7dGYztRP+ihqDU3Opts7Xx8mX/8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SsZ6+CLo; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SsZ6+CLo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758085493; x=1789621493;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X0Rfb5QCHwBe0RYYo786Yb7JEFiCMsaVK8QtiTrRVxE=;
  b=SsZ6+CLolZ0A16mnd4KoDhlTz9nk8D+YQnCCAH4YKLMH/QOw+YjvITFw
   vL2z0PumAEA/4Y8mjMnant/RTkBf1N2k/BlsPW5jCJrrQKrCmM7f+QF7w
   zkSHFtC6TTyFpJmN9Hw1fp983m4fXo2aLeWL/BVbufk6FtTd9iKQgkevf
   +FOR/wz/315bRaoe4uR9E///bG/5Kb6i4Oyzx+vRTbCvtkL0OWbV79oLn
   MIjNjGYjjhseYBy7hlNPe21aV1sxh9lHjanoAFUUcawpP5gqmrOya7xsG
   iHz47FySFLAd0gGI9ury5y2T3yDqJYt2f7oxL3Zd+SfYn3sB4IUyi7mOW
   g==;
X-CSE-ConnectionGUID: CN7ypcJIQj61U7Q642CugQ==
X-CSE-MsgGUID: 0b3UOpWMSf+vr2vW4o636w==
X-IronPort-AV: E=McAfee;i="6800,10657,11555"; a="71484277"
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="71484277"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 22:04:53 -0700
X-CSE-ConnectionGUID: sB/NHNXdQIqoO2ykPrcXBg==
X-CSE-MsgGUID: Jad/lXalRXmHa4vZHqcc7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,271,1751266800"; 
   d="scan'208";a="175224112"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 16 Sep 2025 22:04:46 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uykLT-00015t-1z;
	Wed, 17 Sep 2025 05:04:43 +0000
Date: Wed, 17 Sep 2025 13:04:11 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com,
	glider@google.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com, elver@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com
Subject: Re: [PATCH v1 09/10] fs/binfmt_script: add KFuzzTest target for
 load_script
Message-ID: <202509171240.sw10iAf6-lkp@intel.com>
References: <20250916090109.91132-10-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916090109.91132-10-ethan.w.s.graham@gmail.com>

Hi Ethan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.17-rc6 next-20250916]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20250916-210448
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20250916090109.91132-10-ethan.w.s.graham%40gmail.com
patch subject: [PATCH v1 09/10] fs/binfmt_script: add KFuzzTest target for load_script
config: i386-randconfig-013-20250917 (https://download.01.org/0day-ci/archive/20250917/202509171240.sw10iAf6-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250917/202509171240.sw10iAf6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509171240.sw10iAf6-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from fs/binfmt_script.c:166:
   In file included from fs/tests/binfmt_script_kfuzz.c:8:
>> include/linux/kfuzztest.h:135:3: warning: format specifies type 'unsigned long' but the argument has type 'int' [-Wformat]
     134 |         pr_info("reloc_table: { num_entries = %u, padding = %u } @ offset 0x%lx", rt->num_entries, rt->padding_size,
         |                                                                             ~~~
         |                                                                             %x
     135 |                 (char *)rt - (char *)regions);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:585:34: note: expanded from macro 'pr_info'
     585 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                 ~~~     ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   In file included from fs/binfmt_script.c:166:
   In file included from fs/tests/binfmt_script_kfuzz.c:8:
   include/linux/kfuzztest.h:141:37: warning: format specifies type 'unsigned long' but the argument has type 'int' [-Wformat]
     141 |         pr_info("payload: [0x%lx, 0x%lx)", (char *)payload_start - (char *)regions,
         |                              ~~~           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |                              %x
   include/linux/printk.h:585:34: note: expanded from macro 'pr_info'
     585 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                 ~~~     ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   In file included from fs/binfmt_script.c:166:
   In file included from fs/tests/binfmt_script_kfuzz.c:8:
   include/linux/kfuzztest.h:142:3: warning: format specifies type 'unsigned long' but the argument has type 'int' [-Wformat]
     141 |         pr_info("payload: [0x%lx, 0x%lx)", (char *)payload_start - (char *)regions,
         |                                     ~~~
         |                                     %x
     142 |                 (char *)payload_end - (char *)regions);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/printk.h:585:34: note: expanded from macro 'pr_info'
     585 |         printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
         |                                 ~~~     ^~~~~~~~~~~
   include/linux/printk.h:512:60: note: expanded from macro 'printk'
     512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:484:19: note: expanded from macro 'printk_index_wrap'
     484 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   3 warnings generated.


vim +135 include/linux/kfuzztest.h

6f8f11abdf5c57 Ethan Graham 2025-09-16  117  
6f8f11abdf5c57 Ethan Graham 2025-09-16  118  /*
6f8f11abdf5c57 Ethan Graham 2025-09-16  119   * Dump some information on the parsed headers and payload. Can be useful for
6f8f11abdf5c57 Ethan Graham 2025-09-16  120   * debugging inputs when writing an encoder for the KFuzzTest input format.
6f8f11abdf5c57 Ethan Graham 2025-09-16  121   */
6f8f11abdf5c57 Ethan Graham 2025-09-16  122  __attribute__((unused)) static inline void kfuzztest_debug_header(struct reloc_region_array *regions,
6f8f11abdf5c57 Ethan Graham 2025-09-16  123  								  struct reloc_table *rt, void *payload_start,
6f8f11abdf5c57 Ethan Graham 2025-09-16  124  								  void *payload_end)
6f8f11abdf5c57 Ethan Graham 2025-09-16  125  {
6f8f11abdf5c57 Ethan Graham 2025-09-16  126  	uint32_t i;
6f8f11abdf5c57 Ethan Graham 2025-09-16  127  
6f8f11abdf5c57 Ethan Graham 2025-09-16  128  	pr_info("regions: { num_regions = %u } @ %px", regions->num_regions, regions);
6f8f11abdf5c57 Ethan Graham 2025-09-16  129  	for (i = 0; i < regions->num_regions; i++) {
6f8f11abdf5c57 Ethan Graham 2025-09-16  130  		pr_info("  region_%u: { start: 0x%x, size: 0x%x }", i, regions->regions[i].offset,
6f8f11abdf5c57 Ethan Graham 2025-09-16  131  			regions->regions[i].size);
6f8f11abdf5c57 Ethan Graham 2025-09-16  132  	}
6f8f11abdf5c57 Ethan Graham 2025-09-16  133  
6f8f11abdf5c57 Ethan Graham 2025-09-16  134  	pr_info("reloc_table: { num_entries = %u, padding = %u } @ offset 0x%lx", rt->num_entries, rt->padding_size,
6f8f11abdf5c57 Ethan Graham 2025-09-16 @135  		(char *)rt - (char *)regions);
6f8f11abdf5c57 Ethan Graham 2025-09-16  136  	for (i = 0; i < rt->num_entries; i++) {
6f8f11abdf5c57 Ethan Graham 2025-09-16  137  		pr_info("  reloc_%u: { src: %u, offset: 0x%x, dst: %u }", i, rt->entries[i].region_id,
6f8f11abdf5c57 Ethan Graham 2025-09-16  138  			rt->entries[i].region_offset, rt->entries[i].value);
6f8f11abdf5c57 Ethan Graham 2025-09-16  139  	}
6f8f11abdf5c57 Ethan Graham 2025-09-16  140  
6f8f11abdf5c57 Ethan Graham 2025-09-16  141  	pr_info("payload: [0x%lx, 0x%lx)", (char *)payload_start - (char *)regions,
6f8f11abdf5c57 Ethan Graham 2025-09-16  142  		(char *)payload_end - (char *)regions);
6f8f11abdf5c57 Ethan Graham 2025-09-16  143  }
6f8f11abdf5c57 Ethan Graham 2025-09-16  144  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
