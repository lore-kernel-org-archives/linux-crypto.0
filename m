Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC39AD4B;
	Mon,  8 Dec 2025 00:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765155526; cv=none; b=YYL4KWsO0qCAu6CMZh96Kol1u9tYk3GClT0Xbg06F3PQOG0kWPO0szY9XLa93u/QHLjs56VKNL4MV616PvtRtY/cbSWZYHKAn7FmmluEUK7pD7LLgcfaerZFk8zItSgl6BwiRuZMPrrL3lum2P8rvK/dwZaEg1puIL8y1BgNMIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765155526; c=relaxed/simple;
	bh=AuVsZDC9lU7lEds0aHXmR4LfwJLUrfxrrmaf8c36yhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qUWWAujFVkP2H6dyTRc5Mt3QxHiqO88Sx3R4R0a2/+zPCUzsz1CVgyqHX1eJc0Oz+ceUidNvNqraW6oXdhEjMwPqJXHQXjzdQnU5U4Ie3GWYKiiz54Z7t5C4a2Dnm2Ok8p2RWQOMPd1aVWJpQTW2DlgBAEAEIvmRIt1q9TbuX/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jJTyYo1r; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jJTyYo1r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765155526; x=1796691526;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AuVsZDC9lU7lEds0aHXmR4LfwJLUrfxrrmaf8c36yhk=;
  b=jJTyYo1rxEYTdki0+ZpzbgVZAAQg5SQ0icVgi9CS/U0HXSuF+UpkKtpw
   D1goQ5YZP+OfebwWHRU/jSkMf6BFHUaPjRzsvNxRjCoXkz8dfDQDHmVzD
   BSA5tNEWvIkEoB3Im+rd69OxVnxBOq42anxD/T1rH9dZEc43lV5tSgMeD
   FqYuAb5kSjOcOMrOt0bKVeY3+NBe35R7tDWm5KxO0QPHhGvFjtGUoFwSC
   wZv8VFpr0nrLCl1gjP6T0o0I4D3bu4H8duhrifsQ00h789+ICXxc+SVoz
   udpzp7kG45md51l4nUyxzjCCO1zsnNcYqn2LZW6VAoacu4RaYTX9xDxjK
   Q==;
X-CSE-ConnectionGUID: GRlsRopfQ1y0mkNiln5Smw==
X-CSE-MsgGUID: 3hhe3QfQSXGGSq3B/ffjPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="77419568"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="77419568"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2025 16:58:45 -0800
X-CSE-ConnectionGUID: BKqEMDGdRcSJTkPM7/7ErA==
X-CSE-MsgGUID: 7D6Fkr6YT/a08RrtUmbsOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="195827665"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 07 Dec 2025 16:58:38 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vSPaF-00000000Jkf-2Xiw;
	Mon, 08 Dec 2025 00:58:35 +0000
Date: Mon, 8 Dec 2025 08:58:22 +0800
From: kernel test robot <lkp@intel.com>
To: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com
Cc: oe-kbuild-all@lists.linux.dev, andreyknvl@gmail.com, andy@kernel.org,
	andy.shevchenko@gmail.com, brauner@kernel.org,
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com,
	dhowells@redhat.com, dvyukov@google.com, elver@google.com,
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz,
	jannh@google.com, johannes@sipsolutions.net,
	kasan-dev@googlegroups.com, kees@kernel.org,
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de,
	rmoar@google.com, shuah@kernel.org, sj@kernel.org,
	tarasmadan@google.com, Ethan Graham <ethangraham@google.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
Message-ID: <202512080828.Gxjg6av3-lkp@intel.com>
References: <20251204141250.21114-10-ethan.w.s.graham@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251204141250.21114-10-ethan.w.s.graham@gmail.com>

Hi Ethan,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on herbert-cryptodev-2.6/master herbert-crypto-2.6/master linus/master v6.18]
[cannot apply to next-20251205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ethan-Graham/mm-kasan-implement-kasan_poison_range/20251204-222307
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20251204141250.21114-10-ethan.w.s.graham%40gmail.com
patch subject: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
config: i386-allmodconfig (https://download.01.org/0day-ci/archive/20251208/202512080828.Gxjg6av3-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251208/202512080828.Gxjg6av3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512080828.Gxjg6av3-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "kfuzztest_write_cb_common" [drivers/auxdisplay/charlcd.ko] undefined!
>> ERROR: modpost: "kfuzztest_parse_and_relocate" [drivers/auxdisplay/charlcd.ko] undefined!
>> ERROR: modpost: "record_invocation" [drivers/auxdisplay/charlcd.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
