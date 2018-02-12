From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.16
Date: Mon, 12 Feb 2018 11:17:02 +0800
Message-ID: <20180212031702.GA26153@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180105073808.GA14405@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

This push fixes the following issues:

- Fix oversize stack frames on mn10300 in sha3-generic.
- Fix warning on old compilers in sha3-generic.
- Fix API error in sun4i_ss_prng.
- Fix potential dead-lock in sun4i_ss_prng.
- Fix null-pointer dereference in sha512-mb.
- Fix endless loop when DECO acquire fails in caam.
- Fix kernel oops when hashing empty message in talitos.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Ard Biesheuvel (1):
      crypto: sha3-generic - deal with oversize stack frames

Artem Savkov (2):
      crypto: sun4i_ss_prng - fix return value of sun4i_ss_prng_generate
      crypto: sun4i_ss_prng - convert lock to _bh in sun4i_ss_prng_generate

Eric Biggers (1):
      crypto: sha512-mb - initialize pending lengths correctly

Geert Uytterhoeven (3):
      compiler-gcc.h: Introduce __optimize function attribute
      compiler-gcc.h: __nostackprotector needs gcc-4.4 and up
      crypto: sha3-generic - Use __optimize to support old compilers

Horia Geantă (1):
      crypto: caam - fix endless loop when DECO acquire fails

LEROY Christophe (1):
      crypto: talitos - fix Kernel Oops on hashing an empty file

 .../x86/crypto/sha512-mb/sha512_mb_mgr_init_avx2.c |   10 +-
 crypto/sha3_generic.c                              |  218 +++++++++++---------
 drivers/crypto/caam/ctrl.c                         |    8 +-
 drivers/crypto/sunxi-ss/sun4i-ss-prng.c            |    6 +-
 drivers/crypto/talitos.c                           |    4 +
 include/linux/compiler-gcc.h                       |    7 +-
 include/linux/compiler.h                           |    4 +
 7 files changed, 146 insertions(+), 111 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
