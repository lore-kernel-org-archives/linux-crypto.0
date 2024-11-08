Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ADF1AA1EB;
	Fri,  8 Nov 2024 19:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731092962; cv=none; b=Y2WDLCAX8A67uUx/NKdNCdW5Cd8clIgm4WSwa/lvi8LdhJ4iiuKcIgepgfu67kbR8EnifpQiXaIZXf3t1ib0zsraBWerZS/HvtFp1AF1CmoFK4vEyg7bM6P9uN0B8v1a9w4MpY34FWE+bxoyRQ66QQdkimQNm47+5ksqLyM/HjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731092962; c=relaxed/simple;
	bh=R+CGtLg7J7cZFkaK6iEbxTqVB/sl271eFJkHFX8PQlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IusGCqn759Hu1FkFnVgdqIzJYz0hDUaPlH+3E5Ih80JHIAgm1Og+rdWsPJUbdt72lRDa/2lN+XUck+oRvlAckdDFVl5SY/ZaNS27xIK6ST1Z18cDUIrPd5qnczr5CWO+yr+j4pqEDuJjplR8BxXpiKdYZeYmi492uGFlVcCbjpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KebCbmGh; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KebCbmGh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731092961; x=1762628961;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R+CGtLg7J7cZFkaK6iEbxTqVB/sl271eFJkHFX8PQlI=;
  b=KebCbmGh19EEBAcHD3JOc6i0JRSGd/9MQXY2t7pITZRqSUFd9h0ei+IG
   CLPYXI18NAXQfL4VIvxZaNccch7aQR7IIxBYIacwxd3DAHQ2l7GLSB6g0
   /8c4Ie9SfB7/qLyOjyzFofdZZCPu5mwhxOsBoCfOxr2MJmeeSZl1gz26W
   BUzBOOhaj6kSJ8u9oFhnQxJEe0/YVF+maFvWfj7gUgETrmQEqXKRk0F/i
   /maBcl5xSCFsZrgpZt/XgJuj9NVD4N+314ulRA7L4yEPVz2jbTIqgha04
   ZqQ6nj9ozbhFZWoBLTaBh8d6GOEELYDJwoRWlcl95p1cXIX8AtsDDtQcW
   w==;
X-CSE-ConnectionGUID: DMqkhL3GT7monTCuWSujyg==
X-CSE-MsgGUID: Es9/yF12SSuq3cIG1SFRIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="42086783"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="42086783"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2024 11:09:20 -0800
X-CSE-ConnectionGUID: XD1n0tMySAq3Ut+3KlDDLQ==
X-CSE-MsgGUID: YGwNEXImR2OgQ2epJ63MLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,138,1728975600"; 
   d="scan'208";a="90231501"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 08 Nov 2024 11:09:15 -0800
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t9UM5-000ria-11;
	Fri, 08 Nov 2024 19:09:13 +0000
Date: Sat, 9 Nov 2024 03:08:22 +0800
From: kernel test robot <lkp@intel.com>
To: Alexey Romanov <avromanov@salutedevices.com>, neil.armstrong@linaro.org,
	clabbe@baylibre.com, herbert@gondor.apana.org.au,
	davem@davemloft.net, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, khilman@baylibre.com, jbrunet@baylibre.com,
	martin.blumenstingl@googlemail.com, vadim.fedorenko@linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kernel@salutedevices.com,
	Alexey Romanov <avromanov@salutedevices.com>
Subject: Re: [PATCH v10 09/22] crypto: amlogic - Process more than MAXDESCS
 descriptors
Message-ID: <202411090235.a7vEgZQo-lkp@intel.com>
References: <20241108102907.1788584-10-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241108102907.1788584-10-avromanov@salutedevices.com>

