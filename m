Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0502BEC26;
	Mon, 24 Nov 2025 05:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763960990; cv=none; b=lAVByjwo1Dnt5AbkYxZazmb6q449lOajzdNI/k47+xedCAYeJySyK1/+APV5zgBOLZlUecePYgDRG3otTESZV13ZgFj+DrmKewD6g8FYaSMa6/Dco1EnujGZf3YJP5g59odDCbUOmHve+62dyxJ3OZ6Scwh8tjd6e7agQQqz02w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763960990; c=relaxed/simple;
	bh=1f1TOEQUVvDFuVUkDzaQkzB7ZSNkRXYGJwLUqEJeLgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmV53fvh7jW8d2ic2TC3Xhx5irAEirDl28KIHLLAUm9s5CtvjnxGDaJjfNv9PKld4edaxf+yACeingC4sGJJ+ilPcEbdlrxQeQ+16IiQesZSx52gBEcAhp0d26yWi6wdfs7DuLt9B1xvXkVvd90SfCWzq9x7qYSwhgAwWJ4m8qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IoqTl0tE; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IoqTl0tE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763960988; x=1795496988;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1f1TOEQUVvDFuVUkDzaQkzB7ZSNkRXYGJwLUqEJeLgw=;
  b=IoqTl0tE6dhb/bIDAkx293PVVnWQ0V6k8Z2JIewXVtxVhqjY7h9zMd0a
   i3EGRPwxIeExrcj6HzFMHBn/oXQKuXxwDPSHPTaoYSA0/y6uNUkpcNmaV
   lfjCm+27r30j25EOIgb0v2pDCoywfEKbuVmt+ZhIOnH+iZ5/ZyY2Qn/hf
   A5AkuYJMFGf7Uti0fhEl2k4mFDNVJlXppBnGIEMcnixWKHweENhaypvMP
   8vl09oUSckwq30gMzSZydOkZMGAIMMct7foDzqOuvnuerUhGSW2N5OfBj
   N9a56yqRezs4HBeWNvJMYZmr5EiAZyNTuM8ddYqBxwN1VNae2LEdAnGWh
   g==;
X-CSE-ConnectionGUID: +wxXSX0XRU+4oHLpKQZN3w==
X-CSE-MsgGUID: Qus3Daa0QrmV+HM+22j9mg==
X-IronPort-AV: E=McAfee;i="6800,10657,11622"; a="65139512"
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="65139512"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2025 21:09:47 -0800
X-CSE-ConnectionGUID: adGQh+x5QImRTUk3QYC23w==
X-CSE-MsgGUID: 61thK6UFQnGPplcka6S+xA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="196516253"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 23 Nov 2025 21:09:45 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vNOpa-000000000Or-3509;
	Mon, 24 Nov 2025 05:09:42 +0000
Date: Mon, 24 Nov 2025 13:08:43 +0800
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
Message-ID: <202511241200.Pm3GIul3-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.18-rc7 next-20251121]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Mario-Limonciello-AMD/platform-x86-amd-pmf-Prevent-TEE-errors-after-hibernate/20251120-050203
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20251119205942.3411155-3-superm1%40kernel.org
patch subject: [PATCH 2/2] crypto: ccp - Add an S4 restore flow
config: i386-buildonly-randconfig-003-20251124 (https://download.01.org/0day-ci/archive/20251124/202511241200.Pm3GIul3-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251124/202511241200.Pm3GIul3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511241200.Pm3GIul3-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: drivers/crypto/ccp/sp-dev.o: in function `sp_restore':
>> drivers/crypto/ccp/sp-dev.c:237:(.text+0x28f): undefined reference to `tee_restore'


vim +237 drivers/crypto/ccp/sp-dev.c

   233	
   234	int sp_restore(struct sp_device *sp)
   235	{
   236		if (sp->dev_vdata->psp_vdata->tee) {
 > 237			int r = tee_restore(sp->psp_data);
   238	
   239			if (r)
   240				return r;
   241		}
   242	
   243		return sp_resume(sp);
   244	}
   245	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
