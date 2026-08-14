Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313F6399CF5;
	Fri, 14 Aug 2026 19:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786735689; cv=none; b=iPuCLe9Izo1cPnhIxrLY6OlsopIRCP+sSAnrjdplge3/y1caI1PcWGX8f6VyfwCa0lRVU3hpfNBUc7jY5kG0uzbMH1JX3i6EImglyv7nGZIQiO1JEwsMh7uiAnnU+VnERFcp7urTBEuZeT/Thublyf409anSGIcOmKiAc/KpZU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786735689; c=relaxed/simple;
	bh=SSYQsbj6ZEE7A8qSrmzJSebTXjoAlcHbG+fX1kbjcus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AZBzNm6sI9W237rO1NxXTMTQdP9lFynIH61k/P235HfugvZ40xFqDwMu9woxivdNNh/4bTqtCUrBJ6aC6kAYWF5kuoyIpfUyfDrsCvsmHmtJzMdWrM5V5lqBqVvsGR0ytHgcoKv2wFgkJF/5is7y3Y1ODtWa+bFYEDQcTDG2DNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I1zh5fMT; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I1zh5fMT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786735687; x=1818271687;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SSYQsbj6ZEE7A8qSrmzJSebTXjoAlcHbG+fX1kbjcus=;
  b=I1zh5fMT72ICw3Kx1LO9tIXWDhwuV6N+ZyAixlpKs0nsjyFEVE3CuTCy
   7baHO09gtskjB+l7yIm6nB+rtHRa6zfkRzUwFTB1eG704Xg1EEbHjvI/2
   TLmLLdFKwuzbp3rHZ7a1w781khU3eanIoaxGoS7txjRwoOBwYmUJhbTE6
   1+ubcAWvjq54lwZeo1Iwo0BaxJbus/Hbw85hzYCRqBZldKpgwG2Vp/A/H
   A7vYCHkd0Oj+uT2ri/DL9x+rIN7ESlGirnS65A1Ngeaa1Gf/pUDhnAoW8
   mj6MInzG8VArqhE+AcGkRiehw8KQeC0HxneWtxarbJHVCqIjysE4TsDby
   w==;
X-CSE-ConnectionGUID: 2ggSCd+nT5maU73D+iSxPw==
X-CSE-MsgGUID: z/br76cTQR+FWAGEQoVkzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11875"; a="87242107"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="87242107"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2026 12:28:06 -0700
X-CSE-ConnectionGUID: OMexIP8XSU6gEBTmQA43ew==
X-CSE-MsgGUID: AVHscax6R4+PYxKolsurZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="260066757"
Received: from lkp-server01.sh.intel.com (HELO 6eda058d650d) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 14 Aug 2026 12:28:03 -0700
Received: from kbuild by 6eda058d650d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wuxZQ-00000000Zwg-2PaZ;
	Fri, 14 Aug 2026 19:28:00 +0000
Date: Sat, 15 Aug 2026 03:27:38 +0800
From: kernel test robot <lkp@intel.com>
To: quanyeyang via B4 Relay <devnull+quanyemostima.gmail.com@kernel.org>,
	Thomas Graf <tgraf@suug.ch>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	NeilBrown <neilb@suse.com>, "David S. Miller" <davem@davemloft.net>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+ef8d17bae14efb960935@syzkaller.appspotmail.com,
	quanyeyang <quanyemostima@gmail.com>
Subject: Re: [PATCH] rhashtable: use per-init-site lockdep classes for bucket
 locks
Message-ID: <202608150357.9LheVOQg-lkp@intel.com>
References: <20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c@gmail.com>

Hi quanyeyang,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 0131b508c0e2489eac6e121135988f6eeb716f19]

url:    https://github.com/intel-lab-lkp/linux/commits/quanyeyang-via-B4-Relay/rhashtable-use-per-init-site-lockdep-classes-for-bucket-locks/20260815-014140
base:   0131b508c0e2489eac6e121135988f6eeb716f19
patch link:    https://lore.kernel.org/r/20260801-fix-rhashtable-bucket-lockdep-v1-1-15a0f8ae094c%40gmail.com
patch subject: [PATCH] rhashtable: use per-init-site lockdep classes for bucket locks
config: alpha-allmodconfig (https://download.01.org/0day-ci/archive/20260815/202608150357.9LheVOQg-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260815/202608150357.9LheVOQg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202608150357.9LheVOQg-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> Warning: lib/rhashtable.c:1170 function parameter 'mutex_key' not described in '__rhashtable_init'
>> Warning: lib/rhashtable.c:1170 function parameter 'bucket_key' not described in '__rhashtable_init'
   Warning: lib/rhashtable.c:1170 expecting prototype for rhashtable_init(). Prototype was for __rhashtable_init() instead
>> Warning: lib/rhashtable.c:1247 function parameter 'mutex_key' not described in '__rhltable_init'
>> Warning: lib/rhashtable.c:1247 function parameter 'bucket_key' not described in '__rhltable_init'
   Warning: lib/rhashtable.c:1247 expecting prototype for rhltable_init(). Prototype was for __rhltable_init() instead

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
