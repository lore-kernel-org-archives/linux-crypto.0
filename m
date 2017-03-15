From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.11
Date: Wed, 15 Mar 2017 14:31:51 +0800
Message-ID: <20170315063151.GA6767@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au>
 <20170304074119.GA3041@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39095 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750944AbdCOGcK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Mar 2017 02:32:10 -0400
Content-Disposition: inline
In-Reply-To: <20170304074119.GA3041@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

- Self-test failure of crc32c on powerpc.
- Regressions of ecb(aes) when used with xts/lrw in s5p-sss.
- A number of bugs in the omap RNG driver.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Daniel Axtens (1):
      crypto: powerpc - Fix initialisation of crc32c context

Krzysztof Kozlowski (2):
      crypto: s5p-sss - Fix completing crypto request in IRQ handler
      crypto: s5p-sss - Fix spinlock recursion on LRW(AES)

Thomas Petazzoni (3):
      hwrng: omap - write registers after enabling the clock
      hwrng: omap - use devm_clk_get() instead of of_clk_get()
      hwrng: omap - Do not access INTMASK_REG on EIP76

 arch/powerpc/crypto/crc32c-vpmsum_glue.c |    2 +-
 drivers/char/hw_random/omap-rng.c        |   16 +++-
 drivers/crypto/s5p-sss.c                 |  132 +++++++++++++++++++-----------
 3 files changed, 100 insertions(+), 50 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
