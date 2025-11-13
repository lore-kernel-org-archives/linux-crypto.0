Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B51314D16;
	Thu, 13 Nov 2025 18:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763060097; cv=none; b=AXEeqmwBumjF2pyraIxf4KNVZyvNNPk27Te2zb+LVoPP/K18Q9Pgrv8n6YI3Aao2cyP9i1PjuB9Xf9Dko7kmZgVgTri4Fzko3KBaohO98Rqjuval90fPo7V7+7b5pOuZgt19Tzc6fGzgmU0Oh1eZcs2UzQAxgKKMYxI90gmOSPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763060097; c=relaxed/simple;
	bh=SSkHv0qP9RdS8oYA1m3MhHgCknWNy+M/+MDNO5dnI4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZkMiDX3qbft8/GJSXHg+meOxnz9gjRdy8E9OUO0RWeWwSRDuao4BSUdLbphNTAHD8RjTHquMGs/WIS5eWzQM07tst43B9F1y4dR49VHAI3/JYjdY6d1G7y4SEPlm5xChP7OxDapoMFHCD8kcVMxVcw7nYVklCsHhYPSaC8JDlpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KZl7JiVn; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KZl7JiVn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763060096; x=1794596096;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SSkHv0qP9RdS8oYA1m3MhHgCknWNy+M/+MDNO5dnI4c=;
  b=KZl7JiVnHZs+jsATvco0HMg5zS0hMmx5NvR6ByLGFyTQG1oarA/lwnIm
   YIR/fhLmO51XBNmuYp3ptGaaBuwuDB8ly864zeuH8Cj6/6UHzDOL0OysN
   kug6rr5RGf3OTF6+SzKCZeHGsF+0ATu3AA+5gORXViRcMeVdv61IYplEe
   L6YH2iEB+NVC5WXJes9txc2Ro06kPHq71kN4dGZFWG/C6lGt1RVG0qiam
   Dh2yFcxXq090PMnv4WsCcHYjmAJ+jeJsG8NFaH+fBhTHMkCaclvmnzE/j
   yIi+Amzzp0sMY693im9ESwGMkOn+kSfMHK9Lb2qQ7LCpHeosbqZEODuFu
   w==;
X-CSE-ConnectionGUID: /OYbNDCpTd+HupKFJqfsKA==
X-CSE-MsgGUID: LY5TR+33TsakQijhDYC5ug==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="75466972"
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="75466972"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 10:54:56 -0800
X-CSE-ConnectionGUID: E6m4jWTPQbGFAjAz/UV9pQ==
X-CSE-MsgGUID: ZJuAYNZeQpirrP47L4i+Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,302,1754982000"; 
   d="scan'208";a="194560564"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 13 Nov 2025 10:54:54 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vJcT5-0005lf-1n;
	Thu, 13 Nov 2025 18:54:51 +0000
Date: Fri, 14 Nov 2025 02:54:39 +0800
From: kernel test robot <lkp@intel.com>
To: Haotian Zhang <vulab@iscas.ac.cn>, herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Haotian Zhang <vulab@iscas.ac.cn>
Subject: Re: [PATCH] crypto: sa2ul: Add error handling for DMA metadata
 retrieval
Message-ID: <202511140226.Czi6K1Kj-lkp@intel.com>
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
config: microblaze-randconfig-r073-20251113 (https://download.01.org/0day-ci/archive/20251114/202511140226.Czi6K1Kj-lkp@intel.com/config)
compiler: microblaze-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251114/202511140226.Czi6K1Kj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511140226.Czi6K1Kj-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/crypto/sa2ul.c: In function 'sa_sha_dma_in_callback':
>> drivers/crypto/sa2ul.c:1387:29: error: passing argument 1 of 'skcipher_request_complete' from incompatible pointer type [-Werror=incompatible-pointer-types]
      skcipher_request_complete(req, PTR_ERR(mdptr));
                                ^~~
   In file included from drivers/crypto/sa2ul.c:28:
   include/crypto/internal/skcipher.h:94:71: note: expected 'struct skcipher_request *' but argument is of type 'struct ahash_request *'
    static inline void skcipher_request_complete(struct skcipher_request *req, int err)
                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   drivers/crypto/sa2ul.c: In function 'sa_aead_dma_in_callback':
   drivers/crypto/sa2ul.c:1705:29: error: passing argument 1 of 'skcipher_request_complete' from incompatible pointer type [-Werror=incompatible-pointer-types]
      skcipher_request_complete(req, PTR_ERR(mdptr));
                                ^~~
   In file included from drivers/crypto/sa2ul.c:28:
   include/crypto/internal/skcipher.h:94:71: note: expected 'struct skcipher_request *' but argument is of type 'struct aead_request *'
    static inline void skcipher_request_complete(struct skcipher_request *req, int err)
                                                 ~~~~~~~~~~~~~~~~~~~~~~~~~^~~
   cc1: some warnings being treated as errors


vim +/skcipher_request_complete +1387 drivers/crypto/sa2ul.c

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
