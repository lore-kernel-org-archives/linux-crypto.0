Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CE223C50E;
	Wed,  7 May 2025 07:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746604746; cv=none; b=XMG8YB1VA8jqrBCxhcr+FwzbjM96gqk4kv4JiLp/bz+elbKk+IKzbMiZ2SXGBNVq9+TgOqCGW5mFpnD/S0IHZiabeWcaCR+GfQFUQ5l5ClRUsnBCNOXBkRdTz7uPMbMVKd/TAyPEJ4N14NsDJtnUKn+ZUQjBxJc+f0625koaimk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746604746; c=relaxed/simple;
	bh=e/9srmYivr2j7snT9tUmZWrhhMUFEDe4ILwhbNTCrl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CKa2Amz7ufOCrwOTUW5Q74xboOcx7lmqyI4Qp88+6usM+21XwalifPxR4H/8nk/3HNhNwT5NHI5z6XtsVOegHi4wwwDSKmTohKVSwFmeV3sI41+n//4nNTaauzxwlilZRLArSEA1HzC6KcJVOd/iArW7NW6v3DscDsc1caHGKN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bOAGQg3a; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bOAGQg3a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746604745; x=1778140745;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e/9srmYivr2j7snT9tUmZWrhhMUFEDe4ILwhbNTCrl8=;
  b=bOAGQg3aZ+LUKqVuR+4Qo6vcwVrR3aw6bQaIQZUuiwv9WNco2aQyuW2Q
   7O6bLVQw0jmumYjMPgTlqCMjsXelQ4pn394fdGhbQly8CPJNLWy1n5GxK
   X13+efxKbZ5GW5co7jdgQm/5VqOcZgahFjgLoyl4Rz4IXkJ5HqzLz4flL
   Z1uSvNTs3NjOqpoqfKq0gSEXzxjw1ax6yEFuhsy68z3Z2V+HA+fVrErsi
   Tf0kuCs1gh38BtYKyByLKqG9i4JdaGVG+V5mos/wrn5rFHBz6vRtHdco+
   wZbcFhppl84XIXy5GUgNfs2jLPDW1Hzc9HG8XEmeX5wKid9Xw93PWqYtW
   w==;
X-CSE-ConnectionGUID: 79w0Z3TuQLOoCju7LK9/JQ==
X-CSE-MsgGUID: ex5vPLfhSsSvE9zGyHLXWQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="65727580"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="65727580"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 00:59:04 -0700
X-CSE-ConnectionGUID: ftQEJui7QoesuiniqJ53Tw==
X-CSE-MsgGUID: eJ37biI+Rmu6BzW/07IiLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="140619565"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 07 May 2025 00:58:57 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uCZg6-0007N1-2A;
	Wed, 07 May 2025 07:58:54 +0000
Date: Wed, 7 May 2025 15:58:18 +0800
From: kernel test robot <lkp@intel.com>
To: Tanmay Jagdale <tanmay@marvell.com>, bbrezillon@kernel.org,
	arno@natisbad.org, schalla@marvell.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, sgoutham@marvell.com, lcherian@marvell.com,
	gakula@marvell.com, jerinj@marvell.com, hkelam@marvell.com,
	sbhatta@marvell.com, andrew+netdev@lunn.ch, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, bbhushan2@marvell.com,
	bhelgaas@google.com, pstanner@redhat.com,
	gregkh@linuxfoundation.org, peterz@infradead.org, linux@treblig.org,
	krzysztof.kozlowski@linaro.org, giovanni.cabiddu@intel.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, rkannoth@marvell.com, sumang@marvell.com,
	gcherian@marvell.com, Rakesh Kudurumalla <rkudurumalla@marvell.com>
Subject: Re: [net-next PATCH v1 06/15] octeontx2-af: Add support for CPT
 second pass
Message-ID: <202505071511.neU9Siwr-lkp@intel.com>
References: <20250502132005.611698-7-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-7-tanmay@marvell.com>

Hi Tanmay,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Tanmay-Jagdale/crypto-octeontx2-Share-engine-group-info-with-AF-driver/20250502-213203
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250502132005.611698-7-tanmay%40marvell.com
patch subject: [net-next PATCH v1 06/15] octeontx2-af: Add support for CPT second pass
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20250507/202505071511.neU9Siwr-lkp@intel.com/config)
compiler: clang version 20.1.2 (https://github.com/llvm/llvm-project 58df0ef89dd64126512e4ee27b4ac3fd8ddf6247)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250507/202505071511.neU9Siwr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505071511.neU9Siwr-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:6723:6: warning: variable 'rq_mask' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
    6723 |         if (req->ipsec_cfg1.rq_mask_enable) {
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:6729:41: note: uninitialized use occurs here
    6729 |         configure_rq_mask(rvu, blkaddr, nixlf, rq_mask,
         |                                                ^~~~~~~
   drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:6723:2: note: remove the 'if' if its condition is always true
    6723 |         if (req->ipsec_cfg1.rq_mask_enable) {
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c:6710:13: note: initialize the variable 'rq_mask' to silence this warning
    6710 |         int rq_mask, err;
         |                    ^
         |                     = 0
   1 warning generated.


vim +6723 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c

  6702	
  6703	int rvu_mbox_handler_nix_lf_inline_rq_cfg(struct rvu *rvu,
  6704						  struct nix_rq_cpt_field_mask_cfg_req *req,
  6705						  struct msg_rsp *rsp)
  6706	{
  6707		struct rvu_hwinfo *hw = rvu->hw;
  6708		struct nix_hw *nix_hw;
  6709		int blkaddr, nixlf;
  6710		int rq_mask, err;
  6711	
  6712		err = nix_get_nixlf(rvu, req->hdr.pcifunc, &nixlf, &blkaddr);
  6713		if (err)
  6714			return err;
  6715	
  6716		nix_hw = get_nix_hw(rvu->hw, blkaddr);
  6717		if (!nix_hw)
  6718			return NIX_AF_ERR_INVALID_NIXBLK;
  6719	
  6720		if (!hw->cap.second_cpt_pass)
  6721			return NIX_AF_ERR_INVALID_NIXBLK;
  6722	
> 6723		if (req->ipsec_cfg1.rq_mask_enable) {

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
