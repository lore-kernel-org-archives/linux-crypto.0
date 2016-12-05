From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.9
Date: Mon, 5 Dec 2016 14:37:54 +0800
Message-ID: <20161205063754.GA9408@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:54710 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750772AbcLEGi2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Dec 2016 01:38:28 -0500
Content-Disposition: inline
In-Reply-To: <20161119102748.GA4277@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

- Intermittent build failure in RSA.
- Memory corruption in chelsio crypto driver.
- Regression in DRBG due to vmalloced stack.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


David Michael (1):
      crypto: rsa - Add Makefile dependencies to fix parallel builds

Harsh Jain (1):
      crypto: chcr - Fix memory corruption

Stephan Mueller (1):
      crypto: drbg - prevent invalid SG mappings

 crypto/Makefile                    |    1 +
 crypto/drbg.c                      |   29 ++++++++++++++++++++++++-----
 drivers/crypto/chelsio/chcr_algo.h |    3 ++-
 include/crypto/drbg.h              |    2 ++
 4 files changed, 29 insertions(+), 6 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