Hi Alexey,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on next-20241108]
[cannot apply to herbert-crypto-2.6/master robh/for-next linus/master v6.12-rc6]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Alexey-Romanov/crypto-amlogic-Don-t-hardcode-IRQ-count/20241108-183503
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20241108102907.1788584-10-avromanov%40salutedevices.com
patch subject: [PATCH v10 09/22] crypto: amlogic - Process more than MAXDESCS descriptors
config: x86_64-buildonly-randconfig-002-20241109 (https://download.01.org/0day-ci/archive/20241109/202411090235.a7vEgZQo-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241109/202411090235.a7vEgZQo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411090235.a7vEgZQo-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from drivers/crypto/amlogic/amlogic-gxl-cipher.c:14:
   In file included from include/crypto/scatterwalk.h:16:
   In file included from include/linux/highmem.h:8:
   In file included from include/linux/cacheflush.h:5:
   In file included from arch/x86/include/asm/cacheflush.h:5:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
>> drivers/crypto/amlogic/amlogic-gxl-cipher.c:235:13: warning: variable 'new_iv_phys' set but not used [-Wunused-but-set-variable]
     235 |         dma_addr_t new_iv_phys;
         |                    ^
   2 warnings generated.


vim +/new_iv_phys +235 drivers/crypto/amlogic/amlogic-gxl-cipher.c

   220	
   221	static int meson_kick_hardware(struct cipher_ctx *ctx)
   222	{
   223		struct meson_cipher_req_ctx *rctx = skcipher_request_ctx(ctx->areq);
   224		struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(ctx->areq);
   225		struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
   226		struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
   227		struct meson_alg_template *algt = container_of(alg,
   228							       struct meson_alg_template,
   229							       alg.skcipher.base);
   230		struct meson_dev *mc = op->mc;
   231		unsigned int ivsize = crypto_skcipher_ivsize(tfm);
   232		unsigned int blockmode = algt->blockmode;
   233		enum dma_data_direction new_iv_dir;
   234		struct scatterlist *sg_head;
 > 235		dma_addr_t new_iv_phys;
   236		void *new_iv;
   237		int err;
   238	
   239		if (blockmode == DESC_OPMODE_CBC) {
   240			struct scatterlist *sg_current;
   241			unsigned int offset;
   242	
   243			if (rctx->op_dir == MESON_ENCRYPT) {
   244				sg_current = ctx->dst_sg;
   245				sg_head = ctx->areq->dst;
   246				offset = ctx->dst_offset;
   247				new_iv_dir = DMA_FROM_DEVICE;
   248			} else {
   249				sg_current = ctx->src_sg;
   250				sg_head = ctx->areq->src;
   251				offset = ctx->src_offset;
   252				new_iv_dir = DMA_TO_DEVICE;
   253			}
   254	
   255			if (ctx->areq->src == ctx->areq->dst)
   256				new_iv_dir = DMA_BIDIRECTIONAL;
   257	
   258			offset -= ivsize;
   259			new_iv = sg_virt(sg_current) + offset;
   260			new_iv_phys = sg_dma_address(sg_current) + offset;
   261		}
   262	
   263		if (blockmode == DESC_OPMODE_CBC &&
   264		    rctx->op_dir == MESON_DECRYPT) {
   265			dma_sync_sg_for_cpu(mc->dev, sg_head,
   266					    sg_nents(sg_head), new_iv_dir);
   267			memcpy(ctx->areq->iv, new_iv, ivsize);
   268		}
   269	
   270		reinit_completion(&mc->chanlist[rctx->flow].complete);
   271		meson_dma_start(mc, rctx->flow);
   272		err = wait_for_completion_interruptible_timeout(&mc->chanlist[rctx->flow].complete,
   273								msecs_to_jiffies(500));
   274		if (err == 0) {
   275			dev_err(mc->dev, "DMA timeout for flow %d\n", rctx->flow);
   276			return -EINVAL;
   277		} else if (err < 0) {
   278			dev_err(mc->dev, "Waiting for DMA completion is failed (%d)\n", err);
   279			return err;
   280		}
   281	
   282		if (blockmode == DESC_OPMODE_CBC &&
   283		    rctx->op_dir == MESON_ENCRYPT) {
   284			dma_sync_sg_for_cpu(mc->dev, sg_head,
   285					    sg_nents(sg_head), new_iv_dir);
   286			memcpy(ctx->areq->iv, new_iv, ivsize);
   287		}
   288	
   289		ctx->tloffset = 0;
   290	
   291		return 0;
   292	}
   293	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
