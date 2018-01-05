From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.15
Date: Fri, 5 Jan 2018 18:38:08 +1100
Message-ID: <20180105073808.GA14405@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:49930 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751320AbeAEHiU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jan 2018 02:38:20 -0500
Content-Disposition: inline
In-Reply-To: <20171222064931.GA27068@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus: 

This push fixes the following issues:

- Racy use of ctx->rcvused in af_alg.
- algif_aead crash in chacha20poly1305.
- Freeing bogus pointer in pcrypt.
- Build error on MIPS in mpi.
- Memory leak in inside-secure.
- Memory overwrite in inside-secure.
- NULL pointer dereference in inside-secure.
- State corruption in inside-secure.
- Build error without CRYPTO_GF128MUL in chelsio.
- Use after free in n2.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Antoine Ténart (3):
      crypto: inside-secure - free requests even if their handling failed
      crypto: inside-secure - fix request allocations in invalidation path
      crypto: inside-secure - do not use areq->result for partial results

Arnd Bergmann (1):
      crypto: chelsio - select CRYPTO_GF128MUL

Eric Biggers (2):
      crypto: chacha20poly1305 - validate the digest size
      crypto: pcrypt - fix freeing pcrypt instances

James Hogan (1):
      lib/mpi: Fix umul_ppmm() for MIPS64r6

Jan Engelhardt (1):
      crypto: n2 - cure use after free

Jonathan Cameron (1):
      crypto: af_alg - Fix race around ctx->rcvused by making it atomic_t

Ofer Heifetz (1):
      crypto: inside-secure - per request invalidation

 crypto/af_alg.c                                |    4 +-
 crypto/algif_aead.c                            |    2 +-
 crypto/algif_skcipher.c                        |    2 +-
 crypto/chacha20poly1305.c                      |    6 +-
 crypto/pcrypt.c                                |   19 ++---
 drivers/crypto/chelsio/Kconfig                 |    1 +
 drivers/crypto/inside-secure/safexcel.c        |    1 +
 drivers/crypto/inside-secure/safexcel_cipher.c |   85 ++++++++++++++++------
 drivers/crypto/inside-secure/safexcel_hash.c   |   89 +++++++++++++++++-------
 drivers/crypto/n2_core.c                       |    3 +
 include/crypto/if_alg.h                        |    5 +-
 lib/mpi/longlong.h                             |   18 ++++-
 12 files changed, 173 insertions(+), 62 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
