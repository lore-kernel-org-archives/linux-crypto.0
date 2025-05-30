Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A7C4C92;
	Fri, 30 May 2025 23:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748647333; cv=none; b=QcIOnpYIgx+FVF6hquR0Tb+nr0s+ExmRP+sdleHzxFCEly2ORV/SUuLQStC4S2gwXIJqj2/N4tk6T/2QhtgWZKqVsCyj13SCmKbLv21rOOGqylV9xY2y5fQfJwVUWl7ngFCfi4FiI+qt+79U/r3UFWN4PRtmlknQ63pLkaUMwkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748647333; c=relaxed/simple;
	bh=u5QPujAxahr3lgKkWm19elD7yswC9DeG1bmDQxztD4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZEZr1GhD5OWoOPbOFxEnQquBjjNPDepDwlRqSCeT4JAu3cFnIO3ipEX/G6OOjBCYeE0dcxCwdFdcrLiok+HG8IBtPLkQg1bim/adr6ZLNMVjqq/zzxFRrNCrrfUPsFYDmD3i0jXyg8Qb/5HukAbzaShmBHf0PFEAR9VbjgPTHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k0kaKnFC; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k0kaKnFC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748647331; x=1780183331;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=u5QPujAxahr3lgKkWm19elD7yswC9DeG1bmDQxztD4c=;
  b=k0kaKnFCvGV78ximktRG/6JwhkmVCy56OnBwQT60bK/mm9I3oR15qzyf
   rJMN92Z0B8VpI/LXrPazh/Bco5H0tajVwaRhvH/3Bc33jfzHOma9NcQE1
   S2vGDgXfvUJN3edP3aZsdGvDMeITMHBagPN5Xbg5xIXve1F0Bmj1cRrDE
   rOZC308fHTIqVm8mjyoK4PuzOu/0A29b5YyNnj7PCV1fNL7HvC7ApEU99
   4mQfsMe3aDiIACGmDQgJDoegRp+CHb+SLQPaf53eAVQFINDabOuFHNVrR
   cgeJzyWQ83wq0C+QE6gJ9++eALVglkQ1nYxdlIegrJiBvZWWr4XYoHD60
   g==;
X-CSE-ConnectionGUID: ydTVgESmQViSBHpdcVFfIg==
X-CSE-MsgGUID: 2uF0yv9kRPqVc3hPBT/EOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11449"; a="54545613"
X-IronPort-AV: E=Sophos;i="6.16,197,1744095600"; 
   d="scan'208";a="54545613"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2025 16:22:10 -0700
X-CSE-ConnectionGUID: Ryipz7i6Rr29OwdvhxkT1A==
X-CSE-MsgGUID: kg7DH605RG2+dEWiylfPvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,197,1744095600"; 
   d="scan'208";a="143987977"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 30 May 2025 16:22:08 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uL937-000Y2W-26;
	Fri, 30 May 2025 23:22:05 +0000
Date: Sat, 31 May 2025 07:21:50 +0800
From: kernel test robot <lkp@intel.com>
To: Harsh Jain <h.jain@amd.com>, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, mounika.botcha@amd.com,
	sarat.chand.savitala@amd.com, mohan.dhanawade@amd.com,
	michal.simek@amd.com
Cc: oe-kbuild-all@lists.linux.dev, Harsh Jain <h.jain@amd.com>
Subject: Re: [PATCH 2/3] crypto: xilinx: Add TRNG driver for Versal
Message-ID: <202505310740.bRheYmxs-lkp@intel.com>
References: <20250529113116.669667-3-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250529113116.669667-3-h.jain@amd.com>

Hi Harsh,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.15 next-20250530]
[cannot apply to xilinx-xlnx/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Harsh-Jain/dt-bindings-crypto-Add-node-for-True-Random-Number-Generator/20250529-193255
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250529113116.669667-3-h.jain%40amd.com
patch subject: [PATCH 2/3] crypto: xilinx: Add TRNG driver for Versal
config: arc-randconfig-r053-20250531 (https://download.01.org/0day-ci/archive/20250531/202505310740.bRheYmxs-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250531/202505310740.bRheYmxs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505310740.bRheYmxs-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   drivers/crypto/xilinx/xilinx-trng.c: In function 'xtrng_hwrng_trng_read':
>> include/linux/compiler_types.h:557:38: error: call to '__compiletime_assert_299' declared with attribute error: min(ret, (max - i)) signedness error
     557 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                      ^
   include/linux/compiler_types.h:538:4: note: in definition of macro '__compiletime_assert'
     538 |    prefix ## suffix();    \
         |    ^~~~~~
   include/linux/compiler_types.h:557:2: note: in expansion of macro '_compiletime_assert'
     557 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:93:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      93 |  BUILD_BUG_ON_MSG(!__types_ok(ux, uy),  \
         |  ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:98:2: note: in expansion of macro '__careful_cmp_once'
      98 |  __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
         |  ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:105:19: note: in expansion of macro '__careful_cmp'
     105 | #define min(x, y) __careful_cmp(min, x, y)
         |                   ^~~~~~~~~~~~~
   drivers/crypto/xilinx/xilinx-trng.c:300:25: note: in expansion of macro 'min'
     300 |   memcpy(data + i, buf, min(ret, (max - i)));
         |                         ^~~
--
   In file included from <command-line>:
   xilinx-trng.c: In function 'xtrng_hwrng_trng_read':
>> include/linux/compiler_types.h:557:38: error: call to '__compiletime_assert_299' declared with attribute error: min(ret, (max - i)) signedness error
     557 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                      ^
   include/linux/compiler_types.h:538:4: note: in definition of macro '__compiletime_assert'
     538 |    prefix ## suffix();    \
         |    ^~~~~~
   include/linux/compiler_types.h:557:2: note: in expansion of macro '_compiletime_assert'
     557 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:93:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      93 |  BUILD_BUG_ON_MSG(!__types_ok(ux, uy),  \
         |  ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:98:2: note: in expansion of macro '__careful_cmp_once'
      98 |  __careful_cmp_once(op, x, y, __UNIQUE_ID(x_), __UNIQUE_ID(y_))
         |  ^~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:105:19: note: in expansion of macro '__careful_cmp'
     105 | #define min(x, y) __careful_cmp(min, x, y)
         |                   ^~~~~~~~~~~~~
   xilinx-trng.c:300:25: note: in expansion of macro 'min'
     300 |   memcpy(data + i, buf, min(ret, (max - i)));
         |                         ^~~


vim +/__compiletime_assert_299 +557 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  543  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  544  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  545  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  546  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  547  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  548   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  549   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  550   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  551   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  552   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  553   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  554   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  555   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  556  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @557  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  558  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
