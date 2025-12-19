Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC2F7405A;
	Fri, 19 Dec 2025 04:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766118594; cv=none; b=CUB+gwIDDu3eErYIru0EkxssmzD0qIxQn74FRBlmAkZjh3Q6qPev5+YK2rZRtyjrlexcusRLUDIDY1/HOaeFwIPFiKtv91YD9VolOgO3GQG9XdSkOqAggWnyZRtXy8qwiQJlEpm5SCMnxhBNE/rMngU29jukQVZOy3TLMNB6EYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766118594; c=relaxed/simple;
	bh=tI+x0eCt5Jk0AIqnw9KGquZ/jqfDBwv7KX4+L3F8dt8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=meC8lUtOWnwvSx0OfO9atyJlmzKwCFVmO5ddWE0XrfE6w6+H2Qaq9OyIORqw3/W2geZXg5jL5NqQxXl5VcNU6A41IYVYiVuIa0Fm5vQ516Y1ZKE3oy4AuL6i7JTZ4OfZNgTUIvGTyPBLIJUGqFrXTVhRxn4AvrroLQnKOFn9bd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ip6215jE; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ip6215jE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766118593; x=1797654593;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tI+x0eCt5Jk0AIqnw9KGquZ/jqfDBwv7KX4+L3F8dt8=;
  b=ip6215jE3MpEqiJYxqxdesiCfImd23ohfYJSsqEys2jnCaSMhJ9n2Fr2
   57tsbsqadN6Ez+mU3vxP87kVQOViA6OUaRU0nIhIUYP1maxz0iZTrAXvx
   uJ/0MyO7b7jR41DKd99rhRtBrY8BOJP8cWvtVurbDCbXdvGf4XKCgAzzb
   obsC8M1BvzHmL52YrXh6ak4iBap0RkA4ttAaCIq2O1Y4O0mzAZQlAT41S
   XNQDSPI6+e9ua20GnlWnfguLyko2C1sOf6sG0tHFfMZGWjvTiXvFZvIG0
   BpuTL+nd1hR2d2nZSrWawCCJ64nkETY/iFNxIshrPjNAYBIRaXNybqEpg
   A==;
X-CSE-ConnectionGUID: 0xXwAxNzQP68OVK0ghWJsg==
X-CSE-MsgGUID: fQ9mDoAAQoyn09a5CmHOtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11646"; a="85666127"
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="85666127"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2025 20:29:52 -0800
X-CSE-ConnectionGUID: c7W7TVl6Rx67mKtgG3hQrA==
X-CSE-MsgGUID: k7h3XoBJQzCGu4K+mE5Ogw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,159,1763452800"; 
   d="scan'208";a="197914218"
Received: from lkp-server01.sh.intel.com (HELO 0d09efa1b85f) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 18 Dec 2025 20:29:49 -0800
Received: from kbuild by 0d09efa1b85f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vWS7e-0000000030L-01B1;
	Fri, 19 Dec 2025 04:29:46 +0000
Date: Fri, 19 Dec 2025 12:29:29 +0800
From: kernel test robot <lkp@intel.com>
To: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	"Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Subject: Re: [PATCH 1/3] lib/crypto: Add KUnit test vectors for Ascon-Hash256
Message-ID: <202512191115.8pVsYusz-lkp@intel.com>
References: <20251215-ascon_hash256-v1-1-24ae735e571e@kriptograf.id>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215-ascon_hash256-v1-1-24ae735e571e@kriptograf.id>

Hi Rusydi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ebiggers/libcrypto-next]
[also build test WARNING on ebiggers/libcrypto-fixes linus/master v6.19-rc1 next-20251218]
[cannot apply to herbert-cryptodev-2.6/master herbert-crypto-2.6/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Rusydi-H-Makarim/lib-crypto-Initial-implementation-of-Ascon-Hash256/20251215-165442
base:   https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-next
patch link:    https://lore.kernel.org/r/20251215-ascon_hash256-v1-1-24ae735e571e%40kriptograf.id
patch subject: [PATCH 1/3] lib/crypto: Add KUnit test vectors for Ascon-Hash256
config: parisc-randconfig-001-20251216 (https://download.01.org/0day-ci/archive/20251219/202512191115.8pVsYusz-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251219/202512191115.8pVsYusz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512191115.8pVsYusz-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from lib/crypto/tests/ascon_hash_kunit.c:6:
>> include/crypto/ascon_hash.h:24:18: warning: 'ascon_p_rndc' defined but not used [-Wunused-const-variable=]
      24 | static const u64 ascon_p_rndc[] = {
         |                  ^~~~~~~~~~~~


vim +/ascon_p_rndc +24 include/crypto/ascon_hash.h

    18	
    19	/*
    20	 * The standard of Ascon permutation in NIST SP 800-232 specifies 16 round
    21	 * constants to accomodate potential functionality extensions in the future
    22	 * (see page 2).
    23	 */
  > 24	static const u64 ascon_p_rndc[] = {
    25		0x000000000000003cULL, 0x000000000000002dULL, 0x000000000000001eULL,
    26		0x000000000000000fULL, 0x00000000000000f0ULL, 0x00000000000000e1ULL,
    27		0x00000000000000d2ULL, 0x00000000000000c3ULL, 0x00000000000000b4ULL,
    28		0x00000000000000a5ULL, 0x0000000000000096ULL, 0x0000000000000087ULL,
    29		0x0000000000000078ULL, 0x0000000000000069ULL, 0x000000000000005aULL,
    30		0x000000000000004bULL,
    31	};
    32	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
