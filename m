Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD2D1C5F1E
	for <linux-crypto@vger.kernel.org>; Sun,  2 Mar 2025 13:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740921958; cv=none; b=o0mhBEBKYyjfCSNasN2TqPrqCSB4fXc33cIx8DAI1cHKsLKQ3bC0UN9MFgmMEsZ1enVv5R4Bh/Gzm1W7qyhJj03gROiXWKskIqJ2jEd7GUtUoO0gQYIOv0yCVSb5r0nCXJjnTh5dqhfMSL4mdiUhMwzdiUZrLJ9OIDXlNmb8wqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740921958; c=relaxed/simple;
	bh=ARbbwpIdpbqahwftCs4PJ277+932Zlpgmu9DKAHOPDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kTsXu8dRAI3iRKbCd/EXigawre8Vw2P/OdnGE9+XS9i/JLIXy+G+x7RlHxKNvFh4+hedsdJvdDMo1q6Qp+famQ3xQYY0LnD/A36IjAu/7gEh+PtvKcr4kLV1Anc7R+PLfG4jLyt5QxlexORE92JJPqqAR2bPdoF68Qa/AU8RwM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TsaqlZ7B; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TsaqlZ7B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740921956; x=1772457956;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ARbbwpIdpbqahwftCs4PJ277+932Zlpgmu9DKAHOPDQ=;
  b=TsaqlZ7Bli1jLZB+ogPezrP+W/+0/ou2j0pYSo8Uvx4OqCWd8IAbvxfn
   7qD4wP1qPJw8EwsYYzptm1pWXB6GlRENaIKIBOWv3C6Mh+qGGCTr9JvYG
   qJ1UVawrlZmisyLwxpG8h6s27/pWSRFfozodcBS7BUdds3hNJEGNXAP3U
   Vi6S+sybPy/qNIrMDPJw+F5KqZVoCLsn8M8xF9vIV+1Ies6ex0azNBsE7
   Mc9Mpf5hALQBW0TP44O21rxWc30vJVruWYZPCgS9vBtzqw0kQ9R2bS/Gb
   sewQQH7r6GMX5DtFmBXjK4KmMujUbpELbwQwcFvTnW75YC4YuYCBSLPYJ
   Q==;
X-CSE-ConnectionGUID: m8uyq1XZRtSMlqZqpHcNQw==
X-CSE-MsgGUID: kKpsNESqTleHxMHIvxSpvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11360"; a="53189633"
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="53189633"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 05:25:56 -0800
X-CSE-ConnectionGUID: R0L0yt2fTb+Hn+S+zFwAVg==
X-CSE-MsgGUID: TO8WH1QASGGxQHCNA+Qeng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="122365340"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 02 Mar 2025 05:25:55 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tojKA-000HL4-2J;
	Sun, 02 Mar 2025 13:25:44 +0000
Date: Sun, 2 Mar 2025 21:24:49 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: [herbert-cryptodev-2.6:master 80/80] ld.lld: error: undefined
 symbol: chacha_crypt_generic
Message-ID: <202503022113.79uEtUuy-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   17ec3e71ba797cdb62164fea9532c81b60f47167
commit: 17ec3e71ba797cdb62164fea9532c81b60f47167 [80/80] crypto: lib/Kconfig - Hide arch options from user
config: arm-randconfig-002-20250302 (https://download.01.org/0day-ci/archive/20250302/202503022113.79uEtUuy-lkp@intel.com/config)
compiler: clang version 21.0.0git (https://github.com/llvm/llvm-project 14170b16028c087ca154878f5ed93d3089a965c6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250302/202503022113.79uEtUuy-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503022113.79uEtUuy-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: chacha_crypt_generic
   >>> referenced by chacha_generic.c:32 (crypto/chacha_generic.c:32)
   >>>               crypto/chacha_generic.o:(chacha_stream_xor) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
