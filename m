Return-Path: <SRS0=f3/+=X6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 507D8C4740A
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 21:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1948C222C0
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 21:49:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfJEVtD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Oct 2019 17:49:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:54246 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725801AbfJEVtD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Oct 2019 17:49:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Oct 2019 14:49:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,261,1566889200"; 
   d="scan'208";a="344318027"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 05 Oct 2019 14:49:01 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iGrvA-000BuM-Oc; Sun, 06 Oct 2019 05:49:00 +0800
Date:   Sun, 6 Oct 2019 05:48:31 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     kbuild-all@01.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [cryptodev:master 1/53]
 drivers/crypto/inside-secure/safexcel_hash.c:1781:25: sparse: sparse:
 incorrect type in assignment (different base types)
Message-ID: <201910060530.PTVoB2Wq%lkp@intel.com>
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
head:   4fd7d7befdb531920cae8f78afd4938e4a25e421
commit: a7cf8658460edafb03438eeeb0a7d3c91572d4db [1/53] crypto: inside-secure - Added support for CRC32
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-rc1-42-g38eda53-dirty
        git checkout a7cf8658460edafb03438eeeb0a7d3c91572d4db
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   drivers/crypto/inside-secure/safexcel_hash.c:93:41: sparse: sparse: incorrect type in assignment (different base types) @@    expected restricted __le32 @@    got icted __le32 @@
   drivers/crypto/inside-secure/safexcel_hash.c:93:41: sparse:    expected restricted __le32
   drivers/crypto/inside-secure/safexcel_hash.c:93:41: sparse:    got unsigned int
>> drivers/crypto/inside-secure/safexcel_hash.c:1781:25: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned int @@    got restricted __le32unsigned int @@
>> drivers/crypto/inside-secure/safexcel_hash.c:1781:25: sparse:    expected unsigned int
>> drivers/crypto/inside-secure/safexcel_hash.c:1781:25: sparse:    got restricted __le32 [usertype]

vim +1781 drivers/crypto/inside-secure/safexcel_hash.c

  1772	
  1773	static int safexcel_crc32_init(struct ahash_request *areq)
  1774	{
  1775		struct safexcel_ahash_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
  1776		struct safexcel_ahash_req *req = ahash_request_ctx(areq);
  1777	
  1778		memset(req, 0, sizeof(*req));
  1779	
  1780		/* Start from loaded key */
> 1781		req->state[0]	= cpu_to_le32(~ctx->ipad[0]);
  1782		/* Set processed to non-zero to enable invalidation detection */
  1783		req->len	= sizeof(u32);
  1784		req->processed	= sizeof(u32);
  1785	
  1786		ctx->alg = CONTEXT_CONTROL_CRYPTO_ALG_CRC32;
  1787		req->digest = CONTEXT_CONTROL_DIGEST_XCM;
  1788		req->state_sz = sizeof(u32);
  1789		req->block_sz = sizeof(u32);
  1790	
  1791		return 0;
  1792	}
  1793	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
