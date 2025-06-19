Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F92F22B598;
	Thu, 19 Jun 2025 14:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750343889; cv=none; b=esdbbZ6gs6yn/G2PA7Z2PLQ3HhZ9CcBHLdtbUkNe6Mixqbz2qa54ym8FXJvP1bwRqxpvVqOPf3XCbSEIa4G7PaLpDDvcIoB7WGdGKSM90Rmx+T5lhzjMMa+20YN+G+H72Mg/mgtjopMAz0O+XpSfsWikShT7HjlMQeVCjojqMg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750343889; c=relaxed/simple;
	bh=X9vVkMtiXPrn4Hu8FElJ+z6PvCWbhe9Vge+jEseQxMc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g8FdMTtRvkRr00lCR4J6P2cZiitc5KW0pgVoup+QFUXep6fVRzMDkM/e3/t+HYg4Co+QVh+ZCK9zunY4bg21T4B/uyib9KCGe5UY1WIp9Beeyw6cdkX0YQqBZUocTh3hB4nrkFAjmRJb+IoobK5GEypCXZEbV/EIEPWHwa87ybY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IJxZtbfH; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IJxZtbfH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750343887; x=1781879887;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=X9vVkMtiXPrn4Hu8FElJ+z6PvCWbhe9Vge+jEseQxMc=;
  b=IJxZtbfHT56eeMUgroPPxhtvgGrwThsALVu8qeU3SDs97lBnk3infR85
   992qt87X1tRsnqVJek8evzt6sZLyjWFslnXOnPzJzyWgtOZnrxQEdv35r
   pBMGh4PuQiEvqP/pR1ZUHiQtismWNjOJUG1TXnyLmS0fShYf1xUAsmzhC
   BtvuBhFajBuGzlRxBFN0xAu+C3L8MupNFry1EmvKino0B2+gjGuX+C8nq
   t6MDns7x3B2qNYKIycAp+v0ECFHFRZyMV9FfNvBkh7XrMKmQIKzQC9459
   ozKd/IPWwF3+N70JDVbDsHGYi7XLPKFRGSTpzWrSaGJEdA8+rGGwwGn3M
   w==;
X-CSE-ConnectionGUID: CD0MMLNSTICslleDQhuzHQ==
X-CSE-MsgGUID: f0CDxhbsRu+Y47XHahaajA==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="56399109"
X-IronPort-AV: E=Sophos;i="6.16,248,1744095600"; 
   d="scan'208";a="56399109"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 07:38:07 -0700
X-CSE-ConnectionGUID: AGQuVQKNQg6CKFX5oshRpA==
X-CSE-MsgGUID: dObaJX+/QkiD7AJ4llXM6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,248,1744095600"; 
   d="scan'208";a="150886370"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 19 Jun 2025 07:38:04 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uSGOv-000KpW-35;
	Thu, 19 Jun 2025 14:38:01 +0000
Date: Thu, 19 Jun 2025 22:37:59 +0800
From: kernel test robot <lkp@intel.com>
To: Tanmay Jagdale <tanmay@marvell.com>, davem@davemloft.net,
	leon@kernel.org, horms@kernel.org, sgoutham@marvell.com,
	bbhushan2@marvell.com, herbert@gondor.apana.org.au
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org, Kiran Kumar K <kirankumark@marvell.com>,
	Nithin Dabilpuram <ndabilpuram@marvell.com>,
	Tanmay Jagdale <tanmay@marvell.com>
Subject: Re: [PATCH net-next v2 06/14] octeontx2-af: Add support for SPI to
 SA index translation
Message-ID: <202506192219.aw9iy7xb-lkp@intel.com>
References: <20250618113020.130888-7-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618113020.130888-7-tanmay@marvell.com>

