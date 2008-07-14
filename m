From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 2.6.27
Date: Mon, 14 Jul 2008 20:14:03 +0800
Message-ID: <20080714121403.GA28523__26538.106139242$1216037759$gmane$org@gondor.apana.org.au>
References: <20080421024306.GA6813@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43368 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751998AbYGNMOM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Jul 2008 08:14:12 -0400
Content-Disposition: inline
In-Reply-To: <20080421024306.GA6813@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 2.6.27:

The biggest change is the introduction of the new hash interface
that is capable of supporting asynchronous implementations as well
as reentrancy.  There is quite a bit of driver work too in terms
of new hardware support and a lot of hifn fixes.  On the algorithms
side the RIPEMD family (of hash functions) makes a debut.  There
is also a new CPRNG which has been added for the use of IPsec.
And last but not least crc32c has been converted over to the new
hash interface in preparation for an Intel-specific implementation.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Adrian-Ken Rueegsegger (11):
      [CRYPTO] ripemd: Add support for RIPEMD hash algorithms
      [CRYPTO] tcrypt: Add test vectors for RIPEMD-128 and RIPEMD-160
      [CRYPTO] ripemd: Add Kconfig entries for RIPEMD hash algorithms
      [CRYPTO] ripemd: Put all common RIPEMD values in header file
      [CRYPTO] ripemd: Add support for RIPEMD-256 and RIPEMD-320
      [CRYPTO] tcrypt: Add test vectors for RIPEMD-256 and RIPEMD-320
      [CRYPTO] ripemd: Add Kconfig entries for extended RIPEMD hash algorithms
      [CRYPTO] rmd128: Fix endian problems
      [CRYPTO] rmd160: Fix endian issues
      [CRYPTO] rmd256: Fix endian issues
      [CRYPTO] rmd320: Fix endian issues

Christian Hohnstaedt (1):
      crypto: ixp4xx - Hardware crypto support for IXP4xx CPUs

Harvey Harrison (3):
      crypto: camellia - Use kernel-provided bitops, unaligned access helpers
      crypto: rmd128 - sparse annotations
      crypto: rmd - sparse annotations

Herbert Xu (10):
      [CRYPTO] cryptd: Fix EINPROGRESS notification context
      [CRYPTO] tcrpyt: Get rid of change log in source
      [CRYPTO] rmd: Use pointer form of endian swapping operations
      crypto: tcrpyt - Remove unnecessary kmap/kunmap calls
      crypto: talitos - Use proper form for algorithm driver names
      crypto: hash - Fixed digest size check
      crypto: hash - Removed vestigial ahash fields
      crypto: hash - Added scatter list walking helper
      crypto: crc32c - Add ahash implementation
      crypto: hash - Move ahash functions into crypto/hash.h

Huang Weiyi (1):
      [CRYPTO] hifn: Remove duplicated include

Imre Kaloz (1):
      crypto: ixp4xx - Select CRYPTO_AUTHENC

Jan Glauber (1):
      crypto: s390 - Respect STFL bit

Jeremy Katz (1):
      crypto: padlock - Make module loading quieter when hardware isn't available

Kim Phillips (1):
      crypto: talitos - Freescale integrated security engine (SEC) driver

Lee Nipper (2):
      crypto: talitos - Add support for 3des
      crypto: talitos - Add support for sha256 and md5 variants

Loc Ho (3):
      [CRYPTO] hash: Add asynchronous hash support
      [CRYPTO] cryptd: Add asynchronous hash support
      [CRYPTO] tcrypt: Use asynchronous hash interface

Neil Horman (2):
      [CRYPTO] tcrypt: Add self test for des3_ebe cipher operating in cbc mode
      crypto: prng - Deterministic CPRNG

Patrick McHardy (12):
      [HIFN]: Endianess fixes
      [HIFN]: Remove printk_ratelimit() for debugging printk
      [HIFN]: Indicate asynchronous processing to crypto API
      [HIFN]: Handle ablkcipher_walk errors
      [HIFN]: Fix data alignment checks
      [HIFN]: Properly handle requests for less than the full scatterlist
      [HIFN]: Use unique driver names for different algos
      [HIFN]: Properly initialize ivsize for CBC modes
      [HIFN]: Fix max queue length value
      [HIFN]: Move command descriptor setup to seperate function
      [HIFN]: Have HW invalidate src and dest descriptors after processing
      [CRYPTO] tcrypt: Catch cipher destination memory corruption

Robert P. J. Day (1):
      [CRYPTO] hifn: Simplify code using ARRAY_SIZE() macro

 arch/s390/crypto/crypt_s390.h  |    4 
 crypto/Kconfig                 |   63 +
 crypto/Makefile                |    7 
 crypto/ahash.c                 |  194 ++++
 crypto/api.c                   |    8 
 crypto/camellia.c              |   84 --
 crypto/crc32c.c                |  128 +++
 crypto/cryptd.c                |  253 ++++++
 crypto/digest.c                |   83 ++
 crypto/hash.c                  |  102 ++
 crypto/hmac.c                  |   16 
 crypto/internal.h              |    1 
 crypto/prng.c                  |  410 ++++++++++
 crypto/prng.h                  |   27 
 crypto/ripemd.h                |   43 +
 crypto/rmd128.c                |  325 ++++++++
 crypto/rmd160.c                |  369 +++++++++
 crypto/rmd256.c                |  344 ++++++++
 crypto/rmd320.c                |  393 ++++++++++
 crypto/tcrypt.c                |  188 +++-
 crypto/tcrypt.h                |  526 +++++++++++++
 drivers/crypto/Kconfig         |   26 
 drivers/crypto/Makefile        |    2 
 drivers/crypto/hifn_795x.c     |  367 ++++-----
 drivers/crypto/ixp4xx_crypto.c | 1506 ++++++++++++++++++++++++++++++++++++++
 drivers/crypto/padlock-aes.c   |    4 
 drivers/crypto/padlock-sha.c   |    4 
 drivers/crypto/talitos.c       | 1597 +++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/talitos.h       |  199 +++++
 include/crypto/hash.h          |  154 +++
 include/crypto/internal/hash.h |   78 ++
 include/linux/crypto.h         |   48 +
 32 files changed, 7227 insertions(+), 326 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
