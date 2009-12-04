From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 2.6.33
Date: Fri, 4 Dec 2009 21:55:30 +0800
Message-ID: <20091204135530.GA29371@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40864 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751024AbZLDNzb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 4 Dec 2009 08:55:31 -0500
Content-Disposition: inline
In-Reply-To: <20090324044932.GA18245@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 2.6.33:

* Removal of legacy hash code.
* New ghash (part of GCM) driver using Intel hardware support.
* Hardware RNG driver API update.
* Random fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Benjamin Gilbert (3):
      crypto: hash - Remove legacy hash/digest code
      crypto: api - Remove digest case from procfs show handler
      crypto: hash - Remove cra_u.{digest,hash}

Felipe Contreras (1):
      crypto: testmgr - Fix warning

Herbert Xu (2):
      crypto: ghash-intel - Hard-code pshufb
      crypto: ghash-intel - Add PSHUFB macros

Huang Ying (6):
      crypto: ghash - Add PCLMULQDQ accelerated implementation
      crypto: ghash-intel - Fix building failure on x86_32
      crypto: ghash-intel - Fix irq_fpu_usable usage
      x86: Generate .byte code for some new instructions via gas macro
      crypto: aesni-intel - Use gas macro for AES-NI instructions
      crypto: ghash-clmulni-intel - Use gas macro for PCLMULQDQ-NI and PSHUFB

Ian Molton (3):
      hwrng: virtio-rng - Convert to new API
      hwrng: core - Prevent too-small buffer sizes
      hwrng: core - Replace u32 in driver API with byte array

Jaswinder Singh Rajput (1):
      crypto: ansi_cprng - Move FIPS functions under CONFIG_CRYPTO_FIPS

Jiri Kosina (1):
      crypto: ghash-clmulni-intel - Put proper .data section in place

Neil Horman (1):
      crypto: ansi_cprng - Add FIPS wrapper

Roel Kluin (1):
      crypto: ansi_cprng - Fix test in get_prng_bytes

Youquan, Song (1):
      crypto: testmgr - Add ghash algorithm test before provide to users

 arch/x86/crypto/Makefile                   |    3 
 arch/x86/crypto/aesni-intel_asm.S          |  517 +++++++++--------------------
 arch/x86/crypto/ghash-clmulni-intel_asm.S  |  157 ++++++++
 arch/x86/crypto/ghash-clmulni-intel_glue.c |  333 ++++++++++++++++++
 arch/x86/include/asm/cpufeature.h          |    1 
 arch/x86/include/asm/i387.h                |    7 
 arch/x86/include/asm/inst.h                |  150 ++++++++
 crypto/Kconfig                             |    9 
 crypto/ansi_cprng.c                        |   82 +++-
 crypto/cryptd.c                            |    7 
 crypto/digest.c                            |  240 -------------
 crypto/hash.c                              |  183 ----------
 crypto/proc.c                              |    7 
 crypto/testmgr.c                           |   11 
 crypto/testmgr.h                           |   15 
 drivers/char/hw_random/core.c              |  110 +++---
 drivers/char/hw_random/virtio-rng.c        |   78 +---
 include/crypto/algapi.h                    |    1 
 include/crypto/cryptd.h                    |    1 
 include/linux/crypto.h                     |   27 -
 include/linux/hw_random.h                  |    7 
 21 files changed, 1034 insertions(+), 912 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
