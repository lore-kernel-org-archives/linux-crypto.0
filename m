From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 2.6.31
Date: Sat, 13 Jun 2009 12:05:12 +1000
Message-ID: <20090613020512.GA21024@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:49307 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752767AbZFMCFR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Jun 2009 22:05:17 -0400
Content-Disposition: inline
In-Reply-To: <20090324044932.GA18245@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 2.6.31:

* 64-bit VIA crypto/RNG support.
* More operation modes added for Intel AES.
* New test vectors for CCM/CTR/RNG.
* Slight change to the compress API for squashfs.
* Talitos fixes/clean-ups.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Alex Riesen (1):
      crypto: api - Use formatting of module name

Alexander Clouter (1):
      hwrng: timeriomem - Fix potential oops (request_mem_region/__devi=
nit)

=46rank Seidel (1):
      crypto: tcrypt - Reduce stack size

Geert Uytterhoeven (3):
      crypto: testmgr - Kill test_comp() sparse warnings
      crypto: pcomp - pcompress.c should include crypto/internal/compre=
ss.h
      crypto: compress - Return produced bytes in crypto_{,de}compress_=
{update,final}

Harald Welte (3):
      hwrng: via_rng - The VIA Hardware RNG driver is for the CPU, not =
Chipset
      hwrng: via_rng - Support VIA Nano hardware RNG
      hwrng: via_rng - Support VIA Nano hardware RNG on X86_64 builds

Herbert Xu (4):
      crypto: padlock - Restore dependency on x86
      crypto: testmgr - Dynamically allocate xbuf and axbuf
      crypto: testmgr - Check all test vector lengths
      crypto: testmgr - Allow hash test vectors longer than a page

Huang Ying (3):
      crypto: cryptd - Use nivcipher in cryptd_alloc_ablkcipher
      crypto: fpu - Add template for blkcipher touching FPU
      crypto: aes-ni - Add support for more modes

Jarod Wilson (10):
      crypto: testmgr - Handle AEAD test vectors expected to fail verif=
ication
      crypto: testmgr - Add self-tests for rfc4309(ccm(aes))
      crypto: testmgr - Add infrastructure for ansi_cprng self-tests
      crypto: testmgr - Add ansi_cprng test vectors
      crypto: testmgr - Catch base cipher self-test failures in fips mo=
de
      crypto: testmgr - Print self-test pass notices in fips mode
      crypto: testmgr - Add ctr(aes) test vectors
      crypto: testmgr - Mark algs allowed in fips mode
      crypto: testmgr - Skip algs not flagged fips_allowed in fips mode
      crypto: tcrypt - Do not exit on success in fips mode

Johannes Weiner (1):
      crypto: api - Use kzfree

Kim Phillips (3):
      crypto: talitos - Whitespace/codingstyle/overrun lines cleanup
      crypto: talitos - containerof related codingstyle
      crypto: talitos - Avoid unnecessary decrypt check

Lee Nipper (2):
      crypto: talitos - scaffolding for new algorithm types
      crypto: talitos - Add ablkcipher algorithms

Mike Frysinger (1):
      crypto: hifn_795x - fix __dev{init,exit} markings

Sebastian Andrzej Siewior (1):
      crypto: padlock - Enable on x86_64

Uwe Kleine-K=F6nig (1):
      hwrng: omap - Move probe function to .devinit.text

 arch/x86/crypto/Makefile                |    2 +
 arch/x86/crypto/aesni-intel_glue.c      |  267 ++++++++++++-
 arch/x86/crypto/fpu.c                   |  166 +++++++
 crypto/Kconfig                          |   10 +
 crypto/algboss.c                        |   18 +-
 crypto/api.c                            |   14 +-
 crypto/cryptd.c                         |   14 +-
 crypto/internal.h                       |    3 -
 crypto/pcompress.c                      |    1 +
 crypto/tcrypt.c                         |  183 +++++----
 crypto/testmgr.c                        |  470 ++++++++++++++++-----
 crypto/testmgr.h                        |  645 +++++++++++++++++++++++=
+++++-
 crypto/zlib.c                           |   24 +-
 drivers/char/hw_random/Kconfig          |    2 +-
 drivers/char/hw_random/omap-rng.c       |    2 +-
 drivers/char/hw_random/timeriomem-rng.c |   26 +-
 drivers/char/hw_random/via-rng.c        |   15 +-
 drivers/crypto/Kconfig                  |    2 +-
 drivers/crypto/hifn_795x.c              |    8 +-
 drivers/crypto/padlock-aes.c            |   13 +
 drivers/crypto/talitos.c                |  713 ++++++++++++++++++++++-=
--------
 21 files changed, 2141 insertions(+), 457 deletions(-)
=20
Thanks,
--=20
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
