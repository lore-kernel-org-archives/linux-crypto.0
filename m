Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2811B199DC
	for <linux-crypto@vger.kernel.org>; Wed,  6 Mar 2024 07:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709710039; cv=none; b=RnVtMyXBCxnwm3gxUpFXrzx/TEMV5Q2l1NNZKnLGzeBhOEtGA8V+bjyR97EmvHCIAztfTpeDXZCldfPaLX5MsGmTj3p8c24Oo/XT3jJqBkDVOvr2tHj9UtnuIOKqeXjDX0ZgIhVbChBLvEHm6ecpyhS0RhtL/jsNxVN5v97Z7XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709710039; c=relaxed/simple;
	bh=4LmBbiEU0kdsSfKtEHLEG/h/dQhOZhi0lWHvBxn4h7s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=meX4Vzdy4WxhDrJS4yPUcq2rnFbtPwZW4snUQO1nphIhuG/QHYER70K457EoBCvl/Sgx9uXFcG5S6dzWw1v6AYBKfoOpkTWkYA9iEOe2twRSVW101z+WdDFmXfaleK+IvudXF6tlKXrSa80u+Wqqlm97E4gyrWtD7kKarUIufro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KMx7JknK; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KMx7JknK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709710037; x=1741246037;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4LmBbiEU0kdsSfKtEHLEG/h/dQhOZhi0lWHvBxn4h7s=;
  b=KMx7JknKJf+in/jAMwvrTmQnAY3UGt6QTdQNvamatnAowueuwqTD0ATZ
   MFMjsiH1VUJgIJBt2mgsjGO99t1sGKcXEVnsIbaEEH8nJho8d2ktiH3vQ
   9BpfO0hwzCMZ43dRNJk7Rk4LiesVCT18kj9yBzUwgT0nxRfSNzt36XFp7
   ZFnJjYD/lxVf71XKMnQloTrqIw94Ej/i9tYWzlcIZtGqPb6KtNdfc5bA0
   RgJieK9fP/UJbQTJvqBmd6uSAwcQXQdOogIuo58J3z6GRxNmWgi6gR5Wt
   cCdKgKGVaeRc/egVqzXQkZInpEwOd4ugxTjYCUvad3f6gktkfDnW8MEkZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="14955972"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="14955972"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 23:27:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="14148789"
Received: from lkp-server01.sh.intel.com (HELO b21307750695) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 05 Mar 2024 23:27:14 -0800
Received: from kbuild by b21307750695 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rhlgG-000425-0d;
	Wed, 06 Mar 2024 07:27:12 +0000
Date: Wed, 6 Mar 2024 15:26:55 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and
 Makefile file
