Return-Path: <SRS0=NP+Z=6A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC5C7C352BE
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 14:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 825AD214AF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Apr 2020 14:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392535AbgDPO6g (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Apr 2020 10:58:36 -0400
Received: from mga04.intel.com ([192.55.52.120]:37447 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2896376AbgDPNzT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Apr 2020 09:55:19 -0400
IronPort-SDR: YEMe67De3nvKlGKdXECK06zQXcVHwHXkHXXr8Iv1WahhXrBfX9qbFv8GEhbJrMQ5YuaOxpom1l
 KCN6SCtzpDFQ==
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 06:54:47 -0700
IronPort-SDR: W3cIZo4qAPk/bQIBd2FxBdax0Bv5S6gOjN6wrpEKrY/FvY0h0YZR8cQMkB4jzetK481yAYLmrP
 P5/6gW8Mfcdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="gz'50?scan'50,208,50";a="272073207"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 16 Apr 2020 06:54:44 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jP4ya-000DfM-86; Thu, 16 Apr 2020 21:54:44 +0800
Date:   Thu, 16 Apr 2020 21:53:58 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     kbuild-all@lists.01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [cryptodev:master 7/24] drivers/char/hw_random/cctrng.c:334:49:
 error: 'fips_enabled' undeclared; did you mean 'vdso_enabled'?
Message-ID: <202004162156.90J0gKFM%lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   0a8f5989e03476cfb2a7756e33fa4d0163cb4375
commit: a583ed310bb6b514e717c11a30b5a7bc3a65d1b1 [7/24] hwrng: cctrng - introduce Arm CryptoCell driver
config: s390-defconfig (attached as .config)
compiler: s390-linux-gcc (GCC) 9.3.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout a583ed310bb6b514e717c11a30b5a7bc3a65d1b1
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day GCC_VERSION=9.3.0 make.cross ARCH=s390 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/char/hw_random/cctrng.c: In function 'cc_trng_compwork_handler':
>> drivers/char/hw_random/cctrng.c:334:49: error: 'fips_enabled' undeclared (first use in this function); did you mean 'vdso_enabled'?
     334 |  if (CC_REG_FLD_GET(RNG_ISR, CRNGT_ERR, isr) && fips_enabled) {
         |                                                 ^~~~~~~~~~~~
         |                                                 vdso_enabled
   drivers/char/hw_random/cctrng.c:334:49: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/char/hw_random/cctrng.c:335:3: error: implicit declaration of function 'fips_fail_notify' [-Werror=implicit-function-declaration]
     335 |   fips_fail_notify();
         |   ^~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +334 drivers/char/hw_random/cctrng.c

   314	
   315	void cc_trng_compwork_handler(struct work_struct *w)
   316	{
   317		u32 isr = 0;
   318		u32 ehr_valid = 0;
   319		struct cctrng_drvdata *drvdata =
   320				container_of(w, struct cctrng_drvdata, compwork);
   321		struct device *dev = &(drvdata->pdev->dev);
   322		int i;
   323	
   324		/* stop DMA and the RNG source */
   325		cc_iowrite(drvdata, CC_RNG_DMA_ENABLE_REG_OFFSET, 0);
   326		cc_iowrite(drvdata, CC_RND_SOURCE_ENABLE_REG_OFFSET, 0);
   327	
   328		/* read RNG_ISR and check for errors */
   329		isr = cc_ioread(drvdata, CC_RNG_ISR_REG_OFFSET);
   330		ehr_valid = CC_REG_FLD_GET(RNG_ISR, EHR_VALID, isr);
   331		dev_dbg(dev, "Got RNG_ISR=0x%08X (EHR_VALID=%u)\n", isr, ehr_valid);
   332	
   333	#ifdef CONFIG_CRYPTO_FIPS
 > 334		if (CC_REG_FLD_GET(RNG_ISR, CRNGT_ERR, isr) && fips_enabled) {
 > 335			fips_fail_notify();
   336			/* FIPS error is fatal */
   337			panic("Got HW CRNGT error while fips is enabled!\n");
   338		}
   339	#endif
   340	
   341		/* Clear all pending RNG interrupts */
   342		cc_iowrite(drvdata, CC_RNG_ICR_REG_OFFSET, isr);
   343	
   344	
   345		if (!ehr_valid) {
   346			/* in case of AUTOCORR/TIMEOUT error, try the next ROSC */
   347			if (CC_REG_FLD_GET(RNG_ISR, AUTOCORR_ERR, isr) ||
   348					CC_REG_FLD_GET(RNG_ISR, WATCHDOG, isr)) {
   349				dev_dbg(dev, "cctrng autocorr/timeout error.\n");
   350				goto next_rosc;
   351			}
   352	
   353			/* in case of VN error, ignore it */
   354		}
   355	
   356		/* read EHR data from registers */
   357		for (i = 0; i < CC_TRNG_EHR_IN_WORDS; i++) {
   358			/* calc word ptr in data_buf */
   359			u32 *buf = (u32 *)drvdata->circ.buf;
   360	
   361			buf[drvdata->circ.head] = cc_ioread(drvdata,
   362					CC_EHR_DATA_0_REG_OFFSET + (i*sizeof(u32)));
   363	
   364			/* EHR_DATA registers are cleared on read. In case 0 value was
   365			 * returned, restart the entropy collection.
   366			 */
   367			if (buf[drvdata->circ.head] == 0) {
   368				dev_dbg(dev, "Got 0 value in EHR. active_rosc %u\n",
   369					drvdata->active_rosc);
   370				goto next_rosc;
   371			}
   372	
   373			circ_idx_inc(&drvdata->circ.head, 1<<2);
   374		}
   375	
   376		atomic_set(&drvdata->pending_hw, 0);
   377	
   378		/* continue to fill data buffer if needed */
   379		if (circ_buf_space(drvdata) >= CC_TRNG_EHR_IN_WORDS) {
   380			if (atomic_cmpxchg(&drvdata->pending_hw, 0, 1) == 0) {
   381				/* Re-enable rnd source */
   382				cc_trng_enable_rnd_source(drvdata);
   383				return;
   384			}
   385		}
   386	
   387		cc_trng_pm_put_suspend(dev);
   388	
   389		dev_dbg(dev, "compwork handler done\n");
   390		return;
   391	
   392	next_rosc:
   393		if ((circ_buf_space(drvdata) >= CC_TRNG_EHR_IN_WORDS) &&
   394				(cc_trng_change_rosc(drvdata) == 0)) {
   395			/* trigger trng hw with next rosc */
   396			cc_trng_hw_trigger(drvdata);
   397		} else {
   398			atomic_set(&drvdata->pending_hw, 0);
   399			cc_trng_pm_put_suspend(dev);
   400		}
   401	}
   402	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--NzB8fVQJ5HfG6fxh
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--NzB8fVQJ5HfG6fxh--
