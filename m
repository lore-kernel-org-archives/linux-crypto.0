Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FC721147D;
	Wed,  7 May 2025 06:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746600203; cv=none; b=rq0Z/0DMmymwbuLvEUNa96vgRR1c2Id1Kp48kPjr2KeqLHkIyj7kvThp3607MTaU4ITVFjb4xaA2006CdPL75zZfSOKnVSQM4/uVIkZZNwIpTRACcHCFfE88v3mWlXv8Ip/RkmiJyQw7xHfEk/FjFq9wFQ2LHqJYdpSnZw/44Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746600203; c=relaxed/simple;
	bh=i0apkUUnzBZ5ueSXEpjrnTFVG/7j8XNnBPzQ/uTBttg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JTEcqmRtNDg8fl0WwsuS+1IbOV7xb5j2ad1Wxn4dCLfLmU9/Et/IBybcS9OlnUr3+IBKPSfI17gfSnKtuRQp4nFlr9YBvE5DaJk50fwe0BaCtq5jd9yPVpl98JLxO7ArDfG40gWCqmhQMarGTQQ5mSV9706zXTmEUEnWjmyrSeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H2Ugb77G; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H2Ugb77G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746600202; x=1778136202;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i0apkUUnzBZ5ueSXEpjrnTFVG/7j8XNnBPzQ/uTBttg=;
  b=H2Ugb77GUdJoq5+ThWMzHrxwHz+CNnbmGyw4gridg7DELPQxuySK7y1g
   wPrUOFzyKshu3UTmGwUG5mrDtKOW2P89XEr8xEUW6vPdrPsaEl4EWTzw3
   Wa03cUTAvhh01oE6iqYwWoU1/0fMivmYBTxQ7bHvV6QTbBY+YitUbyU/u
   RaAdJn7waNiKDXCL8nLsex3CkKzo0BliI8MMlRccZYcN8aI/Yhb00uGc9
   fH1P/5ZPppYFBjO/atVUdoBGx09BhBWGna2KNFjzTnnNTnbjtPj/9N2aA
   bUqJVHyR3TmXdfr/egCMjh5I22JblFTAyC06bWRWa2ceQui3uuxA6Op5I
   w==;
X-CSE-ConnectionGUID: s/zRT+v2Rd6+sgoB579grQ==
X-CSE-MsgGUID: 7rAFV1HZR7qrLcogz+d36Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="59299861"
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="59299861"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2025 23:43:21 -0700
X-CSE-ConnectionGUID: 6wjCPT+hTC+MlSK7liLbww==
X-CSE-MsgGUID: 1aOjtuWkSG+iPf1O27Oerw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,268,1739865600"; 
   d="scan'208";a="141040774"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 06 May 2025 23:43:14 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uCYUq-0007Dh-0P;
	Wed, 07 May 2025 06:43:12 +0000
Date: Wed, 7 May 2025 14:42:50 +0800
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
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	rkannoth@marvell.com, sumang@marvell.com, gcherian@marvell.com,
	Tanmay Jagdale <tanmay@marvell.com>
Subject: Re: [net-next PATCH v1 15/15] octeontx2-pf: ipsec: Add XFRM state
 and policy hooks for inbound flows
Message-ID: <202505071416.T1HY7g1G-lkp@intel.com>
References: <20250502132005.611698-16-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-16-tanmay@marvell.com>

Hi Tanmay,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Tanmay-Jagdale/crypto-octeontx2-Share-engine-group-info-with-AF-driver/20250502-213203
base:   net-next/main
patch link:    https://lore.kernel.org/r/20250502132005.611698-16-tanmay%40marvell.com
patch subject: [net-next PATCH v1 15/15] octeontx2-pf: ipsec: Add XFRM state and policy hooks for inbound flows
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20250507/202505071416.T1HY7g1G-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250507/202505071416.T1HY7g1G-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505071416.T1HY7g1G-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c: In function 'cn10k_ipsec_npa_refill_inb_ipsecq':
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:868:27: warning: variable 'qset' set but not used [-Wunused-but-set-variable]
     868 |         struct otx2_qset *qset = NULL;
         |                           ^~~~
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c: In function 'cn10k_inb_cpt_init':
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:932:15: warning: variable 'ptr' set but not used [-Wunused-but-set-variable]
     932 |         void *ptr;
         |               ^~~
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c: In function 'cn10k_inb_write_sa':
>> drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:1214:9: error: implicit declaration of function 'dmb'; did you mean 'rmb'? [-Wimplicit-function-declaration]
    1214 |         dmb(sy);
         |         ^~~
         |         rmb
>> drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:1214:13: error: 'sy' undeclared (first use in this function); did you mean 's8'?
    1214 |         dmb(sy);
         |             ^~
         |             s8
   drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c:1214:13: note: each undeclared identifier is reported only once for each function it appears in


vim +1214 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c

  1164	
  1165	static int cn10k_inb_write_sa(struct otx2_nic *pf,
  1166				      struct xfrm_state *x,
  1167				      struct cn10k_inb_sw_ctx_info *inb_ctx_info)
  1168	{
  1169		dma_addr_t res_iova, dptr_iova, sa_iova;
  1170		struct cn10k_rx_sa_s *sa_dptr, *sa_cptr;
  1171		struct cpt_inst_s inst;
  1172		u32 sa_size, off;
  1173		struct cpt_res_s *res;
  1174		u64 reg_val;
  1175		int ret;
  1176	
  1177		res = dma_alloc_coherent(pf->dev, sizeof(struct cpt_res_s),
  1178					 &res_iova, GFP_ATOMIC);
  1179		if (!res)
  1180			return -ENOMEM;
  1181	
  1182		sa_cptr = inb_ctx_info->sa_entry;
  1183		sa_iova = inb_ctx_info->sa_iova;
  1184		sa_size = sizeof(struct cn10k_rx_sa_s);
  1185	
  1186		sa_dptr = dma_alloc_coherent(pf->dev, sa_size, &dptr_iova, GFP_ATOMIC);
  1187		if (!sa_dptr) {
  1188			dma_free_coherent(pf->dev, sizeof(struct cpt_res_s), res,
  1189					  res_iova);
  1190			return -ENOMEM;
  1191		}
  1192	
  1193		for (off = 0; off < (sa_size / 8); off++)
  1194			*((u64 *)sa_dptr + off) = cpu_to_be64(*((u64 *)sa_cptr + off));
  1195	
  1196		memset(&inst, 0, sizeof(struct cpt_inst_s));
  1197	
  1198		res->compcode = 0;
  1199		inst.res_addr = res_iova;
  1200		inst.dptr = (u64)dptr_iova;
  1201		inst.param2 = sa_size >> 3;
  1202		inst.dlen = sa_size;
  1203		inst.opcode_major = CN10K_IPSEC_MAJOR_OP_WRITE_SA;
  1204		inst.opcode_minor = CN10K_IPSEC_MINOR_OP_WRITE_SA;
  1205		inst.cptr = sa_iova;
  1206		inst.ctx_val = 1;
  1207		inst.egrp = CN10K_DEF_CPT_IPSEC_EGRP;
  1208	
  1209		/* Re-use Outbound CPT LF to install Ingress SAs as well because
  1210		 * the driver does not own the ingress CPT LF.
  1211		 */
  1212		pf->ipsec.io_addr = (__force u64)otx2_get_regaddr(pf, CN10K_CPT_LF_NQX(0));
  1213		cn10k_cpt_inst_flush(pf, &inst, sizeof(struct cpt_inst_s));
> 1214		dmb(sy);
  1215	
  1216		ret = cn10k_wait_for_cpt_respose(pf, res);
  1217		if (ret)
  1218			goto out;
  1219	
  1220		/* Trigger CTX flush to write dirty data back to DRAM */
  1221		reg_val = FIELD_PREP(GENMASK_ULL(45, 0), sa_iova >> 7);
  1222		otx2_write64(pf, CN10K_CPT_LF_CTX_FLUSH, reg_val);
  1223	
  1224	out:
  1225		dma_free_coherent(pf->dev, sa_size, sa_dptr, dptr_iova);
  1226		dma_free_coherent(pf->dev, sizeof(struct cpt_res_s), res, res_iova);
  1227		return ret;
  1228	}
  1229	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
