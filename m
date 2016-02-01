From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.5
Date: Mon, 1 Feb 2016 16:31:58 +0800
Message-ID: <20160201083158.GA6009@gondor.apana.org.au>
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47131 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbcBAIcI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 03:32:08 -0500
Content-Disposition: inline
In-Reply-To: <20160122101828.GA15966@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

API:

* algif_hash needs to wait for init operations to complete.
* The has_key setting for shash was always true.

Algorithms:

* Add missing selections of CRYPTO_HASH.
* Fix pkcs7 authentication.

Drivers:

* Fix stack alignment bug in chacha20-ssse3.
* Fix performance regression in caam due to incorrect setting.
* Fix potential compile-only build failure of stm32.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Arnd Bergmann (1):
      crypto: ghash,poly1305 - select CRYPTO_HASH where needed

Cyrille Pitchen (1):
      crypto: atmel-aes - remove calls of clk_prepare() from atomic contexts

Eli Cooper (1):
      crypto: chacha20-ssse3 - Align stack pointer to 64 bytes

Herbert Xu (1):
      crypto: shash - Fix has_key setting

Horia Geant? (1):
      crypto: caam - make write transactions bufferable on PPC platforms

Peter Jones (1):
      PKCS#7: Don't require SpcSpOpusInfo in Authenticode pkcs7 signatures

Richard Weinberger (1):
      hwrng: stm32 - Fix dependencies for !HAS_IOMEM archs

Wang, Rui Y (1):
      crypto: algif_hash - wait for crypto_ahash_init() to complete

 arch/x86/crypto/chacha20-ssse3-x86_64.S |    6 ++++--
 crypto/Kconfig                          |    2 ++
 crypto/algif_hash.c                     |    4 +++-
 crypto/asymmetric_keys/pkcs7_parser.c   |    4 +---
 crypto/shash.c                          |    7 +++----
 drivers/char/hw_random/Kconfig          |    1 +
 drivers/crypto/atmel-aes.c              |   16 ++++++++++++----
 drivers/crypto/caam/ctrl.c              |    4 ++--
 8 files changed, 28 insertions(+), 16 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