Hi Tanmay,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Tanmay-Jagdale/crypto-octeontx2-Share-engine-group-info-with-AF-driver/20250618-193646
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250618113020.130888-7-tanmay%40marvell.com
patch subject: [PATCH net-next v2 06/14] octeontx2-af: Add support for SPI to SA index translation
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20250619/202506192219.aw9iy7xb-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250619/202506192219.aw9iy7xb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506192219.aw9iy7xb-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c: In function 'nix_spi_to_sa_index_check_duplicate':
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c:25:21: error: implicit declaration of function 'FIELD_GET' [-Wimplicit-function-declaration]
      25 |         spi_index = FIELD_GET(NIX_AF_SPI_TO_SA_SPI_INDEX_MASK, wkey);
         |                     ^~~~~~~~~
   drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c: In function 'nix_spi_to_sa_index_table_update':
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c:53:16: error: implicit declaration of function 'FIELD_PREP' [-Wimplicit-function-declaration]
      53 |         wkey = FIELD_PREP(NIX_AF_SPI_TO_SA_SPI_INDEX_MASK, req->spi_index);
         |                ^~~~~~~~~~


vim +/FIELD_GET +25 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix_spi.c

     9	
    10	static bool
    11	nix_spi_to_sa_index_check_duplicate(struct rvu *rvu,
    12					    struct nix_spi_to_sa_add_req *req,
    13					    struct nix_spi_to_sa_add_rsp *rsp,
    14					    int blkaddr, int16_t index, u8 way,
    15					    bool *is_valid, int lfidx)
    16	{
    17		u32 spi_index;
    18		u16 match_id;
    19		bool valid;
    20		u64 wkey;
    21		u8 lfid;
    22	
    23		wkey = rvu_read64(rvu, blkaddr, NIX_AF_SPI_TO_SA_KEYX_WAYX(index, way));
    24	
  > 25		spi_index = FIELD_GET(NIX_AF_SPI_TO_SA_SPI_INDEX_MASK, wkey);
    26		match_id = FIELD_GET(NIX_AF_SPI_TO_SA_MATCH_ID_MASK, wkey);
    27		lfid = FIELD_GET(NIX_AF_SPI_TO_SA_LFID_MASK, wkey);
    28		valid = FIELD_GET(NIX_AF_SPI_TO_SA_KEYX_WAYX_VALID, wkey);
    29	
    30		*is_valid = valid;
    31		if (!valid)
    32			return 0;
    33	
    34		if (req->spi_index == spi_index && req->match_id == match_id &&
    35		    lfidx == lfid) {
    36			rsp->hash_index = index;
    37			rsp->way = way;
    38			rsp->is_duplicate = true;
    39			return 1;
    40		}
    41		return 0;
    42	}
    43	
    44	static void  nix_spi_to_sa_index_table_update(struct rvu *rvu,
    45						      struct nix_spi_to_sa_add_req *req,
    46						      struct nix_spi_to_sa_add_rsp *rsp,
    47						      int blkaddr, int16_t index,
    48						      u8 way, int lfidx)
    49	{
    50		u64 wvalue;
    51		u64 wkey;
    52	
  > 53		wkey = FIELD_PREP(NIX_AF_SPI_TO_SA_SPI_INDEX_MASK, req->spi_index);
    54		wkey |= FIELD_PREP(NIX_AF_SPI_TO_SA_MATCH_ID_MASK, req->match_id);
    55		wkey |= FIELD_PREP(NIX_AF_SPI_TO_SA_LFID_MASK, lfidx);
    56		wkey |= FIELD_PREP(NIX_AF_SPI_TO_SA_KEYX_WAYX_VALID, req->valid);
    57	
    58		rvu_write64(rvu, blkaddr, NIX_AF_SPI_TO_SA_KEYX_WAYX(index, way),
    59			    wkey);
    60		wvalue = (req->sa_index & 0xFFFFFFFF);
    61		rvu_write64(rvu, blkaddr, NIX_AF_SPI_TO_SA_VALUEX_WAYX(index, way),
    62			    wvalue);
    63		rsp->hash_index = index;
    64		rsp->way = way;
    65		rsp->is_duplicate = false;
    66	}
    67	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
