Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B092C1D47D9;
	Tue,  5 Nov 2024 12:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730808571; cv=none; b=iwQFk/uVD6L8vwW6uC/AxfNao7qiSrgRKub0ogVzUxeuWE12Rsl8hi4BySGtcHM9JIwh7Yalzeg6ZGk1Mn2Ip9XVUVMnCHHGbrzGi6i8PntBoUkkyVjhytHwBbji4fFL0ittcqSKOfn4ORcMhBm9VPkr6WV4GNw3yilHVZXh7zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730808571; c=relaxed/simple;
	bh=J/B+ENA4OJ4XDGIbjRbvBcVaTYPoDG6+MJhHGv0MEQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6hifuOmO9YGjwep4gz4UR1uhU/eaEICSoMaO7e4KXwiW1HUtEE0eTK39Ktx0mzM9ej/Xe9j0wiah4TYK9UqqnNJ8MpcEmj0AcIzB+pDX94Oz3gAUXaweO8n928j0Ez+KfDSvGBJMyCkq+76vS+jsTEFXFkrd8VBTP4prBoZ7yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WB8rD+7Q; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WB8rD+7Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730808570; x=1762344570;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J/B+ENA4OJ4XDGIbjRbvBcVaTYPoDG6+MJhHGv0MEQQ=;
  b=WB8rD+7Q4xq0Wz0gm4/t9PeANaRpdwZMu31DO2pwJen/v57VdWOWyiM5
   r7TBHzpx42Iz3clUNP8wes7xrskPXTt6ZKSqSN3ADv0+2NtoquDZ3+v7Z
   8Y+YYZdgS6EAaWrzaLqtSbgu5JVMqB1v7W27SBR85rzJn0nQ0HxyLKTIa
   +gidH6MQTF+7Hl4Wj/o0OB5oYQQkBlSGwILgvXb8IuOdVSRG5inEmRBhq
   GUvZrUh5RUD+JmovJB7xFNPRYPKi6xrcb0RyAEfp2xbk1FVTDvLBKIX2J
   C5MjmXNHOEvdSOE8tZAdWODNb8jAbFsGxpOu89caBeEPEacIGE5D+ZD8C
   Q==;
X-CSE-ConnectionGUID: UkpkIvJDQA6qTVIb4LUMvA==
X-CSE-MsgGUID: 7ozrjAU1SvuaLxlf6AycMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="33389693"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="33389693"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 04:09:29 -0800
X-CSE-ConnectionGUID: zQ/rrbs1RB6/gxOiycK1og==
X-CSE-MsgGUID: LlRr8a9hR5ensXNCeAb/cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="83649240"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 05 Nov 2024 04:09:26 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t8INA-000m1e-0k;
	Tue, 05 Nov 2024 12:09:24 +0000
Date: Tue, 5 Nov 2024 20:08:54 +0800
From: kernel test robot <lkp@intel.com>
To: Dionna Glaze <dionnaglaze@google.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ashish Kalra <ashish.kalra@amd.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, Dionna Glaze <dionnaglaze@google.com>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 3/6] crypto: ccp: Track GCTX through sev commands
Message-ID: <202411051934.6vECpMIv-lkp@intel.com>
References: <20241105010558.1266699-4-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105010558.1266699-4-dionnaglaze@google.com>

Hi Dionna,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master kvm/queue linus/master v6.12-rc6 next-20241105]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Dionna-Glaze/kvm-svm-Fix-gctx-page-leak-on-invalid-inputs/20241105-090822
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20241105010558.1266699-4-dionnaglaze%40google.com
patch subject: [PATCH v4 3/6] crypto: ccp: Track GCTX through sev commands
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20241105/202411051934.6vECpMIv-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 639a7ac648f1e50ccd2556e17d401c04f9cce625)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241105/202411051934.6vECpMIv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411051934.6vECpMIv-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/crypto/ccp/sev-fw.c:9:10: fatal error: 'asm/sev.h' file not found
       9 | #include <asm/sev.h>
         |          ^~~~~~~~~~~
   1 error generated.

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for MODVERSIONS
   Depends on [n]: MODULES [=y] && !COMPILE_TEST [=y]
   Selected by [y]:
   - RANDSTRUCT_FULL [=y] && (CC_HAS_RANDSTRUCT [=y] || GCC_PLUGINS [=n]) && MODULES [=y]


vim +9 drivers/crypto/ccp/sev-fw.c

     8	
   > 9	#include <asm/sev.h>
    10	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