Message-ID: <202403061522.phoAmD4a-lkp@intel.com>
References: <20240305112831.3380896-5-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305112831.3380896-5-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.8-rc7 next-20240305]
[cannot apply to xilinx-xlnx/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-M/Add-SPAcc-driver-to-Linux-kernel/20240305-193337
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20240305112831.3380896-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
config: x86_64-randconfig-122-20240306 (https://download.01.org/0day-ci/archive/20240306/202403061522.phoAmD4a-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240306/202403061522.phoAmD4a-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202403061522.phoAmD4a-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/crypto/dwc-spacc/spacc_interrupt.c:17:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:17:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:17:36: sparse:     got void *
>> drivers/crypto/dwc-spacc/spacc_interrupt.c:21:17: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:21:17: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:21:17: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:46:63: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:46:63: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:46:63: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:54:63: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:54:63: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:54:63: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:65:25: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:65:25: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:65:25: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:82:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:82:33: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:82:33: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:97:35: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:97:35: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:97:35: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:108:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:108:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:108:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:112:39: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:112:39: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:112:39: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:114:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:114:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:114:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:116:47: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:116:47: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:116:47: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:121:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:121:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:121:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:123:39: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:123:39: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:123:39: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:130:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:130:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:130:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:139:36: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:139:36: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:139:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:140:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:140:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:140:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:142:47: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:142:47: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:142:47: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:147:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:147:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:147:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:149:47: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:149:47: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:149:47: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:154:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:154:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:154:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:156:47: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:156:47: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:156:47: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:161:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:161:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:161:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:163:47: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:163:47: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:163:47: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:168:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:168:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:168:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:170:47: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:170:47: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:170:47: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:175:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:175:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:175:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:177:47: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:177:47: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:177:47: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_interrupt.c:182:33: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_interrupt.c:182:33: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_interrupt.c:182:33: sparse:     got void *
>> drivers/crypto/dwc-spacc/spacc_interrupt.c:180:6: sparse: sparse: symbol 'spacc_disable_int' was not declared. Should it be static?
--
>> drivers/crypto/dwc-spacc/spacc_device.c:106:18: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void *baseaddr @@     got void [noderef] __iomem * @@
   drivers/crypto/dwc-spacc/spacc_device.c:106:18: sparse:     expected void *baseaddr
   drivers/crypto/dwc-spacc/spacc_device.c:106:18: sparse:     got void [noderef] __iomem *
>> drivers/crypto/dwc-spacc/spacc_device.c:227:36: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_device.c:227:36: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_device.c:227:36: sparse:     got void *
>> drivers/crypto/dwc-spacc/spacc_device.c:229:36: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_device.c:229:36: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_device.c:229:36: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_device.c:233:28: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_device.c:233:28: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_device.c:233:28: sparse:     got void *
--
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:15:17: sparse: sparse: symbol 'possible_ciphers' was not declared. Should it be static?
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:153:50: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_skcipher.c:153:50: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_skcipher.c:153:50: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_skcipher.c:477:44: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_skcipher.c:477:44: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_skcipher.c:477:44: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_skcipher.c:492:51: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_skcipher.c:492:51: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_skcipher.c:492:51: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_skcipher.c:509:51: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_skcipher.c:509:51: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_skcipher.c:509:51: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_skcipher.c:526:51: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_skcipher.c:526:51: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_skcipher.c:526:51: sparse:     got void *
>> drivers/crypto/dwc-spacc/spacc_skcipher.c:651:21: sparse: sparse: symbol 'spacc_skcipher_alg' was not declared. Should it be static?
   drivers/crypto/dwc-spacc/spacc_skcipher.c: note: in included file (through include/linux/smp.h, include/linux/lockdep.h, include/linux/spinlock.h, ...):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
--
>> drivers/crypto/dwc-spacc/spacc_aead.c:522:50: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_aead.c:522:50: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_aead.c:522:50: sparse:     got void *
>> drivers/crypto/dwc-spacc/spacc_aead.c:1246:17: sparse: sparse: symbol 'spacc_aead_algs' was not declared. Should it be static?
   drivers/crypto/dwc-spacc/spacc_aead.c: note: in included file (through include/linux/swait.h, include/linux/completion.h, include/linux/crypto.h, ...):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
--
>> drivers/crypto/dwc-spacc/spacc_ahash.c:1106:24: sparse: sparse: symbol 'spacc_hash_template' was not declared. Should it be static?
   drivers/crypto/dwc-spacc/spacc_ahash.c: note: in included file (through include/linux/swait.h, include/linux/completion.h, include/linux/crypto.h, ...):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
--
>> drivers/crypto/dwc-spacc/spacc_hal.c:25:25: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_hal.c:25:25: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:25:25: sparse:     got void *
>> drivers/crypto/dwc-spacc/spacc_hal.c:46:32: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_hal.c:46:32: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:46:32: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_hal.c:48:23: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_hal.c:48:23: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:48:23: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_hal.c:57:25: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_hal.c:57:25: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:57:25: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_hal.c:66:25: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_hal.c:66:25: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:66:25: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_hal.c:86:33: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_hal.c:86:33: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:86:33: sparse:     got void *
   drivers/crypto/dwc-spacc/spacc_hal.c:92:31: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void * @@
   drivers/crypto/dwc-spacc/spacc_hal.c:92:31: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:92:31: sparse:     got void *
>> drivers/crypto/dwc-spacc/spacc_hal.c:103:32: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got unsigned char *addr @@
   drivers/crypto/dwc-spacc/spacc_hal.c:103:32: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:103:32: sparse:     got unsigned char *addr
>> drivers/crypto/dwc-spacc/spacc_hal.c:113:32: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got unsigned char *addr @@
   drivers/crypto/dwc-spacc/spacc_hal.c:113:32: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:113:32: sparse:     got unsigned char *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:130:27: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got unsigned char *addr @@
   drivers/crypto/dwc-spacc/spacc_hal.c:130:27: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:130:27: sparse:     got unsigned char *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:142:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got unsigned char *addr @@
   drivers/crypto/dwc-spacc/spacc_hal.c:142:27: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:142:27: sparse:     got unsigned char *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:163:27: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got unsigned char *addr @@
   drivers/crypto/dwc-spacc/spacc_hal.c:163:27: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:163:27: sparse:     got unsigned char *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:175:27: sparse: sparse: incorrect type in argument 1 (different address spaces) @@     expected void const volatile [noderef] __iomem *addr @@     got unsigned char *addr @@
   drivers/crypto/dwc-spacc/spacc_hal.c:175:27: sparse:     expected void const volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:175:27: sparse:     got unsigned char *addr
>> drivers/crypto/dwc-spacc/spacc_hal.c:212:21: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected void volatile [noderef] __iomem *addr @@     got void *addr @@
   drivers/crypto/dwc-spacc/spacc_hal.c:212:21: sparse:     expected void volatile [noderef] __iomem *addr
   drivers/crypto/dwc-spacc/spacc_hal.c:212:21: sparse:     got void *addr

vim +17 drivers/crypto/dwc-spacc/spacc_interrupt.c

6ad822cec22644 Pavitrakumar M 2024-03-05    8  
6ad822cec22644 Pavitrakumar M 2024-03-05    9  uint32_t spacc_process_irq(struct spacc_device *spacc)
6ad822cec22644 Pavitrakumar M 2024-03-05   10  {
6ad822cec22644 Pavitrakumar M 2024-03-05   11  	u32 temp, tempreg;
6ad822cec22644 Pavitrakumar M 2024-03-05   12  	int x, cmd_max;
6ad822cec22644 Pavitrakumar M 2024-03-05   13  	unsigned long lock_flag;
6ad822cec22644 Pavitrakumar M 2024-03-05   14  
6ad822cec22644 Pavitrakumar M 2024-03-05   15  	spin_lock_irqsave(&spacc->lock, lock_flag);
6ad822cec22644 Pavitrakumar M 2024-03-05   16  
6ad822cec22644 Pavitrakumar M 2024-03-05  @17  	temp = readl(spacc->regmap + SPACC_REG_IRQ_STAT);
6ad822cec22644 Pavitrakumar M 2024-03-05   18  
6ad822cec22644 Pavitrakumar M 2024-03-05   19  	/* clear interrupt pin and run registered callback */
6ad822cec22644 Pavitrakumar M 2024-03-05   20  	if (temp & SPACC_IRQ_STAT_STAT) {
6ad822cec22644 Pavitrakumar M 2024-03-05  @21  		SPACC_IRQ_STAT_CLEAR_STAT(spacc);
6ad822cec22644 Pavitrakumar M 2024-03-05   22  		if (spacc->op_mode == SPACC_OP_MODE_IRQ) {
6ad822cec22644 Pavitrakumar M 2024-03-05   23  			spacc->config.fifo_cnt <<= 2;
6ad822cec22644 Pavitrakumar M 2024-03-05   24  			if (spacc->config.fifo_cnt >=
6ad822cec22644 Pavitrakumar M 2024-03-05   25  					spacc->config.stat_fifo_depth)
6ad822cec22644 Pavitrakumar M 2024-03-05   26  				spacc->config.fifo_cnt =
6ad822cec22644 Pavitrakumar M 2024-03-05   27  					spacc->config.stat_fifo_depth;
6ad822cec22644 Pavitrakumar M 2024-03-05   28  
6ad822cec22644 Pavitrakumar M 2024-03-05   29  			/* update fifo count to allow more stati to pile up*/
6ad822cec22644 Pavitrakumar M 2024-03-05   30  			spacc_irq_stat_enable(spacc, spacc->config.fifo_cnt);
6ad822cec22644 Pavitrakumar M 2024-03-05   31  			 /* reenable CMD0 empty interrupt*/
6ad822cec22644 Pavitrakumar M 2024-03-05   32  			spacc_irq_cmdx_enable(spacc, 0, 0);
6ad822cec22644 Pavitrakumar M 2024-03-05   33  		} else if (spacc->op_mode == SPACC_OP_MODE_WD) {
6ad822cec22644 Pavitrakumar M 2024-03-05   34  		}
6ad822cec22644 Pavitrakumar M 2024-03-05   35  		if (spacc->irq_cb_stat)
6ad822cec22644 Pavitrakumar M 2024-03-05   36  			spacc->irq_cb_stat(spacc);
6ad822cec22644 Pavitrakumar M 2024-03-05   37  	}
6ad822cec22644 Pavitrakumar M 2024-03-05   38  
6ad822cec22644 Pavitrakumar M 2024-03-05   39  	/* Watchdog IRQ */
6ad822cec22644 Pavitrakumar M 2024-03-05   40  	if (spacc->op_mode == SPACC_OP_MODE_WD) {
6ad822cec22644 Pavitrakumar M 2024-03-05   41  		if (temp & SPACC_IRQ_STAT_STAT_WD) {
6ad822cec22644 Pavitrakumar M 2024-03-05   42  			if (++spacc->wdcnt == SPACC_WD_LIMIT) {
6ad822cec22644 Pavitrakumar M 2024-03-05   43  				/* this happens when you get too many IRQs that
6ad822cec22644 Pavitrakumar M 2024-03-05   44  				 *  go unanswered
6ad822cec22644 Pavitrakumar M 2024-03-05   45  				 */
6ad822cec22644 Pavitrakumar M 2024-03-05   46  				tempreg = readl(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05   47  							SPACC_REG_IRQ_EN);
6ad822cec22644 Pavitrakumar M 2024-03-05   48  				spacc_irq_stat_wd_disable(spacc);
6ad822cec22644 Pavitrakumar M 2024-03-05   49  				 /* we set the STAT CNT to 1 so that every job
6ad822cec22644 Pavitrakumar M 2024-03-05   50  				  * generates an IRQ now
6ad822cec22644 Pavitrakumar M 2024-03-05   51  				  */
6ad822cec22644 Pavitrakumar M 2024-03-05   52  				spacc_irq_stat_enable(spacc, 1);
6ad822cec22644 Pavitrakumar M 2024-03-05   53  				spacc->op_mode = SPACC_OP_MODE_IRQ;
6ad822cec22644 Pavitrakumar M 2024-03-05   54  				tempreg = readl(spacc->regmap +
6ad822cec22644 Pavitrakumar M 2024-03-05   55  							SPACC_REG_IRQ_EN);
6ad822cec22644 Pavitrakumar M 2024-03-05   56  			} else if (spacc->config.wd_timer < (0xFFFFFFUL >> 4)) {
6ad822cec22644 Pavitrakumar M 2024-03-05   57  				/* if the timer isn't too high lets bump it up
6ad822cec22644 Pavitrakumar M 2024-03-05   58  				 * a bit so as to give the IRQ a chance to
6ad822cec22644 Pavitrakumar M 2024-03-05   59  				 * reply
6ad822cec22644 Pavitrakumar M 2024-03-05   60  				 */
6ad822cec22644 Pavitrakumar M 2024-03-05   61  				spacc_set_wd_count(spacc,
6ad822cec22644 Pavitrakumar M 2024-03-05   62  						   spacc->config.wd_timer << 4);
6ad822cec22644 Pavitrakumar M 2024-03-05   63  			}
6ad822cec22644 Pavitrakumar M 2024-03-05   64  
6ad822cec22644 Pavitrakumar M 2024-03-05   65  			SPACC_IRQ_STAT_CLEAR_STAT_WD(spacc);
6ad822cec22644 Pavitrakumar M 2024-03-05   66  			if (spacc->irq_cb_stat_wd)
6ad822cec22644 Pavitrakumar M 2024-03-05   67  				spacc->irq_cb_stat_wd(spacc);
6ad822cec22644 Pavitrakumar M 2024-03-05   68  		}
6ad822cec22644 Pavitrakumar M 2024-03-05   69  	}
6ad822cec22644 Pavitrakumar M 2024-03-05   70  
6ad822cec22644 Pavitrakumar M 2024-03-05   71  	if (spacc->op_mode == SPACC_OP_MODE_IRQ) {
6ad822cec22644 Pavitrakumar M 2024-03-05   72  		cmd_max = (spacc->config.is_qos ? SPACC_CMDX_MAX_QOS :
6ad822cec22644 Pavitrakumar M 2024-03-05   73  				SPACC_CMDX_MAX);
6ad822cec22644 Pavitrakumar M 2024-03-05   74  		for (x = 0; x < cmd_max; x++) {
6ad822cec22644 Pavitrakumar M 2024-03-05   75  			if (temp & SPACC_IRQ_STAT_CMDX(x)) {
6ad822cec22644 Pavitrakumar M 2024-03-05   76  				spacc->config.fifo_cnt = 1;
6ad822cec22644 Pavitrakumar M 2024-03-05   77  				/* disable CMD0 interrupt since STAT=1 */
6ad822cec22644 Pavitrakumar M 2024-03-05   78  				spacc_irq_cmdx_disable(spacc, x);
6ad822cec22644 Pavitrakumar M 2024-03-05   79  				spacc_irq_stat_enable(spacc,
6ad822cec22644 Pavitrakumar M 2024-03-05   80  						      spacc->config.fifo_cnt);
6ad822cec22644 Pavitrakumar M 2024-03-05   81  
6ad822cec22644 Pavitrakumar M 2024-03-05   82  				SPACC_IRQ_STAT_CLEAR_CMDX(spacc, x);
6ad822cec22644 Pavitrakumar M 2024-03-05   83  				/* run registered callback */
6ad822cec22644 Pavitrakumar M 2024-03-05   84  				if (spacc->irq_cb_cmdx)
6ad822cec22644 Pavitrakumar M 2024-03-05   85  					spacc->irq_cb_cmdx(spacc, x);
6ad822cec22644 Pavitrakumar M 2024-03-05   86  			}
6ad822cec22644 Pavitrakumar M 2024-03-05   87  		}
6ad822cec22644 Pavitrakumar M 2024-03-05   88  	}
6ad822cec22644 Pavitrakumar M 2024-03-05   89  
6ad822cec22644 Pavitrakumar M 2024-03-05   90  	spin_unlock_irqrestore(&spacc->lock, lock_flag);
6ad822cec22644 Pavitrakumar M 2024-03-05   91  
6ad822cec22644 Pavitrakumar M 2024-03-05   92  	return temp;
6ad822cec22644 Pavitrakumar M 2024-03-05   93  }
6ad822cec22644 Pavitrakumar M 2024-03-05   94  
6ad822cec22644 Pavitrakumar M 2024-03-05   95  void spacc_set_wd_count(struct spacc_device *spacc, uint32_t val)
6ad822cec22644 Pavitrakumar M 2024-03-05   96  {
6ad822cec22644 Pavitrakumar M 2024-03-05   97  	writel(val, spacc->regmap + SPACC_REG_STAT_WD_CTRL);
6ad822cec22644 Pavitrakumar M 2024-03-05   98  }
6ad822cec22644 Pavitrakumar M 2024-03-05   99  
6ad822cec22644 Pavitrakumar M 2024-03-05  100  /* cmdx and cmdx_cnt depend on HW config */
6ad822cec22644 Pavitrakumar M 2024-03-05  101  /* cmdx can be 0, 1 or 2 */
6ad822cec22644 Pavitrakumar M 2024-03-05  102  /* cmdx_cnt must be 2^6 or less */
6ad822cec22644 Pavitrakumar M 2024-03-05  103  void spacc_irq_cmdx_enable(struct spacc_device *spacc, int cmdx, int cmdx_cnt)
6ad822cec22644 Pavitrakumar M 2024-03-05  104  {
6ad822cec22644 Pavitrakumar M 2024-03-05  105  	u32 temp;
6ad822cec22644 Pavitrakumar M 2024-03-05  106  
6ad822cec22644 Pavitrakumar M 2024-03-05  107  	/* read the reg, clear the bit range and set the new value */
6ad822cec22644 Pavitrakumar M 2024-03-05  108  	temp = readl(spacc->regmap + SPACC_REG_IRQ_CTRL) &
6ad822cec22644 Pavitrakumar M 2024-03-05  109  		(~SPACC_IRQ_CTRL_CMDX_CNT_MASK(cmdx));
6ad822cec22644 Pavitrakumar M 2024-03-05  110  	temp |= SPACC_IRQ_CTRL_CMDX_CNT_SET(cmdx, cmdx_cnt);
6ad822cec22644 Pavitrakumar M 2024-03-05  111  	writel(temp | SPACC_IRQ_CTRL_CMDX_CNT_SET(cmdx, cmdx_cnt),
6ad822cec22644 Pavitrakumar M 2024-03-05  112  			spacc->regmap + SPACC_REG_IRQ_CTRL);
6ad822cec22644 Pavitrakumar M 2024-03-05  113  
6ad822cec22644 Pavitrakumar M 2024-03-05  114  	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) |
6ad822cec22644 Pavitrakumar M 2024-03-05  115  				SPACC_IRQ_EN_CMD(cmdx),
6ad822cec22644 Pavitrakumar M 2024-03-05  116  				spacc->regmap + SPACC_REG_IRQ_EN);
6ad822cec22644 Pavitrakumar M 2024-03-05  117  }
6ad822cec22644 Pavitrakumar M 2024-03-05  118  
6ad822cec22644 Pavitrakumar M 2024-03-05  119  void spacc_irq_cmdx_disable(struct spacc_device *spacc, int cmdx)
6ad822cec22644 Pavitrakumar M 2024-03-05  120  {
6ad822cec22644 Pavitrakumar M 2024-03-05  121  	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
6ad822cec22644 Pavitrakumar M 2024-03-05  122  			(~SPACC_IRQ_EN_CMD(cmdx)),
6ad822cec22644 Pavitrakumar M 2024-03-05  123  			spacc->regmap + SPACC_REG_IRQ_EN);
6ad822cec22644 Pavitrakumar M 2024-03-05  124  }
6ad822cec22644 Pavitrakumar M 2024-03-05  125  
6ad822cec22644 Pavitrakumar M 2024-03-05  126  void spacc_irq_stat_enable(struct spacc_device *spacc, int stat_cnt)
6ad822cec22644 Pavitrakumar M 2024-03-05  127  {
6ad822cec22644 Pavitrakumar M 2024-03-05  128  	u32 temp;
6ad822cec22644 Pavitrakumar M 2024-03-05  129  
6ad822cec22644 Pavitrakumar M 2024-03-05  130  	temp = readl(spacc->regmap + SPACC_REG_IRQ_CTRL);
6ad822cec22644 Pavitrakumar M 2024-03-05  131  	if (spacc->config.is_qos) {
6ad822cec22644 Pavitrakumar M 2024-03-05  132  		temp &= (~SPACC_IRQ_CTRL_STAT_CNT_MASK_QOS);
6ad822cec22644 Pavitrakumar M 2024-03-05  133  		temp |= SPACC_IRQ_CTRL_STAT_CNT_SET_QOS(stat_cnt);
6ad822cec22644 Pavitrakumar M 2024-03-05  134  	} else {
6ad822cec22644 Pavitrakumar M 2024-03-05  135  		temp &= (~SPACC_IRQ_CTRL_STAT_CNT_MASK);
6ad822cec22644 Pavitrakumar M 2024-03-05  136  		temp |= SPACC_IRQ_CTRL_STAT_CNT_SET(stat_cnt);
6ad822cec22644 Pavitrakumar M 2024-03-05  137  	}
6ad822cec22644 Pavitrakumar M 2024-03-05  138  
6ad822cec22644 Pavitrakumar M 2024-03-05  139  	writel(temp, spacc->regmap + SPACC_REG_IRQ_CTRL);
6ad822cec22644 Pavitrakumar M 2024-03-05  140  	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) |
6ad822cec22644 Pavitrakumar M 2024-03-05  141  				SPACC_IRQ_EN_STAT,
6ad822cec22644 Pavitrakumar M 2024-03-05  142  				spacc->regmap + SPACC_REG_IRQ_EN);
6ad822cec22644 Pavitrakumar M 2024-03-05  143  }
6ad822cec22644 Pavitrakumar M 2024-03-05  144  
6ad822cec22644 Pavitrakumar M 2024-03-05  145  void spacc_irq_stat_disable(struct spacc_device *spacc)
6ad822cec22644 Pavitrakumar M 2024-03-05  146  {
6ad822cec22644 Pavitrakumar M 2024-03-05  147  	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
6ad822cec22644 Pavitrakumar M 2024-03-05  148  				(~SPACC_IRQ_EN_STAT),
6ad822cec22644 Pavitrakumar M 2024-03-05  149  				spacc->regmap + SPACC_REG_IRQ_EN);
6ad822cec22644 Pavitrakumar M 2024-03-05  150  }
6ad822cec22644 Pavitrakumar M 2024-03-05  151  
6ad822cec22644 Pavitrakumar M 2024-03-05  152  void spacc_irq_stat_wd_enable(struct spacc_device *spacc)
6ad822cec22644 Pavitrakumar M 2024-03-05  153  {
6ad822cec22644 Pavitrakumar M 2024-03-05  154  	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) |
6ad822cec22644 Pavitrakumar M 2024-03-05  155  				SPACC_IRQ_EN_STAT_WD,
6ad822cec22644 Pavitrakumar M 2024-03-05  156  				spacc->regmap + SPACC_REG_IRQ_EN);
6ad822cec22644 Pavitrakumar M 2024-03-05  157  }
6ad822cec22644 Pavitrakumar M 2024-03-05  158  
6ad822cec22644 Pavitrakumar M 2024-03-05  159  void spacc_irq_stat_wd_disable(struct spacc_device *spacc)
6ad822cec22644 Pavitrakumar M 2024-03-05  160  {
6ad822cec22644 Pavitrakumar M 2024-03-05  161  	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
6ad822cec22644 Pavitrakumar M 2024-03-05  162  				(~SPACC_IRQ_EN_STAT_WD),
6ad822cec22644 Pavitrakumar M 2024-03-05  163  				spacc->regmap + SPACC_REG_IRQ_EN);
6ad822cec22644 Pavitrakumar M 2024-03-05  164  }
6ad822cec22644 Pavitrakumar M 2024-03-05  165  
6ad822cec22644 Pavitrakumar M 2024-03-05  166  void spacc_irq_glbl_enable(struct spacc_device *spacc)
6ad822cec22644 Pavitrakumar M 2024-03-05  167  {
6ad822cec22644 Pavitrakumar M 2024-03-05  168  	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) |
6ad822cec22644 Pavitrakumar M 2024-03-05  169  				SPACC_IRQ_EN_GLBL,
6ad822cec22644 Pavitrakumar M 2024-03-05  170  				spacc->regmap + SPACC_REG_IRQ_EN);
6ad822cec22644 Pavitrakumar M 2024-03-05  171  }
6ad822cec22644 Pavitrakumar M 2024-03-05  172  
6ad822cec22644 Pavitrakumar M 2024-03-05  173  void spacc_irq_glbl_disable(struct spacc_device *spacc)
6ad822cec22644 Pavitrakumar M 2024-03-05  174  {
6ad822cec22644 Pavitrakumar M 2024-03-05 @175  	writel(readl(spacc->regmap + SPACC_REG_IRQ_EN) &
6ad822cec22644 Pavitrakumar M 2024-03-05  176  				(~SPACC_IRQ_EN_GLBL),
6ad822cec22644 Pavitrakumar M 2024-03-05  177  				spacc->regmap + SPACC_REG_IRQ_EN);
6ad822cec22644 Pavitrakumar M 2024-03-05  178  }
6ad822cec22644 Pavitrakumar M 2024-03-05  179  
6ad822cec22644 Pavitrakumar M 2024-03-05 @180  void spacc_disable_int (struct spacc_device *spacc)
6ad822cec22644 Pavitrakumar M 2024-03-05  181  {
6ad822cec22644 Pavitrakumar M 2024-03-05  182  	writel(0, spacc->regmap + SPACC_REG_IRQ_EN);
6ad822cec22644 Pavitrakumar M 2024-03-05  183  }
6ad822cec22644 Pavitrakumar M 2024-03-05  184  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
