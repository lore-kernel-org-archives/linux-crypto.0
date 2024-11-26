Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C7F1898FC;
	Tue, 26 Nov 2024 07:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732604753; cv=none; b=mhyoIaZiZdnEOXsWqMbRjbdvp5B08z7rSgTrNzXVZk+UIyr3I8dyf40eb1pK2nAinEaa21MpfN+uLNFh7LAlUy8vFIdZMrOeh8RDqera9FnvuCRkE7U+kb0Uv7uS1HENxqbx2I5izb/BBfbmynVpVly616tZtLuyD/iT2oDheYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732604753; c=relaxed/simple;
	bh=xaU5B8y8EM6Iu+8Y+nodl+0QKfUC5iXarFMjzNAmxAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0bGZMquBGOHtt1DE56vKN+ZMuaCOSpRjIFtPn4cXvOOEO71goTeijUg6HBRV5XtKhVN57DHoY78PEzZbhV4gH/mN2vx4ur+GQ/FWdmN7e8pGtYwkhsoYx9zagv5983ZlBhC+l2eq1VRSa1YKOh7frROPXu+0H7P0MpeJyrhVPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ef++cCF6; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ef++cCF6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732604752; x=1764140752;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xaU5B8y8EM6Iu+8Y+nodl+0QKfUC5iXarFMjzNAmxAY=;
  b=Ef++cCF6rZ0P3RjuQGU5ACog6vtcL5XoavojuRo/q18EjO9WD/OMJI+3
   aJitMKiFUKCAdrmf2/ksPmuHzam9nhsWBrogxiijK7SoxggiOSwIume+j
   S8tsRKNJAz7dRUSc4UVKWNCzK7ZuUehRb6EndEqCd8oAaGfr+3jOfFhtq
   v+yfg58mU2N/JBie35NOpYSa9Cfq/mXHz6Kk/L3Uj6Fbi01LaRJV10ydq
   Ty0mnQ6RZXQ9ozX53LzRygXvxtPpVdBMfZszTPweZBNYK6esWAp6I8PO+
   mxkrdf7bYMlcujA7C4vPyGt1tpZ/TI9oca9vSnGbEABvrWkwEr+bO6E4n
   A==;
X-CSE-ConnectionGUID: s+tLOdDaTHqRBBIJ3Yd0iQ==
X-CSE-MsgGUID: nRmRhh1jSBWddYqyebdn9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11267"; a="43362866"
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="43362866"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2024 23:05:50 -0800
X-CSE-ConnectionGUID: w66V3T7bToG0BdscdNGQUA==
X-CSE-MsgGUID: rT27KM6WS+WO0v3so3eARg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,185,1728975600"; 
   d="scan'208";a="91459250"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 25 Nov 2024 23:05:44 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tFpdl-00078v-2d;
	Tue, 26 Nov 2024 07:05:41 +0000
Date: Tue, 26 Nov 2024 15:05:37 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, yosryahmed@google.com, nphamcs@gmail.com,
	chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, ying.huang@intel.com, 21cnbao@gmail.com,
	akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com
Cc: oe-kbuild-all@lists.linux.dev, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com, kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v4 03/10] crypto: iaa - Implement batch_compress(),
 batch_decompress() API in iaa_crypto.
Message-ID: <202411261737.ozFff8Ym-lkp@intel.com>
References: <20241123070127.332773-4-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241123070127.332773-4-kanchana.p.sridhar@intel.com>

