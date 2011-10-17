From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 0/7] crypto: add SSE2-x86_64/i586 implementation of Serpent
	cipher
Date: Tue, 18 Oct 2011 00:02:47 +0300
Message-ID: <20111017210247.13543.75430.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:37666 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1JQVCw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Oct 2011 17:02:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series adds SSE2 optimized version of Serpent cipher for x86_64 and i586
architectures. The i586 implementation processes four serpent blocks parallel
in SSE2 registers. The x86_64 implementation utilizes available extra SSE2
registers for higher performance on out-of-order CPUs, crypting 8 blocks
parallel.

Series depends on previous testmgr/tcrypt patches in twofish-asm-3way series
and also on following patches:
  http://marc.info/?l=linux-crypto-vger&m=131827700228773&w=2
  http://marc.info/?l=linux-crypto-vger&m=131827699228759&w=2

---

Jussi Kivilinna (7):
      crypto: testmgr: add new serpent test vectors
      crypto: tcrypt: add test_acipher_speed
      crypto: tcrypt: add serpent speed tests
      crypto: serpent: export common functions for x86_64/i386-sse2 assembler implementations
      crypto: serpent: rename module from serpent to serpent_generic
      crypto: serpent: add 8-way parallel x86_64/SSE2 assembler implementation
      crypto: serpent: add 4-way parallel i586/SSE2 assembler implementation


 arch/x86/crypto/Makefile                     |    4 
 arch/x86/crypto/serpent-sse2-i586-asm_32.S   |  639 ++++++++++++++++++++++
 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S |  761 ++++++++++++++++++++++++++
 arch/x86/crypto/serpent_sse2_glue.c          |  719 +++++++++++++++++++++++++
 arch/x86/include/asm/serpent.h               |   64 ++
 crypto/Kconfig                               |   34 +
 crypto/Makefile                              |    4 
 crypto/serpent.c                             |   44 +-
 crypto/tcrypt.c                              |  282 ++++++++++
 crypto/testmgr.c                             |   90 +++
 crypto/testmgr.h                             |  393 +++++++++++++
 include/crypto/serpent.h                     |   25 +
 12 files changed, 3037 insertions(+), 22 deletions(-)
 create mode 100644 arch/x86/crypto/serpent-sse2-i586-asm_32.S
 create mode 100644 arch/x86/crypto/serpent-sse2-x86_64-asm_64.S
 create mode 100644 arch/x86/crypto/serpent_sse2_glue.c
 create mode 100644 arch/x86/include/asm/serpent.h
 create mode 100644 include/crypto/serpent.h
