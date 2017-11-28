From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.15
Date: Wed, 29 Nov 2017 10:09:29 +1100
Message-ID: <20171128230929.GA17783@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:40444 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751867AbdK1XJq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 18:09:46 -0500
Content-Disposition: inline
In-Reply-To: <20170922084401.GA15541@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes the following issues:

- Potential bogus alignment for some AEAD operations.
- Crash in algif_aead.
- Sleeping in softirq context with async af_alg.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ondrej Mosnáček (1):
      crypto: skcipher - Fix skcipher_walk_aead_common

Stephan Mueller (2):
      crypto: algif_aead - skip SGL entries with NULL page
      crypto: af_alg - remove locking in async callback

 crypto/af_alg.c         |   21 ++++++++++++------
 crypto/algif_aead.c     |   56 ++++++++++++++++++++++++++++++-----------------
 crypto/algif_skcipher.c |   23 +++++++++----------
 crypto/skcipher.c       |    3 +++
 include/crypto/if_alg.h |    1 +
 5 files changed, 66 insertions(+), 38 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
