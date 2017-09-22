From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Fixes for 4.14
Date: Fri, 22 Sep 2017 16:44:01 +0800
Message-ID: <20170922084401.GA15541@gondor.apana.org.au>
References: <20161119102748.GA4277@gondor.apana.org.au>
 <20161213132414.GA7898@gondor.apana.org.au>
 <20170223125141.GA17400@gondor.apana.org.au>
 <20170714141855.GA29426@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170714141855.GA29426@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Linus: 

This push fixes the following issues:

- Fix compiler warnings in inside-secure.
- Fix LS1021A support in caam.
- Avoid using RBP in x86 crypto code.
- Fix bug in talitos that prevents hashing with algif.
- Fix bugs talitos hashing code that cause incorrect hash result.
- Fix memory freeing path bug in drbg.
- Fix af_alg crash when two SG lists are chained.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Arnd Bergmann (1):
      crypto: inside-secure - fix gcc-4.9 warnings

Horia Geantă (1):
      crypto: caam - fix LS1021A support on ARMv7 multiplatform kernel

Josh Poimboeuf (12):
      crypto: x86/blowfish - Fix RBP usage
      crypto: x86/camellia - Fix RBP usage
      crypto: x86/cast5 - Fix RBP usage
      crypto: x86/cast6 - Fix RBP usage
      crypto: x86/des3_ede - Fix RBP usage
      crypto: x86/sha1-avx2 - Fix RBP usage
      crypto: x86/sha1-ssse3 - Fix RBP usage
      crypto: x86/sha256-avx - Fix RBP usage
      crypto: x86/sha256-avx2 - Fix RBP usage
      crypto: x86/sha256-ssse3 - Fix RBP usage
      crypto: sha512-avx2 - Fix RBP usage
      crypto: x86/twofish - Fix RBP usage

LEROY Christophe (3):
      crypto: talitos - fix sha224
      crypto: talitos - fix hashing
      crypto: talitos - Don't provide setkey for non hmac hashing algs.

Stephan Mueller (2):
      crypto: drbg - fix freeing of resources
      crypto: af_alg - update correct dst SGL entry

 arch/x86/crypto/blowfish-x86_64-asm_64.S       |   48 ++++++++-------
 arch/x86/crypto/camellia-x86_64-asm_64.S       |   26 ++++----
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S      |   47 +++++++++------
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S      |   50 +++++++++++-----
 arch/x86/crypto/des3_ede-asm_64.S              |   15 +++--
 arch/x86/crypto/sha1_avx2_x86_64_asm.S         |    4 +-
 arch/x86/crypto/sha1_ssse3_asm.S               |   11 ++--
 arch/x86/crypto/sha256-avx-asm.S               |   15 +++--
 arch/x86/crypto/sha256-avx2-asm.S              |   22 +++----
 arch/x86/crypto/sha256-ssse3-asm.S             |   15 +++--
 arch/x86/crypto/sha512-avx2-asm.S              |   75 ++++++++++++------------
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S    |   12 ++--
 crypto/af_alg.c                                |    4 +-
 crypto/drbg.c                                  |    8 +--
 drivers/crypto/caam/Kconfig                    |    5 +-
 drivers/crypto/caam/ctrl.c                     |   19 +++---
 drivers/crypto/caam/regs.h                     |   59 +++++++++----------
 drivers/crypto/inside-secure/safexcel_cipher.c |    2 +-
 drivers/crypto/inside-secure/safexcel_hash.c   |    2 +-
 drivers/crypto/talitos.c                       |    9 +--
 20 files changed, 236 insertions(+), 212 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
