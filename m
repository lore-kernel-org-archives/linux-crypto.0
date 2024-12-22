Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B540939AEB;
	Sun, 22 Dec 2024 04:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734840509; cv=none; b=hvNU4F6JrXdbH0FftPsGbkqt4/qq9yWmvzDDc99YEBKMQvw96sG02FvkNPwsXgSM97XKO6bp62DStK8uFk/GUOkjtHnajtG+7gEAV8Du21KYuPRqBQOgjIU64tjVLlOW7D/t3r12J9kAZeg/XoUHYKsHOM2yvcCtYVsYgivYito=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734840509; c=relaxed/simple;
	bh=FylykkKqihLkQwPrnaT6M0siQ00EymeYnP9fiu64h18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JfqMehLeso/LxerS7lb3EJVGm6baM6uLpcKoETiFYBOZoJGN/J1sV95sJ1xRoBKFFy+ceATwFyNjPK1T/fvqcyPak5dC3LgGSoaYrF33EZyitqBK/9pBcbKY9LO2QfMfW4/OuNryGpYcQFe2d6PaMXGUJ81Zf62LqxhsEcrYfEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lWUZIq9h; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lWUZIq9h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734840507; x=1766376507;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FylykkKqihLkQwPrnaT6M0siQ00EymeYnP9fiu64h18=;
  b=lWUZIq9htR61TBRYQ/raSeeuOJSTiu/IXR/EjcglH8FvbvO2Ik4YUZJa
   AetFlCMBdTksF8v+DYvDEJuAumkiYGjB1dPKcIW8XfmFqg1uPV55tdfxA
   dW5zJn7eVAgsn8ERH6Q3OSD6lp1TxZf8IE818hktJhiejEQ3a3hvXH6jN
   UkLhRXk3q1MOAcyvcwEasI3ytSg/c3l4Ca1L5qrk/pMMuFU7Jw5rBP5Wo
   EAn7IMpoqZpN86PPLcC7BMXFkjzpL5e3NjChDIlh6uixx1P60RHWRQp0/
   L5ilDu6ccrnxaxs7JQiKVoV1h5qBZ+/x5ZHX0gw1PgjvCJZRsH7kjWTVd
   Q==;
X-CSE-ConnectionGUID: b5n3ikSCQ5e/kBnGu4Yovw==
X-CSE-MsgGUID: FNLYTt6wTLOSe4LC8Dw9gA==
X-IronPort-AV: E=McAfee;i="6700,10204,11293"; a="22931898"
X-IronPort-AV: E=Sophos;i="6.12,254,1728975600"; 
   d="scan'208";a="22931898"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2024 20:08:26 -0800
X-CSE-ConnectionGUID: TvhkXB/PRjWQMbTwe3JetQ==
X-CSE-MsgGUID: t22xr3XDSVuQGd/GskbpXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,254,1728975600"; 
   d="scan'208";a="129712676"
Received: from lkp-server01.sh.intel.com (HELO a46f226878e0) ([10.239.97.150])
  by orviesa002.jf.intel.com with ESMTP; 21 Dec 2024 20:08:21 -0800
Received: from kbuild by a46f226878e0 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tPDGM-0002il-2K;
	Sun, 22 Dec 2024 04:08:18 +0000
Date: Sun, 22 Dec 2024 12:07:34 +0800
From: kernel test robot <lkp@intel.com>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	hannes@cmpxchg.org, yosryahmed@google.com, nphamcs@gmail.com,
	chengming.zhou@linux.dev, usamaarif642@gmail.com,
	ryan.roberts@arm.com, 21cnbao@gmail.com, akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: Re: [PATCH v5 04/12] crypto: iaa - Implement batch_compress(),
 batch_decompress() API in iaa_crypto.
Message-ID: <202412221117.i9BKx0mV-lkp@intel.com>
References: <20241221063119.29140-5-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241221063119.29140-5-kanchana.p.sridhar@intel.com>

Hi Kanchana,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 5555a83c82d66729e4abaf16ae28d6bd81f9a64a]

url:    https://github.com/intel-lab-lkp/linux/commits/Kanchana-P-Sridhar/crypto-acomp-Add-synchronous-asynchronous-acomp-request-chaining/20241221-143254
base:   5555a83c82d66729e4abaf16ae28d6bd81f9a64a
patch link:    https://lore.kernel.org/r/20241221063119.29140-5-kanchana.p.sridhar%40intel.com
patch subject: [PATCH v5 04/12] crypto: iaa - Implement batch_compress(), batch_decompress() API in iaa_crypto.
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20241222/202412221117.i9BKx0mV-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241222/202412221117.i9BKx0mV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412221117.i9BKx0mV-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/crypto/intel/iaa/iaa_crypto_main.c:1897: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * This API provides IAA compress batching functionality for use by swap
   drivers/crypto/intel/iaa/iaa_crypto_main.c:2050: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
    * This API provides IAA decompress batching functionality for use by swap


