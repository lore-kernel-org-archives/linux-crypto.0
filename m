Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C84313D897
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 11:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739706186; cv=none; b=qqhZP8BrGa2HyY3k4xg2JJat+X9M0+ICixq0Ki+tF/EMWZuvR7oIwMmpXX9B1r9HOk3CiubJUA6n3qD7uy6vtNc+6+rvmvMFHtoMqgm5lzKr2Swe/a0PzW01qfUOmvojX1YVwPvJeP+UZ+6pDhlVpSahl8h/7NvS6MtCe67+U0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739706186; c=relaxed/simple;
	bh=zk3b78TcMLcpEwC8P2M9C644oKojIcpaSL0LfWDMapI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XM6uAC+M/iACxJJXNnB3MyyPy/Iny5rLksODw/8CLPvJdd0+XLOzLG2kuPnly5mi5xQ9y0Ly2FsRycHEVmjNiRR1ANVC81ALA84/Mpl5k0XPdrE/yGyxtA2AkhPHC1+BEn590/fEhmpwdTmVj3FQ3gF6xV4PU2IeImEf6KU8Jl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NQf6R7As; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NQf6R7As"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739706184; x=1771242184;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zk3b78TcMLcpEwC8P2M9C644oKojIcpaSL0LfWDMapI=;
  b=NQf6R7Asf+jb06mtRCwxvz/Jny4K4d3VekD9Bm5b2LyLgrFZ2dwP1y30
   mNCNLYjHuomMVtmbyE67YMOOtah3bOLRGWiuP59v9tCVkpyGOj4tDx9Ze
   qMf9NeGK0OSXmaCnKZdaABb33nfzcAatT6OQrm9yg9maQtxG29DKyPejl
   f+yb5S1ahhZZ6QOjqeE4PBksCpd6gV7STnfh30n6cLEdubhtjUE0usxJX
   h/KSKE67ogfvlqmdd8UV0Hr9uvozmJbUgK80NSJo6A32VvTpMv4DmzXoF
   7y5anc0uTBCuqF9ncUfb/uZztg33Dg/iA3uyRensP0d3y5xT+DvO6g1kA
   w==;
X-CSE-ConnectionGUID: D8BPq1b5TTOfflBXYvLyUg==
X-CSE-MsgGUID: c063th/IRu6dircWoIWz+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11346"; a="65757806"
X-IronPort-AV: E=Sophos;i="6.13,290,1732608000"; 
   d="scan'208";a="65757806"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2025 03:43:03 -0800
X-CSE-ConnectionGUID: xgIKFAEbTtelWEauRC7EFA==
X-CSE-MsgGUID: OaQC6mnYRAijcOQ0btNEnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,291,1732608000"; 
   d="scan'208";a="113829798"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 16 Feb 2025 03:43:01 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tjd35-001Bt5-0m;
	Sun, 16 Feb 2025 11:42:59 +0000
Date: Sun, 16 Feb 2025 19:42:43 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Megha Dey <megha.dey@linux.intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [v2 PATCH 09/11] crypto: hash - Add sync hash interface
Message-ID: <202502161953.REiC4YpV-lkp@intel.com>
References: <d6e10dbf172f0b7c791f5406d55e8f1c74492d57.1739674648.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6e10dbf172f0b7c791f5406d55e8f1c74492d57.1739674648.git.herbert@gondor.apana.org.au>

Hi Herbert,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[cannot apply to herbert-crypto-2.6/master brauner-vfs/vfs.all linus/master v6.14-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Herbert-Xu/crypto-ahash-Only-save-callback-and-data-in-ahash_save_req/20250216-150941
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/d6e10dbf172f0b7c791f5406d55e8f1c74492d57.1739674648.git.herbert%40gondor.apana.org.au
patch subject: [v2 PATCH 09/11] crypto: hash - Add sync hash interface
config: s390-randconfig-001-20250216 (https://download.01.org/0day-ci/archive/20250216/202502161953.REiC4YpV-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250216/202502161953.REiC4YpV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502161953.REiC4YpV-lkp@intel.com/

All warnings (new ones prefixed by >>, old ones prefixed by <<):

ERROR: modpost: vmlinux: 'crypto_shash_tfm_digest' exported twice. Previous export was in vmlinux
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/slub_kunit.o
>> WARNING: modpost: EXPORT symbol "crypto_shash_tfm_digest" [vmlinux] version generation failed, symbol will not be versioned.
Is "crypto_shash_tfm_digest" prototyped in <asm/asm-prototypes.h>?

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
