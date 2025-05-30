Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7531C84A5;
	Fri, 30 May 2025 11:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748603895; cv=none; b=AgGGbUQTfXUbVrcU2GuB5GSOcoezM8S6FldoKtd4w/XBOiMpdeStMYkni7krSTCiWal6NGtAxmbWkDEllNBOSIxgEnTPxLSMQpKPCjhT5DrxVTpXhLgIK22kxpr3WijTCnvZkirsv/MauLIiIW13cNemGvQHSo5bNGp5/sStjYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748603895; c=relaxed/simple;
	bh=ZZUVdS/Ifwk7iIia2/SU3+4KHAWV/YorCas2i1xzcAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BtIUwd1/BF4gNhi8Hy3xpoNoq4D+hCS2e+f0YqxwWsCW2DnfdI6mF439Se5FRDoBJOBkLTbPHNbMeLTYZ8FneWAQAmq/IVjD3SelibMC1ynL0znGtMFxNHTE3Pys/PEQ1vZfk42S3CE620BMPNDqNn8hbVoNYGLUWz9sFmhxxsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cVRE9oID; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cVRE9oID"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748603893; x=1780139893;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZZUVdS/Ifwk7iIia2/SU3+4KHAWV/YorCas2i1xzcAU=;
  b=cVRE9oID2sb+T6P7mcKnvxMWFeH6TkgSRpAT1uPP1Ib7+nWb41+VYVYo
   cbABEMa6VQSIbF0VCm1FLdy2Mhc5PtdKXxnYwqlsItCddl19D6nW2pVHU
   zpYeo7aiuwmEosHC8QYuNrS+Sb69txInacOYl8eLeurZouq2a4ZknXOUa
   sZakF14+jdGIwflc3Bsc9RPxvI+xcmYFb6AwcBjz0+Qi4WtKhXMw2NhNi
   oceYuL1dyEvoTLXG9y3OourFzQGcbF7yVIZ8B3Qo4xj3ifTBHJ3xI5BqQ
   F0MPqtxSwhxOt/TL57tVprG48m09VVJUhrrAy2xsjSrOdPuI/FgflDiIR
   A==;
X-CSE-ConnectionGUID: P04pP0+4RAmUbzExAXf/AQ==
X-CSE-MsgGUID: e1FBpz4hRQatRtj0+AroIg==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="54493543"
X-IronPort-AV: E=Sophos;i="6.16,195,1744095600"; 
   d="scan'208";a="54493543"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2025 04:18:12 -0700
X-CSE-ConnectionGUID: MANiozsiQHyVzeRT+DKsHA==
X-CSE-MsgGUID: Rd9rOmeIQUKMkhZoIUkAbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,195,1744095600"; 
   d="scan'208";a="144488988"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 30 May 2025 04:18:10 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uKxkU-000Xaa-3A;
	Fri, 30 May 2025 11:18:06 +0000
Date: Fri, 30 May 2025 19:17:32 +0800
From: kernel test robot <lkp@intel.com>
To: Harsh Jain <h.jain@amd.com>, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, mounika.botcha@amd.com,
	sarat.chand.savitala@amd.com, mohan.dhanawade@amd.com,
	michal.simek@amd.com
Cc: Paul Gazzillo <paul@pgazz.com>,
	Necip Fazil Yildiran <fazilyildiran@gmail.com>,
	oe-kbuild-all@lists.linux.dev, Harsh Jain <h.jain@amd.com>
Subject: Re: [PATCH 3/3] crypto: drbg: Export CTR DRBG DF functions
Message-ID: <202505301900.Ufegky8f-lkp@intel.com>
References: <20250529113116.669667-4-h.jain@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250529113116.669667-4-h.jain@amd.com>

Hi Harsh,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master linus/master v6.15 next-20250530]
[cannot apply to xilinx-xlnx/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Harsh-Jain/dt-bindings-crypto-Add-node-for-True-Random-Number-Generator/20250529-193255
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250529113116.669667-4-h.jain%40amd.com
patch subject: [PATCH 3/3] crypto: drbg: Export CTR DRBG DF functions
config: alpha-kismet-CONFIG_CRYPTO_DRBG_CTR-CONFIG_CRYPTO_DEV_XILINX_TRNG-0-0 (https://download.01.org/0day-ci/archive/20250530/202505301900.Ufegky8f-lkp@intel.com/config)
reproduce: (https://download.01.org/0day-ci/archive/20250530/202505301900.Ufegky8f-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505301900.Ufegky8f-lkp@intel.com/

kismet warnings: (new ones prefixed by >>)
>> kismet: WARNING: unmet direct dependencies detected for CRYPTO_DRBG_CTR when selected by CRYPTO_DEV_XILINX_TRNG
   WARNING: unmet direct dependencies detected for CRYPTO_DRBG_CTR
     Depends on [n]: CRYPTO [=y] && CRYPTO_DRBG_MENU [=n]
     Selected by [y]:
     - CRYPTO_DEV_XILINX_TRNG [=y] && CRYPTO [=y] && CRYPTO_HW [=y] && (ZYNQMP_FIRMWARE [=n] || COMPILE_TEST [=y])

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
