Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E4617B425;
	Mon,  5 May 2025 14:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746457039; cv=none; b=G5O7Gx3MHZVVFS2m8Z6wCPR4HLEJgBXZrYAOt4bWWbxBaaS6Iv3EhA3QeoFA3NTL30G77noOCrFD6ESDRZ3gzuBT+TCj0WOZ62PnLQoxybCkUdVQ+fT96vf0tfd76LAdqbiGEsZHP7QXgt56WLuNAdRKNxIPpmhO4MQzNT+WYwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746457039; c=relaxed/simple;
	bh=Sip1PnDID2/ngnatk9xALApIFhWqepNEXsu98AyzCMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6pNt2U1FYlLtoGHlBOPdpwi5zBWUimGwySAf+pm42YQcw6RBvJnhKdkFTx/irk/vNKZ5wu8f3b8p0N8TwaygRNwZf+oYy1dtmX8zxI6owF4MD8cg7y3U/FXOrIAhaNS6q3CmeugHqJJgLNM2gmfaFm12vVUPQjDyH62N44uCps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U6WlL0uR; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U6WlL0uR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746457037; x=1777993037;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Sip1PnDID2/ngnatk9xALApIFhWqepNEXsu98AyzCMU=;
  b=U6WlL0uR5/QutGcgQlaIrVnfououjOem7VMgFR4MxhlZtJCL9on97s4E
   suI0MPdrPx8nBq0hPT293f1D+s35tNzqHhdcEyW6ztImnNyVkZdDjrW09
   FveWz1i922n4P5/VN3esMXftBG/P6QClaVHd01MkzyOXXeGmG7XmemA6/
   +jA5fWK8OilzmPPFe1KkHsHih9Nt9+GiBHk9PuuMTq2Egu3sVIGHsrLF2
   CNFjPpqZbTNISeYmcGh2y9TyEPwZWGweWWZTKKO2jcB006VGwCjC8ofG3
   7dxrwKehOvPnEu2Gc1VAfs+ewxemMEXh3JkbUDY4kPf77u78D9EAX/o+k
   w==;
X-CSE-ConnectionGUID: qRY8q596QMOgXftNLcV3RQ==
X-CSE-MsgGUID: alJmyazLRvi1RPtPjBbvhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11424"; a="65475568"
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="65475568"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2025 07:57:16 -0700
X-CSE-ConnectionGUID: dwURUL9HRTS3RSrgxuYveg==
X-CSE-MsgGUID: aIp5ZAbNRyWXPZsDXP5leQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,262,1739865600"; 
   d="scan'208";a="172499800"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 05 May 2025 07:57:13 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uBxFn-0005qL-22;
	Mon, 05 May 2025 14:57:11 +0000
Date: Mon, 5 May 2025 22:56:42 +0800
From: kernel test robot <lkp@intel.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, Kamlesh Gurudasani <kamlesh@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 2/2] crypto: ti: Add driver for DTHE V2 AES Engine
 (ECB, CBC)
Message-ID: <202505052251.UeYNEjXC-lkp@intel.com>
References: <20250502121253.456974-4-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502121253.456974-4-t-pratham@ti.com>

Hi Pratham,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on next-20250505]
[cannot apply to herbert-crypto-2.6/master robh/for-next linus/master v6.15-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/T-Pratham/dt-bindings-crypto-Add-binding-for-TI-DTHE-V2/20250502-201653
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250502121253.456974-4-t-pratham%40ti.com
patch subject: [PATCH v3 2/2] crypto: ti: Add driver for DTHE V2 AES Engine (ECB, CBC)
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20250505/202505052251.UeYNEjXC-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250505/202505052251.UeYNEjXC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505052251.UeYNEjXC-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/crypto/ti/dthev2-common.c:15:
>> drivers/crypto/ti/dthev2-common.h:9:9: warning: '__TI_DTHEV2_H__' is used as a header guard here, followed by #define of a different macro [-Wheader-guard]
       9 | #ifndef __TI_DTHEV2_H__
         |         ^~~~~~~~~~~~~~~
   drivers/crypto/ti/dthev2-common.h:10:9: note: '__TI_DTHE2V_H__' is defined here; did you mean '__TI_DTHEV2_H__'?
      10 | #define __TI_DTHE2V_H__
         |         ^~~~~~~~~~~~~~~
         |         __TI_DTHEV2_H__
   1 warning generated.


vim +/__TI_DTHEV2_H__ +9 drivers/crypto/ti/dthev2-common.h

   > 9	#ifndef __TI_DTHEV2_H__
    10	#define __TI_DTHE2V_H__
    11	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
