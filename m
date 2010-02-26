From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 2.6.34
Date: Fri, 26 Feb 2010 08:49:14 +0800
Message-ID: <20100226004914.GA20812@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48968 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934755Ab0BZAtX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2010 19:49:23 -0500
Content-Disposition: inline
In-Reply-To: <20091204135530.GA29371@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 2.6.34:

* New pcrypt module to spread crypto work across CPUs.
* Added RFC4543 GCM support.
* Added nomadik RNG driver.
* MD5 export/import support.
* Random fixes.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git


Alessandro Rubini (2):
      hwrng: nomadik - Add hardware RNG driver
      hwrng: nomadik - Add platform device for rng in cpu-8815

Max Vozeler (1):
      crypto: md5 - Add export support

M=E1rton N=E9meth (1):
      crypto: Make Open Firmware device id constant

Richard Hartmann (19):
      crypto: ablkcipher - Fix checkpatch errors
      crypto: aead - Fix checkpatch errors
      crypto: blowfish - Fix checkpatch errors
      crypto: algapi - Fix checkpatch errors
      crypto: anubis - Fix checkpatch errors
      crypto: api - Fix checkpatch errors
      crypto: authenc - Fix checkpatch errors
      crypto: camellia - Fix checkpatch errors
      crypto: cast5 - Fix checkpatch errors
      crypto: cast6 - Fix checkpatch errors
      crypto: compress - Fix checkpatch errors
      crypto: crc32 - Fix checkpatch errors
      crypto: cipher - Fix checkpatch errors
      crypto: crypto_null - Fix checkpatch errors
      crypto: deflate - Fix checkpatch errors
      crypto: des_generic - Fix checkpatch errors
      crypto: ecb - Fix checkpatch errors
      crypto: fcrypt - Fix checkpatch errors
      crypto: aes_generic - Fix checkpatch errors

Roel Kluin (3):
      crypto: aes_s390 - access .cip instead of .blk in cipher mode
      crypto: geode-aes - access .cip instead of .blk in cipher mode
      crypto: geode-aes - Fix cip/blk confusion

Steffen Klassert (3):
      padata: Generic parallelization/serialization interface
      crypto: pcrypt - Add pcrypt crypto parallelization wrapper
      crypto: pcrypt - call the complete function on error

Tobias Brunner (1):
      crypto: gcm - Add RFC4543 wrapper for GCM

Youquan, Song (1):
      crypto: testmgr - Fix complain about lack test for internal used =
algorithm

 arch/arm/mach-nomadik/cpu-8815.c     |    8 +
 arch/s390/crypto/aes_s390.c          |    6 +-
 crypto/Kconfig                       |   10 +
 crypto/Makefile                      |    1 +
 crypto/ablkcipher.c                  |    4 +-
 crypto/aead.c                        |    4 +-
 crypto/aes_generic.c                 |    4 +-
 crypto/algapi.c                      |    4 +-
 crypto/anubis.c                      |   22 +-
 crypto/api.c                         |   13 +-
 crypto/authenc.c                     |   10 +-
 crypto/blowfish.c                    |   18 +-
 crypto/camellia.c                    |  616 +++++++++++++++-----------=
----
 crypto/cast5.c                       |   14 +-
 crypto/cast6.c                       |  122 +++---
 crypto/cipher.c                      |    2 +-
 crypto/compress.c                    |    4 +-
 crypto/crc32c.c                      |    6 +-
 crypto/crypto_null.c                 |    8 +-
 crypto/deflate.c                     |   20 +-
 crypto/des_generic.c                 |    3 +-
 crypto/ecb.c                         |    2 +-
 crypto/fcrypt.c                      |    6 +-
 crypto/gcm.c                         |  287 ++++++++++++++
 crypto/md5.c                         |   40 ++-
 crypto/pcrypt.c                      |  445 ++++++++++++++++++++++
 crypto/testmgr.c                     |   84 ++++
 drivers/char/hw_random/Kconfig       |   12 +
 drivers/char/hw_random/Makefile      |    1 +
 drivers/char/hw_random/nomadik-rng.c |  103 +++++
 drivers/crypto/amcc/crypto4xx_core.c |    2 +-
 drivers/crypto/geode-aes.c           |    8 +-
 drivers/crypto/talitos.c             |    2 +-
 include/crypto/md5.h                 |   17 +
 include/crypto/pcrypt.h              |   51 +++
 include/linux/padata.h               |   88 +++++
 include/linux/pfkeyv2.h              |    1 +
 init/Kconfig                         |    4 +
 kernel/Makefile                      |    1 +
 kernel/padata.c                      |  690 ++++++++++++++++++++++++++=
++++++++
 net/xfrm/xfrm_algo.c                 |   16 +
 41 files changed, 2293 insertions(+), 466 deletions(-)

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
