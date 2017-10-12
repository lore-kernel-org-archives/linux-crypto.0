From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.14
Date: Thu, 12 Oct 2017 18:51:01 +0800
Message-ID: <20171012105101.GA29403@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170922084401.GA15541@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

This push fixes the following issues:

- Crashes in skcipher/shash from zero-length input.
- Fix softirq GFP_KERNEL allocation in shash_setkey_unaligned.
- Error path bug in xts create function.
- Compiler warning regressions in axis and stm32.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Arnd Bergmann (2):
      crypto: axis - hide an unused variable
      crypto: stm32 - Try to fix hash padding

Christophe Jaillet (1):
      crypto: xts - Fix an error handling path in 'create()'

Herbert Xu (2):
      crypto: skcipher - Fix crash on zero-length input
      crypto: shash - Fix zero-length shash ahash digest crash

Jia-Ju Bai (1):
      crypto: shash - Fix a sleep-in-atomic bug in shash_setkey_unaligned

 crypto/shash.c                       |   10 ++++++----
 crypto/skcipher.c                    |   17 +++++++++++------
 crypto/xts.c                         |    6 ++++--
 drivers/crypto/axis/artpec6_crypto.c |    4 ++--
 drivers/crypto/stm32/stm32-hash.c    |   15 +++++++++------
 5 files changed, 32 insertions(+), 20 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
