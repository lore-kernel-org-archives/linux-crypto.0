Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A84340D9E;
	Wed, 21 Jan 2026 17:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769017859; cv=none; b=e6/a26ua+L7fTPGGAr6KVaksgqmITTIaSv1+nVf/0if2WaL+NOdPrTYvf4FOeD4gAPneWJytxzBRERjg79OLz8NSiZI0+yn55Tgm2eBSxxMBRbcEJkrCsjGvoGIyhTXnyZDIj8MShcomeV7iftfV9ZltlwaMw7FqSyiBu94b5wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769017859; c=relaxed/simple;
	bh=3MYiRsfmJspvl/SoswP+hUfE8ou4Z+5WbA9yfdIRxl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxyXywD2YfUtrto09DFjyssJonLOPnVYJsoLK4EYBHlcfCdv0TfCa/ognOv2R4zcBb/jb24kmAbHLibPXHtZC6CPsMBxtWM1+D22bsToq3zCvKIUZBNFUeUoqVMalPIzwEbwmTwcjYUrkcsi7fZlYnNNS16R3XNW+aoOqDr5Xuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d7CAJriX; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d7CAJriX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769017856; x=1800553856;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3MYiRsfmJspvl/SoswP+hUfE8ou4Z+5WbA9yfdIRxl8=;
  b=d7CAJriXKe4JYGUJbfDsC/NKds+6hyFqQA04ll3vsVMRgVbAF00cZ6uE
   xzBvnTYwaW6aWY6eOUmjFtTsKF4zWOYDgfzU9ruVdnWl4USE2rPIkwPyW
   Ddjp8z99ywiHVIsg9FJSnJrN/Si/gdbeABnLcMsT8jOUOtFC7r8mLs5KQ
   9pOloHTyYb/8zqPIO7hcwwBmLM82m6fibPtc2waXPfDznzgWhPR+bkOAz
   hpU9FHRhbtntnLpBb63t8lauHnayvL9tDKbv9Y5gib0pzSf8amCbTJqVN
   EkGKsHyIAZ1KgZn8DB3JxB3/WSdaHXyrWGfhu/uVRWFVD44w8kJF3gxz2
   A==;
X-CSE-ConnectionGUID: 6eYtpoZ7Q7ik/7lsfP2WcA==
X-CSE-MsgGUID: veqiXJW7QzaOUimjxMz9pw==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="81359611"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="81359611"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 09:50:55 -0800
X-CSE-ConnectionGUID: tOvd/WTMRkaB/9UPRysoMA==
X-CSE-MsgGUID: OKccG1LuQCyNjYxKe0uJPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206935246"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 21 Jan 2026 09:50:51 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vicLx-00000000RW1-0t8L;
	Wed, 21 Jan 2026 17:50:49 +0000
Date: Thu, 22 Jan 2026 01:50:11 +0800
From: kernel test robot <lkp@intel.com>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH] crypto: aegis128: Add RISC-V vector SIMD implementation
Message-ID: <202601220110.ontiS30n-lkp@intel.com>
References: <20260121101923.64657-1-zhangchunyan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121101923.64657-1-zhangchunyan@iscas.ac.cn>

