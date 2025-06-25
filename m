Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5D6269B08;
	Wed, 25 Jun 2025 14:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750862333; cv=none; b=dxwfFKIk/Ak3KNALj76TfngUJkTOWKyq9tgUPq7TuaQMUhtmV2qIS3D2/XWVC3pVSJ4a7iwvUbexQa8fkthxGYbxfMl9LEQvOlnYudR9/1orPQpA6DzsP8V9ANo5PeedJ3Q4lQqxiWUiodOukBBHNE4GI5NFAkH87V4Ouivlvjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750862333; c=relaxed/simple;
	bh=cTwRaJlK/PTXSKZazS8/fTQEDEkqeMZtGBeXz+9mOtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dh4k8OMgkjlIk6fG7JJXzjkiE+0fUau6LfaXKJoOjleynenoQ1dEhc0v5wnE8ftuOAFdOpXYu4Z97INvx6BmSNMjvZR/LParxmthyOHXQgGWao+OWg1BPzWuIRjBPUutEFyAIX78bVMdFrCCgPZRjOiZCk72LC4IJKZRAJDVd4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iD33ZQAu; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iD33ZQAu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750862332; x=1782398332;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cTwRaJlK/PTXSKZazS8/fTQEDEkqeMZtGBeXz+9mOtc=;
  b=iD33ZQAuRVn/AnTbhP+n3LU+gxPlD2BALaiojISSKH5aFBVMcNlf6zOo
   qzBBQB7q1/CGY6Tqw/udcteT9xqEdCk2m/77C+oCjx4DWty9ZAohUBQiF
   cZYAR9ni4c29Gts0XCfHNo/T15KIo53m2mzJb8IT+U33Ad0kE5kBoa7El
   H4XF3lFuRYBe6mZouna8RaR2SLyTuNrXOKLv/9873/J7xfXb2Umy8mMsb
   qCvgJVFP5LXYYLIRU/kT7QHrNFnFIk7RfC3zhVqM/lunvge1nukjHSPgj
   OING2BX3mjC9LkL/Tqa3nW6gRuY1FlnsASXn9zE4JuF7gPVD3AzH3omLS
   A==;
X-CSE-ConnectionGUID: lpr8RLpGR76uk92bhPDMHA==
X-CSE-MsgGUID: XxduBImcQjelNv1jZSIaPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53069232"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="53069232"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 07:38:51 -0700
X-CSE-ConnectionGUID: m0xc58rKQkCtoM3knyyeYw==
X-CSE-MsgGUID: xxOJKLpBTGiN45cJn8/SnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="156799955"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 25 Jun 2025 07:38:48 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uURGv-000TCU-1r;
	Wed, 25 Jun 2025 14:38:45 +0000
Date: Wed, 25 Jun 2025 22:38:14 +0800
From: kernel test robot <lkp@intel.com>
To: Tanmay Jagdale <tanmay@marvell.com>, davem@davemloft.net,
	leon@kernel.org, horms@kernel.org, sgoutham@marvell.com,
	bbhushan2@marvell.com, herbert@gondor.apana.org.au
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	Tanmay Jagdale <tanmay@marvell.com>
Subject: Re: [PATCH net-next v2 14/14] octeontx2-pf: ipsec: Add XFRM state
 and policy hooks for inbound flows
Message-ID: <202506252237.x9hiFnbB-lkp@intel.com>
References: <20250618113020.130888-15-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618113020.130888-15-tanmay@marvell.com>

