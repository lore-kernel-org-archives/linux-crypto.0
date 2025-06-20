Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030AD81ACA;
	Fri, 20 Jun 2025 03:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750388482; cv=none; b=CWP7IDGKYuGTl95n/XaXCC9mF+4dkLHcTZDAZ6tzEXRRClc8SqPZKod1ZDuAzqwNDmz9K3JXtsm8IfbOQ0tO+WLxRy004pd7GiSj2VQiBWRkP7zPYb6dvWT73iO0lZugEsKihDV1j9Dn2W3tyGGEGxct8EIAEEEHjKfHempL58w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750388482; c=relaxed/simple;
	bh=f7V5rYWc1EwjcgrxpnoH3ziozc2NpXhZC+YcuAXFxeE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pJJqgGJVibP7XMKwp3nRZRE6FnDGLhiEWrTczavCDs1PVQKmNn4KYjRZ2+3mmWMfc3wAEosIsraTDyiLVJapJTb8Z1eaCz9lfzTlM3szpSdzlg0XNrkq3DHcvhYa5BzqV1OIc6abRi2HNYeKzHXamP9ndopP7rj50SW4sSoCPU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ecMWs2IE; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ecMWs2IE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750388481; x=1781924481;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=f7V5rYWc1EwjcgrxpnoH3ziozc2NpXhZC+YcuAXFxeE=;
  b=ecMWs2IEvV9YE7XE7ZHHPOkzvHFd4oJPHx4eakVSUTkCgtcQFY0jSBVy
   OXfOQphJVULkLXIJoWQxrL8uGVyBxnGFO2V47z19jmxRoCUhwz24XbXwC
   j3gTg36Fd9zRhQW/j8CsLlBGPChwLUKLJS5u89TfJhGZGhI8QWmf3fPm9
   ci7UJSrL10kel2QIMCF0VPmoekFUzPKUuXTzNNUtPL/vRnzsAemn3b8ll
   zB0YsU9fEswWaYSIyRWxWTXCHpJ+R4lVCZMCInRj65lmlOlkDOFuftO6s
   3asugS5qFMEiCdM302xvx6i9t7W86OrqYf1qJkcnGx6VG3vrdaznos0W8
   w==;
X-CSE-ConnectionGUID: gLPstCzDQjuo8/JZiDINmA==
X-CSE-MsgGUID: 8tjdHGr7TSKgPSc0PK2h/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="51871292"
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="51871292"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 20:01:20 -0700
X-CSE-ConnectionGUID: AscknAMsTSqjYgMPwfOSEw==
X-CSE-MsgGUID: zF1ixVj+S4iOTJcojkyKRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="181664045"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 19 Jun 2025 20:01:17 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uSS0B-000LJu-1o;
	Fri, 20 Jun 2025 03:01:15 +0000
Date: Fri, 20 Jun 2025 11:00:18 +0800
From: kernel test robot <lkp@intel.com>
To: Ovidiu Panait <ovidiu.panait.oss@gmail.com>, clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, wens@csie.org, jernej.skrabec@gmail.com,
	samuel@sholland.org, linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: Re: [PATCH 10/10] crypto: sun8i-ce - implement request batching
Message-ID: <202506201006.eQ2P1PuC-lkp@intel.com>
References: <20250619122316.2587236-11-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250619122316.2587236-11-ovidiu.panait.oss@gmail.com>

Hi Ovidiu,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on next-20250619]
[cannot apply to sunxi/sunxi/for-next herbert-crypto-2.6/master linus/master v6.16-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ovidiu-Panait/crypto-sun8i-ce-remove-channel-timeout-field/20250619-202957
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250619122316.2587236-11-ovidiu.panait.oss%40gmail.com
patch subject: [PATCH 10/10] crypto: sun8i-ce - implement request batching
config: loongarch-allyesconfig (https://download.01.org/0day-ci/archive/20250620/202506201006.eQ2P1PuC-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250620/202506201006.eQ2P1PuC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506201006.eQ2P1PuC-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c: In function 'sun8i_ce_dump_task_descriptors':
>> drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:178:52: warning: '%d' directive output may be truncated writing between 1 and 11 bytes into a region of size 7 [-Wformat-truncation=]
     178 |                 snprintf(task, sizeof(task), "TASK %d:", i);
         |                                                    ^~
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:178:46: note: directive argument in the range [-2147483641, 2147483646]
     178 |                 snprintf(task, sizeof(task), "TASK %d:", i);
         |                                              ^~~~~~~~~~
   drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c:178:17: note: 'snprintf' output between 8 and 18 bytes into a destination of size 12
     178 |                 snprintf(task, sizeof(task), "TASK %d:", i);
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +178 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c

   171	
   172	static void sun8i_ce_dump_task_descriptors(struct sun8i_ce_flow *chan)
   173	{
   174		for (int i = 0; i < chan->reqs_no; ++i) {
   175			struct ce_task *cet = &chan->tl[i];
   176			char task[CE_MAX_TASK_DESCR_DUMP_MSG_SIZE];
   177	
 > 178			snprintf(task, sizeof(task), "TASK %d:", i);
   179			print_hex_dump(KERN_INFO, task, DUMP_PREFIX_NONE, 16, 4,
   180				       cet, sizeof(struct ce_task), false);
   181		}
   182	}
   183	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
