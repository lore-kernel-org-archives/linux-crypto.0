Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A453711CAF;
	Thu, 13 Feb 2025 04:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739422239; cv=none; b=SyMnUnNzRX9dicpBGi8QkCBj4Ip8XpltbZff9pCrNyscNtaZItWPJhRH23hVHX9YNuSIJNtgUr1tU9pGIVhwgHC++/4osT+1GYVUtlMLIxQWg4oq36nbk9pJHE+K0SEtCEWd083EjoZEaUUnPa1X+7m+unW0YOPjjewzlAcSLHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739422239; c=relaxed/simple;
	bh=t/XlHmnF4em2TJtn+6iu7CW23sHU9iPmvCmeRbckjSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJ2vjivT7OLMPGgwCFMJfyt6GmZLZ1zwwc6+3Mq9kvPubOBov2u1xyCEVdoEcXWaJM1C2hnzwoGem8equc98UqzexKyM5ac4GQkZ1b/nl02g4vWTFWZ2VnuUIgR96r3vHOOqH9qJRdewbl38OzKURrlDTjrEsIMuQk/12B54Chw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TT17ZfW4; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TT17ZfW4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739422235; x=1770958235;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t/XlHmnF4em2TJtn+6iu7CW23sHU9iPmvCmeRbckjSQ=;
  b=TT17ZfW4Lki7OK2LBb8OEm/xn3vbw0hQ7PKASCsh98TteSDTE/L0n7j6
   bZ6fxS7bEuTtR8PQ7049v3ZiiKOO1hAIoNVXC1512hfmq3X3SkLQzx8em
   VXV6Qp4rFpJft8T7qoEWxp6piEmDKFz/nsoxYbhnrV7iA8kuCO/al/i57
   cGPl2sAKb9rjSLkJkN6SSFOariM04fUOe20UNU36NsyI/DuobJrOosKPD
   zAiMTih59VPN1n2kOMqyy8Sw8JKbc8hdNNq+NpBFvhwvl9uFp4IPD61FH
   NwFPTKSTmXOyvfy6CoEpWLHDaQhFxzSba6ynkVsfF0yME0IeGgjIJqyn2
   Q==;
X-CSE-ConnectionGUID: Ng8JBD5bRXqsi8P8LAb+5w==
X-CSE-MsgGUID: zPmzKgQfRDmYSWE4/Ob02g==
X-IronPort-AV: E=McAfee;i="6700,10204,11343"; a="44040952"
X-IronPort-AV: E=Sophos;i="6.13,281,1732608000"; 
   d="scan'208";a="44040952"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2025 20:50:34 -0800
X-CSE-ConnectionGUID: 26WSsSaMQJuJsUnWv50m/A==
X-CSE-MsgGUID: /9MYp2giS+aUJMG84VU6Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="113512256"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 12 Feb 2025 20:50:32 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tiRBF-0016Ww-2Q;
	Thu, 13 Feb 2025 04:50:29 +0000
Date: Thu, 13 Feb 2025 12:49:37 +0800
From: kernel test robot <lkp@intel.com>
To: Akhil R <akhilrajeev@nvidia.com>, herbert@gondor.apana.org.au,
	davem@davemloft.net, thierry.reding@gmail.com, jonathanh@nvidia.com,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Akhil R <akhilrajeev@nvidia.com>
Subject: Re: [PATCH v2 06/10] crypto: tegra: Fix HASH intermediate result
 handling
Message-ID: <202502131216.RDQlFu1f-lkp@intel.com>
References: <20250211171713.65770-7-akhilrajeev@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211171713.65770-7-akhilrajeev@nvidia.com>

