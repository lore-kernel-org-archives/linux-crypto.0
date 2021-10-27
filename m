Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F2D7C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 04:47:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D21660F9B
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Oct 2021 04:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbhJ0EuQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Oct 2021 00:50:16 -0400
Received: from mga18.intel.com ([134.134.136.126]:45286 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232365AbhJ0EuP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Oct 2021 00:50:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="216985105"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="gz'50?scan'50,208,50";a="216985105"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 21:47:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="gz'50?scan'50,208,50";a="664836261"
Received: from lkp-server01.sh.intel.com (HELO 33c68f307df1) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 26 Oct 2021 21:47:47 -0700
Received: from kbuild by 33c68f307df1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mfaqo-0000Ex-FL; Wed, 27 Oct 2021 04:47:46 +0000
Date:   Wed, 27 Oct 2021 12:46:49 +0800
From:   kernel test robot <lkp@intel.com>
To:     Richard van Schagen <vschagen@icloud.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        matthias.bgg@gmail.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        linux-crypto@vger.kernel.org,
        Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH 2/2] crypto: mtk-eip93 - Add Mediatek EIP-93 crypto engine
Message-ID: <202110271203.zvzQ7MTI-lkp@intel.com>
References: <20211025094725.2282336-3-vschagen@icloud.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20211025094725.2282336-3-vschagen@icloud.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Richard,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on herbert-cryptodev-2.6/master]
[also build test WARNING on herbert-crypto-2.6/master v5.15-rc7 next-20211026]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Richard-van-Schagen/Enable-the-Mediatek-EIP-93-crypto-engine/20211025-175520
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
config: hexagon-randconfig-r032-20211027 (attached as .config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project 5db7568a6a1fcb408eb8988abdaff2a225a8eb72)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/837eaffbc258885acfac24a243519105d3ea21ca
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Richard-van-Schagen/Enable-the-Mediatek-EIP-93-crypto-engine/20211025-175520
        git checkout 837eaffbc258885acfac24a243519105d3ea21ca
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 ARCH=hexagon 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/crypto/mtk-eip93/eip93-main.c:131:6: warning: variable 'err' set but not used [-Wunused-but-set-variable]
           int err = 0;
               ^
>> drivers/crypto/mtk-eip93/eip93-main.c:128:19: warning: variable 'complete' set but not used [-Wunused-but-set-variable]
           bool last_entry, complete;
                            ^
>> drivers/crypto/mtk-eip93/eip93-main.c:126:31: warning: variable 'async' set but not used [-Wunused-but-set-variable]
           struct crypto_async_request *async = NULL;
                                        ^
>> drivers/crypto/mtk-eip93/eip93-main.c:124:6: warning: no previous prototype for function 'mtk_handle_result_descriptor' [-Wmissing-prototypes]
   void mtk_handle_result_descriptor(struct mtk_device *mtk)
        ^
   drivers/crypto/mtk-eip93/eip93-main.c:124:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void mtk_handle_result_descriptor(struct mtk_device *mtk)
   ^
   static 
