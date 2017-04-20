From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 5/9] staging: ccree: add AEAD support
Date: Fri, 21 Apr 2017 02:57:53 +0800
Message-ID: <201704210221.n1RK8DTY%fengguang.wu@intel.com>
References: <1492693983-8175-6-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gilad.benyossef-5wv7dgnIgG8@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Stuart Yoder <stuart.yoder-5wv7dgnIgG8@public.gmane.org>,
        Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>
To: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492693983-8175-6-git-send-email-gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Hi Gilad,

[auto build test WARNING on linus/master]
[also build test WARNING on v4.11-rc7]
[cannot apply to staging/staging-testing next-20170420]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Gilad-Ben-Yossef/staging-ccree-add-Arm-TrustZone-CryptoCell-REE-driver/20170420-222023


coccinelle warnings: (new ones prefixed by >>)

>> drivers/staging/ccree/ssi_buffer_mgr.c:758:2-4: ERROR: test of a variable/field address

vim +758 drivers/staging/ccree/ssi_buffer_mgr.c

   742		
   743			if (areq_ctx->gcm_iv_inc2_dma_addr != 0) {
   744				SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->gcm_iv_inc2_dma_addr);
   745				dma_unmap_single(dev, areq_ctx->gcm_iv_inc2_dma_addr, 
   746					AES_BLOCK_SIZE, DMA_TO_DEVICE);
   747			}
   748		}
   749	#endif
   750	
   751		if (areq_ctx->ccm_hdr_size != ccm_header_size_null) {
   752			if (areq_ctx->ccm_iv0_dma_addr != 0) {
   753				SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->ccm_iv0_dma_addr);
   754				dma_unmap_single(dev, areq_ctx->ccm_iv0_dma_addr, 
   755					AES_BLOCK_SIZE, DMA_TO_DEVICE);
   756			}
   757	
 > 758			if (&areq_ctx->ccm_adata_sg != NULL)
   759				dma_unmap_sg(dev, &areq_ctx->ccm_adata_sg,
   760					1, DMA_TO_DEVICE);
   761		}
   762		if (areq_ctx->gen_ctx.iv_dma_addr != 0) {
   763			SSI_RESTORE_DMA_ADDR_TO_48BIT(areq_ctx->gen_ctx.iv_dma_addr);
   764			dma_unmap_single(dev, areq_ctx->gen_ctx.iv_dma_addr,
   765					 hw_iv_size, DMA_BIDIRECTIONAL);
   766		}

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
