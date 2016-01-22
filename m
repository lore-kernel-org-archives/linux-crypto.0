From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.5
Date: Fri, 22 Jan 2016 18:18:28 +0800
Message-ID: <20160122101828.GA15966@gondor.apana.org.au>
References: <20140605062336.GA14440@gondor.apana.org.au>
 <20140804130339.GA1178@gondor.apana.org.au>
 <20141007131826.GA29688@gondor.apana.org.au>
 <20141211125119.GA12380@gondor.apana.org.au>
 <20150214094328.GA7457@gondor.apana.org.au>
 <20150415033951.GA1406@gondor.apana.org.au>
 <20150622084457.GA7806@gondor.apana.org.au>
 <20150831135655.GA2694@gondor.apana.org.au>
 <20151102080427.GA8465@gondor.apana.org.au>
 <20160111101450.GA24044@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34696 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbcAVKSl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jan 2016 05:18:41 -0500
Content-Disposition: inline
In-Reply-To: <20160111101450.GA24044@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

This push fixes the following issues:

API:

* A large number of bug fixes for the af_alg interface, credit
goes to Dmitry Vyukov for discovering and reporting these issues.

Algorithms:

* sw842 needs to select crc32.
* The soft dependency on crc32c is now in the correct spot.

Drivers:

* The atmel AES driver needs HAS_DMA.
* The atmel AES driver was a missing break statement, fortunately
it's only a debug function.
* A number of bug fixes for the Intel qat driver.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Arnd Bergmann (1):
      lib: sw842: select crc32

Geert Uytterhoeven (1):
      crypto: CRYPTO_DEV_ATMEL_AES should depend on HAS_DMA

Herbert Xu (18):
      crypto: algif_skcipher - Require setkey before accept(2)
      crypto: af_alg - Disallow bind/setkey/... after accept(2)
      crypto: af_alg - Fix socket double-free when accept fails
      crypto: af_alg - Add nokey compatibility path
      crypto: algif_skcipher - Add nokey compatibility path
      crypto: hash - Add crypto_ahash_has_setkey
      crypto: algif_hash - Require setkey before accept(2)
      crypto: skcipher - Add crypto_skcipher_has_setkey
      crypto: algif_skcipher - Add key check exception for cipher_null
      crypto: af_alg - Allow af_af_alg_release_parent to be called on nokey path
      crypto: algif_hash - Remove custom release parent function
      crypto: algif_skcipher - Remove custom release parent function
      crypto: af_alg - Forbid bind(2) when nokey child sockets are present
      crypto: algif_hash - Fix race condition in hash_check_key
      crypto: algif_skcipher - Fix race condition in skcipher_check_key
      crypto: atmel-aes - Add missing break to atmel_aes_reg_name
      crypto: algif_skcipher - Load TX SG list after waiting
      crypto: algif_skcipher - sendmsg SG marking is off by one

Jean Delvare (1):
      crypto: crc32c - Fix crc32c soft dependency

Pingchao Yang (2):
      crypto: qat - remove to call get_sram_bar_id for qat_c3xxx
      crypto: qat - fix timeout issues

Tadeusz Struk (1):
      crypto: qat - update init_esram for C3xxx dev type

 crypto/af_alg.c                         |   55 ++++++++--
 crypto/ahash.c                          |    5 +-
 crypto/algif_hash.c                     |  165 +++++++++++++++++++++++++++--
 crypto/algif_skcipher.c                 |  172 ++++++++++++++++++++++++++++---
 crypto/crc32c_generic.c                 |    1 -
 crypto/shash.c                          |    4 +-
 crypto/skcipher.c                       |    2 +
 drivers/crypto/Kconfig                  |    1 +
 drivers/crypto/atmel-aes.c              |    1 +
 drivers/crypto/qat/qat_common/qat_hal.c |   23 +++--
 include/crypto/hash.h                   |    6 ++
 include/crypto/if_alg.h                 |   11 +-
 include/crypto/skcipher.h               |    7 ++
 lib/Kconfig                             |    2 +
 lib/libcrc32c.c                         |    1 +
 15 files changed, 411 insertions(+), 45 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