Hi Kanchana,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 5a7056135bb69da2ce0a42eb8c07968c1331777b]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-Sridhar/crypto-acomp-Define-two-new-interfaces-for-compress-decompress-batching/20241125-110412
base:   5a7056135bb69da2ce0a42eb8c07968c1331777b
patch link:    https://lore.kernel.org/r/20241123070127.332773-4-kanchana.p.sridhar%40intel.com
patch subject: [PATCH v4 03/10] crypto: iaa - Implement batch_compress(), batch_decompress() API in iaa_crypto.
config: x86_64-rhel-9.4 (https://download.01.org/0day-ci/archive/20241126/202411261737.ozFff8Ym-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241126/202411261737.ozFff8Ym-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411261737.ozFff8Ym-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/crypto/intel/iaa/iaa_crypto_main.c:1882: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * This API provides IAA compress batching functionality for use by swap
   drivers/crypto/intel/iaa/iaa_crypto_main.c:2010: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * This API provides IAA decompress batching functionality for use by swap


vim +1882 drivers/crypto/intel/iaa/iaa_crypto_main.c

  1880	
  1881	/**
> 1882	 * This API provides IAA compress batching functionality for use by swap
  1883	 * modules.
  1884	 *
  1885	 * @reqs: @nr_pages asynchronous compress requests.
  1886	 * @wait: crypto_wait for synchronous acomp batch compress. If NULL, the
  1887	 *        completions will be processed asynchronously.
  1888	 * @pages: Pages to be compressed by IAA in parallel.
  1889	 * @dsts: Pre-allocated destination buffers to store results of IAA
  1890	 *        compression. Each element of @dsts must be of size "PAGE_SIZE * 2".
  1891	 * @dlens: Will contain the compressed lengths.
  1892	 * @errors: zero on successful compression of the corresponding
  1893	 *          req, or error code in case of error.
  1894	 * @nr_pages: The number of pages, up to CRYPTO_BATCH_SIZE,
  1895	 *            to be compressed.
  1896	 */
  1897	static void iaa_comp_acompress_batch(
  1898		struct acomp_req *reqs[],
  1899		struct crypto_wait *wait,
  1900		struct page *pages[],
  1901		u8 *dsts[],
  1902		unsigned int dlens[],
  1903		int errors[],
  1904		int nr_pages)
  1905	{
  1906		struct scatterlist inputs[CRYPTO_BATCH_SIZE];
  1907		struct scatterlist outputs[CRYPTO_BATCH_SIZE];
  1908		bool compressions_done = false;
  1909		bool poll = (async_mode && !use_irq);
  1910		int i;
  1911	
  1912		BUG_ON(nr_pages > CRYPTO_BATCH_SIZE);
  1913		BUG_ON(!poll && !wait);
  1914	
  1915		if (poll)
  1916			iaa_set_req_poll(reqs, nr_pages, true);
  1917		else
  1918			iaa_set_req_poll(reqs, nr_pages, false);
  1919	
  1920		/*
  1921		 * Prepare and submit acomp_reqs to IAA. IAA will process these
  1922		 * compress jobs in parallel if async-poll mode is enabled.
  1923		 * If IAA is used in sync mode, the jobs will be processed sequentially
  1924		 * using "wait".
  1925		 */
  1926		for (i = 0; i < nr_pages; ++i) {
  1927			sg_init_table(&inputs[i], 1);
  1928			sg_set_page(&inputs[i], pages[i], PAGE_SIZE, 0);
  1929	
  1930			/*
  1931			 * Each dst buffer should be of size (PAGE_SIZE * 2).
  1932			 * Reflect same in sg_list.
  1933			 */
  1934			sg_init_one(&outputs[i], dsts[i], PAGE_SIZE * 2);
  1935			acomp_request_set_params(reqs[i], &inputs[i],
  1936						 &outputs[i], PAGE_SIZE, dlens[i]);
  1937	
  1938			/*
  1939			 * If poll is in effect, submit the request now, and poll for
  1940			 * a completion status later, after all descriptors have been
  1941			 * submitted. If polling is not enabled, submit the request
  1942			 * and wait for it to complete, i.e., synchronously, before
  1943			 * moving on to the next request.
  1944			 */
  1945			if (poll) {
  1946				errors[i] = iaa_comp_acompress(reqs[i]);
  1947	
  1948				if (errors[i] != -EINPROGRESS)
  1949					errors[i] = -EINVAL;
  1950				else
  1951					errors[i] = -EAGAIN;
  1952			} else {
  1953				acomp_request_set_callback(reqs[i],
  1954							   CRYPTO_TFM_REQ_MAY_BACKLOG,
  1955							   crypto_req_done, wait);
  1956				errors[i] = crypto_wait_req(iaa_comp_acompress(reqs[i]),
  1957							    wait);
  1958				if (!errors[i])
  1959					dlens[i] = reqs[i]->dlen;
  1960			}
  1961		}
  1962	
  1963		/*
  1964		 * If not doing async compressions, the batch has been processed at
  1965		 * this point and we can return.
  1966		 */
  1967		if (!poll)
  1968			goto reset_reqs_wait;
  1969	
  1970		/*
  1971		 * Poll for and process IAA compress job completions
  1972		 * in out-of-order manner.
  1973		 */
  1974		while (!compressions_done) {
  1975			compressions_done = true;
  1976	
  1977			for (i = 0; i < nr_pages; ++i) {
  1978				/*
  1979				 * Skip, if the compression has already completed
  1980				 * successfully or with an error.
  1981				 */
  1982				if (errors[i] != -EAGAIN)
  1983					continue;
  1984	
  1985				errors[i] = iaa_comp_poll(reqs[i]);
  1986	
  1987				if (errors[i]) {
  1988					if (errors[i] == -EAGAIN)
  1989						compressions_done = false;
  1990				} else {
  1991					dlens[i] = reqs[i]->dlen;
  1992				}
  1993			}
  1994		}
  1995	
  1996	reset_reqs_wait:
  1997		/*
  1998		 * For the same 'reqs[]' and 'wait' to be usable by
  1999		 * iaa_comp_acompress()/iaa_comp_deacompress():
  2000		 * Clear the CRYPTO_ACOMP_REQ_POLL bit on the acomp_reqs.
  2001		 * Reset the crypto_wait "wait" callback to reqs[0].
  2002		 */
  2003		iaa_set_req_poll(reqs, nr_pages, false);
  2004		acomp_request_set_callback(reqs[0],
  2005					   CRYPTO_TFM_REQ_MAY_BACKLOG,
  2006					   crypto_req_done, wait);
  2007	}
  2008	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
