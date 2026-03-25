Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CEB315D46;
	Wed, 25 Mar 2026 05:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774417761; cv=none; b=C6ZN8ffI/7yBzxlUWxRfe7PgjY1kUNAkYZ5VFVLbOF0d7YrAShrmm0GFz6Ji/qz5XTaVcE90eDAk++C3jukNk/cjLGCY/3VrOBjadxNL8WLVZw3bNtLF6O7PnavuinJsUCCUE4sbPxm+N87fhgJt0wB7rbkghugf3mpkc4/YiHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774417761; c=relaxed/simple;
	bh=yNSLxXr/frsV5stEmBs7+zyttMOjHGrN+gV+hUbXI9Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qmfpnXvrI1em5QNEl6OXghB3Xu0mGfHv/qdIjSR/UAdLrno7LmisikM2gd3XqpbHykkSNfEYkwTT64A48jRz4VkSdn0xAIFkRb3+NXSPORlwaBm38DyPqH0nBmHaZK+h73eG9zwpA2yvN7yxFuhZ9eidEnAh9GYcpnyZf9OgcpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ef9EjFV2; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ef9EjFV2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774417760; x=1805953760;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=yNSLxXr/frsV5stEmBs7+zyttMOjHGrN+gV+hUbXI9Q=;
  b=ef9EjFV2KF35c5pe2REys5JZRpnu2Kq2NlhIXJtalfthUsVThg9yASH7
   naAbnOCMb4yyBxyyFrXmqm0Jw7Yll48AeYqj9vFi4s/1DQyBA/dT1Ljki
   IRlT4JPl33i459H8QVC3yXfRxsqz1fpi10oe9te1dRh8Fp/Rm9yCUCQJI
   KwDtR8vBP5DHxEY8YL+HXz8nkQ5gkY1CwBYPaJ2NSqR3j3l+nGG8gKJWk
   L631HjfGc6QLC1ZoVC7+nPDDlFaXPD48KdtNvDPtHkvE/8ScB5PcOWiPP
   qoVo5K7kbo1zXMvVDtUGENnGKNXTsZ4qrX0/A2vyeI3qa8rKY377KvB2f
   w==;
X-CSE-ConnectionGUID: R8rd2/KsTvOGkB3zdj+sbw==
X-CSE-MsgGUID: cpHiU6fORx6na0WB7EqBcA==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="86142218"
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="86142218"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 22:49:19 -0700
X-CSE-ConnectionGUID: IDYujCNzTFGNI2v+lvvJRg==
X-CSE-MsgGUID: o8t92k2tS9ijjKQUFLbf7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="228647091"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 24 Mar 2026 22:49:17 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w5H7C-000000006GH-30uo;
	Wed, 25 Mar 2026 05:49:14 +0000
Date: Wed, 25 Mar 2026 13:48:17 +0800
From: kernel test robot <lkp@intel.com>
To: Eric Biggers <ebiggers@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2] crypto: cryptomgr - Select algorithm types only when
 CRYPTO_SELFTESTS
Message-ID: <202603251327.8QCIZ1bS-lkp@intel.com>
References: <20260324050123.9494-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324050123.9494-1-ebiggers@kernel.org>

Hi Eric,

kernel test robot noticed the following build errors:

[auto build test ERROR on f9bbd547cfb98b1c5e535aab9b0671a2ff22453a]

url:    https://github.com/intel-lab-lkp/linux/commits/Eric-Biggers/crypto-cryptomgr-Select-algorithm-types-only-when-CRYPTO_SELFTESTS/20260324-131705
base:   f9bbd547cfb98b1c5e535aab9b0671a2ff22453a
patch link:    https://lore.kernel.org/r/20260324050123.9494-1-ebiggers%40kernel.org
patch subject: [PATCH v2] crypto: cryptomgr - Select algorithm types only when CRYPTO_SELFTESTS
config: i386-randconfig-053-20260325 (https://download.01.org/0day-ci/archive/20260325/202603251327.8QCIZ1bS-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260325/202603251327.8QCIZ1bS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603251327.8QCIZ1bS-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: crypto_register_acomps
   >>> referenced by qat_comp_algs.c:258 (drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:258)
   >>>               drivers/crypto/intel/qat/qat_common/qat_comp_algs.o:(qat_comp_algs_register) in archive vmlinux.a
--
>> ld.lld: error: undefined symbol: crypto_unregister_acomps
   >>> referenced by qat_comp_algs.c:267 (drivers/crypto/intel/qat/qat_common/qat_comp_algs.c:267)
   >>>               drivers/crypto/intel/qat/qat_common/qat_comp_algs.o:(qat_comp_algs_unregister) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
