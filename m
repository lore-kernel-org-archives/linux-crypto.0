Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794276320;
	b=p/lbSKudYwsEw9n4IrC92coq/3O8QFoWAgQnjSiCEpbriMgsvRHGEl2hsarBbIqP+3go
	 Bzejfkve48jNbZJad+YcjjqrJ3egn59jc6LHdPeEw6sT6YRbxucWTuSCPzkWmmdV7lk/d
	 90dpppg2TQSL2K7yx3HXMpfPcDqjG+fcgktcTiXN4C5FMwwPIMqcIkFPubey1ZOhIbDaz
	 Pa/NbwdjBhsxJvGVbkN9UZTWfV4E6l0GdQLi64dBmr+ULpzAseiAxD1a7X2OdtOhZfgdO
	 4/sbWB8zBO2I/74FxLRd3BpcwxJ7zoNpF6gnk2AcQaDMPNu59ISLSW2iwCk5eOnpWEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794276320;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=PHi2s2f16mLfxcR4BhP+bBJMxU0LcZFpYGFigSfV9Kc=;
	b=PczFDfLQ9NsViZOdW2Yp33lpoecyQxxpS1u1Z8iW8wYP7s334DLcxv39vV7ZCqCL7paW
	 6ZmLr+mMFzGOczlwW7q6oocbdFwGegg6nHDvSDkDyVt2a9J837k8hULF+v+sH5rhHYDYi
	 FSIj5IdMo8TNJppC2/LA5WLgtFyjJDWig9JllNX+9K0kDFKfLycTND/EOufzAlz4b+I5l
	 7ZJiQiluxXJ/mV3gkp0CwSn5GFUcbBBNCgt1ZN1D1SogTGzn00op9SVo51ePYGTiiZRaD
	 0tAK2ehBDy41dqC125o4/t8eeUbrzX6aT7JFyhHAN3H3Y4umzPtkcdZv5MXA8NW7GOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PNExLYqp;
	arc=none smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2784606A321;
	Tue, 10 Nov 2026 02:05:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2784606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PNExLYqp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794276319; x=1825812319;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JH5OURTQMWE/CgnqxOwW+e2/FmEhQm7dl5QFh/wnna0=;
  b=PNExLYqphRkAGY4JS7CQaWowBvdEenHF93a0U941BZlFEs2yaa8nTi/P
   kRsVCbA5y3qMh030z5hY4clmALEdhVYBfWmLywnQbDg8O3RmqlcFqsA/C
   r7B4jlWgg/Ro1bovqDCY/yBes9WOvG7cpsHmxdK8YUZDmo7+tBtI5SN8f
   90dU3z9S8SMf+eZRja3aKWudIzZICjj/NWu8cPiaoADQwaVOtQXZkuYZ7
   B2yvRAZC5niCpUuMNDVQHbda1gyrNHBpm5FOWIbDDD9zPtlU0RX31u79H
   tvU3hHbRpNoYocvMmtDsofCneLJOeAxM1RMyhFYEljHOiy+fX6tcnLuTz
   g==;
X-CSE-ConnectionGUID: Q35Vtw33StCXQuM6CEfKYg==
X-CSE-MsgGUID: i8pDznOuSmulP9+tMjBkPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11961"; a="3049264"
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="3049264"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 18:05:18 -0800
X-CSE-ConnectionGUID: /OxRHji+Q2y9+mcZM02zYQ==
X-CSE-MsgGUID: oGV6OJz6TbGQxzY2j+rwaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,204,1787036400"; 
   d="scan'208";a="8332004"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 09 Nov 2026 18:05:15 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xQbEW-00000000vkN-2Vje;
	Tue, 10 Nov 2026 02:05:12 +0000
Date: Tue, 10 Nov 2026 10:05:08 +0800
From: kernel test robot <lkp@intel.com>
To: Chenghai Huang <huangchenghai2@huawei.com>, herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	liulongfang@huawei.com, qianweili@huawei.com,
	wangzhou1@hisilicon.com, linwenkai6@hisilicon.com
Subject: Re: [PATCH 2/4] crypto: engine - add acomp support
Message-ID: <202611100938.hePDEbMz-lkp@intel.com>
References: <20261109073556.2517351-3-huangchenghai2@huawei.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109073556.2517351-3-huangchenghai2@huawei.com>

Hi Chenghai,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v7.4-rc2 next-20261109]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chenghai-Huang/crypto-engine-clear-busy-and-recheck-running-in-the-retry-pump-loop/20261109-153553
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20261109073556.2517351-3-huangchenghai2%40huawei.com
patch subject: [PATCH 2/4] crypto: engine - add acomp support
config: arm-gemini_defconfig (https://download.01.org/0day-ci/archive/20261110/202611100938.hePDEbMz-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project b3e2466a7ef2bbc97d31230c3bf39a6fa50a608a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261110/202611100938.hePDEbMz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611100938.hePDEbMz-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: crypto_register_acomp
   >>> referenced by crypto_engine.c
   >>>               crypto/crypto_engine.o:(crypto_engine_register_acomp) in archive vmlinux.a
--
>> ld.lld: error: undefined symbol: crypto_unregister_acomp
   >>> referenced by crypto_engine.c
   >>>               crypto/crypto_engine.o:(crypto_engine_unregister_acomp) in archive vmlinux.a

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
