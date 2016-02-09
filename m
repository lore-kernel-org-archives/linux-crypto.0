From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.5
Date: Tue, 9 Feb 2016 18:54:11 +0100
Message-ID: <20160209175411.GA13330@gondor.apana.org.au>
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

This push fixes the following issues:

API:

* Fix async algif_skcipher, it was broken by recent fixes.
* Fix potential race condition in algif_skcipher with ctx.
* Fix potential memory corruption in algif_skcipher.
* Add missing lock to crypto_user when doing an alg dump.

Drivers:

* marvell/cesa was testing the wrong variable for NULL after
  allocation.
* Fix potential double-free in atmel-sha.
* Fix illegal call to sleepin function from atomic context in
  atmel-sha.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Boris BREZILLON (1):
      crypto: marvell/cesa - fix test in mv_cesa_dev_dma_init()

Cyrille Pitchen (2):
      crypto: atmel-sha - fix atmel_sha_remove()
      crypto: atmel-sha - remove calls of clk_prepare() from atomic contexts

Herbert Xu (3):
      crypto: algif_skcipher - Do not assume that req is unchanged
      crypto: algif_skcipher - Do not dereference ctx without socket lock
      crypto: algif_skcipher - Do not set MAY_BACKLOG on the async path

Mathias Krause (1):
      crypto: user - lock crypto_alg_list on alg dump

 crypto/algif_skcipher.c       |   80 +++++++++++++++++++++--------------------
 crypto/crypto_user.c          |    6 +++-
 drivers/crypto/atmel-sha.c    |   23 ++++++------
 drivers/crypto/marvell/cesa.c |    2 +-
 4 files changed, 60 insertions(+), 51 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