Hi Tanmay,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Tanmay-Jagdale/crypto-octeontx2-Share-engine-group-info-with-AF-driver/20250618-193646
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250618113020.130888-15-tanmay%40marvell.com
patch subject: [PATCH net-next v2 14/14] octeontx2-pf: ipsec: Add XFRM state and policy hooks for inbound flows
config: um-allmodconfig (https://download.01.org/0day-ci/archive/20250625/202506252237.x9hiFnbB-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250625/202506252237.x9hiFnbB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506252237.x9hiFnbB-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:7:
   In file included from include/net/xfrm.h:9:
   In file included from include/linux/skbuff.h:17:
   In file included from include/linux/bvec.h:10:
   In file included from include/linux/highmem.h:12:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:12:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:1175:55: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
    1175 |         return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
         |                                                   ~~~~~~~~~~ ^
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:924:8: warning: variable 'ptr' set but not used [-Wunused-but-set-variable]
     924 |         void *ptr;
         |               ^
>> drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:1206:2: error: call to undeclared function 'dmb'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1206 |         dmb(sy);
         |         ^
>> drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:1206:6: error: use of undeclared identifier 'sy'
    1206 |         dmb(sy);
         |             ^
   2 warnings and 2 errors generated.


vim +/dmb +1206 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c

  1156	
  1157	static int cn10k_inb_write_sa(struct otx2_nic *pf,
  1158				      struct xfrm_state *x,
  1159				      struct cn10k_inb_sw_ctx_info *inb_ctx_info)
  1160	{
  1161		dma_addr_t res_iova, dptr_iova, sa_iova;
  1162		struct cn10k_rx_sa_s *sa_dptr, *sa_cptr;
  1163		struct cpt_inst_s inst;
  1164		u32 sa_size, off;
  1165		struct cpt_res_s *res;
  1166		u64 reg_val;
  1167		int ret;
  1168	
  1169		res = dma_alloc_coherent(pf->dev, sizeof(struct cpt_res_s),
  1170					 &res_iova, GFP_ATOMIC);
  1171		if (!res)
  1172			return -ENOMEM;
  1173	
  1174		sa_cptr = inb_ctx_info->sa_entry;
  1175		sa_iova = inb_ctx_info->sa_iova;
  1176		sa_size = sizeof(struct cn10k_rx_sa_s);
  1177	
  1178		sa_dptr = dma_alloc_coherent(pf->dev, sa_size, &dptr_iova, GFP_ATOMIC);
  1179		if (!sa_dptr) {
  1180			dma_free_coherent(pf->dev, sizeof(struct cpt_res_s), res,
  1181					  res_iova);
  1182			return -ENOMEM;
  1183		}
  1184	
  1185		for (off = 0; off < (sa_size / 8); off++)
  1186			*((u64 *)sa_dptr + off) = cpu_to_be64(*((u64 *)sa_cptr + off));
  1187	
  1188		memset(&inst, 0, sizeof(struct cpt_inst_s));
  1189	
  1190		res->compcode = 0;
  1191		inst.res_addr = res_iova;
  1192		inst.dptr = (u64)dptr_iova;
  1193		inst.param2 = sa_size >> 3;
  1194		inst.dlen = sa_size;
  1195		inst.opcode_major = CN10K_IPSEC_MAJOR_OP_WRITE_SA;
  1196		inst.opcode_minor = CN10K_IPSEC_MINOR_OP_WRITE_SA;
  1197		inst.cptr = sa_iova;
  1198		inst.ctx_val = 1;
  1199		inst.egrp = CN10K_DEF_CPT_IPSEC_EGRP;
  1200	
  1201		/* Re-use Outbound CPT LF to install Ingress SAs as well because
  1202		 * the driver does not own the ingress CPT LF.
  1203		 */
  1204		pf->ipsec.io_addr = (__force u64)otx2_get_regaddr(pf, CN10K_CPT_LF_NQX(0));
  1205		cn10k_cpt_inst_flush(pf, &inst, sizeof(struct cpt_inst_s));
> 1206		dmb(sy);
  1207	
  1208		ret = cn10k_wait_for_cpt_respose(pf, res);
  1209		if (ret)
  1210			goto out;
  1211	
  1212		/* Trigger CTX flush to write dirty data back to DRAM */
  1213		reg_val = FIELD_PREP(GENMASK_ULL(45, 0), sa_iova >> 7);
  1214		otx2_write64(pf, CN10K_CPT_LF_CTX_FLUSH, reg_val);
  1215	
  1216	out:
  1217		dma_free_coherent(pf->dev, sa_size, sa_dptr, dptr_iova);
  1218		dma_free_coherent(pf->dev, sizeof(struct cpt_res_s), res, res_iova);
  1219		return ret;
  1220	}
  1221	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
