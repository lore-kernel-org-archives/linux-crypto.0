From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.18
Date: Fri, 22 Jun 2018 22:54:03 +0800
Message-ID: <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
 <20170922084401.GA15541@gondor.apana.org.au>
 <20171128230929.GA17783@gondor.apana.org.au>
 <20171222064931.GA27068@gondor.apana.org.au>
 <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

This push fixes the following issues:

- Fix use after free in chtls.
- Fix RBP breakage in sha3.
- Fix use after free in hwrng_unregister.
- Fix overread in morus640.
- Move sleep out of kernel_neon in arm64/aes-blk.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Dan Carpenter (1):
      crypto: chtls - use after free in chtls_pt_recvmsg()

Dmitry Vyukov (1):
      crypto: don't optimize keccakf()

Jia He (1):
      crypto: arm64/aes-blk - fix and move skcipher_walk_done out of kernel_neon_begin, _end

Michael Büsch (1):
      hwrng: core - Always drop the RNG in hwrng_unregister()

Ondrej Mosnáček (1):
      crypto: morus640 - Fix out-of-bounds access

 arch/arm64/crypto/aes-glue.c            |    2 +-
 crypto/morus640.c                       |    3 ++-
 crypto/sha3_generic.c                   |    2 +-
 drivers/char/hw_random/core.c           |   11 +++++++++--
 drivers/crypto/chelsio/chtls/chtls_io.c |    5 ++---
 5 files changed, 15 insertions(+), 8 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