Hi Akhil,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-crypto-2.6/master]
[also build test WARNING on herbert-cryptodev-2.6/master linus/master v6.14-rc2 next-20250212]
[cannot apply to tegra/for-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Akhil-R/crypto-tegra-Use-separate-buffer-for-setkey/20250212-012434
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
patch link:    https://lore.kernel.org/r/20250211171713.65770-7-akhilrajeev%40nvidia.com
patch subject: [PATCH v2 06/10] crypto: tegra: Fix HASH intermediate result handling
config: arm-randconfig-004-20250213 (https://download.01.org/0day-ci/archive/20250213/202502131216.RDQlFu1f-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250213/202502131216.RDQlFu1f-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202502131216.RDQlFu1f-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/device.h:15,
                    from include/linux/dma-mapping.h:5,
                    from drivers/crypto/tegra/tegra-se-hash.c:8:
   drivers/crypto/tegra/tegra-se-hash.c: In function 'tegra_sha_prep_cmd':
>> drivers/crypto/tegra/tegra-se-hash.c:342:26: warning: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'ssize_t' {aka 'int'} [-Wformat=]
     342 |         dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
         |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/dev_printk.h:139:49: note: in definition of macro 'dev_no_printk'
     139 |                         _dev_printk(level, dev, fmt, ##__VA_ARGS__);    \
         |                                                 ^~~
   include/linux/dev_printk.h:171:40: note: in expansion of macro 'dev_fmt'
     171 |         dev_no_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__)
         |                                        ^~~~~~~
   drivers/crypto/tegra/tegra-se-hash.c:342:9: note: in expansion of macro 'dev_dbg'
     342 |         dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
         |         ^~~~~~~
   drivers/crypto/tegra/tegra-se-hash.c:342:59: note: format string is defined here
     342 |         dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
         |                                                         ~~^
         |                                                           |
         |                                                           long unsigned int
         |                                                         %u
   drivers/crypto/tegra/tegra-se-hash.c: In function 'tegra_sha_digest':
   drivers/crypto/tegra/tegra-se-hash.c:701:13: warning: unused variable 'ret' [-Wunused-variable]
     701 |         int ret;
         |             ^~~


vim +342 drivers/crypto/tegra/tegra-se-hash.c

   265	
   266	static int tegra_sha_prep_cmd(struct tegra_sha_ctx *ctx, u32 *cpuvaddr,
   267				      struct tegra_sha_reqctx *rctx)
   268	{
   269		struct tegra_se *se = ctx->se;
   270		u64 msg_len, msg_left;
   271		int i = 0;
   272	
   273		msg_len = rctx->total_len * 8;
   274		msg_left = rctx->datbuf.size * 8;
   275	
   276		/*
   277		 * If IN_ADDR_HI_0.SZ > SHA_MSG_LEFT_[0-3] to the HASH engine,
   278		 * HW treats it as the last buffer and process the data.
   279		 * Therefore, add an extra byte to msg_left if it is not the
   280		 * last buffer.
   281		 */
   282		if (rctx->task & SHA_UPDATE) {
   283			msg_left += 8;
   284			msg_len += 8;
   285		}
   286	
   287		cpuvaddr[i++] = host1x_opcode_setpayload(8);
   288		cpuvaddr[i++] = se_host1x_opcode_incr_w(SE_SHA_MSG_LENGTH);
   289		cpuvaddr[i++] = lower_32_bits(msg_len);
   290		cpuvaddr[i++] = upper_32_bits(msg_len);
   291		cpuvaddr[i++] = 0;
   292		cpuvaddr[i++] = 0;
   293		cpuvaddr[i++] = lower_32_bits(msg_left);
   294		cpuvaddr[i++] = upper_32_bits(msg_left);
   295		cpuvaddr[i++] = 0;
   296		cpuvaddr[i++] = 0;
   297		cpuvaddr[i++] = host1x_opcode_setpayload(2);
   298		cpuvaddr[i++] = se_host1x_opcode_incr_w(SE_SHA_CFG);
   299		cpuvaddr[i++] = rctx->config;
   300	
   301		if (rctx->task & SHA_FIRST) {
   302			cpuvaddr[i++] = SE_SHA_TASK_HASH_INIT;
   303			rctx->task &= ~SHA_FIRST;
   304		} else {
   305			/*
   306			 * If it isn't the first task, program the HASH_RESULT register
   307			 * with the intermediate result from the previous task
   308			 */
   309			i += tegra_se_insert_hash_result(ctx, cpuvaddr + i, rctx);
   310		}
   311	
   312		cpuvaddr[i++] = host1x_opcode_setpayload(4);
   313		cpuvaddr[i++] = se_host1x_opcode_incr_w(SE_SHA_IN_ADDR);
   314		cpuvaddr[i++] = rctx->datbuf.addr;
   315		cpuvaddr[i++] = (u32)(SE_ADDR_HI_MSB(upper_32_bits(rctx->datbuf.addr)) |
   316					SE_ADDR_HI_SZ(rctx->datbuf.size));
   317	
   318		if (rctx->task & SHA_UPDATE) {
   319			cpuvaddr[i++] = rctx->intr_res.addr;
   320			cpuvaddr[i++] = (u32)(SE_ADDR_HI_MSB(upper_32_bits(rctx->intr_res.addr)) |
   321						SE_ADDR_HI_SZ(rctx->intr_res.size));
   322		} else {
   323			cpuvaddr[i++] = rctx->digest.addr;
   324			cpuvaddr[i++] = (u32)(SE_ADDR_HI_MSB(upper_32_bits(rctx->digest.addr)) |
   325						SE_ADDR_HI_SZ(rctx->digest.size));
   326		}
   327	
   328		if (rctx->key_id) {
   329			cpuvaddr[i++] = host1x_opcode_setpayload(1);
   330			cpuvaddr[i++] = se_host1x_opcode_nonincr_w(SE_SHA_CRYPTO_CFG);
   331			cpuvaddr[i++] = SE_AES_KEY_INDEX(rctx->key_id);
   332		}
   333	
   334		cpuvaddr[i++] = host1x_opcode_setpayload(1);
   335		cpuvaddr[i++] = se_host1x_opcode_nonincr_w(SE_SHA_OPERATION);
   336		cpuvaddr[i++] = SE_SHA_OP_WRSTALL | SE_SHA_OP_START |
   337				SE_SHA_OP_LASTBUF;
   338		cpuvaddr[i++] = se_host1x_opcode_nonincr(host1x_uclass_incr_syncpt_r(), 1);
   339		cpuvaddr[i++] = host1x_uclass_incr_syncpt_cond_f(1) |
   340				host1x_uclass_incr_syncpt_indx_f(se->syncpt_id);
   341	
 > 342		dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
   343			msg_len, msg_left, rctx->datbuf.size, rctx->config);
   344	
   345		return i;
   346	}
   347	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
