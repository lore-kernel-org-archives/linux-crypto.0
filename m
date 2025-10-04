Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7627EEEA8;
	Sat,  4 Oct 2025 01:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759540765; cv=none; b=A6H71/Hpj/i8ivncvbrTFAZrI8dBAvd1KmYH1TN2tjn9mLuhTcGe2MgzGdJr+DaB8cgyf0CDnDw63qxPPt4ZAAOUo44cDyhPM8sBCx5VpLZ6ggyULmJq8MEUT4ROtm256yAENrcOo4p+2Q9qJm/o7WHMVNX5Da2fjkALSHTEZ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759540765; c=relaxed/simple;
	bh=fNfRYHZRZciYP1VNcc5BID8iEUccG3YVhkfMXauiGIc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HVQTQyqjD4t9YtFRhDxqVx4iE3cU6lCP+ZG7vHGr8DgPfXcDpOFFkj4Or9tzA8Zv61E4f13Ul12szPrm/0OhXZIpmjTGBAKutEhNRiDrdydPGS8NvVzR9CcCfRZVv/EL+4PMjPZamZuz+pY/QUt+x+stA3047Bc9pcBrVym5sX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ktCZCCQr; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ktCZCCQr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759540764; x=1791076764;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fNfRYHZRZciYP1VNcc5BID8iEUccG3YVhkfMXauiGIc=;
  b=ktCZCCQrnFGXis9AaiZLIevQVceogQxjQi+0XxrtVQbGex2Z8aaBwp+g
   bJfAXOnBk7INmyALnYLesShpPbWsPouITS+Hfb+nKperkxxueKSFQGIRR
   WwnliC3xQHclCw9//kw1Fz2UFebSaQ0u7CJHsDZbKoktWQoExHBzjoGLG
   ApO+wh8F52Y2lyTLO9p3hDxS0Xt+CcsAT1YMa2UVZgd9F86OgmBuPPPMk
   AwsaR5l/jxBpgwlSZ91q9Hi0FqlDUhJ0eiFG9+wm2OAikEebf/mpQyc9O
   ZoLVbWIr4K0y29EDUijeBUtWHzrF8gUsGzzd/8RcG8NmAsJvEiedYx3Kx
   A==;
X-CSE-ConnectionGUID: H/hDFKyJRbelj0cwge65gQ==
X-CSE-MsgGUID: IeTkcbNyRUiDWizL9Sq2kA==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="61988898"
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="61988898"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 18:19:23 -0700
X-CSE-ConnectionGUID: 7KqFVGjMReazrN229o0DBA==
X-CSE-MsgGUID: qNiyH4HgSxOJmfJN43zV6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,314,1751266800"; 
   d="scan'208";a="179840945"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 03 Oct 2025 18:19:20 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v4qvd-00050h-1N;
	Sat, 04 Oct 2025 01:19:17 +0000
Date: Sat, 4 Oct 2025 09:18:53 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, krzk+dt@kernel.org,
	conor+dt@kernel.org, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v6 4/4] Add SPAcc Kconfig and Makefile
Message-ID: <202510040852.qK4TiL4k-lkp@intel.com>
References: <20250929074334.118413-5-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929074334.118413-5-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build errors:

[auto build test ERROR on 166c83f7789ed02dc1f25bc7bed4a1beb25343aa]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-Managutte/dt-bindings-crypto-Document-support-for-SPAcc/20250929-155434
base:   166c83f7789ed02dc1f25bc7bed4a1beb25343aa
patch link:    https://lore.kernel.org/r/20250929074334.118413-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH v6 4/4] Add SPAcc Kconfig and Makefile
config: i386-randconfig-013-20251004 (https://download.01.org/0day-ci/archive/20251004/202510040852.qK4TiL4k-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251004/202510040852.qK4TiL4k-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510040852.qK4TiL4k-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: crypto_engine_alloc_init
   >>> referenced by spacc_device.c:88 (drivers/crypto/dwc-spacc/spacc_device.c:88)
   >>>               drivers/crypto/dwc-spacc/spacc_device.o:(spacc_crypto_probe) in archive vmlinux.a
--
>> ld.lld: error: undefined symbol: crypto_engine_start
   >>> referenced by spacc_device.c:95 (drivers/crypto/dwc-spacc/spacc_device.c:95)
   >>>               drivers/crypto/dwc-spacc/spacc_device.o:(spacc_crypto_probe) in archive vmlinux.a
--
>> ld.lld: error: undefined symbol: crypto_engine_stop
   >>> referenced by spacc_device.c:203 (drivers/crypto/dwc-spacc/spacc_device.c:203)
   >>>               drivers/crypto/dwc-spacc/spacc_device.o:(spacc_crypto_probe) in archive vmlinux.a
   >>> referenced by spacc_device.c:250 (drivers/crypto/dwc-spacc/spacc_device.c:250)
   >>>               drivers/crypto/dwc-spacc/spacc_device.o:(spacc_crypto_remove) in archive vmlinux.a
--
>> ld.lld: error: undefined symbol: crypto_engine_exit
   >>> referenced by spacc_device.c:206 (drivers/crypto/dwc-spacc/spacc_device.c:206)
   >>>               drivers/crypto/dwc-spacc/spacc_device.o:(spacc_crypto_probe) in archive vmlinux.a
   >>> referenced by spacc_device.c:251 (drivers/crypto/dwc-spacc/spacc_device.c:251)
   >>>               drivers/crypto/dwc-spacc/spacc_device.o:(spacc_crypto_remove) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
