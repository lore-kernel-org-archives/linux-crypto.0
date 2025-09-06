Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83300F510;
	Sat,  6 Sep 2025 17:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757178192; cv=none; b=iL0IBzoil7hg0NdP15Qpxt2IL753SVNCZ++9eePCdA1tjNn/UH65n5LU4mTbzbywqZfHXOZMZcOkHjPFBbof2ESYELOAOacbhKTQMHTGJ2bNuHe3EOVrCJGCKTeGziAVOhVBh6KyCFrkAAgbkSSYzbMVaIMgJFjrut7h0yyqwKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757178192; c=relaxed/simple;
	bh=cnjlGov3rmmTlFwWRM+VBLOvYtGyRStbSa0iflkMYbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gU0s+qHDRsIiZ9DQPedvMNd32ATKzHSY2K2FaVxRoPVWlUOVGvX65SFApAlfxzPcz8CO8hxUufCXLnHAfVe+JVGgKAksX9yjElvXpYkApZVBKAHaNA/nj1mK3NkV99p8wtROSPxAvit4CeNfUXypgTVJNDM+zNncbdP2pLNYdwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bE8RFOSa; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bE8RFOSa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757178191; x=1788714191;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cnjlGov3rmmTlFwWRM+VBLOvYtGyRStbSa0iflkMYbw=;
  b=bE8RFOSaiLXw+o8VcCgGnQOhpPX7FUIj94vlhc/CXT8mhN7iQBRUOHAO
   chrkQsUukkZZZm0Ce6AVZGUhjOwSaD1BeCEIEtz5Td2BWJDW/mUl5n0xa
   +PNAn39x7La73F7Orfxp00IyMJ4G1fQlbTIrBVWkrt9+rx643YJnU0kSm
   qQyF+1Lf/qAveVbcSJADb0Kn7OdHXjhdzDvvtOY21NHyGPy8Y0ntsmZDn
   BqgEinu8mXN6U7smlwqElG3VE8lV5F8jiZ4lt17MGZUiy1KZjICdSkCVT
   L9Os4b+Sku48jHrXiSRRV1SeJXNkVt2DNEET80rgQjH1/1uWi+nVuXVM9
   A==;
X-CSE-ConnectionGUID: WXGRfs73SzKdpuZ0fuFw2g==
X-CSE-MsgGUID: STZbIbBVT9CCvuYlkP3yWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11545"; a="59570734"
X-IronPort-AV: E=Sophos;i="6.18,244,1751266800"; 
   d="scan'208";a="59570734"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2025 10:03:10 -0700
X-CSE-ConnectionGUID: OiElRqG8QaWDfvCJl6qlBg==
X-CSE-MsgGUID: lPKYn7a5S7+lonh5AjrDhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,244,1751266800"; 
   d="scan'208";a="172337462"
Received: from lkp-server01.sh.intel.com (HELO 114d98da2b6c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 06 Sep 2025 10:03:06 -0700
Received: from kbuild by 114d98da2b6c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uuwJb-0001fL-1L;
	Sat, 06 Sep 2025 17:03:03 +0000
Date: Sun, 7 Sep 2025 01:02:19 +0800
From: kernel test robot <lkp@intel.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	netdev@vger.kernel.org, Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>,
	Kavitha Malarvizhi <k-malarvizhi@ti.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] crypto: ti: Add support for AES-GCM in DTHEv2 driver
Message-ID: <202509070015.xKJCeXKj-lkp@intel.com>
References: <20250905133504.2348972-7-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905133504.2348972-7-t-pratham@ti.com>

Hi Pratham,

