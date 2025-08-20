Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE5E33470A
	for <linux-crypto@vger.kernel.org>; Wed, 20 Aug 2025 21:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755726653; cv=none; b=mLBXZOU/HP7sSU6xSQzMvjYy+n964T6crWQEe8P5w6rBP/98m/ejyqB3EK311NY4FNr8yvpk7j//3FVEdAHVH1ggjRBA3JWdBT2M0n/nHtKYHeKEAWkn5kZ/Rjk6E7VmRgumF5j8k8A2M7Q6UdYswj2pRdgDdwhNln3HkfFJhVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755726653; c=relaxed/simple;
	bh=QAJM2vtk+jQErQJw0BJQHZUwsFbRTuLCCthqPSR+ct4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W9yAvNI/cQJMu0NexBNasQSCvdc984YZMnAWRDUlegnVxwOyviBM3Puq/JSyOtedwEaMQhWhmTmL6UayHK/DBbaEhui8N881N3SgAC6WT2Ge2Vgw9wPVqn16S9PRFOuwBbOCeHk0VIoGLqvm9DPWDoP+YbZKuuOBLRVGkdgjm70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UsIStoaz; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UsIStoaz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755726651; x=1787262651;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QAJM2vtk+jQErQJw0BJQHZUwsFbRTuLCCthqPSR+ct4=;
  b=UsIStoazprPMSHmDL0i5YvheLKoEbZb6T48MRRNgQ+mkGILEVi0ox1wl
   RL8USOA2onOwvWExpvyNNs4rsJvPO+YQMLlfIvaG5FBuK34V91gwuTXxQ
   fLSNmfGX/F1R30kT74acXIF6S/g6Rbp/bfqoxoH7p2O9APW7XBpEfU46C
   VeJKYg0A6YjzyqObBa7yxEiY8emsw1SNyGFECsPMKIF88sRNcXcTb/jI7
   +IEbgq29SWEoktTFH5sXJnBfNJtSrfACxJqO2zfeR3p0Q1iQw9OuYN6Cb
   WSA+zpRkUDQOnKwAn61psAGOqDDwTQqZwETOGXGgnIIj25JkFSqNIFFfk
   Q==;
X-CSE-ConnectionGUID: LUmSmtN8TSSHSlX4bGKFBQ==
X-CSE-MsgGUID: tUnVXKG/SaqqVsW93NXqnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="45581465"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="45581465"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 14:50:51 -0700
X-CSE-ConnectionGUID: 3i776o2vQP6XTmlLlTM4UA==
X-CSE-MsgGUID: t/8RawfnQS2cb3n5GuBCEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="169024566"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 20 Aug 2025 14:50:48 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uoqhc-000JhX-0J;
	Wed, 20 Aug 2025 21:50:42 +0000
Date: Thu, 21 Aug 2025 05:50:15 +0800
From: kernel test robot <lkp@intel.com>
To: hare@kernel.org, Christoph Hellwig <hch@lst.de>
Cc: oe-kbuild-all@lists.linux.dev, Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>, Chris Leech <cleech@redhat.com>,
	linux-nvme@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	Hannes Reinecke <hare@kernel.org>
Subject: Re: [PATCH 1/2] crypto: hkdf: add hkdf_expand_label()
Message-ID: <202508210523.p8BdHsR7-lkp@intel.com>
References: <20250820091211.25368-2-hare@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820091211.25368-2-hare@kernel.org>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.17-rc2 next-20250820]
[cannot apply to hch-configfs/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/hare-kernel-org/crypto-hkdf-add-hkdf_expand_label/20250820-172750
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250820091211.25368-2-hare%40kernel.org
patch subject: [PATCH 1/2] crypto: hkdf: add hkdf_expand_label()
config: loongarch-randconfig-001-20250821 (https://download.01.org/0day-ci/archive/20250821/202508210523.p8BdHsR7-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250821/202508210523.p8BdHsR7-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508210523.p8BdHsR7-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: crypto/hkdf.c:151 function parameter 'labellen' not described in 'hkdf_expand_label'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
