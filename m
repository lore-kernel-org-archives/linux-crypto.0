Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCFB3C76188
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 03:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE4F020873
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 03:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbfGSDMM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 23:12:12 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:45746 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfGSDMM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 23:12:12 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hoJJZ-0005if-B8; Fri, 19 Jul 2019 11:12:09 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hoJJW-0007XQ-6j; Fri, 19 Jul 2019 11:12:06 +0800
Date:   Fri, 19 Jul 2019 11:12:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT] Crypto Fixes for 5.3
Message-ID: <20190719031206.nxyxk4vj6dg7hwxg@gondor.apana.org.au>
References: <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
 <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
 <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515060552.ecfwhazt2fnthepg@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus: 

This push fixes the following issues:

- Fix missed wake-up race in padata.
- Use crypto_memneq in ccp.
- Fix version check in ccp.
- Fix fuzz test failure in ccp.
- Fix potential double free in crypto4xx.
- Fix compile warning in stm32.


The following changes since commit f3880a23564e3172437285ebcb5b8a124539fdae:

  crypto: stm32/hash - remove interruptible condition for dma (2019-07-03 22:15:08 +0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to cf144f81a99d1a3928f90b0936accfd3f45c9a0a:

  padata: use smp_mb in padata_reorder to avoid orphaned padata jobs (2019-07-18 13:39:54 +0800)

----------------------------------------------------------------
Cfir Cohen (1):
      crypto: ccp/gcm - use const time tag comparison.

Daniel Jordan (1):
      padata: use smp_mb in padata_reorder to avoid orphaned padata jobs

David Rientjes (1):
      crypto: ccp - Fix SEV_VERSION_GREATER_OR_EQUAL

Herbert Xu (1):
      crypto: stm32/hash - Fix incorrect printk modifier for size_t

Hook, Gary (1):
      crypto: ccp - memset structure fields to zero before reuse

Wen Yang (1):
      crypto: crypto4xx - fix a potential double free in ppc4xx_trng_probe

 drivers/crypto/amcc/crypto4xx_trng.c |  1 -
 drivers/crypto/ccp/ccp-ops.c         | 15 +++++++++++++--
 drivers/crypto/ccp/psp-dev.c         | 19 ++++++++++++-------
 drivers/crypto/stm32/stm32-hash.c    |  2 +-
 kernel/padata.c                      | 12 ++++++++++++
 5 files changed, 38 insertions(+), 11 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
