Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3208B3A961F
	for <linux-crypto@vger.kernel.org>; Sat, 28 Mar 2026 18:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774723497; cv=none; b=R7yVtNwB6PBC1Qo35dF+NJK1lvZmIKlAPXQt0KB78NzfgQDKypAi69cLEBB0pxQl9U3+kp9N76nTQ7hXAETqyajOsTUL7/uyKN6jUG139uVuAlXOSIM2Q9LsyVkzWnK54IA9TdQhpwq6CSMQEIjIAgtrvX+86rT7lL8+duilhzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774723497; c=relaxed/simple;
	bh=L4bpxF1/kagi643bP3KhVUSGAg+SlQcszygzmbQ68xI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5gMlzUYv58F2elgmVlXJCzq8xBlcaiKFuPMyF/V7DTu8fn9VJo40vzm+/VID06t13DCIxbC72l4TW3nFK6Ucdnf0pY3u82C1cwSUtncWEOAoAuF7+S/k4dCB+ER6aNAdn+ARY6CCK3MITZGOnuz+9jgOhBpl44VXKvkPhkP0pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cRZkKviK; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cRZkKviK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774723492; x=1806259492;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L4bpxF1/kagi643bP3KhVUSGAg+SlQcszygzmbQ68xI=;
  b=cRZkKviKuR5teurUTUvYooUq0Bp1IY01yIZnCt8hGaKV18PEgk8FQeal
   3IpS3NuMnxSC/KgF8iDkP998itSnlXvOR3DoDjkgk9NWeYIdurg3Mk29o
   +U7enWq4jocuIZI4LS16WK2D1LYhS+yxPW7ZKUP9nZA5Yx89M4Oc2ayNP
   5jZYk+JFK+lWkZau7K4ZETZoulypKnvR8/4290ysHhndJ2BsHdNQR7F1E
   Bi/hUfiCBzibRrE6PW1Eus30MbZVqYHYuid1TrtEf+vXzYjHH/8JPcWDA
   C+o6Fdz3LmQqaqqOklqhD2KvVqRlSNGFLJtO/3fZtDZ6vaZeFrjW3Qmt6
   g==;
X-CSE-ConnectionGUID: wM4IAFQ6QZCWjnwW69w7Zw==
X-CSE-MsgGUID: 8eyZ6qELSyKSRqV77BS9aw==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="78367380"
X-IronPort-AV: E=Sophos;i="6.23,146,1770624000"; 
   d="scan'208";a="78367380"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 11:44:51 -0700
X-CSE-ConnectionGUID: 3pSdk3leRt6Lsz9G4EE95Q==
X-CSE-MsgGUID: B7ePu1YqQkWZ5iR4wVxD7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,146,1770624000"; 
   d="scan'208";a="225624124"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 28 Mar 2026 11:44:48 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6YeL-00000000BgD-2wCm;
	Sat, 28 Mar 2026 18:44:45 +0000
Date: Sun, 29 Mar 2026 02:43:57 +0800
From: kernel test robot <lkp@intel.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	herbert@gondor.apana.org.au
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	qat-linux@intel.com, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Laurent M Coquerel <laurent.m.coquerel@intel.com>
Subject: Re: [PATCH] crypto: qat - add support for zstd
Message-ID: <202603290259.Ig9kDOmI-lkp@intel.com>
References: <20260327214645.2098424-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327214645.2098424-1-giovanni.cabiddu@intel.com>

Hi Giovanni,

kernel test robot noticed the following build errors:

[auto build test ERROR on 93e03a16c015b8e55e2ec97865f67d9bf1ec1921]

url:    https://github.com/intel-lab-lkp/linux/commits/Giovanni-Cabiddu/crypto-qat-add-support-for-zstd/20260328-212011
base:   93e03a16c015b8e55e2ec97865f67d9bf1ec1921
patch link:    https://lore.kernel.org/r/20260327214645.2098424-1-giovanni.cabiddu%40intel.com
patch subject: [PATCH] crypto: qat - add support for zstd
config: alpha-randconfig-r071-20260329 (https://download.01.org/0day-ci/archive/20260329/202603290259.Ig9kDOmI-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 12.5.0
smatch: v0.5.0-9004-gb810ac53
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260329/202603290259.Ig9kDOmI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603290259.Ig9kDOmI-lkp@intel.com/

All errors (new ones prefixed by >>):

   alpha-linux-ld: drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.o: in function `adf_gen4_build_decomp_block':
>> drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:141:(.text+0xeec): undefined reference to `__bswapsi2'
>> alpha-linux-ld: drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:141:(.text+0xef8): undefined reference to `__bswapsi2'
   alpha-linux-ld: drivers/crypto/intel/qat/qat_common/adf_gen4_hw_data.o: in function `adf_gen4_build_comp_block':
   drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:57:(.text+0xf64): undefined reference to `__bswapsi2'
   alpha-linux-ld: drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h:57:(.text+0xf7c): undefined reference to `__bswapsi2'


vim +141 drivers/crypto/intel/qat/qat_common/icp_qat_hw_20_comp.h

5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  119  
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  120  static inline __u32
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  121  ICP_QAT_FW_DECOMP_20_BUILD_CONFIG_LOWER(struct icp_qat_hw_decomp_20_config_csr_lower csr)
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  122  {
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  123  	u32 val32 = 0;
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  124  
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  125  	QAT_FIELD_SET(val32, csr.hbs,
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  126  		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_HBS_CONTROL_BITPOS,
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  127  		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_HBS_CONTROL_MASK);
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  128  	QAT_FIELD_SET(val32, csr.lbms,
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  129  		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_LBMS_BITPOS,
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  130  		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_LBMS_MASK);
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  131  	QAT_FIELD_SET(val32, csr.algo,
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  132  		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_HW_DECOMP_FORMAT_BITPOS,
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  133  		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_HW_DECOMP_FORMAT_MASK);
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  134  	QAT_FIELD_SET(val32, csr.mmctrl,
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  135  		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_MIN_MATCH_CONTROL_BITPOS,
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  136  		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_MIN_MATCH_CONTROL_MASK);
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  137  	QAT_FIELD_SET(val32, csr.lbc,
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  138  		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_PRESENT_BITPOS,
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  139  		      ICP_QAT_HW_DECOMP_20_CONFIG_CSR_LZ4_BLOCK_CHECKSUM_PRESENT_MASK);
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  140  
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28 @141  	return __builtin_bswap32(val32);
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  142  }
5b14b2b307e404 drivers/crypto/qat/qat_common/icp_qat_hw_20_comp.h Giovanni Cabiddu 2022-11-28  143  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
