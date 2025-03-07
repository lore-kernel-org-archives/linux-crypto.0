Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6954C18FC83
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 04:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741321346; cv=none; b=bTbLDvwiR5xcUEeueeyRashLCB83OqTkgIfN4KbLSd9cbOHlYGajnNwK5tUddRu+uo0NQx6AgsZIP2HAjh4IEdpaJ2Al6VkM7EOMyTL5vGfj/EGAklrjJ11coQsg2rckciyxzYWn14WNC+6Srfl/39CyKjKcVMTNjdFgU31sJsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741321346; c=relaxed/simple;
	bh=mGsnUFU14gRE5OTvGZgN8fDv0j0aTIyMRktWQWR9oe4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OlnABcYyKl0pimVjsE4wD78qYlr53afrt7iaA6UgmQsT9z+cBuyvS9XRVxRGvmtxvQZkYc+iWn/plhZlVINeQ3W6lbJHwv+3x4Vxv9HGTzDNtITyT//EOKNZNqKyWXXa2R7LoC+DrmZt1o2RQFsbQL9LikubDrl5tQQPE6g5hVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mUD2x2CF; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mUD2x2CF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741321344; x=1772857344;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mGsnUFU14gRE5OTvGZgN8fDv0j0aTIyMRktWQWR9oe4=;
  b=mUD2x2CFYOWA94XHoyXY8OY+PQ2SW2kSStF6oBJFy2mruLDHKfhxfXZq
   LDpg3QRryKYcY4oNX6vaylJbjSvIPIYon+L0Gy91YRNcmxl4os6HQkAge
   /TfPB+JYz90xxNfsh5KQDO7kBWAiob9DR3i7AEEnBK/oMSqn1mAw0L9CU
   BQfRDqpD7DWWtwbgiMxSERL93T/befLmm/dzQ7IBHvrG5lCD9pxZ9ZBU/
   QeH3KL2nXkGoQQLMC02Nu3phb1Gm5IZ7MbYj/lB+XXt4VSjDGq1A11seJ
   MjEMfThzTaj6FtFgHgfV1FzLdVW19QRlW3CJFYCwHgqJspg7OF57YkFt/
   A==;
X-CSE-ConnectionGUID: hmGCZ0+WS/yL9GpeXqtfMg==
X-CSE-MsgGUID: OzjELHrmQciJhxSraYomqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11365"; a="67737585"
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="67737585"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2025 20:22:24 -0800
X-CSE-ConnectionGUID: zrRamg93SeuRWoipnKOWPA==
X-CSE-MsgGUID: x3YwzdfsSa+lzOU0WSkzZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,228,1736841600"; 
   d="scan'208";a="119397843"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 06 Mar 2025 20:22:22 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tqPE4-000ONm-13;
	Fri, 07 Mar 2025 04:22:20 +0000
Date: Fri, 7 Mar 2025 12:22:07 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v3 PATCH] crypto: scatterwalk - Add memcpy_sglist
Message-ID: <202503071218.9J2sUblV-lkp@intel.com>
References: <Z8kXhLb681E_FLzs@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8kXhLb681E_FLzs@gondor.apana.org.au>

