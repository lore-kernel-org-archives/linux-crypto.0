Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C67C07E95
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Jul 2021 03:09:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54D7161CD8
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Jul 2021 03:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhGHDMC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Jul 2021 23:12:02 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51178 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230244AbhGHDMC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Jul 2021 23:12:02 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1m1KPd-00060d-FZ; Thu, 08 Jul 2021 11:09:17 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1m1KPZ-0008Mp-Mj; Thu, 08 Jul 2021 11:09:13 +0800
Date:   Thu, 8 Jul 2021 11:09:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 5.14
Message-ID: <20210708030913.GA32097@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au>
 <20201026011159.GA2428@gondor.apana.org.au>
 <20201227113221.GA28744@gondor.apana.org.au>
 <20210108035450.GA6191@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210108035450.GA6191@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

This push contains the following fixes and changes:

- Regression in drbg due to missing self-test for new default algorithm.
- Add ratelimit on user-triggerable message in qat.
- Build failure due to missing dependency in sl3516.
- Remove obsolete PageSlab checks.
- Bogus hardware register writes on Kunpeng920 in hisilicon/sec.

The following changes since commit 9f38b678ffc4e2ccf167a1131c0403dc4f5e1bb7:

  crypto: sl3516 - depends on HAS_IOMEM (2021-06-24 14:57:28 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

for you to fetch changes up to 66192b2e3fd8ab97ed518d6c0240e26655a20b4b:

  crypto: hisilicon/sec - fix the process of disabling sva prefetching (2021-06-28 11:28:09 +0800)

----------------------------------------------------------------
Colin Ian King (1):
      crypto: qat - ratelimit invalid ioctl message and print the invalid cmd

Geert Uytterhoeven (2):
      crypto: sl3516 - Typo s/Stormlink/Storlink/
      crypto: sl3516 - Add dependency on ARCH_GEMINI

Herbert Xu (2):
      crypto: scatterwalk - Remove obsolete PageSlab check
      crypto: omap - Drop obsolete PageSlab check

Kai Ye (1):
      crypto: hisilicon/sec - fix the process of disabling sva prefetching

Stephan Müller (1):
      crypto: drbg - self test for HMAC(SHA-512)

 crypto/testmgr.c                            |  5 ++-
 crypto/testmgr.h                            | 49 +++++++++++++++++++++++++++++
 drivers/crypto/Kconfig                      |  6 ++--
 drivers/crypto/gemini/sl3516-ce-cipher.c    |  2 +-
 drivers/crypto/gemini/sl3516-ce-core.c      |  2 +-
 drivers/crypto/hisilicon/sec2/sec_main.c    |  3 ++
 drivers/crypto/omap-crypto.c                |  3 +-
 drivers/crypto/qat/qat_common/adf_ctl_drv.c |  2 +-
 include/crypto/scatterwalk.h                |  7 +----
 9 files changed, 64 insertions(+), 15 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
