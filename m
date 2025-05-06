Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97930284692
	for <linux-crypto@vger.kernel.org>; Tue,  6 May 2025 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746548819; cv=none; b=dtV7+CqeUgoFeFnIqbct+15aanU+eCd9lZjQ6RK/jG14GPzVM4T9zshZHndT4oAZCPspgwv2whEKC4FJZahbVyBGWhl8rm0vurH9cEBmdndOXZQGTgtIerzZGydqK2sjaVyInHtJ/0ZVkIlzAuyIc5Cc8wTyHCzxfcqj3SjQVEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746548819; c=relaxed/simple;
	bh=J0HTwTcQYD6klLby0aigAvGQ4vEho727QoS71VGdmeE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=H08A8AtkYm+fEzQFzqMNZhzS6Wk2HBioY+ZFRy71BHGeYyJBwlRFA6WylB0hQ2JncZ3KES41r79C9SHtZvkEIHteYiTvGPS7xd2sYI3oIH+r4Wqdn+H/ls1fi6xDfYhcgmUQoUdsMDCWwx6QI5SvBhRFMKXMRsnnxKoTdmMF3Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RE/01ie+; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RE/01ie+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746548816; x=1778084816;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=J0HTwTcQYD6klLby0aigAvGQ4vEho727QoS71VGdmeE=;
  b=RE/01ie+iLjf9PYkb7BXUSAkW36tH/o53dhz+CBnXP8gsrZzAMgrM4To
   mq0fEWle/3DoBIOquB3fJRoQrZVqZc6EXDP/P94pltPDoEPekPBjJjhkC
   R1GMZLChMf1frq9sae1ESawgtrbsOi6DP1Utf332Lk9jl2DF3CklKlJ+U
   ezcimE6d1ox1FndgaTuTzkLFDlJKKTUZGmiFIcvEo92zr9/nDjoleX2jQ
   s0jtgB++oQFRSLgyvP5nPFjdX2RSIXDkMPuBsz09ktR3do0DAdw4D60XL
   b/a5FczzztQILZ4Xtu2Wxvii7A8luq2jGTDt/YcNl0ztDEeVjSIjQ0TaG
   Q==;
X-CSE-ConnectionGUID: +QQsLOQwTzqae+jbAtS/WA==
X-CSE-MsgGUID: KZ7MAchHSkWjTLWrMjMTEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="59592093"
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="59592093"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 09:26:35 -0700
X-CSE-ConnectionGUID: DOs0lt6DQH+OKKxlaBp80A==
X-CSE-MsgGUID: M1xRnNGSTxK6git6bucIqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,266,1739865600"; 
   d="scan'208";a="135666891"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 06 May 2025 09:26:34 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uCL7o-0006hB-0F;
	Tue, 06 May 2025 16:26:32 +0000
Date: Wed, 7 May 2025 00:25:45 +0800
From: kernel test robot <lkp@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org
Subject: [herbert-cryptodev-2.6:master 50/70]
 arch/um/include/asm/fpu/api.h:14:15: error: unknown type name 'bool'
Message-ID: <202505070045.vWc04ygs-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   9b9d4ef0cf750c514735bfd77745387b95cbddda
commit: 5b90a779bc547939421bfeb333e470658ba94fb6 [50/70] crypto: lib/sha256 - Add helpers for block-based shash
config: um-randconfig-001-20250506 (https://download.01.org/0day-ci/archive/20250507/202505070045.vWc04ygs-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250507/202505070045.vWc04ygs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505070045.vWc04ygs-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from lib/crypto/sha256.c:14:
   In file included from include/crypto/internal/sha2.h:6:
   In file included from include/crypto/internal/simd.h:9:
   In file included from arch/x86/include/asm/simd.h:5:
>> arch/um/include/asm/fpu/api.h:14:15: error: unknown type name 'bool'
      14 | static inline bool irq_fpu_usable(void)
         |               ^
>> arch/um/include/asm/fpu/api.h:16:9: error: use of undeclared identifier 'true'
      16 |         return true;
         |                ^
   2 errors generated.


vim +/bool +14 arch/um/include/asm/fpu/api.h

c0ecca6604b80e Anton Ivanov 2021-03-12  13  
c0ecca6604b80e Anton Ivanov 2021-03-12 @14  static inline bool irq_fpu_usable(void)
c0ecca6604b80e Anton Ivanov 2021-03-12  15  {
c0ecca6604b80e Anton Ivanov 2021-03-12 @16  	return true;
c0ecca6604b80e Anton Ivanov 2021-03-12  17  }
c0ecca6604b80e Anton Ivanov 2021-03-12  18  

:::::: The code at line 14 was first introduced by commit
:::::: c0ecca6604b80e438b032578634c6e133c7028f6 um: enable the use of optimized xor routines in UML

:::::: TO: Anton Ivanov <anton.ivanov@cambridgegreys.com>
:::::: CC: Richard Weinberger <richard@nod.at>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
