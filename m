From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.11
Date: Mon, 10 Apr 2017 19:04:32 +0800
Message-ID: <20170410110432.GA8731@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161215160732.GA16580@gondor.apana.org.au>
 <20170111115646.GA8943@gondor.apana.org.au>
 <20170304074119.GA3041@gondor.apana.org.au>
 <20170315063151.GA6767@gondor.apana.org.au>
 <20170324134627.GA14273@gondor.apana.org.au>
 <20170331102907.GA11348@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170331102907.GA11348@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes a number of bugs in the caam driver:

- Device creation fails after release.
- Error-path NULL-pointer dereference.
- Spurious hardware error in RNG deinstantiation.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Horia Geantă (3):
      crypto: caam - fix JR platform device subsequent (re)creations
      crypto: caam - fix invalid dereference in caam_rsa_init_tfm()
      crypto: caam - fix RNG deinstantiation error checking

 drivers/crypto/caam/caampkc.c |    2 +-
 drivers/crypto/caam/ctrl.c    |   66 +++++++++++++----------------------------
 drivers/crypto/caam/intern.h  |    1 -
 3 files changed, 22 insertions(+), 47 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
