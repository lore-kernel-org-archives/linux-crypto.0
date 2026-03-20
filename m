Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AA238B15B;
	Fri, 20 Mar 2026 11:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774005979; cv=none; b=e5bUof6gASp77CWAM/DnlAaxTJnop3I7DL56rqS8LtoNGuG/FSYKadd7O7uXIOEsRDL4LAJAMvbFPNABaklnG/sNTMDqppO2+U3Fx0S1gc9HpVjw9YVf0i7DguCB+SFoQQK98IsO3dBIVL8CVnM2kgQAP4AIx3p2DvJeLeqv2zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774005979; c=relaxed/simple;
	bh=uuHxpvvk+KMKo/NMJwYXrb2UA5H+9aWt/1abSvlkJdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZgQOo/RzbH3H7kogV1nM2Jbs7yFLt+qcEh4i05W3txtCHQd1j3TRO+LWddVmA6UUXneHyAKR8na8WbPr6Hjq0MdnKzG3dVbt5nxbBn0psJ9loEXePIo0/03ghHdVNJSI0TtK0dyPgsusyCCuznyUpf+/TJgG1EebU189mBl8DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hcswx/hs; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hcswx/hs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774005978; x=1805541978;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=uuHxpvvk+KMKo/NMJwYXrb2UA5H+9aWt/1abSvlkJdM=;
  b=hcswx/hsOKMsA7ysfXjCA7daemcXTHlHwlmB1UY67oiCU/lFrLZRcgKe
   EbYfsQC4U+YI3sT8b9mzaKk49LInLUmtXKBrh6eoh8TPHYnrOY9uwRUFm
   dPXAU9SKVS7vQR5Sx+/6AE5X5+2yTcrJAplyk4s9rkZVP3TTAmiWchGld
   /qx2fTeIjABFqbemdARnaldGtyh9E5d0YDsDL9FIFf9UBfumvT9FLUZQg
   UY1+bPF8TH+Ce65zWG0X+rrDKWnfbVaYeiF2CQjEXN4S9HnHOR6Gagk9W
   H38DK2gMaNsuMYI0am0ZbgqnZsf9egs6WfjHwpWyx4xQqiUTzVFh9r4AM
   A==;
X-CSE-ConnectionGUID: KkpzZ+YzQ5GGz4QbYhXo8Q==
X-CSE-MsgGUID: Z4MDuuFpSEe96l7LQ2gBow==
X-IronPort-AV: E=McAfee;i="6800,10657,11734"; a="85403920"
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="85403920"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 04:25:57 -0700
X-CSE-ConnectionGUID: AvowKarpTfSGc8EpGWTeew==
X-CSE-MsgGUID: GUsOegipRcWhO/OUdJAmFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,130,1770624000"; 
   d="scan'208";a="227988118"
Received: from lkp-server02.sh.intel.com (HELO a51c2a36b9df) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 20 Mar 2026 04:25:53 -0700
Received: from kbuild by a51c2a36b9df with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w3Xvq-000000002Ij-46fk;
	Fri, 20 Mar 2026 11:24:53 +0000
Date: Fri, 20 Mar 2026 19:22:09 +0800
From: kernel test robot <lkp@intel.com>
To: Demian Shulhan <demyansh@gmail.com>, ebiggers@kernel.org,
	ardb@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Demian Shulhan <demyansh@gmail.com>
Subject: Re: [PATCH] lib/crc: arm64: add NEON accelerated CRC64-NVMe
 implementation
Message-ID: <202603201958.gFoHxLV7-lkp@intel.com>
References: <20260317065425.2684093-1-demyansh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317065425.2684093-1-demyansh@gmail.com>

Hi Demian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ebiggers/crc-next]
[also build test WARNING on linus/master v7.0-rc4 next-20260319]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Demian-Shulhan/lib-crc-arm64-add-NEON-accelerated-CRC64-NVMe-implementation/20260318-003936
base:   https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-next
patch link:    https://lore.kernel.org/r/20260317065425.2684093-1-demyansh%40gmail.com
patch subject: [PATCH] lib/crc: arm64: add NEON accelerated CRC64-NVMe implementation
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20260320/202603201958.gFoHxLV7-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260320/202603201958.gFoHxLV7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603201958.gFoHxLV7-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> lib/crc/arm64/crc64-neon-inner.c:20:5: warning: no previous prototype for function 'crc64_nvme_arm64_c' [-Wmissing-prototypes]
      20 | u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len)
         |     ^
   lib/crc/arm64/crc64-neon-inner.c:20:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
      20 | u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len)
         | ^
         | static 
   1 warning generated.


vim +/crc64_nvme_arm64_c +20 lib/crc/arm64/crc64-neon-inner.c

    19	
  > 20	u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len)

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
