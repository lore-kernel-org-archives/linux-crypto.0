From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.8
Date: Mon, 1 Aug 2016 17:58:21 +0800
Message-ID: <20160801095821.GA1260@gondor.apana.org.au>
References: <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
 <20160122101828.GA15966@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160122101828.GA15966@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus:

This push fixes a number of regressions in the marvell cesa driver
caused by the chaining work, and a regression in lib/mpi that
leads to a GFP_KERNEL allocation with preemption disabled.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Herbert Xu (1):
      lib/mpi: Fix SG miter leak

Romain Perier (4):
      crypto: marvell - Fix memory leaks in TDMA chain for cipher requests
      crypto: marvell - Don't chain at DMA level when backlog is disabled
      crypto: marvell - Update cache with input sg only when it is unmapped
      crypto: marvell - Don't copy IV vectors from the _process op for ciphers

 drivers/crypto/marvell/cesa.c   |    7 ++++---
 drivers/crypto/marvell/cipher.c |   25 +++++++------------------
 drivers/crypto/marvell/hash.c   |   12 ++++++------
 lib/mpi/mpicoder.c              |   14 +++++++-------
 4 files changed, 24 insertions(+), 34 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
