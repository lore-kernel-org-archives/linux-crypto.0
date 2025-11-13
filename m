Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4481325707;
	Thu, 13 Nov 2025 22:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763071997; cv=none; b=XNCjU2XGD/MBXG1C3TDdDz4F9uQtkLI9p2HefCmj2lf10orrV5m8AWvkaa/sU6zdq7vYPddXeXnVnR8MBTUyDRyMUL8Y8tLuo4QsP2bgwton3S68/R9GTN/orGH7aW0oU4m36kvXwFIMTgL7sTCDpq2PCiC962OBAf/EKw59wec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763071997; c=relaxed/simple;
	bh=7DsvcDAxazj+gsNw+fr8ZOWv5UnQaP6Roe8FfVy6ghc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qkGmoIBhCBjA9Mx2LCzSDQ7qQJ+zA3SxHzlUmDNI/xNO3MiXygBn0bn+ICxUsBdtYq5EzTvUzpGVf68A5KtlJ7R14UJDPA2KPwLi6i15PeU0F7lg/eUbUjyooNm0bWJuMWj/Zm4bWg9aj23bWA5KM2q1B6jU8ASfg2e+NpMAnWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k83NHY0j; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k83NHY0j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763071996; x=1794607996;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7DsvcDAxazj+gsNw+fr8ZOWv5UnQaP6Roe8FfVy6ghc=;
  b=k83NHY0jdF+Lif5M8qsmDPITh7tOqhe2v0ypcH2xzTY8R076esOsEvuQ
   UfIMVARUY01sVPMiwWBscBDxLokOMPyG7v9LXP2F5jky3QzE0PjkUjN5k
   fHVNT2JZCHPpt+d/01g7rs2OQ7psS0Dg5zuRqqNtO4SPfPcczgz5y30y5
   2dGRn1EMyAVcK0AE39ZVVe8OEJDrtdENbu7HNf5C/ZSV4cbc+Kd82vUry
   CV2PIV7a3VE2u3tso4QGnzgifREUD2po2tvzQblBzEtv4+wTpB8IuOb+D
   GhddPEKzDXFTDSGykDu/Insdt7/G6dcG1ufCQFYDj4MfMw33ADrO//f9O
   Q==;
X-CSE-ConnectionGUID: f5qa44A3Q1S1Be2QPFJ9zA==
X-CSE-MsgGUID: n/l6XBJ3TzKpm5lYnTI9Gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="87810545"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="87810545"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:13:15 -0800
X-CSE-ConnectionGUID: M4ZtxGFfQBW3L6/7MnfzOQ==
X-CSE-MsgGUID: nRIfcmGJTZWkYSxQOLxlKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="189810777"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 13 Nov 2025 14:13:14 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJfZ1-0005w3-13;
	Thu, 13 Nov 2025 22:13:11 +0000
Date: Fri, 14 Nov 2025 06:13:05 +0800
From: kernel test robot <lkp@intel.com>
To: Haotian Zhang <vulab@iscas.ac.cn>, herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: Re: [PATCH] crypto: sa2ul: Add error handling for DMA metadata
 retrieval
Message-ID: <202511140542.Z9DpLPyb-lkp@intel.com>
References: <20251113075104.1396-1-vulab@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251113075104.1396-1-vulab@iscas.ac.cn>

Hi Haotian,

kernel test robot noticed the following build errors:

[auto build test ERROR on herbert-cryptodev-2.6/master]
[also build test ERROR on herbert-crypto-2.6/master linus/master v6.18-rc5 next-20251113]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Haotian-Zhang/crypto-sa2ul-Add-error-handling-for-DMA-metadata-retrieval/20251113-155200
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20251113075104.1396-1-vulab%40iscas.ac.cn
patch subject: [PATCH] crypto: sa2ul: Add error handling for DMA metadata retrieval
config: loongarch-randconfig-002-20251113 (https://download.01.org/0day-ci/archive/20251114/202511140542.Z9DpLPyb-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 0bba1e76581bad04e7d7f09f5115ae5e2989e0d9)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511140542.Z9DpLPyb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511140542.Z9DpLPyb-lkp@intel.com/

All errors (new ones prefixed by >>):

>> drivers/crypto/sa2ul.c:1387:29: error: incompatible pointer types passing 'struct ahash_request *' to parameter of type 'struct skcipher_request *' [-Wincompatible-pointer-types]
    1387 |                 skcipher_request_complete(req, PTR_ERR(mdptr));
         |                                           ^~~
   include/crypto/internal/skcipher.h:94:71: note: passing argument to parameter 'req' here
      94 | static inline void skcipher_request_complete(struct skcipher_request *req, int err)
         |                                                                       ^
>> drivers/crypto/sa2ul.c:1705:29: error: incompatible pointer types passing 'struct aead_request *' to parameter of type 'struct skcipher_request *' [-Wincompatible-pointer-types]
    1705 |                 skcipher_request_complete(req, PTR_ERR(mdptr));
         |                                           ^~~
   include/crypto/internal/skcipher.h:94:71: note: passing argument to parameter 'req' here
      94 | static inline void skcipher_request_complete(struct skcipher_request *req, int err)
         |                                                                       ^
   2 errors generated.


vim +1387 drivers/crypto/sa2ul.c

  1365	
  1366	static void sa_sha_dma_in_callback(void *data)
  1367	{
  1368		struct sa_rx_data *rxd = data;
  1369		struct ahash_request *req;
  1370		struct crypto_ahash *tfm;
  1371		unsigned int authsize;
  1372		int i;
  1373		size_t ml, pl;
  1374		u32 *result;
  1375		__be32 *mdptr;
  1376	
  1377		sa_sync_from_device(rxd);
  1378		req = container_of(rxd->req, struct ahash_request, base);
  1379		tfm = crypto_ahash_reqtfm(req);
  1380		authsize = crypto_ahash_digestsize(tfm);
  1381	
  1382		mdptr = (__be32 *)dmaengine_desc_get_metadata_ptr(rxd->tx_in, &pl, &ml);
  1383		if (IS_ERR(mdptr)) {
  1384			dev_err(rxd->ddev, "Failed to get SHA RX metadata pointer: %ld\n",
  1385				PTR_ERR(mdptr));
  1386			sa_free_sa_rx_data(rxd);
> 1387			skcipher_request_complete(req, PTR_ERR(mdptr));
  1388			return;
  1389		}
  1390	
  1391		result = (u32 *)req->result;
  1392	
  1393		for (i = 0; i < (authsize / 4); i++)
  1394			result[i] = be32_to_cpu(mdptr[i + 4]);
  1395	
  1396		sa_free_sa_rx_data(rxd);
  1397	
  1398		ahash_request_complete(req, 0);
  1399	}
  1400	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
