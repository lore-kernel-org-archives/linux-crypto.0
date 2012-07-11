From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 00/14] crypto: cleanup - alg and shash init/exit cleanups and
 remove unneeded cra_list initializations
Date: Wed, 11 Jul 2012 14:19:50 +0300
Message-ID: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:40487 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2GKLT6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Jul 2012 07:19:58 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patches 1-5 change various cipher modules to use new crypto_register_algs and
crypto_unregister_algs.

Patch 6 adds new crypto_register_shashes and crypto_unregister_shashes
functions for registering multiple shash algorithms at same time.

Patches 7-10 change various shash modules to use new crypto_register_shashes
and crypto_unregister_shashes.

Patches 11-14 remove unneeded .cra_list initializations.

---

Jussi Kivilinna (14):
      crypto: tea - use crypto_[un]register_algs
      crypto: crypto_null - use crypto_[un]register_algs
      crypto: des - use crypto_[un]register_algs
      crypto: serpent - use crypto_[un]register_algs
      crypto: ansi_cprng - use crypto_[un]register_algs
      crypto: add crypto_[un]register_shashes for [un]registering multiple shash entries at once
      crypto: tiger - use crypto_[un]register_shashes
      crypto: sha256 - use crypto_[un]register_shashes
      crypto: sha512 - use crypto_[un]register_shashes
      crypto: whirlpool - use crypto_[un]register_shashes
      crypto: cleanup - remove unneeded crypto_alg.cra_list initializations
      crypto: arch/x86 - cleanup - remove unneeded crypto_alg.cra_list initializations
      crypto: drivers - remove cra_list initialization
      crypto: arch/s390 - cleanup - remove unneeded cra_list initialization


 arch/s390/crypto/aes_s390.c                |    5 --
 arch/s390/crypto/des_s390.c                |   10 ----
 arch/s390/crypto/ghash_s390.c              |    1 
 arch/x86/crypto/aes_glue.c                 |    1 
 arch/x86/crypto/aesni-intel_glue.c         |    5 --
 arch/x86/crypto/blowfish_glue.c            |    4 --
 arch/x86/crypto/camellia_glue.c            |    6 ---
 arch/x86/crypto/ghash-clmulni-intel_glue.c |    2 -
 arch/x86/crypto/salsa20_glue.c             |    1 
 arch/x86/crypto/serpent_avx_glue.c         |   10 ----
 arch/x86/crypto/serpent_sse2_glue.c        |   10 ----
 arch/x86/crypto/twofish_avx_glue.c         |   10 ----
 arch/x86/crypto/twofish_glue.c             |    1 
 arch/x86/crypto/twofish_glue_3way.c        |    5 --
 crypto/aes_generic.c                       |    1 
 crypto/ansi_cprng.c                        |   63 ++++++++++------------------
 crypto/anubis.c                            |    1 
 crypto/blowfish_generic.c                  |    1 
 crypto/camellia_generic.c                  |    1 
 crypto/cast5.c                             |    1 
 crypto/cast6.c                             |    1 
 crypto/crypto_null.c                       |   57 ++++++++-----------------
 crypto/deflate.c                           |    1 
 crypto/des_generic.c                       |   25 ++---------
 crypto/fcrypt.c                            |    1 
 crypto/ghash-generic.c                     |    1 
 crypto/khazad.c                            |    1 
 crypto/krng.c                              |    1 
 crypto/lzo.c                               |    1 
 crypto/salsa20_generic.c                   |    1 
 crypto/seed.c                              |    1 
 crypto/serpent_generic.c                   |   53 ++++++++----------------
 crypto/sha256_generic.c                    |   25 ++---------
 crypto/sha512_generic.c                    |   20 ++-------
 crypto/shash.c                             |   36 ++++++++++++++++
 crypto/tea.c                               |   41 +++---------------
 crypto/tgr192.c                            |   38 +++--------------
 crypto/twofish_generic.c                   |    1 
 crypto/wp512.c                             |   39 +++--------------
 drivers/crypto/atmel-aes.c                 |    2 -
 drivers/crypto/atmel-tdes.c                |    1 
 drivers/crypto/geode-aes.c                 |    3 -
 drivers/crypto/nx/nx-aes-cbc.c             |    1 
 drivers/crypto/nx/nx-aes-ccm.c             |    2 -
 drivers/crypto/nx/nx-aes-ctr.c             |    2 -
 drivers/crypto/nx/nx-aes-ecb.c             |    1 
 drivers/crypto/nx/nx-aes-gcm.c             |    2 -
 drivers/crypto/omap-aes.c                  |    1 
 drivers/crypto/padlock-aes.c               |    3 -
 drivers/crypto/s5p-sss.c                   |    1 
 drivers/crypto/tegra-aes.c                 |    2 -
 include/crypto/internal/hash.h             |    2 +
 52 files changed, 132 insertions(+), 374 deletions(-)
