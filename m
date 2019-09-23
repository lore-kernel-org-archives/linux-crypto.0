Return-Path: <SRS0=uYt1=XS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE43C49ED7
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Sep 2019 05:05:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F63320882
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Sep 2019 05:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729194AbfIWFFg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Sep 2019 01:05:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:34786 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728841AbfIWFFf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Sep 2019 01:05:35 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iCGXG-0001gS-7s; Mon, 23 Sep 2019 15:05:19 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Sep 2019 15:05:15 +1000
Date:   Mon, 23 Sep 2019 15:05:15 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 5.4
Message-ID: <20190923050515.GA6980@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916084901.GA20338@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

This push fixes the following issues:

- Potential boot hang in hwrng.
- Missing switch/break in talitos.
- Bugs and warnings in hisilicon.
- Build warning in inside-secure.

The following changes since commit 9575d1a5c0780ea26ff8dd29c94a32be32ce3c85:

  crypto: caam - Cast to long first before pointer conversion (2019-09-13 21:20:47 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus

for you to fetch changes up to bf6a7a5ad6fa69e48b735be75eeb90569d9584bb:

  crypto: hisilicon - avoid unused function warning (2019-09-20 23:05:33 +1000)

----------------------------------------------------------------
Arnd Bergmann (1):
      crypto: hisilicon - avoid unused function warning

Gustavo A. R. Silva (1):
      crypto: talitos - fix missing break in switch statement

Laurent Vivier (1):
      hwrng: core - don't wait on add_early_randomness()

Pascal van Leeuwen (1):
      crypto: inside-secure - Fix unused variable warning when CONFIG_PCI=n

Yunfeng Ye (3):
      crypto: hisilicon - Fix double free in sec_free_hw_sgl()
      crypto: hisilicon - Matching the dma address for dma_pool_free()
      crypto: hisilicon - Fix return value check in hisi_zip_acompress()

 drivers/char/hw_random/core.c             |  2 +-
 drivers/crypto/hisilicon/sec/sec_algs.c   | 43 ++++++++++++++-----------------
 drivers/crypto/hisilicon/zip/zip_crypto.c |  4 +--
 drivers/crypto/hisilicon/zip/zip_main.c   |  7 ++---
 drivers/crypto/inside-secure/safexcel.c   | 40 ++++++++++++++++++++--------
 drivers/crypto/talitos.c                  |  1 +
 6 files changed, 54 insertions(+), 43 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
