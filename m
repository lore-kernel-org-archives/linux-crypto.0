Return-Path: <SRS0=2cET=YT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBFACA9EBD
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 07:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE924206DD
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Oct 2019 07:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfJZHIB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Oct 2019 03:08:01 -0400
Received: from mga04.intel.com ([192.55.52.120]:8437 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbfJZHIB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Oct 2019 03:08:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Oct 2019 00:07:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,230,1569308400"; 
   d="scan'208";a="189146460"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 26 Oct 2019 00:07:58 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iOGB3-000HH0-UG; Sat, 26 Oct 2019 15:07:57 +0800
Date:   Sat, 26 Oct 2019 15:07:42 +0800
From:   kbuild test robot <lkp@intel.com>
To:     "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
Cc:     kbuild-all@lists.01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [cryptodev:master 124/137] drivers/crypto/atmel-aes.c:2076:40:
 sparse: sparse: incorrect type in argument 3 (different base types)
Message-ID: <201910261540.eu22Mp7V%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
head:   691505a803a7f223b2af621848d581259c61f77d
commit: 49c4cd80354b948f0901d301b94d4b8dcafc9e04 [124/137] crypto: atmel - fix data types for __be{32,64}
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-dirty
        git checkout 49c4cd80354b948f0901d301b94d4b8dcafc9e04
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/crypto/atmel-aes.c:2076:40: sparse: sparse: incorrect type in argument 3 (different base types) @@    expected restricted __be32 const [usertype] *iv @@    got t [usertype] *iv @@
>> drivers/crypto/atmel-aes.c:2076:40: sparse:    expected restricted __be32 const [usertype] *iv
>> drivers/crypto/atmel-aes.c:2076:40: sparse:    got unsigned int *

vim +2076 drivers/crypto/atmel-aes.c

89a82ef87e0120 Cyrille Pitchen 2017-01-26  2043  
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2044  static int atmel_aes_authenc_transfer(struct atmel_aes_dev *dd, int err,
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2045  				      bool is_async)
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2046  {
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2047  	struct aead_request *req = aead_request_cast(dd->areq);
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2048  	struct atmel_aes_authenc_reqctx *rctx = aead_request_ctx(req);
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2049  	bool enc = atmel_aes_is_encrypt(dd);
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2050  	struct scatterlist *src, *dst;
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2051  	u32 iv[AES_BLOCK_SIZE / sizeof(u32)];
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2052  	u32 emr;
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2053  
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2054  	if (is_async)
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2055  		dd->is_async = true;
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2056  	if (err)
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2057  		return atmel_aes_complete(dd, err);
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2058  
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2059  	/* Prepare src and dst scatter-lists to transfer cipher/plain texts. */
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2060  	src = scatterwalk_ffwd(rctx->src, req->src, req->assoclen);
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2061  	dst = src;
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2062  
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2063  	if (req->src != req->dst)
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2064  		dst = scatterwalk_ffwd(rctx->dst, req->dst, req->assoclen);
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2065  
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2066  	/* Configure the AES device. */
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2067  	memcpy(iv, req->iv, sizeof(iv));
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2068  
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2069  	/*
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2070  	 * Here we always set the 2nd parameter of atmel_aes_write_ctrl() to
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2071  	 * 'true' even if the data transfer is actually performed by the CPU (so
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2072  	 * not by the DMA) because we must force the AES_MR_SMOD bitfield to the
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2073  	 * value AES_MR_SMOD_IDATAR0. Indeed, both AES_MR_SMOD and SHA_MR_SMOD
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2074  	 * must be set to *_MR_SMOD_IDATAR0.
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2075  	 */
89a82ef87e0120 Cyrille Pitchen 2017-01-26 @2076  	atmel_aes_write_ctrl(dd, true, iv);
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2077  	emr = AES_EMR_PLIPEN;
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2078  	if (!enc)
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2079  		emr |= AES_EMR_PLIPD;
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2080  	atmel_aes_write(dd, AES_EMR, emr);
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2081  
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2082  	/* Transfer data. */
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2083  	return atmel_aes_dma_start(dd, src, dst, rctx->textlen,
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2084  				   atmel_aes_authenc_digest);
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2085  }
89a82ef87e0120 Cyrille Pitchen 2017-01-26  2086  

:::::: The code at line 2076 was first introduced by commit
:::::: 89a82ef87e012061989fcaf7dd51d706ff2090e3 crypto: atmel-authenc - add support to authenc(hmac(shaX), Y(aes)) modes

:::::: TO: Cyrille Pitchen <cyrille.pitchen@atmel.com>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
