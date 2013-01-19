From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 00/12] crypto: x86 assembler cleanups
Date: Sat, 19 Jan 2013 13:38:45 +0200
Message-ID: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:36742 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLis (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:38:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change x86 crypto implementations to use ENTRY()/ENDPROC() as linux/linkage.h 
recommends use of ENDPROC() for assembler functions.

While at it, also change jump targets to local labels for some implementations.

---

Jussi Kivilinna (12):
      crypto: x86/aes - assembler clean-ups: use ENTRY/ENDPROC, localize jump targets
      crypto: aesni-intel - add ENDPROC statements for assembler functions
      crypto: blowfish-x86_64: use ENTRY()/ENDPROC() for assembler functions and localize jump targets
      crypto: camellia-x86_64/aes-ni: use ENTRY()/ENDPROC() for assembler functions and localize jump targets
      crypto: cast5-avx: use ENTRY()/ENDPROC() for assembler functions and localize jump targets
      crypto: cast6-avx: use ENTRY()/ENDPROC() for assembler functions
      crypto: x86/crc32c - assembler clean-up: use ENTRY/ENDPROC
      crypto: x86/ghash - assembler clean-up: use ENDPROC at end of assember functions
      crypto: x86/salsa20 - assembler cleanup, use ENTRY/ENDPROC for assember functions and rename ECRYPT_* to salsa20_*
      crypto: x86/serpent - use ENTRY/ENDPROC for assember functions and localize jump targets
      crypto: x86/sha1 - assembler clean-ups: use ENTRY/ENDPROC
      crypto: x86/twofish - assembler clean-ups: use ENTRY/ENDPROC, localize jump labels


 arch/x86/crypto/aes-i586-asm_32.S            |   15 +++-----
 arch/x86/crypto/aes-x86_64-asm_64.S          |   30 ++++++++--------
 arch/x86/crypto/aesni-intel_asm.S            |   23 +++++++++++-
 arch/x86/crypto/blowfish-x86_64-asm_64.S     |   39 +++++++-------------
 arch/x86/crypto/camellia-aesni-avx-asm_64.S  |   38 +++++++-------------
 arch/x86/crypto/camellia-x86_64-asm_64.S     |   50 +++++++++++---------------
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S    |   48 +++++++++----------------
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S    |   35 ++++++------------
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S    |    8 +++-
 arch/x86/crypto/ghash-clmulni-intel_asm.S    |    4 ++
 arch/x86/crypto/salsa20-i586-asm_32.S        |   28 +++++++--------
 arch/x86/crypto/salsa20-x86_64-asm_64.S      |   28 +++++++--------
 arch/x86/crypto/salsa20_glue.c               |    5 ---
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S  |   35 ++++++------------
 arch/x86/crypto/serpent-sse2-i586-asm_32.S   |   20 ++++------
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S |   20 ++++------
 arch/x86/crypto/sha1_ssse3_asm.S             |   10 +++--
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S  |   35 ++++++------------
 arch/x86/crypto/twofish-i586-asm_32.S        |   11 +++---
 arch/x86/crypto/twofish-x86_64-asm_64-3way.S |   20 ++++------
 arch/x86/crypto/twofish-x86_64-asm_64.S      |   11 +++---
 21 files changed, 219 insertions(+), 294 deletions(-)

--