kernel test robot noticed the following build warnings:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on next-20250905]
[cannot apply to herbert-crypto-2.6/master linus/master v6.17-rc4]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/T-Pratham/crypto-ti-Add-support-for-AES-XTS-in-DTHEv2-driver/20250905-214245
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
patch link:    https://lore.kernel.org/r/20250905133504.2348972-7-t-pratham%40ti.com
patch subject: [PATCH 3/4] crypto: ti: Add support for AES-GCM in DTHEv2 driver
config: arm64-allmodconfig (https://download.01.org/0day-ci/archive/20250907/202509070015.xKJCeXKj-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250907/202509070015.xKJCeXKj-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509070015.xKJCeXKj-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/crypto/ti/dthev2-aes.c:787:7: warning: variable 'unpadded_cryptlen' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     787 |                 if (!dst) {
         |                     ^~~~
   drivers/crypto/ti/dthev2-aes.c:927:6: note: uninitialized use occurs here
     927 |         if (unpadded_cryptlen % AES_BLOCK_SIZE)
         |             ^~~~~~~~~~~~~~~~~
   drivers/crypto/ti/dthev2-aes.c:787:3: note: remove the 'if' if its condition is always false
     787 |                 if (!dst) {
         |                 ^~~~~~~~~~~
     788 |                         ret = -ENOMEM;
         |                         ~~~~~~~~~~~~~~
     789 |                         goto aead_prep_dst_err;
         |                         ~~~~~~~~~~~~~~~~~~~~~~~
     790 |                 }
         |                 ~
   drivers/crypto/ti/dthev2-aes.c:748:32: note: initialize the variable 'unpadded_cryptlen' to silence this warning
     748 |         unsigned int unpadded_cryptlen;
         |                                       ^
         |                                        = 0
   1 warning generated.


vim +787 drivers/crypto/ti/dthev2-aes.c

   737	
   738	static int dthe_aead_run(struct crypto_engine *engine, void *areq)
   739	{
   740		struct aead_request *req = container_of(areq, struct aead_request, base);
   741		struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
   742		struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
   743		struct dthe_data *dev_data = dthe_get_dev(ctx);
   744	
   745		unsigned int cryptlen = req->cryptlen;
   746		unsigned int assoclen = req->assoclen;
   747		unsigned int authsize = ctx->authsize;
   748		unsigned int unpadded_cryptlen;
   749		struct scatterlist *src = req->src;
   750		struct scatterlist *dst = req->dst;
   751	
   752		int src_nents;
   753		int dst_nents;
   754		int src_mapped_nents, dst_mapped_nents;
   755	
   756		enum dma_data_direction src_dir, dst_dir;
   757	
   758		struct device *tx_dev, *rx_dev;
   759		struct dma_async_tx_descriptor *desc_in, *desc_out;
   760	
   761		int ret;
   762	
   763		void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
   764	
   765		u32 aes_irqenable_val = readl_relaxed(aes_base_reg + DTHE_P_AES_IRQENABLE);
   766		u32 aes_sysconfig_val = readl_relaxed(aes_base_reg + DTHE_P_AES_SYSCONFIG);
   767	
   768		aes_sysconfig_val |= DTHE_AES_SYSCONFIG_DMA_DATA_IN_OUT_EN;
   769		writel_relaxed(aes_sysconfig_val, aes_base_reg + DTHE_P_AES_SYSCONFIG);
   770	
   771		aes_irqenable_val |= DTHE_AES_IRQENABLE_EN_ALL;
   772		writel_relaxed(aes_irqenable_val, aes_base_reg + DTHE_P_AES_IRQENABLE);
   773	
   774		/* In decryption, the last authsize bytes are the TAG */
   775		if (!rctx->enc)
   776			cryptlen -= authsize;
   777	
   778		// Prep src and dst scatterlists
   779		src = dthe_aead_prep_src(req->src, req->assoclen, cryptlen);
   780		if (!src) {
   781			ret = -ENOMEM;
   782			goto aead_err;
   783		}
   784	
   785		if (cryptlen != 0) {
   786			dst = dthe_aead_prep_dst(req->dst, req->assoclen, cryptlen);
 > 787			if (!dst) {
   788				ret = -ENOMEM;
   789				goto aead_prep_dst_err;
   790			}
   791		}
   792	
   793		unpadded_cryptlen = cryptlen;
   794	
   795		if (req->assoclen % AES_BLOCK_SIZE)
   796			assoclen += AES_BLOCK_SIZE - (req->assoclen % AES_BLOCK_SIZE);
   797		if (cryptlen % AES_BLOCK_SIZE)
   798			cryptlen += AES_BLOCK_SIZE - (cryptlen % AES_BLOCK_SIZE);
   799	
   800		src_nents = sg_nents_for_len(src, assoclen + cryptlen);
   801		dst_nents = sg_nents_for_len(dst, cryptlen);
   802	
   803		// Prep finished
   804	
   805		src_dir = DMA_TO_DEVICE;
   806		dst_dir = DMA_FROM_DEVICE;
   807	
   808		tx_dev = dmaengine_get_dma_device(dev_data->dma_aes_tx);
   809		rx_dev = dmaengine_get_dma_device(dev_data->dma_aes_rx);
   810	
   811		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
   812		if (src_mapped_nents == 0) {
   813			ret = -EINVAL;
   814			goto aead_dma_map_src_err;
   815		}
   816	
   817		desc_out = dmaengine_prep_slave_sg(dev_data->dma_aes_tx, src, src_mapped_nents,
   818						   DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
   819		if (!desc_out) {
   820			ret = -EINVAL;
   821			goto aead_dma_prep_src_err;
   822		}
   823	
   824		desc_out->callback = dthe_aead_dma_in_callback;
   825		desc_out->callback_param = req;
   826	
   827		if (cryptlen != 0) {
   828			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
   829			if (dst_mapped_nents == 0) {
   830				ret = -EINVAL;
   831				goto aead_dma_prep_src_err;
   832			}
   833	
   834			desc_in = dmaengine_prep_slave_sg(dev_data->dma_aes_rx, dst,
   835							  dst_mapped_nents, DMA_DEV_TO_MEM,
   836							  DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
   837			if (!desc_in) {
   838				ret = -EINVAL;
   839				goto aead_dma_prep_dst_err;
   840			}
   841		}
   842	
   843		init_completion(&rctx->aes_compl);
   844	
   845		/*
   846		 * HACK: There is an unknown hw issue where if the previous operation had alen = 0 and
   847		 * plen != 0, the current operation's tag calculation is incorrect in the case where
   848		 * plen = 0 and alen != 0 currently. This is a workaround for now which somwhow works;
   849		 * by resetting the context by writing a 1 to the C_LENGTH_0 and AUTH_LENGTH registers.
   850		 */
   851		if (cryptlen == 0) {
   852			writel_relaxed(1, aes_base_reg + DTHE_P_AES_C_LENGTH_0);
   853			writel_relaxed(1, aes_base_reg + DTHE_P_AES_AUTH_LENGTH);
   854		}
   855	
   856		u32 iv_in[AES_IV_WORDS];
   857	
   858		if (req->iv) {
   859			memcpy(iv_in, req->iv, GCM_AES_IV_SIZE);
   860		} else {
   861			iv_in[0] = 0;
   862			iv_in[1] = 0;
   863			iv_in[2] = 0;
   864		}
   865		iv_in[3] = 0x01000000;
   866	
   867		// Clear key2 to reset previous GHASH intermediate data
   868		for (int i = 0; i < AES_KEYSIZE_256 / sizeof(u32); ++i)
   869			writel_relaxed(0, aes_base_reg + DTHE_P_AES_KEY2_6 + DTHE_REG_SIZE * i);
   870	
   871		dthe_aes_set_ctrl_key(ctx, rctx, iv_in);
   872	
   873		writel_relaxed(lower_32_bits(unpadded_cryptlen), aes_base_reg + DTHE_P_AES_C_LENGTH_0);
   874		writel_relaxed(upper_32_bits(unpadded_cryptlen), aes_base_reg + DTHE_P_AES_C_LENGTH_1);
   875		writel_relaxed(req->assoclen, aes_base_reg + DTHE_P_AES_AUTH_LENGTH);
   876	
   877		if (cryptlen != 0)
   878			dmaengine_submit(desc_in);
   879		dmaengine_submit(desc_out);
   880	
   881		if (cryptlen != 0)
   882			dma_async_issue_pending(dev_data->dma_aes_rx);
   883		dma_async_issue_pending(dev_data->dma_aes_tx);
   884	
   885		// Need to do a timeout to ensure mutex gets unlocked if DMA callback fails for any reason
   886		ret = wait_for_completion_timeout(&rctx->aes_compl, msecs_to_jiffies(DTHE_DMA_TIMEOUT_MS));
   887		if (!ret) {
   888			ret = -ETIMEDOUT;
   889			if (cryptlen != 0)
   890				dmaengine_terminate_sync(dev_data->dma_aes_rx);
   891			dmaengine_terminate_sync(dev_data->dma_aes_tx);
   892	
   893			for (int i = 0; i < AES_BLOCK_SIZE / sizeof(int); ++i)
   894				readl_relaxed(aes_base_reg + DTHE_P_AES_DATA_IN_OUT + DTHE_REG_SIZE * i);
   895		} else {
   896			ret = 0;
   897		}
   898	
   899		if (cryptlen != 0)
   900			dma_sync_sg_for_cpu(rx_dev, dst, dst_nents, dst_dir);
   901		if (rctx->enc) {
   902			dthe_aead_enc_get_tag(req);
   903			ret = 0;
   904		} else {
   905			ret = dthe_aead_dec_verify_tag(req);
   906		}
   907	
   908	aead_dma_prep_dst_err:
   909		if (cryptlen != 0)
   910			dma_unmap_sg(rx_dev, dst, dst_nents, dst_dir);
   911	aead_dma_prep_src_err:
   912		dma_unmap_sg(tx_dev, src, src_nents, src_dir);
   913	
   914	aead_dma_map_src_err:
   915		if (unpadded_cryptlen % AES_BLOCK_SIZE && cryptlen != 0)
   916			kfree(sg_virt(&dst[dst_nents - 1]));
   917	
   918		if (cryptlen != 0)
   919			kfree(dst);
   920	
   921	aead_prep_dst_err:
   922		if (req->assoclen % AES_BLOCK_SIZE) {
   923			int assoc_nents = sg_nents_for_len(src, req->assoclen);
   924	
   925			kfree(sg_virt(&src[assoc_nents]));
   926		}
   927		if (unpadded_cryptlen % AES_BLOCK_SIZE)
   928			kfree(sg_virt(&src[src_nents - 1]));
   929	
   930		kfree(src);
   931	
   932	aead_err:
   933		local_bh_disable();
   934		crypto_finalize_aead_request(dev_data->engine, req, ret);
   935		local_bh_enable();
   936		return ret;
   937	}
   938	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
