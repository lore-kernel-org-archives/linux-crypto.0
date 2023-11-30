Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644291B3
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 04:27:05 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r8g8B-005IHN-SW; Thu, 30 Nov 2023 20:27:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Nov 2023 20:27:09 +0800
Date: Thu, 30 Nov 2023 20:27:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH 0/19] crypto: Remove cfb and ofb
Message-ID: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This patch series removes the unused algorithms cfb and ofb.  The
rule for kernel crypto algorithms is that there must be at least
one in-kernel user.  CFB used to have a user but it has now gone
away.  OFB never had any user.

Herbert Xu (19):
  crypto: arm64/sm4 - Remove cfb(sm4)
  crypto: x86/sm4 - Remove cfb(sm4)
  crypto: crypto4xx - Remove cfb and ofb
  crypto: aspeed - Remove cfb and ofb
  crypto: atmel - Remove cfb and ofb
  crypto: cpt - Remove cfb
  crypto: nitrox - Remove cfb
  crypto: ccp - Remove cfb and ofb
  crypto: hifn_795x - Remove cfb and ofb
  crypto: hisilicon/sec2 - Remove cfb and ofb
  crypto: safexcel - Remove cfb and ofb
  crypto: octeontx - Remove cfb
  crypto: n2 - Remove cfb
  crypto: starfive - Remove cfb and ofb
  crypto: bcm - Remove ofb
  crypto: ccree - Remove ofb
  crypto: tcrypt - Remove cfb and ofb
  crypto: testmgr - Remove cfb and ofb
  crypto: cfb,ofb - Remove cfb and ofb

 arch/arm64/crypto/Kconfig                     |    6 +-
 arch/arm64/crypto/sm4-ce-core.S               |  158 ---
 arch/arm64/crypto/sm4-ce-glue.c               |  108 +-
 arch/arm64/crypto/sm4-ce.h                    |    3 -
 arch/arm64/crypto/sm4-neon-core.S             |  113 --
 arch/arm64/crypto/sm4-neon-glue.c             |  105 +-
 arch/x86/crypto/Kconfig                       |    8 +-
 arch/x86/crypto/sm4-aesni-avx-asm_64.S        |   52 -
 arch/x86/crypto/sm4-aesni-avx2-asm_64.S       |   55 -
 arch/x86/crypto/sm4-avx.h                     |    4 -
 arch/x86/crypto/sm4_aesni_avx2_glue.c         |   26 -
 arch/x86/crypto/sm4_aesni_avx_glue.c          |  130 --
 crypto/Kconfig                                |   23 -
 crypto/Makefile                               |    2 -
 crypto/cfb.c                                  |  254 ----
 crypto/ofb.c                                  |  106 --
 crypto/tcrypt.c                               |   76 --
 crypto/testmgr.c                              |   39 -
 crypto/testmgr.h                              | 1148 -----------------
 drivers/crypto/amcc/crypto4xx_alg.c           |   14 -
 drivers/crypto/amcc/crypto4xx_core.c          |   40 -
 drivers/crypto/amcc/crypto4xx_core.h          |    4 -
 drivers/crypto/aspeed/Kconfig                 |    4 +-
 drivers/crypto/aspeed/aspeed-hace-crypto.c    |  230 ----
 drivers/crypto/atmel-aes.c                    |  214 +--
 drivers/crypto/atmel-tdes.c                   |  205 +--
 drivers/crypto/bcm/cipher.c                   |   57 -
 drivers/crypto/cavium/cpt/cptvf_algs.c        |   24 -
 .../crypto/cavium/nitrox/nitrox_skcipher.c    |   19 -
 drivers/crypto/ccp/ccp-crypto-aes.c           |   18 -
 drivers/crypto/ccree/cc_cipher.c              |   35 -
 drivers/crypto/hifn_795x.c                    |  126 +-
 drivers/crypto/hisilicon/sec2/sec_crypto.c    |   24 -
 drivers/crypto/inside-secure/safexcel.c       |    4 -
 drivers/crypto/inside-secure/safexcel.h       |    4 -
 .../crypto/inside-secure/safexcel_cipher.c    |  152 ---
 .../crypto/marvell/octeontx/otx_cptvf_algs.c  |   23 -
 drivers/crypto/n2_core.c                      |   27 +-
 drivers/crypto/starfive/jh7110-aes.c          |   62 -
 39 files changed, 21 insertions(+), 3681 deletions(-)
 delete mode 100644 crypto/cfb.c
 delete mode 100644 crypto/ofb.c

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
