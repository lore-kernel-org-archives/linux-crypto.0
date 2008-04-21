From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Crypto Update for 2.6.26
Date: Mon, 21 Apr 2008 10:43:06 +0800
Message-ID: <20080421024306.GA6813@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-cry
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39464 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753540AbYDUCnO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Apr 2008 22:43:14 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Linus:

Here is the crypto update for 2.6.26:

We have just one new algorithm this time with CTS (Cipher Text
Stealing).  Apart from that it's mostly clean-ups and code
reorganisation.  Most notbaliy tcrypt is now much smaller in
size thanks to Sebastian Siewior's work.

Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

or

master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

Alexey Dobriyan (1):
      [CRYPTO] api: Switch to proc_create()

David Brownell (1):
      [HWRNG] omap: Minor updates

Jan Engelhardt (1):
      [CRYPTO] api: Constify function pointer tables

Jan Glauber (4):
      [CRYPTO] s390: Generic sha_update and sha_final
      [CRYPTO] sha512: Hardware acceleration for s390
      [CRYPTO] sha384: Hardware acceleration for s390
      [CRYPTO] sha512: Rename sha512 to sha512_generic

Kamalesh Babulal (1):
      [CRYPTO] all: Clean up init()/fini()

Kevin Coffman (1):
      [CRYPTO] cts: Add CTS mode required for Kerberos AES support

Marcin Slusarz (1):
      [CRYPTO] lrw: Replace all adds to big endians variables with be*_add_cpu

Sebastian Siewior (10):
      [CRYPTO] tcrypt: Group common speed templates
      [CRYPTO] tcrypt: Shrink speed templates
      [CRYPTO] aes-x86-32: Remove unused return code
      [CRYPTO] tcrypt: Change the usage of the test vectors
      [CRYPTO] tcrypt: Shrink the tcrypt module
      [CRYPTO] tcrypt: Change the XTEA test vectors
      [CRYPTO] api: Make the crypto subsystem fully modular
      [CRYPTO] aes: Export generic setkey
      [CRYPTO] padlock-aes: Use generic setkey function
      [CRYPTO] kconfig: Ordering cleanup

 arch/s390/crypto/Makefile         |    5 
 arch/s390/crypto/crypt_s390.h     |    2 
 arch/s390/crypto/sha.h            |   35 
 arch/s390/crypto/sha1_s390.c      |   91 
 arch/s390/crypto/sha256_s390.c    |   90 
 arch/s390/crypto/sha512_s390.c    |  114 
 arch/s390/crypto/sha_common.c     |   97 
 arch/x86/crypto/aes-i586-asm_32.S |    3 
 crypto/Kconfig                    |  638 +-
 crypto/Makefile                   |    6 
 crypto/aes_generic.c              |   56 
 crypto/anubis.c                   |    8 
 crypto/api.c                      |    3 
 crypto/blowfish.c                 |    8 
 crypto/cast5.c                    |    8 
 crypto/cast6.c                    |    8 
 crypto/crc32c.c                   |    8 
 crypto/crypto_null.c              |    8 
 crypto/cts.c                      |  347 +
 crypto/deflate.c                  |    8 
 crypto/des_generic.c              |    8 
 crypto/fcrypt.c                   |    8 
 crypto/khazad.c                   |    8 
 crypto/lrw.c                      |    5 
 crypto/lzo.c                      |    8 
 crypto/md4.c                      |    8 
 crypto/md5.c                      |    8 
 crypto/proc.c                     |    8 
 crypto/salsa20_generic.c          |    8 
 crypto/serpent.c                  |    8 
 crypto/sha1_generic.c             |    8 
 crypto/sha256_generic.c           |    8 
 crypto/sha512.c                   |  305 
 crypto/sha512_generic.c           |  306 
 crypto/tcrypt.c                   |  529 -
 crypto/tcrypt.h                   |11923 +++++++++++++++++++-------------------
 crypto/tea.c                      |    8 
 crypto/tgr192.c                   |    8 
 crypto/twofish.c                  |    8 
 crypto/wp512.c                    |    8 
 drivers/char/hw_random/omap-rng.c |   26 
 drivers/crypto/Kconfig            |   14 
 drivers/crypto/padlock-aes.c      |  320 -
 include/crypto/aes.h              |    8 
 include/linux/crypto.h            |    7 
 45 files changed, 7710 insertions(+), 7396 deletions(-)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
