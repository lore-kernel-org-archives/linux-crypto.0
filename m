From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 2.6.24
Date: Wed, 10 Oct 2007 11:17:29 +0800
Message-ID: <20071010031729.GA26697@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "David S. Miller" <davem@davemloft.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-ker
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2913 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750739AbXJJDRi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Oct 2007 23:17:38 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

Here is the crypto update for 2.6.24:

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

Summary:

* Added SEED algorithm.
* Added XTS block cipher mode.
* Added new aead type (essentially blkcipher + hash).
* Added authenc wrapper as first aead algorithm.
* Preparatory work for CTR (Counter) mode support.
* Better loading of optimised algorithm modules.


Adrian Bunk (2):
      [CRYPTO] Kconfig: Remove "default m"s
      [CRYPTO] drivers/Kconfig: Remove "default m"s

Herbert Xu (15):
      [CRYPTO] api: Add aead crypto type
      [CRYPTO] api: Add support for multiple template parameters
      [CRYPTO] api: Add missing headers for setkey_unaligned
      [CRYPTO] ablkcipher: Remove queue pointer from common alg object
      [CRYPTO] api: Move scatterwalk into algapi
      [CRYPTO] scatterwalk: Add scatterwalk_map_and_copy
      [CRYPTO] api: Fixed crypto_*_reqsize return type
      [CRYPTO] aead: Add authenc
      [CRYPTO] api: Kill crypto_km_types
      [CRYPTO] cryptomgr: Fix parsing of recursive algorithms
      [CRYPTO] authenc: Kill spaces in algorithm names
      [CRYPTO] blkcipher: Remove alignment restriction on block size
      [CRYPTO] api: Explain the comparison on larval cra_name
      [CRYPTO] blkcipher: Increase kmalloc amount to aligned block size
      [CRYPTO] blkcipher: Added blkcipher_walk_virt_block

Hye-Shik Chang (1):
      [CRYPTO] seed: New cipher algorithm

Ingo Oeser (1):
      [CRYPTO] blkcipher: Use max() in blkcipher_get_spot() to state the intention

Jan Glauber (1):
      [CRYPTO] sha: Add header file for SHA definitions

Rik Snel (1):
      [CRYPTO] xts: XTS blockcipher mode implementation without partial blocks

Sebastian Siewior (4):
      [CRYPTO] api: Add crypto_ablkcipher_ctx_aligned
      [CRYPTO] des: Rename des to des-generic
      [CRYPTO] aes: Rename aes to aes-generic
      [CRYPTO] sha: Load the SHA[1|256] module by an alias

 arch/s390/crypto/aes_s390.c      |    2 
 arch/s390/crypto/sha1_s390.c     |   16 
 arch/s390/crypto/sha256_s390.c   |   22 
 crypto/Kconfig                   |   40 +
 crypto/Makefile                  |   16 
 crypto/ablkcipher.c              |    9 
 crypto/aead.c                    |  101 +++
 crypto/aes.c                     |  456 -----------------
 crypto/aes_generic.c             |  456 +++++++++++++++++
 crypto/algapi.c                  |   37 +
 crypto/authenc.c                 |  400 +++++++++++++++
 crypto/blkcipher.c               |   57 +-
 crypto/cipher.c                  |    5 
 crypto/cryptd.c                  |    7 
 crypto/cryptomgr.c               |   96 ++-
 crypto/des.c                     | 1011 --------------------------------------
 crypto/des_generic.c             | 1012 +++++++++++++++++++++++++++++++++++++++
 crypto/gf128mul.c                |   11 
 crypto/hash.c                    |    3 
 crypto/internal.h                |   11 
 crypto/scatterwalk.c             |   30 -
 crypto/scatterwalk.h             |    3 
 crypto/seed.c                    |  479 ++++++++++++++++++
 crypto/sha1.c                    |  142 -----
 crypto/sha1_generic.c            |  140 +++++
 crypto/sha256.c                  |  342 -------------
 crypto/sha256_generic.c          |  331 ++++++++++++
 crypto/sha512.c                  |   63 --
 crypto/tcrypt.c                  |   20 
 crypto/tcrypt.h                  |  507 +++++++++++++++++++
 crypto/xts.c                     |  292 +++++++++++
 drivers/crypto/Kconfig           |    5 
 drivers/crypto/geode-aes.c       |    1 
 drivers/crypto/padlock-aes.c     |    4 
 drivers/crypto/padlock-sha.c     |   53 --
 include/crypto/algapi.h          |   73 ++
 include/crypto/gf128mul.h        |    2 
 include/crypto/sha.h             |   53 ++
 include/linux/crypto.h           |  214 ++++++++
 39 files changed, 4366 insertions(+), 2156 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
