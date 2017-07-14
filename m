From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.13
Date: Fri, 14 Jul 2017 22:18:55 +0800
Message-ID: <20170714141855.GA29426@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170223125141.GA17400@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

This push fixes the following issues:

- New compiler warnings in cavium.
- Set post-op IV properly in caam (this fixes chaining).
- Fix potential use-after-free in atmel in case of EBUSY.
- Fix sleeping in softirq path in chcr.
- Disable buggy sha1-avx2 driver (may overread and page fault).
- Fix use-after-free on signals in caam.
 

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Colin Ian King (1):
      crypto: cavium - make several functions static

David Gstir (1):
      crypto: caam - properly set IV after {en,de}crypt

Gilad Ben-Yossef (1):
      crypto: atmel - only treat EBUSY as transient if backlog

Harsh Jain (1):
      crypto: chcr - Avoid algo allocation in softirq.

Herbert Xu (2):
      crypto: sha1-ssse3 - Disable avx2

Horia Geantă (1):
      crypto: caam - fix signals handling

 arch/x86/crypto/sha1_ssse3_glue.c      |    2 +-
 crypto/af_alg.c                        |    2 +-
 drivers/crypto/atmel-sha.c             |    4 +++-
 drivers/crypto/caam/caamalg.c          |   20 ++++++++++++++++++--
 drivers/crypto/caam/caamhash.c         |    2 +-
 drivers/crypto/caam/key_gen.c          |    2 +-
 drivers/crypto/cavium/cpt/cptvf_algs.c |    8 ++++----
 drivers/crypto/chelsio/chcr_algo.c     |   23 +++++++++++++++--------
 drivers/crypto/chelsio/chcr_crypto.h   |    1 +
 9 files changed, 45 insertions(+), 19 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
