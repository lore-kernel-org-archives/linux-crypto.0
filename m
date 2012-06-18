From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 00/11] crypto: x86 - split common glue code into helper modules
Date: Mon, 18 Jun 2012 14:06:53 +0300
Message-ID: <20120618110652.28985.70075.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:58322 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2FRLG4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jun 2012 07:06:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently several block-ciphers in arch/x86/crypto duplicate glue code for using
assembler implementations that process multiple blocks parallel. This patchset
adds shared glue_helper module for these 128bit cipher modules to use.

Downside of generalisation of glue code is slightly increased overhead. Tcrypt
test results of camellia-x86_64, twofish-x86_64-3way and serpent-sse2 (new/old
ratio, average of ecb, cbc, ctr):

            camellia  twofish   serpent
  16 bytes: 0.926x    0.945x    0.980x
  64 bytes: 0.977x    0.968x    0.982x
 256 bytes: 0.980x    0.984x    0.982x
1024 bytes: 0.987x    0.992x    0.985x
4096 bytes: 0.988x    0.993x    0.985x

For ciphers utilising SSE/AVX instructions, shared ablk_helper module is added
for registering async-ciphers.

---

Jussi Kivilinna (11):
      crypto: ablk_helper - move ablk_* functions from serpent-sse2/avx glue code to shared module
      crypto: twofish-avx - change to use shared ablk_* functions
      crypto: aes_ni - change to use shared ablk_* functions
      crypto: serpent-sse2 - prepare serpent-sse2 glue code into generic x86 glue code for 128bit block ciphers
      crypto: serpent-sse2 - split generic glue code to new helper module
      crypto: serpent-avx: remove duplicated glue code and use shared glue code from glue_helper
      crypto: camellia-x86_64 - remove duplicated glue code and use shared glue code from glue_helper
      crypto: twofish-x86_64-3way - remove duplicated glue code and use shared glue code from glue_helper
      crypto: twofish-avx - remove duplicated glue code and use shared glue code from glue_helper
      crypto: move arch/x86/include/asm/serpent-{sse2|avx}.h to arch/x86/include/asm/crypto/
      crypto: move arch/x86/include/asm/aes.h to arch/x86/include/asm/crypto/


 arch/x86/crypto/Makefile                   |    3 
 arch/x86/crypto/ablk_helper.c              |  149 ++++++
 arch/x86/crypto/aes_glue.c                 |    2 
 arch/x86/crypto/aesni-intel_glue.c         |  102 ----
 arch/x86/crypto/camellia_glue.c            |  355 ++++-----------
 arch/x86/crypto/glue_helper.c              |  307 +++++++++++++
 arch/x86/crypto/serpent_avx_glue.c         |  513 ++++-----------------
 arch/x86/crypto/serpent_sse2_glue.c        |  513 ++++-----------------
 arch/x86/crypto/twofish_avx_glue.c         |  672 ++++------------------------
 arch/x86/crypto/twofish_glue_3way.c        |  407 ++++-------------
 arch/x86/include/asm/aes.h                 |   11 
 arch/x86/include/asm/crypto/ablk_helper.h  |   31 +
 arch/x86/include/asm/crypto/aes.h          |   11 
 arch/x86/include/asm/crypto/glue_helper.h  |  115 +++++
 arch/x86/include/asm/crypto/serpent-avx.h  |   32 +
 arch/x86/include/asm/crypto/serpent-sse2.h |   63 +++
 arch/x86/include/asm/crypto/twofish.h      |   46 ++
 arch/x86/include/asm/serpent-avx.h         |   32 -
 arch/x86/include/asm/serpent-sse2.h        |   63 ---
 crypto/Kconfig                             |   21 +
 20 files changed, 1286 insertions(+), 2162 deletions(-)
 create mode 100644 arch/x86/crypto/ablk_helper.c
 create mode 100644 arch/x86/crypto/glue_helper.c
 delete mode 100644 arch/x86/include/asm/aes.h
 create mode 100644 arch/x86/include/asm/crypto/ablk_helper.h
 create mode 100644 arch/x86/include/asm/crypto/aes.h
 create mode 100644 arch/x86/include/asm/crypto/glue_helper.h
 create mode 100644 arch/x86/include/asm/crypto/serpent-avx.h
 create mode 100644 arch/x86/include/asm/crypto/serpent-sse2.h
 create mode 100644 arch/x86/include/asm/crypto/twofish.h
 delete mode 100644 arch/x86/include/asm/serpent-avx.h
 delete mode 100644 arch/x86/include/asm/serpent-sse2.h
