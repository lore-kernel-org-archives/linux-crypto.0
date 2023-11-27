Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T/p+GXX3"
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46DFAB8;
	Mon, 27 Nov 2023 03:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701085227; x=1732621227;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9qGOS8dFXPRD0ZSL6WNDIfGJ6sGAi1aGsitrqBVicww=;
  b=T/p+GXX3OGnMu+cGfOfCiGQEFJspgBZhlINt7ZsiOFBcRiI6C5Offbvi
   cMlq1COvjLfjIrypCg110H+b4V2+KUjM61F3TpF7v9+yb2tkR9ukOnLlJ
   khdBzvoTR/j+YTAhSM/yizhpkj8IV3m8aTNPZm4OUFH4DCWm6Z8lSSF3d
   UwgXCHEMsbhMZepd3LD+xrsXUJhfATToGngDNfYpZnDlXWdsUpbeFqgGL
   +2d2441W6FJvOfO0Fu7d3LNvkA+k5HjnY89ZEfAyDqm+3s8380aPShRKJ
   EAV0eT8auXiwRhbkYE2Aqi2LH4SyCnQXXty7GtxWtv2FVcBUjFvyU3QAW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10906"; a="5934486"
X-IronPort-AV: E=Sophos;i="6.04,230,1695711600"; 
   d="scan'208";a="5934486"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 03:40:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10906"; a="802615770"
X-IronPort-AV: E=Sophos;i="6.04,230,1695711600"; 
   d="scan'208";a="802615770"
Received: from lkp-server01.sh.intel.com (HELO d584ee6ebdcc) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 27 Nov 2023 03:40:15 -0800
Received: from kbuild by d584ee6ebdcc with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r7ZyH-0006DU-28;
	Mon, 27 Nov 2023 11:40:13 +0000
Date: Mon, 27 Nov 2023 19:39:50 +0800
From: kernel test robot <lkp@intel.com>
To: Srujana Challa <schalla@marvell.com>, herbert@gondor.apana.org.au,
	davem@davemloft.net, kuba@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	bbrezillon@kernel.org, arno@natisbad.org, pabeni@redhat.com,
	edumazet@google.com, ndabilpuram@marvell.com, sgoutham@marvell.com,
	jerinj@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
	lcherian@marvell.com, gakula@marvell.com, schalla@marvell.com
Subject: Re: [PATCH net-next 02/10] crypto: octeontx2: add SGv2 support for
 CN10KB or CN10KA B0
Message-ID: <202311271719.io1crN0R-lkp@intel.com>
References: <20231124125047.2329693-3-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231124125047.2329693-3-schalla@marvell.com>

Hi Srujana,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Srujana-Challa/crypto-octeontx2-remove-CPT-block-reset/20231124-210255
base:   net-next/main
patch link:    https://lore.kernel.org/r/20231124125047.2329693-3-schalla%40marvell.com
patch subject: [PATCH net-next 02/10] crypto: octeontx2: add SGv2 support for CN10KB or CN10KA B0
config: sparc-randconfig-r113-20231127 (https://download.01.org/0day-ci/archive/20231127/202311271719.io1crN0R-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 13.2.0
reproduce: (https://download.01.org/0day-ci/archive/20231127/202311271719.io1crN0R-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311271719.io1crN0R-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   drivers/crypto/marvell/octeontx2/otx2_cptvf_main.c: note: in included file (through drivers/crypto/marvell/octeontx2/otx2_cptlf.h, drivers/crypto/marvell/octeontx2/otx2_cptvf.h):
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:301:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] len0 @@     got unsigned short [usertype] size @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:301:30: sparse:     expected restricted __be16 [usertype] len0
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:301:30: sparse:     got unsigned short [usertype] size
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:302:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] len1 @@     got unsigned short [usertype] size @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:302:30: sparse:     expected restricted __be16 [usertype] len1
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:302:30: sparse:     got unsigned short [usertype] size
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:303:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] len2 @@     got unsigned short [usertype] size @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:303:30: sparse:     expected restricted __be16 [usertype] len2
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:303:30: sparse:     got unsigned short [usertype] size
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:304:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] ptr0 @@     got unsigned long long [usertype] dma_addr @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:304:30: sparse:     expected restricted __be64 [usertype] ptr0
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:304:30: sparse:     got unsigned long long [usertype] dma_addr
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:305:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] ptr1 @@     got unsigned long long [usertype] dma_addr @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:305:30: sparse:     expected restricted __be64 [usertype] ptr1
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:305:30: sparse:     got unsigned long long [usertype] dma_addr
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:306:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] ptr2 @@     got unsigned long long [usertype] dma_addr @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:306:30: sparse:     expected restricted __be64 [usertype] ptr2
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:306:30: sparse:     got unsigned long long [usertype] dma_addr
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:307:36: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] valid_segs @@     got int @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:307:36: sparse:     expected restricted __be16 [usertype] valid_segs
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:307:36: sparse:     got int
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:312:28: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] valid_segs @@     got int [assigned] components @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:312:28: sparse:     expected restricted __be16 [usertype] valid_segs
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:312:28: sparse:     got int [assigned] components
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:315:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] len1 @@     got unsigned short [usertype] size @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:315:30: sparse:     expected restricted __be16 [usertype] len1
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:315:30: sparse:     got unsigned short [usertype] size
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:316:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] ptr1 @@     got unsigned long long [usertype] dma_addr @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:316:30: sparse:     expected restricted __be64 [usertype] ptr1
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:316:30: sparse:     got unsigned long long [usertype] dma_addr
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:319:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] len0 @@     got unsigned short [usertype] size @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:319:30: sparse:     expected restricted __be16 [usertype] len0
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:319:30: sparse:     got unsigned short [usertype] size
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:320:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] ptr0 @@     got unsigned long long [usertype] dma_addr @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:320:30: sparse:     expected restricted __be64 [usertype] ptr0
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:320:30: sparse:     got unsigned long long [usertype] dma_addr
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:301:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] len0 @@     got unsigned short [usertype] size @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:301:30: sparse:     expected restricted __be16 [usertype] len0
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:301:30: sparse:     got unsigned short [usertype] size
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:302:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] len1 @@     got unsigned short [usertype] size @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:302:30: sparse:     expected restricted __be16 [usertype] len1
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:302:30: sparse:     got unsigned short [usertype] size
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:303:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] len2 @@     got unsigned short [usertype] size @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:303:30: sparse:     expected restricted __be16 [usertype] len2
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:303:30: sparse:     got unsigned short [usertype] size
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:304:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] ptr0 @@     got unsigned long long [usertype] dma_addr @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:304:30: sparse:     expected restricted __be64 [usertype] ptr0
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:304:30: sparse:     got unsigned long long [usertype] dma_addr
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:305:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] ptr1 @@     got unsigned long long [usertype] dma_addr @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:305:30: sparse:     expected restricted __be64 [usertype] ptr1
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:305:30: sparse:     got unsigned long long [usertype] dma_addr
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:306:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] ptr2 @@     got unsigned long long [usertype] dma_addr @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:306:30: sparse:     expected restricted __be64 [usertype] ptr2
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:306:30: sparse:     got unsigned long long [usertype] dma_addr
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:307:36: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] valid_segs @@     got int @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:307:36: sparse:     expected restricted __be16 [usertype] valid_segs
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:307:36: sparse:     got int
>> drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:312:28: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] valid_segs @@     got int [assigned] components @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:312:28: sparse:     expected restricted __be16 [usertype] valid_segs
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:312:28: sparse:     got int [assigned] components
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:315:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] len1 @@     got unsigned short [usertype] size @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:315:30: sparse:     expected restricted __be16 [usertype] len1
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:315:30: sparse:     got unsigned short [usertype] size
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:316:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] ptr1 @@     got unsigned long long [usertype] dma_addr @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:316:30: sparse:     expected restricted __be64 [usertype] ptr1
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:316:30: sparse:     got unsigned long long [usertype] dma_addr
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:319:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be16 [usertype] len0 @@     got unsigned short [usertype] size @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:319:30: sparse:     expected restricted __be16 [usertype] len0
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:319:30: sparse:     got unsigned short [usertype] size
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:320:30: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __be64 [usertype] ptr0 @@     got unsigned long long [usertype] dma_addr @@
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:320:30: sparse:     expected restricted __be64 [usertype] ptr0
   drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h:320:30: sparse:     got unsigned long long [usertype] dma_addr