>> drivers/crypto/mtk-eip93/eip93-main.c:221:6: warning: no previous prototype for function 'mtk_initialize' [-Wmissing-prototypes]
   void mtk_initialize(struct mtk_device *mtk)
        ^
   drivers/crypto/mtk-eip93/eip93-main.c:221:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void mtk_initialize(struct mtk_device *mtk)
   ^
   static 
   drivers/crypto/mtk-eip93/eip93-main.c:438:53: error: array has incomplete element type 'const struct of_device_id'
   static const struct of_device_id mtk_crypto_of_match[] = {
                                                       ^
   include/linux/device/driver.h:105:15: note: forward declaration of 'struct of_device_id'
           const struct of_device_id       *of_match_table;
                        ^
   5 warnings and 1 error generated.


vim +/err +131 drivers/crypto/mtk-eip93/eip93-main.c

   123	
 > 124	void mtk_handle_result_descriptor(struct mtk_device *mtk)
   125	{
 > 126		struct crypto_async_request *async = NULL;
   127		struct eip93_descriptor_s *rdesc;
 > 128		bool last_entry, complete;
   129		u32 flags;
   130		int handled, ready;
 > 131		int err = 0;
   132		union peCrtlStat_w	done1;
   133		union peLength_w	done2;
   134	
   135	get_more:
   136		handled = 0;
   137	
   138		ready = readl(mtk->base + EIP93_REG_PE_RD_COUNT) & GENMASK(10, 0);
   139	
   140		if (!ready) {
   141			mtk_irq_clear(mtk, EIP93_INT_PE_RDRTHRESH_REQ);
   142			mtk_irq_enable(mtk, EIP93_INT_PE_RDRTHRESH_REQ);
   143			return;
   144		}
   145	
   146		last_entry = false;
   147		complete = false;
   148	
   149		while (ready) {
   150			rdesc = mtk_get_descriptor(mtk);
   151			if (IS_ERR(rdesc)) {
   152				dev_err(mtk->dev, "Ndesc: %d nreq: %d\n",
   153					handled, ready);
   154				err = -EIO;
   155				break;
   156			}
   157			/* make sure DMA is finished writing */
   158			do {
   159				done1.word = READ_ONCE(rdesc->peCrtlStat.word);
   160				done2.word = READ_ONCE(rdesc->peLength.word);
   161			} while ((!done1.bits.peReady) || (!done2.bits.peReady));
   162	
   163			err = rdesc->peCrtlStat.bits.errStatus;
   164	
   165			flags = rdesc->userId;
   166			async = (struct crypto_async_request *)rdesc->arc4Addr;
   167	
   168			writel(1, mtk->base + EIP93_REG_PE_RD_COUNT);
   169			mtk_irq_clear(mtk, EIP93_INT_PE_RDRTHRESH_REQ);
   170	
   171			handled++;
   172			ready--;
   173	
   174			if (flags & MTK_DESC_LAST) {
   175				last_entry = true;
   176				break;
   177			}
   178		}
   179	
   180		if (!last_entry)
   181			goto get_more;
   182	#ifdef CONFIG_CRYPTO_DEV_EIP93_SKCIPHER
   183		if (flags & MTK_DESC_SKCIPHER)
   184			mtk_skcipher_handle_result(mtk, async, err);
   185	#endif
   186	#ifdef CONFIG_CRYPTO_DEV_EIP93_AEAD
   187		if (flags & MTK_DESC_AEAD)
   188			mtk_aead_handle_result(mtk, async, err);
   189	#endif
   190		goto get_more;
   191	}
   192	
   193	static void mtk_done_task(unsigned long data)
   194	{
   195		struct mtk_device *mtk = (struct mtk_device *)data;
   196	
   197		mtk_handle_result_descriptor(mtk);
   198	}
   199	
   200	static irqreturn_t mtk_irq_handler(int irq, void *dev_id)
   201	{
   202		struct mtk_device *mtk = (struct mtk_device *)dev_id;
   203		u32 irq_status;
   204	
   205		irq_status = readl(mtk->base + EIP93_REG_INT_MASK_STAT);
   206	
   207		if (irq_status & EIP93_INT_PE_RDRTHRESH_REQ) {
   208			mtk_irq_disable(mtk, EIP93_INT_PE_RDRTHRESH_REQ);
   209			tasklet_schedule(&mtk->ring->done_task);
   210			return IRQ_HANDLED;
   211		}
   212	
   213	/* TODO: error handler; for now just clear ALL */
   214		mtk_irq_clear(mtk, irq_status);
   215		if (irq_status)
   216			mtk_irq_disable(mtk, irq_status);
   217	
   218		return IRQ_NONE;
   219	}
   220	
 > 221	void mtk_initialize(struct mtk_device *mtk)
   222	{
   223		union peConfig_w peConfig;
   224		union peEndianCfg_w peEndianCfg;
   225		union peIntCfg_w peIntCfg;
   226		union peClockCfg_w peClockCfg;
   227		union peBufThresh_w peBufThresh;
   228		union peRingThresh_w peRingThresh;
   229	
   230		/* Reset Engine and setup Mode */
   231		peConfig.word = 0;
   232		peConfig.bits.resetPE = 1;
   233		peConfig.bits.resetRing = 1;
   234		peConfig.bits.peMode = 3;
   235		peConfig.bits.enCDRupdate = 1;
   236	
   237		writel(peConfig.word, mtk->base + EIP93_REG_PE_CONFIG);
   238	
   239		udelay(10);
   240	
   241		peConfig.bits.resetPE = 0;
   242		peConfig.bits.resetRing = 0;
   243	
   244		writel(peConfig.word, mtk->base + EIP93_REG_PE_CONFIG);
   245	
   246		/* Initialize the BYTE_ORDER_CFG register */
   247		peEndianCfg.word = 0;
   248		writel(peEndianCfg.word, mtk->base + EIP93_REG_PE_ENDIAN_CONFIG);
   249	
   250		/* Initialize the INT_CFG register */
   251		peIntCfg.word = 0;
   252		writel(peIntCfg.word, mtk->base + EIP93_REG_INT_CFG);
   253	
   254		/* Config Clocks */
   255		peClockCfg.word = 0;
   256		peClockCfg.bits.enPEclk = 1;
   257	#ifdef CONFIG_CRYPTO_DEV_EIP93_DES
   258		peClockCfg.bits.enDESclk = 1;
   259	#endif
   260	#ifdef CONFIG_CRYPTO_DEV_EIP93_AES
   261		peClockCfg.bits.enAESclk = 1;
   262	#endif
   263	#ifdef CONFIG_CRYPTO_DEV_EIP93_HMAC
   264		peClockCfg.bits.enHASHclk = 1;
   265	#endif
   266		writel(peClockCfg.word, mtk->base + EIP93_REG_PE_CLOCK_CTRL);
   267	
   268		/* Config DMA thresholds */
   269		peBufThresh.word = 0;
   270		peBufThresh.bits.inputBuffer  = 128;
   271		peBufThresh.bits.outputBuffer = 128;
   272	
   273		writel(peBufThresh.word, mtk->base + EIP93_REG_PE_BUF_THRESH);
   274	
   275		/* Clear/ack all interrupts before disable all */
   276		mtk_irq_clear(mtk, 0xFFFFFFFF);
   277		mtk_irq_disable(mtk, 0xFFFFFFFF);
   278	
   279		/* Config Ring Threshold */
   280		peRingThresh.word = 0;
   281		peRingThresh.bits.CDRThresh = MTK_RING_SIZE - MTK_RING_BUSY;
   282		peRingThresh.bits.RDRThresh = 1;
   283		peRingThresh.bits.RDTimeout = 5;
   284		peRingThresh.bits.enTimeout = 1;
   285	
   286		writel(peRingThresh.word, mtk->base + EIP93_REG_PE_RING_THRESH);
   287	}
   288	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--Qxx1br4bt0+wmkIi
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICAXGeGEAAy5jb25maWcAlDxNd9u2svv7K3jSTe+ijS3banLf8QIiQREVSTAAKcvZ8Mgy
k+jVlvIkOW3+/ZsB+AGQoOzbRWPNDAYDYDBfAPjLv37xyMtp/7w+bTfrp6ef3tdqVx3Wp+rR
+7J9qv7HC7iX8tyjAct/B+J4u3v55/236p/11/3Ou/n98ub3i98Om0tvUR121ZPn73dftl9f
gMN2v/vXL//yeRqyeen75ZIKyXha5nSV377bPK13X70f1eEIdN7l9e8Xv194v37dnv7z/j38
/3l7OOwP75+efjyX3w/7/602J+/m8eGPm+mH9XR9+WXzcH3xoXr48PHDh/XD4/rLl8l6MrlZ
A+iPyb/fNb3Ou25vLwxRmCz9mKTz258tEH+2tJfXF/BfgyMSG8TxMunoAeYmjoNhjwBTDIKu
fWzQ2QxAvAi4E5mUc55zQ0QbUfIiz4q8w+ecx7KURZZxkZeCxsLZlqUxS+kAlfIyEzxkMS3D
tCR5brRm4lN5x8UCILCiv3hzpSJP3rE6vXzv1pilLC9puiyJgAGyhOW3V5O2G55kyDynEmX+
xavhd1QILrzt0dvtT8ixnSHuk7iZonftks4KBlMnSZwbwICGpIhzJYEDHHGZpySht+9+3e13
Vacf8l4uWeZ3I60B+K+fxx0845KtyuRTQQvqhnZNuqGR3I9KhXWMzxdcyjKhCRf3ON/EjzrO
haQxmxnqVsD2a6YflsM7vjwcfx5P1XM3/XOaUsF8tVqwlDNDUBMlI37nxvgRy+xFD3hCWGrD
JEtcRGXEqCDCj+5tbEhkTjnr0KBtaRDDuqqpqnaP3v5Lb0h94XzQhQVd0jSXQ8kNZDkTnAQ+
ke1U5dtnsDCu2cqZvyh5SmE6jD0UfS4z4MoD5psrCZsDMAzEdiykQhos2DyC3Sehh6Q3yoE0
rVJnYSMx/OkSF8BKw0hsqRiCizQTbNkqOw9Dh5CgUCLhAS0DoKXClMrusdVtQWmS5TA6ZSyU
bH5WvM/Xx7+8EwzEW0Pz42l9OnrrzWb/sjttd1978wsNSuL7vEhzpqxtK3gmmSllK8wbuuiY
IHsmeUxysBEmOyWt8AtPOhYeBlYCrlsx+FHSFay7oQjSolBteiAiF1I1rRXRgRqAioC64Lkg
vkMmmcNqo+FMeGpjUkrBBtK5P4uZzG1cSFLwDIbl7YBlTEl4ezm1WHF/hhM5KhPoMgnKZGaq
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
UUOSsi5F/gfGmh/UTMgBAA==

--Qxx1br4bt0+wmkIi--