Hi Chunyan,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.19-rc6 next-20260120]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chunyan-Zhang/crypto-aegis128-Add-RISC-V-vector-SIMD-implementation/20260121-184354
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20260121101923.64657-1-zhangchunyan%40iscas.ac.cn
patch subject: [PATCH] crypto: aegis128: Add RISC-V vector SIMD implementation
config: riscv-randconfig-001-20260121 (https://download.01.org/0day-ci/archive/20260122/202601220110.ontiS30n-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260122/202601220110.ontiS30n-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601220110.ontiS30n-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> crypto/aegis128-rvv.c:21:2: error: call to undeclared function 'kernel_vector_begin'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           kernel_vector_begin();
           ^
>> crypto/aegis128-rvv.c:23:2: error: call to undeclared function 'kernel_vector_end'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           kernel_vector_end();
           ^
   crypto/aegis128-rvv.c:28:2: error: call to undeclared function 'kernel_vector_begin'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           kernel_vector_begin();
           ^
   crypto/aegis128-rvv.c:30:2: error: call to undeclared function 'kernel_vector_end'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           kernel_vector_end();
           ^
   crypto/aegis128-rvv.c:36:2: error: call to undeclared function 'kernel_vector_begin'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           kernel_vector_begin();
           ^
   crypto/aegis128-rvv.c:38:2: error: call to undeclared function 'kernel_vector_end'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           kernel_vector_end();
           ^
   crypto/aegis128-rvv.c:44:2: error: call to undeclared function 'kernel_vector_begin'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           kernel_vector_begin();
           ^
   crypto/aegis128-rvv.c:46:2: error: call to undeclared function 'kernel_vector_end'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           kernel_vector_end();
           ^
   crypto/aegis128-rvv.c:57:2: error: call to undeclared function 'kernel_vector_begin'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           kernel_vector_begin();
           ^
   crypto/aegis128-rvv.c:60:2: error: call to undeclared function 'kernel_vector_end'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
           kernel_vector_end();
           ^
   10 errors generated.
--
>> crypto/aegis128-rvv-inner.c:317:10: warning: unknown option, expected 'push', 'pop', 'rvc', 'norvc', 'relax' or 'norelax' [-Winline-asm]
                         ".option  arch,+v\n"
                          ^
   <inline asm>:2:9: note: instantiated into assembly here
   .option arch,+v
           ^
>> crypto/aegis128-rvv-inner.c:318:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vsetivli zero, 0x10, e8, m1, ta, ma\n"
                          ^
   <inline asm>:3:1: note: instantiated into assembly here
   vsetivli        zero, 0x10, e8, m1, ta, ma
   ^
   crypto/aegis128-rvv-inner.c:319:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vle8.v   v0, (%[const0])\n"
                          ^
   <inline asm>:4:1: note: instantiated into assembly here
   vle8.v  v0, (a5)
   ^
   crypto/aegis128-rvv-inner.c:320:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vle8.v   v1, (%[const1])\n"
                          ^
   <inline asm>:5:1: note: instantiated into assembly here
   vle8.v  v1, (s1)
   ^
   crypto/aegis128-rvv-inner.c:321:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vse8.v   v0, (%[block2])\n"
                          ^
   <inline asm>:6:1: note: instantiated into assembly here
   vse8.v  v0, (a1)
   ^
   crypto/aegis128-rvv-inner.c:322:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vse8.v   v1, (%[block1])\n"
                          ^
   <inline asm>:7:1: note: instantiated into assembly here
   vse8.v  v1, (a0)
   ^
   crypto/aegis128-rvv-inner.c:323:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vle8.v   v2, (%[iv])\n"
                          ^
   <inline asm>:8:1: note: instantiated into assembly here
   vle8.v  v2, (a2)
   ^
   crypto/aegis128-rvv-inner.c:324:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vle8.v   v3, (%[key])\n"
                          ^
   <inline asm>:9:1: note: instantiated into assembly here
   vle8.v  v3, (s2)
   ^
   crypto/aegis128-rvv-inner.c:325:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vxor.vv  v0, v0, v3\n"
                          ^
   <inline asm>:10:1: note: instantiated into assembly here
   vxor.vv v0, v0, v3
   ^
   crypto/aegis128-rvv-inner.c:326:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vxor.vv  v1, v1, v3\n"
                          ^
   <inline asm>:11:1: note: instantiated into assembly here
   vxor.vv v1, v1, v3
   ^
   crypto/aegis128-rvv-inner.c:327:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vxor.vv  v2, v2, v3\n"
                          ^
   <inline asm>:12:1: note: instantiated into assembly here
   vxor.vv v2, v2, v3
   ^
   crypto/aegis128-rvv-inner.c:328:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vse8.v   v2, (%[block0])\n"
                          ^
   <inline asm>:13:1: note: instantiated into assembly here
   vse8.v  v2, (s3)
   ^
   crypto/aegis128-rvv-inner.c:329:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vse8.v   v2, (%[kiv])\n"
                          ^
   <inline asm>:14:1: note: instantiated into assembly here
   vse8.v  v2, (s6)
   ^
   crypto/aegis128-rvv-inner.c:330:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vse8.v   v0, (%[block3])\n"
                          ^
   <inline asm>:15:1: note: instantiated into assembly here
   vse8.v  v0, (a3)
   ^
   crypto/aegis128-rvv-inner.c:331:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vse8.v   v1, (%[block4])\n"
                          ^
   <inline asm>:16:1: note: instantiated into assembly here
   vse8.v  v1, (a4)
   ^
   crypto/aegis128-rvv-inner.c:82:10: warning: unknown option, expected 'push', 'pop', 'rvc', 'norvc', 'relax' or 'norelax' [-Winline-asm]
                         ".option  arch,+v\n"
                          ^
   <inline asm>:2:9: note: instantiated into assembly here
   .option arch,+v
           ^
   crypto/aegis128-rvv-inner.c:83:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vsetivli zero, 0x10, e8, m1, ta, ma\n"
                          ^
   <inline asm>:3:1: note: instantiated into assembly here
   vsetivli        zero, 0x10, e8, m1, ta, ma
   ^
   crypto/aegis128-rvv-inner.c:84:10: error: instruction requires the following: 'V' (Vector Extension for Application Processors), 'Zve32x' or 'Zve64x' (Vector Extensions for Embedded Processors)
                         "vle8.v   v13, (%[rev32qu16])\n"
                          ^
   <inline asm>:4:1: note: instantiated into assembly here
   vle8.v  v13, (a0)


vim +/kernel_vector_begin +21 crypto/aegis128-rvv.c

    16	
    17	void crypto_aegis128_init_simd(struct aegis_state *state,
    18				       const union aegis_block *key,
    19				       const u8 *iv)
    20	{
  > 21		kernel_vector_begin();
    22		crypto_aegis128_init_rvv(state, key, iv);
  > 23		kernel_vector_end();
    24	}
    25	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
