From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.15
Date: Fri, 22 Dec 2017 17:49:31 +1100
Message-ID: <20171222064931.GA27068@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:45932 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751069AbdLVGuS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 01:50:18 -0500
Content-Disposition: inline
In-Reply-To: <20171128230929.GA17783@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes the following issues:

- Fix chacha20 crash on zero-length input due to unset IV.
- Fix potential race conditions in mcryptd with spinlock.
- Only wait once at top of algif recvmsg to avoid inconsistencies.
- Fix potential use-after-free in algif_aead/algif_skcipher.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Eric Biggers (1):
      crypto: skcipher - set walk.iv for zero-length inputs

Sebastian Andrzej Siewior (1):
      crypto: mcryptd - protect the per-CPU queue with a lock

Stephan Mueller (2):
      crypto: af_alg - wait for data at beginning of recvmsg
      crypto: af_alg - fix race accessing cipher request

 crypto/af_alg.c          |    6 ------
 crypto/algif_aead.c      |   16 +++++++++++-----
 crypto/algif_skcipher.c  |   16 +++++++++++-----
 crypto/mcryptd.c         |   23 ++++++++++-------------
 crypto/skcipher.c        |   10 ++++------
 include/crypto/mcryptd.h |    1 +
 6 files changed, 37 insertions(+), 35 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
