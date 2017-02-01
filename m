From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.10
Date: Wed, 1 Feb 2017 17:04:15 +0800
Message-ID: <20170201090415.GA32141@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51975 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751560AbdBAJEa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 04:04:30 -0500
Content-Disposition: inline
In-Reply-To: <20170111115646.GA8943@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes a bug in CBC/CTR on ARM64 that breaks chaining
as well as a bug in the core API that causes registration failures
when a driver unloads and then reloads an algorithm.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (1):
      crypto: arm64/aes-blk - honour iv_out requirement in CBC and CTR modes

Salvatore Benedetto (1):
      crypto: api - Clear CRYPTO_ALG_DEAD bit before registering an alg

 arch/arm64/crypto/aes-modes.S |   88 ++++++++++++++++++++---------------------
 crypto/algapi.c               |    1 +
 2 files changed, 43 insertions(+), 46 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