Hi Herbert,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on next-20250306]
[cannot apply to linus/master v6.14-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-scatterwalk-Add-memcpy_sglist/20250306-113457
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/Z8kXhLb681E_FLzs%40gondor.apana.org.au
patch subject: [v3 PATCH] crypto: scatterwalk - Add memcpy_sglist
config: i386-buildonly-randconfig-002-20250307 (https://download.01.org/0day-ci/archive/20250307/202503071218.9J2sUblV-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250307/202503071218.9J2sUblV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503071218.9J2sUblV-lkp@intel.com/

All errors (new ones prefixed by >>):

>> crypto/scatterwalk.c:107:41: error: too few arguments to function call, expected 3, have 2
     107 |                 slen = scatterwalk_next(&swalk, nbytes);
         |                        ~~~~~~~~~~~~~~~~               ^
   include/crypto/scatterwalk.h:129:21: note: 'scatterwalk_next' declared here
     129 | static inline void *scatterwalk_next(struct scatter_walk *walk,
         |                     ^                ~~~~~~~~~~~~~~~~~~~~~~~~~~
     130 |                                      unsigned int total,
         |                                      ~~~~~~~~~~~~~~~~~~~
     131 |                                      unsigned int *nbytes_ret)
         |                                      ~~~~~~~~~~~~~~~~~~~~~~~~
   crypto/scatterwalk.c:108:41: error: too few arguments to function call, expected 3, have 2
     108 |                 dlen = scatterwalk_next(&dwalk, nbytes);
         |                        ~~~~~~~~~~~~~~~~               ^
   include/crypto/scatterwalk.h:129:21: note: 'scatterwalk_next' declared here
     129 | static inline void *scatterwalk_next(struct scatter_walk *walk,
         |                     ^                ~~~~~~~~~~~~~~~~~~~~~~~~~~
     130 |                                      unsigned int total,
         |                                      ~~~~~~~~~~~~~~~~~~~
     131 |                                      unsigned int *nbytes_ret)
         |                                      ~~~~~~~~~~~~~~~~~~~~~~~~
>> crypto/scatterwalk.c:110:16: error: no member named 'addr' in 'struct scatter_walk'
     110 |                 memcpy(dwalk.addr, swalk.addr, len);
         |                        ~~~~~ ^
   arch/x86/include/asm/string_32.h:150:42: note: expanded from macro 'memcpy'
     150 | #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
         |                                          ^
   crypto/scatterwalk.c:110:28: error: no member named 'addr' in 'struct scatter_walk'
     110 |                 memcpy(dwalk.addr, swalk.addr, len);
         |                                    ~~~~~ ^
   arch/x86/include/asm/string_32.h:150:45: note: expanded from macro 'memcpy'
     150 | #define memcpy(t, f, n) __builtin_memcpy(t, f, n)
         |                                             ^
   crypto/scatterwalk.c:111:35: error: too few arguments to function call, expected 3, have 2
     111 |                 scatterwalk_done_dst(&dwalk, len);
         |                 ~~~~~~~~~~~~~~~~~~~~            ^
   include/crypto/scatterwalk.h:174:20: note: 'scatterwalk_done_dst' declared here
     174 | static inline void scatterwalk_done_dst(struct scatter_walk *walk,
         |                    ^                    ~~~~~~~~~~~~~~~~~~~~~~~~~~
     175 |                                         void *vaddr, unsigned int nbytes)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   crypto/scatterwalk.c:112:35: error: too few arguments to function call, expected 3, have 2
     112 |                 scatterwalk_done_src(&swalk, len);
         |                 ~~~~~~~~~~~~~~~~~~~~            ^
   include/crypto/scatterwalk.h:158:20: note: 'scatterwalk_done_src' declared here
     158 | static inline void scatterwalk_done_src(struct scatter_walk *walk,
         |                    ^                    ~~~~~~~~~~~~~~~~~~~~~~~~~~
     159 |                                         const void *vaddr, unsigned int nbytes)
         |                                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   6 errors generated.


vim +107 crypto/scatterwalk.c

    90	
    91	void memcpy_sglist(struct scatterlist *dst, struct scatterlist *src,
    92			   unsigned int nbytes)
    93	{
    94		struct scatter_walk swalk;
    95		struct scatter_walk dwalk;
    96	
    97		if (unlikely(nbytes == 0)) /* in case sg == NULL */
    98			return;
    99	
   100		scatterwalk_start(&swalk, src);
   101		scatterwalk_start(&dwalk, dst);
   102	
   103		do {
   104			unsigned int slen, dlen;
   105			unsigned int len;
   106	
 > 107			slen = scatterwalk_next(&swalk, nbytes);
   108			dlen = scatterwalk_next(&dwalk, nbytes);
   109			len = min(slen, dlen);
 > 110			memcpy(dwalk.addr, swalk.addr, len);
   111			scatterwalk_done_dst(&dwalk, len);
   112			scatterwalk_done_src(&swalk, len);
   113			nbytes -= len;
   114		} while (nbytes);
   115	}
   116	EXPORT_SYMBOL_GPL(memcpy_sglist);
   117	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