vim +1897 drivers/crypto/intel/iaa/iaa_crypto_main.c

  1895	
  1896	/**
> 1897	 * This API provides IAA compress batching functionality for use by swap
  1898	 * modules.
  1899	 *
  1900	 * @reqs: @nr_pages asynchronous compress requests.
  1901	 * @wait: crypto_wait for acomp batch compress implemented using request
  1902	 *        chaining. Required if async_mode is "false". If async_mode is "true",
  1903	 *        and @wait is NULL, the completions will be processed using
  1904	 *        asynchronous polling of the requests' completion statuses.
  1905	 * @pages: Pages to be compressed by IAA.
  1906	 * @dsts: Pre-allocated destination buffers to store results of IAA
  1907	 *        compression. Each element of @dsts must be of size "PAGE_SIZE * 2".
  1908	 * @dlens: Will contain the compressed lengths.
  1909	 * @errors: zero on successful compression of the corresponding
  1910	 *          req, or error code in case of error.
  1911	 * @nr_pages: The number of pages, up to IAA_CRYPTO_MAX_BATCH_SIZE,
  1912	 *            to be compressed.
  1913	 *
  1914	 * Returns true if all compress requests complete successfully,
  1915	 * false otherwise.
  1916	 */
  1917	static bool iaa_comp_acompress_batch(
  1918		struct acomp_req *reqs[],
  1919		struct crypto_wait *wait,
  1920		struct page *pages[],
  1921		u8 *dsts[],
  1922		unsigned int dlens[],
  1923		int errors[],
  1924		int nr_pages)
  1925	{
  1926		struct scatterlist inputs[IAA_CRYPTO_MAX_BATCH_SIZE];
  1927		struct scatterlist outputs[IAA_CRYPTO_MAX_BATCH_SIZE];
  1928		bool compressions_done = false;
  1929		bool async = (async_mode && !use_irq);
  1930		bool async_poll = (async && !wait);
  1931		int i, err = 0;
  1932	
  1933		BUG_ON(nr_pages > IAA_CRYPTO_MAX_BATCH_SIZE);
  1934		BUG_ON(!async && !wait);
  1935	
  1936		if (async)
  1937			iaa_set_req_poll(reqs, nr_pages, true);
  1938		else
  1939			iaa_set_req_poll(reqs, nr_pages, false);
  1940	
  1941		/*
  1942		 * Prepare and submit acomp_reqs to IAA. IAA will process these
  1943		 * compress jobs in parallel if async_mode is true.
  1944		 */
  1945		for (i = 0; i < nr_pages; ++i) {
  1946			sg_init_table(&inputs[i], 1);
  1947			sg_set_page(&inputs[i], pages[i], PAGE_SIZE, 0);
  1948	
  1949			/*
  1950			 * Each dst buffer should be of size (PAGE_SIZE * 2).
  1951			 * Reflect same in sg_list.
  1952			 */
  1953			sg_init_one(&outputs[i], dsts[i], PAGE_SIZE * 2);
  1954			acomp_request_set_params(reqs[i], &inputs[i],
  1955						 &outputs[i], PAGE_SIZE, dlens[i]);
  1956	
  1957			/*
  1958			 * As long as the API is called with a valid "wait", chain the
  1959			 * requests for synchronous/asynchronous compress ops.
  1960			 * If async_mode is in effect, but the API is called with a
  1961			 * NULL "wait", submit the requests first, and poll for
  1962			 * their completion status later, after all descriptors have
  1963			 * been submitted.
  1964			 */
  1965			if (!async_poll) {
  1966				/* acomp request chaining. */
  1967				if (i)
  1968					acomp_request_chain(reqs[i], reqs[0]);
  1969				else
  1970					acomp_reqchain_init(reqs[0], 0, crypto_req_done,
  1971							    wait);
  1972			} else {
  1973				errors[i] = iaa_comp_acompress(reqs[i]);
  1974	
  1975				if (errors[i] != -EINPROGRESS) {
  1976					errors[i] = -EINVAL;
  1977					err = -EINVAL;
  1978				} else {
  1979					errors[i] = -EAGAIN;
  1980				}
  1981			}
  1982		}
  1983	
  1984		if (!async_poll) {
  1985			if (async)
  1986				/* Process the request chain in parallel. */
  1987				err = crypto_wait_req(acomp_do_async_req_chain(reqs[0],
  1988						      iaa_comp_acompress, iaa_comp_poll),
  1989						      wait);
  1990			else
  1991				/* Process the request chain in series. */
  1992				err = crypto_wait_req(acomp_do_req_chain(reqs[0],
  1993						      iaa_comp_acompress), wait);
  1994	
  1995			for (i = 0; i < nr_pages; ++i) {
  1996				errors[i] = acomp_request_err(reqs[i]);
  1997				if (errors[i]) {
  1998					err = -EINVAL;
  1999					pr_debug("Request chaining req %d compress error %d\n", i, errors[i]);
  2000				} else {
  2001					dlens[i] = reqs[i]->dlen;
  2002				}
  2003			}
  2004	
  2005			goto reset_reqs;
  2006		}
  2007	
  2008		/*
  2009		 * Asynchronously poll for and process IAA compress job completions.
  2010		 */
  2011		while (!compressions_done) {
  2012			compressions_done = true;
  2013	
  2014			for (i = 0; i < nr_pages; ++i) {
  2015				/*
  2016				 * Skip, if the compression has already completed
  2017				 * successfully or with an error.
  2018				 */
  2019				if (errors[i] != -EAGAIN)
  2020					continue;
  2021	
  2022				errors[i] = iaa_comp_poll(reqs[i]);
  2023	
  2024				if (errors[i]) {
  2025					if (errors[i] == -EAGAIN)
  2026						compressions_done = false;
  2027					else
  2028						err = -EINVAL;
  2029				} else {
  2030					dlens[i] = reqs[i]->dlen;
  2031				}
  2032			}
  2033		}
  2034	
  2035	reset_reqs:
  2036		/*
  2037		 * For the same 'reqs[]' to be usable by
  2038		 * iaa_comp_acompress()/iaa_comp_deacompress(),
  2039		 * clear the CRYPTO_ACOMP_REQ_POLL bit on all acomp_reqs, and the
  2040		 * CRYPTO_TFM_REQ_CHAIN bit on the reqs[0].
  2041		 */
  2042		iaa_set_req_poll(reqs, nr_pages, false);
  2043		if (!async_poll)
  2044			acomp_reqchain_clear(reqs[0], wait);
  2045	
  2046		return !err;
  2047	}
  2048	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
