Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF7DEC7
	for <linux-crypto@vger.kernel.org>; Sun,  4 Aug 2024 00:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722730901; cv=none; b=QWf/5j+Hx5tVv6pcq/gseSSEFE3X8bU4JGCzbzm9+nfuqbwajuorV/UmHj1O5yTC4FjqZu/fG9Sin0CK8b70c88re0ZE0yL0+fbhorkQ1DVd4OnCiYoNKFDFbU33bGUdUlk8pGUv5N65lT1M+H8lCLnmiN8MN2gUidbgT5w0cY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722730901; c=relaxed/simple;
	bh=6fwdjn2Sdr9CngYFRhAVfoaS6hFUQxV5ElQ3usVTWds=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=FvPWPDwow6X95k1uTHmtWgoXgwqR1Ov6lTmLCnhHBETdSBsm9ZLJ4oL1dn09vJxGgCvfbc0gUF/SaIdpk9YkH/+vX/LZ7gQJw3z1ROq2dUnqRM6cjrT1wvIAREg+ZdmyWD8ohWuYZv2FJTZGrviY4HHpdigJWxScF8G3s3Lu+h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NSp2zJaY; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NSp2zJaY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722730900; x=1754266900;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=6fwdjn2Sdr9CngYFRhAVfoaS6hFUQxV5ElQ3usVTWds=;
  b=NSp2zJaYGkD88dSI8Ksbz91595OW6t0dmfU8SAGpnwHXbW44ER0+byc+
   aFNe+otC/nANRTYc2BaYFT2p1OFxbXo/CcPFZizGcbwqw3wK1wWFUjPjI
   0IA7fETP1Ge/PHlx9Gzj2zBeFba/m85FxokPjlPnCZxQN4fmf3Vt2TUy+
   kZN3F+vjc6uq0g9Y9xJvwNJZP8Xy/kbXSNFBIiW+JdktmsaTrLZL+UrpM
   nrwiQ0fWZeUc4y/NgeTFiUNBqtHZ8mMulwZPXMj27RNTI+Hy0/FW4895G
   PJkxOYBbRnLtgB1+h7VcJ9/gFQHNnfieYvv43E1Nu/OxE6BEYJKkxq2lp
   w==;
X-CSE-ConnectionGUID: 8LW13vAVQcq7vmi1lhJRjA==
X-CSE-MsgGUID: HG3xVjR1TZ21abP53pzZ7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11153"; a="43242578"
X-IronPort-AV: E=Sophos;i="6.09,261,1716274800"; 
   d="scan'208";a="43242578"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2024 17:21:39 -0700
X-CSE-ConnectionGUID: 16t7gnjDQZWIb9U8blcFEQ==
X-CSE-MsgGUID: 0JC6fkHlQrqfRZgLcePUUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,261,1716274800"; 
   d="scan'208";a="55665630"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 03 Aug 2024 17:21:37 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1saP0A-00012A-2n;
	Sun, 04 Aug 2024 00:21:34 +0000
Date: Sun, 4 Aug 2024 08:20:34 +0800
From: kernel test robot <lkp@intel.com>
To: Jia He <justin.he@arm.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [herbert-cryptodev-2.6:master 2/9]
 arch/arm64/crypto/poly1305-core.S:415:(.text+0x3d4): relocation truncated to
 fit: R_AARCH64_ADR_PREL_LO21 against `.rodata'
Message-ID: <202408040817.OWKXtCv6-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   e0d3b845a1b10b7b5abdad7ecc69d45b2aab3209
commit: 47d96252099a7184b4bad852fcfa3c233c1d2f71 [2/9] crypto: arm64/poly1305 - move data to rodata section
config: arm64-randconfig-002-20240804 (https://download.01.org/0day-ci/archive/20240804/202408040817.OWKXtCv6-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240804/202408040817.OWKXtCv6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408040817.OWKXtCv6-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/arm64/crypto/poly1305-core.o: in function `poly1305_blocks_neon':
>> arch/arm64/crypto/poly1305-core.S:415:(.text+0x3d4): relocation truncated to fit: R_AARCH64_ADR_PREL_LO21 against `.rodata'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
