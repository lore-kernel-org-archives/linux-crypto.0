Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BE7345729;
	Thu, 20 Nov 2025 13:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763646980; cv=none; b=KLw/dLoOrlQFMMZcauRYf4x8idlwhZjzyDo6wQQvHl70W8gTsGexfpw4KdUuuh+D7YgVhJfAi6kC9dI0z1C/Ql72niuklre6IinoGGCVOzO/BLpW0RAeL0zZSAyxZcP2n7TbxeXhdDDUWMPvHyMSz4iBfklob6cKqMPNHXpY2VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763646980; c=relaxed/simple;
	bh=qjwbKhdVipvIJ0N2rgFc287iWpDosQTnc6T99JMqA3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UBcUc51vD0oLxqJ5487QRdbO2vRCrACHJn103Uh46RpnwIkrmA2r5Uwc0nlRtEjPqwTomkT42qwgMptcd/BSiffTyrO6Bex2QJoIcBts8EM36u4ltnvpZftuQQjQF4ZgTWRK5Ikunh8GPBUOu5LYGvu6kmN0QPj9HQ/zv6Hic3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NCGTKWx0; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NCGTKWx0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763646979; x=1795182979;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qjwbKhdVipvIJ0N2rgFc287iWpDosQTnc6T99JMqA3Y=;
  b=NCGTKWx0a/BsbeKOzgijkPqI5PKG/IME8ordXwnGGE7mhl1SpsVoQojy
   XMSkoGHPdby4OLDKnwrEYkglxV5g+zSJ2iGDNtdlKMTHXKcKHtyWDkGvv
   GYoT+vuJqP9O+y1UjS31vFqkS9x2+bIOLRFcowqV0z/LqwlJ8tP5T3tX4
   nHOn5IBFJU+Db4TwQSVwSWglhACj70G7KdKS/Mikvy6kxhnYDXUSNt4Ap
   vfhLiJWmsHqlJpGQ/APwhEmxKeAE/NdQ8GoWFDE8kWKlib4Q+tzECdH3T
   +Yp1BCgid7wIaa3CvfdgWhCCb2PZnJxkOUNuoJWoXYUtVBhdifsUdYKnX
   w==;
X-CSE-ConnectionGUID: WMdb3h4hTuSg14F9laKJuA==
X-CSE-MsgGUID: SBo7AXAYRVCxCM49AgHXTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="53286313"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="53286313"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 05:56:18 -0800
X-CSE-ConnectionGUID: LpySW7dPTTKtDU45dJ3A/g==
X-CSE-MsgGUID: 25bOMTJ4Q8OZbjzrpKXwcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="192169734"
Received: from lkp-server01.sh.intel.com (HELO adf6d29aa8d9) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 20 Nov 2025 05:56:16 -0800
Received: from kbuild by adf6d29aa8d9 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vM58v-00043P-1O;
	Thu, 20 Nov 2025 13:56:13 +0000
Date: Thu, 20 Nov 2025 21:55:17 +0800
From: kernel test robot <lkp@intel.com>
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Cc: oe-kbuild-all@lists.linux.dev, John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Hans de Goede <hansg@kernel.org>,
	"(open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER)" <linux-crypto@vger.kernel.org>,
	platform-driver-x86@vger.kernel.org,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lars Francke <lars.francke@gmail.com>
Subject: Re: [PATCH 2/2] crypto: ccp - Add an S4 restore flow
Message-ID: <202511202139.doSFJwaz-lkp@intel.com>
References: <20251119205942.3411155-3-superm1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119205942.3411155-3-superm1@kernel.org>

Hi Mario,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.18-rc6 next-20251120]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mario-Limonciello-AMD/platform-x86-amd-pmf-Prevent-TEE-errors-after-hibernate/20251120-050203
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20251119205942.3411155-3-superm1%40kernel.org
patch subject: [PATCH 2/2] crypto: ccp - Add an S4 restore flow
config: i386-randconfig-r133-20251120 (https://download.01.org/0day-ci/archive/20251120/202511202139.doSFJwaz-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251120/202511202139.doSFJwaz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511202139.doSFJwaz-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/crypto/ccp/sp-pci.c:573:25: sparse: sparse: symbol 'sp_pci_pm_ops' was not declared. Should it be static?

vim +/sp_pci_pm_ops +573 drivers/crypto/ccp/sp-pci.c

   572	
 > 573	const struct dev_pm_ops sp_pci_pm_ops = {
   574		.suspend = pm_sleep_ptr(sp_pci_suspend),
   575		.resume = pm_sleep_ptr(sp_pci_resume),
   576		.freeze = pm_sleep_ptr(sp_pci_suspend),
   577		.thaw = pm_sleep_ptr(sp_pci_resume),
   578		.poweroff = pm_sleep_ptr(sp_pci_suspend),
   579		.restore = pm_sleep_ptr(sp_pci_restore),
   580	};
   581	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
