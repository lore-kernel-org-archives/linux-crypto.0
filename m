Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA11D2DCF47;
	Sat, 27 Sep 2025 11:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758971653; cv=none; b=RoHYzxwv5Qlwp5RGGbPXqzcdCShNZ6gUtAcqLLFDFchixCmIFCBikbtLFTHSCKm9cNeg+xLqvjj3L8ijkB64/fdQrqB4CBlVecgMqKjFFmRyCyQUCOS74SFFzgadY4IKibk5xi59jxgxrZwZxA+SRA6aGd/fhQk9AH2G4Q332+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758971653; c=relaxed/simple;
	bh=9a5XdVUOGz2zxJlmuwuLpmWr7XJcLR57zKZGoq/vHHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=USoHTxR4m5ls+UCu9Gp5zuI22d2zgzclpP/Prbws1mD52oRgqld04BOigVAGdxFPeF2/xfGGS/7n7407doXb4Au+2xxejFLZcsdeck37CvXDR6wpF883iZ5zgPXg3JzIqoEzCdfDUwkzbmrIkuRbLeJ73rZMZM9WC8putqA+nqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=efnZIYfr; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="efnZIYfr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758971651; x=1790507651;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9a5XdVUOGz2zxJlmuwuLpmWr7XJcLR57zKZGoq/vHHg=;
  b=efnZIYfruuJA2jO5Aa0xAWEszXMT+5Pcaz4i5t6cOpvHLAIeb6j6c9Fp
   Jw4skpxdoWiZiQ0hB+qoskMiBCFOR9I3stTU/YERjKWsjfSUXyVdEyjgb
   IDIcubyA7UYlCwLtiLwA1KV73N/lbU4MrsEIxnxMLtOMMPltTlzyp8mq7
   4HIT+t+Uid0ChtCoSyA+inm65k26q8sk3d6ZzJz+5yccVO/0ZJ4lkKH41
   r1ghxETpAAs89LGFKy1y3fZPr/DZcaBzVvIoMvOz2OOy8QjoBkEdBqbcK
   OVx1BNHDh8ffFxYioNnlMokCpCY3eyO7QMhnwse7VWxBFFLpA93nOigIP
   g==;
X-CSE-ConnectionGUID: Iaiq6rqhQ1G/ZnxZxcqj1A==
X-CSE-MsgGUID: 9UbSBzxdSBqQ/GQUR3Q0Lw==
X-IronPort-AV: E=McAfee;i="6800,10657,11565"; a="60992154"
X-IronPort-AV: E=Sophos;i="6.18,297,1751266800"; 
   d="scan'208";a="60992154"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 04:14:11 -0700
X-CSE-ConnectionGUID: ExKl2LrGQ4yRv8c2jcrJTQ==
X-CSE-MsgGUID: uAXV3QyGSHu/aBaw0D5hgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,297,1751266800"; 
   d="scan'208";a="182996563"
Received: from lkp-server02.sh.intel.com (HELO 84c55410ccf6) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 27 Sep 2025 04:14:07 -0700
Received: from kbuild by 84c55410ccf6 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v2SsO-00070b-37;
	Sat, 27 Sep 2025 11:14:04 +0000
Date: Sat, 27 Sep 2025 19:13:48 +0800
From: kernel test robot <lkp@intel.com>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
	robh@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, krzk+dt@kernel.org, conor+dt@kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	adityak@vayavyalabs.com,
	Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Subject: Re: [PATCH v5 4/4] Add SPAcc Kconfig and Makefile
Message-ID: <202509271802.8KQP38Ht-lkp@intel.com>
References: <20250926141904.38919-5-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926141904.38919-5-pavitrakumarm@vayavyalabs.com>

Hi Pavitrakumar,

kernel test robot noticed the following build errors:

[auto build test ERROR on b73f28d2f847c24ca5d858a79fd37055036b0a67]

url:    https://github.com/intel-lab-lkp/linux/commits/Pavitrakumar-Managutte/dt-bindings-crypto-Document-support-for-SPAcc/20250926-222812
base:   b73f28d2f847c24ca5d858a79fd37055036b0a67
patch link:    https://lore.kernel.org/r/20250926141904.38919-5-pavitrakumarm%40vayavyalabs.com
patch subject: [PATCH v5 4/4] Add SPAcc Kconfig and Makefile
config: m68k-allmodconfig (https://download.01.org/0day-ci/archive/20250927/202509271802.8KQP38Ht-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250927/202509271802.8KQP38Ht-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509271802.8KQP38Ht-lkp@intel.com/

All errors (new ones prefixed by >>):

>> make[6]: *** No rule to make target 'drivers/crypto/dwc-spacc/spacc_skcipher.o', needed by 'drivers/crypto/dwc-spacc/snps-spacc.o'.
>> make[6]: *** No rule to make target 'drivers/crypto/dwc-spacc/spacc_aead.o', needed by 'drivers/crypto/dwc-spacc/snps-spacc.o'.
   make[6]: Target 'drivers/crypto/dwc-spacc/' not remade because of errors.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
