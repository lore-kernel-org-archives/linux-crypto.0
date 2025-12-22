Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BFB322B73;
	Mon, 22 Dec 2025 17:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766423547; cv=none; b=n3VrB2p3iIXtxoIPB5psFk6GBySqc75BEczt8sLFwSyKvGfjNDi+7CXg9KL2IgTt+JR+08BWUg0eSiMs+Z5zy8ss9gu+6o9+TEN41hbNSBfY0FRj3gmW9Iv6L781XXfEXs8Gj8DjkOu+1UPtAdbShstIukrElwMAS8gVKNL+wrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766423547; c=relaxed/simple;
	bh=OhoBkjnY0xpu56sErDgnqNkAe2///XrHKr2YYE9m49Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UnQbHexdY3tHyDrFlbzTvzHBtuwHktDfijK5nUYDW8xTkvc5g2QtVGmUDDOlD81iBWIVhFYv2T4+0IueyqEj1Mw+ApBiPT4dLUF7k8kWCb2/EilCwAv+tURVa6M/gW/xQoLKn8eONVpbw11dHQ6+iSY7F6uXC0VLhx1dXhBbABM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kJ7o9twT; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kJ7o9twT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766423546; x=1797959546;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OhoBkjnY0xpu56sErDgnqNkAe2///XrHKr2YYE9m49Q=;
  b=kJ7o9twTwt0ipMji2xRzYUh0oj2AZbwIRewNMUjO7juye8qGQcu7zNaq
   Zy/ubhF7MsFdIfID5eJ+vGX0tLnYeGb1aB1fzfkF1cEtsfbQyY3ztn8WD
   6Cu3YLEfZAy4WnmocZNp89g+gVKy/vw54ucQxF37uJOYH8skj4e+VNhcN
   uP5NxOAujgfIWIVzzRxP/HIZxkn5Ghd72zXlyjAzME3AVkZUyGQgxYNXK
   m3/t/9r2Fvngx/9YdRmHjIiFKYvVgr8MJKz8nAxRc1KagHx2cbiTHdYVV
   W7ANFJTmUJ+TNe6NWC2l1JIFGFckf2wxU67nXSIYH/r8thddG5zoZqr5W
   g==;
X-CSE-ConnectionGUID: lwxx9r9KQmSdNhzZAjDp1Q==
X-CSE-MsgGUID: bC7/NDMmTMmfyocdNIkFxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11650"; a="78597816"
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="78597816"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2025 09:12:25 -0800
X-CSE-ConnectionGUID: ABC+28DlTxmt6hXgPIzs/A==
X-CSE-MsgGUID: nDZNxFzbQoGY51lH+MPhJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,168,1763452800"; 
   d="scan'208";a="198710127"
Received: from igk-lkp-server01.igk.intel.com (HELO 8a0c053bdd2a) ([10.211.93.152])
  by orviesa006.jf.intel.com with ESMTP; 22 Dec 2025 09:12:22 -0800
Received: from kbuild by 8a0c053bdd2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vXjSG-000000005Yy-23k6;
	Mon, 22 Dec 2025 17:12:20 +0000
Date: Mon, 22 Dec 2025 18:11:48 +0100
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
Message-ID: <202512221855.nLchuL2R-lkp@intel.com>
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

[auto build test WARNING on 92de2d349e02c2dd96d8d1b7016cc78cf80fc085]

url:    https://github.com/intel-lab-lkp/linux/commits/Rusydi-H-Makarim/lib-crypto-Add-KUnit-test-vectors-for-Ascon-Hash256/20251215-215114
base:   92de2d349e02c2dd96d8d1b7016cc78cf80fc085
patch link:    https://lore.kernel.org/r/20251215-ascon_hash256-v1-1-24ae735e571e%40kriptograf.id
patch subject: [PATCH 1/3] lib/crypto: Add KUnit test vectors for Ascon-Hash256
config: x86_64-rhel-9.4-kunit (https://download.01.org/0day-ci/archive/20251222/202512221855.nLchuL2R-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251222/202512221855.nLchuL2R-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512221855.nLchuL2R-lkp@intel.com/

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
