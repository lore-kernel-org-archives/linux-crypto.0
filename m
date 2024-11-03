Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D44D156225;
	Sun,  3 Nov 2024 09:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730624669; cv=none; b=hZqXqTnSAjPH2rNauyu8ZBGhTEVeJfYX/hXClAsOYR5SEEZU0doidzfj95ay6af0A34thXEaw3Lb8jqZrnyyaehbHGgUz5cpiBwlGrvvbHRfddyAhdxCVnJORQZ7ln9WS8tVMZbD+bH6+3zhGqkkt5NRbZ4ilXj72df7X9kWe+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730624669; c=relaxed/simple;
	bh=snBziOUc/u2Kkl53/U6DI9Ys6nv3Gp9bFeiW0dtFrtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AG0+/T7ULWnQZupJtMYGMz+y62X6QFTbDxXjsLbaw5G/+QiyVNvPriDZiQhmfbLXmAIteYG6C+Lt4C7/bfgTEFekL90we3GG6zvRwvJjIoxVPVcRgW7sH/wDR6hbT+be/wwGmWEBneHk5LjXfUXkLd1TbUoae8UcnroVuKBNCT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dNLkisHG; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dNLkisHG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730624668; x=1762160668;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=snBziOUc/u2Kkl53/U6DI9Ys6nv3Gp9bFeiW0dtFrtc=;
  b=dNLkisHGkAHx+dpXkIqrF6J8r2Aem3MZWVaXfNtDvfcDMeuwYgLkBeAd
   eFIorOwmBl7LEUSDyf1FUEaGEh0Je7NvWbXHamNj6WBwYcIJ4fWSLHw9a
   b5Dv/VL4xY/nNTji9eFhUAXUhV7xKCcpQchewoj4xx3LMFtTRBzhbvm4P
   sr7cjibG59vgi/3DjRY+DMGl4igWOlgfrDhetiWohhvh4NrFrQ/xBBmTw
   ihxATTB8Ci6dmN76kq7JVT4ADdDmdiL0ShR40RFaoSnpGvtPbAmaGpurP
   rPCAjBrc/RETZ5zvfLo5Ek6ldBnRWp8bolhWdTPfTrrNtZRynWUM6/Pzn
   Q==;
X-CSE-ConnectionGUID: sjyG9mU/QPSeCPEAMl0hRg==
X-CSE-MsgGUID: UryRo3mQSBS3i8q6qz5tJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30188254"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30188254"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2024 01:04:26 -0800
X-CSE-ConnectionGUID: +YOHN/GJSeGlWqY4+F2OMg==
X-CSE-MsgGUID: 9b3eg3pxTE2CVhjYx7TwYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,254,1725346800"; 
   d="scan'208";a="82888019"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 03 Nov 2024 01:04:20 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t7WWw-000jqj-0J;
	Sun, 03 Nov 2024 09:04:18 +0000
Date: Sun, 3 Nov 2024 17:03:45 +0800
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
Cc: oe-kbuild-all@lists.linux.dev, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com, kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v2 12/13] mm: Add sysctl vm.compress-batching switch for
 compress batching during swapout.
Message-ID: <202411031633.Hlf9Mjxh-lkp@intel.com>
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
config: m68k-stmark2_defconfig (https://download.01.org/0day-ci/archive/20241103/202411031633.Hlf9Mjxh-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 13.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241103/202411031633.Hlf9Mjxh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411031633.Hlf9Mjxh-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/swap.c:17:
>> include/linux/mm.h:88:27: error: expected identifier or '(' before numeric constant
      88 | #define compress_batching 0
         |                           ^
   mm/swap.c:51:14: note: in expansion of macro 'compress_batching'
      51 | unsigned int compress_batching;
         |              ^~~~~~~~~~~~~~~~~
   mm/swap.c: In function 'swap_setup':
>> mm/swap.c:1082:27: error: lvalue required as left operand of assignment
    1082 |         compress_batching = 0;
         |                           ^


vim +88 include/linux/mm.h

    82	
    83	#ifdef CONFIG_SYSCTL
    84	extern int sysctl_legacy_va_layout;
    85	extern unsigned int compress_batching;
    86	#else
    87	#define sysctl_legacy_va_layout 0
  > 88	#define compress_batching 0
    89	#endif
    90	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