vim +301 drivers/crypto/marvell/octeontx2/otx2_cpt_reqmgr.h

   272	
   273	static inline int sgv2io_components_setup(struct pci_dev *pdev,
   274						  struct otx2_cpt_buf_ptr *list,
   275						  int buf_count, u8 *buffer)
   276	{
   277		struct cn10kb_cpt_sglist_component *sg_ptr = NULL;
   278		int ret = 0, i, j;
   279		int components;
   280	
   281		if (unlikely(!list)) {
   282			dev_err(&pdev->dev, "Input list pointer is NULL\n");
   283			return -EFAULT;
   284		}
   285	
   286		for (i = 0; i < buf_count; i++) {
   287			if (unlikely(!list[i].vptr))
   288				continue;
   289			list[i].dma_addr = dma_map_single(&pdev->dev, list[i].vptr,
   290							  list[i].size,
   291							  DMA_BIDIRECTIONAL);
   292			if (unlikely(dma_mapping_error(&pdev->dev, list[i].dma_addr))) {
   293				dev_err(&pdev->dev, "Dma mapping failed\n");
   294				ret = -EIO;
   295				goto sg_cleanup;
   296			}
   297		}
   298		components = buf_count / 3;
   299		sg_ptr = (struct cn10kb_cpt_sglist_component *)buffer;
   300		for (i = 0; i < components; i++) {
 > 301			sg_ptr->len0 = list[i * 3 + 0].size;
 > 302			sg_ptr->len1 = list[i * 3 + 1].size;
 > 303			sg_ptr->len2 = list[i * 3 + 2].size;
 > 304			sg_ptr->ptr0 = list[i * 3 + 0].dma_addr;
 > 305			sg_ptr->ptr1 = list[i * 3 + 1].dma_addr;
 > 306			sg_ptr->ptr2 = list[i * 3 + 2].dma_addr;
 > 307			sg_ptr->valid_segs = 3;
   308			sg_ptr++;
   309		}
   310		components = buf_count % 3;
   311	
 > 312		sg_ptr->valid_segs = components;
   313		switch (components) {
   314		case 2:
   315			sg_ptr->len1 = list[i * 3 + 1].size;
   316			sg_ptr->ptr1 = list[i * 3 + 1].dma_addr;
   317			fallthrough;
   318		case 1:
   319			sg_ptr->len0 = list[i * 3 + 0].size;
   320			sg_ptr->ptr0 = list[i * 3 + 0].dma_addr;
   321			break;
   322		default:
   323			break;
   324		}
   325		return ret;
   326	
   327	sg_cleanup:
   328		for (j = 0; j < i; j++) {
   329			if (list[j].dma_addr) {
   330				dma_unmap_single(&pdev->dev, list[j].dma_addr,
   331						 list[j].size, DMA_BIDIRECTIONAL);
   332			}
   333	
   334			list[j].dma_addr = 0;
   335		}
   336		return ret;
   337	}
   338	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
