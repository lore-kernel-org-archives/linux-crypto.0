From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 0/6] x86_64 assembler implementation of camellia block cipher
Date: Mon, 05 Mar 2012 20:26:16 +0200
Message-ID: <20120305182616.25411.58251.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:33180 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab2CES0r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Mar 2012 13:26:47 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patches 1-2 add new tests and test vectors for camellia.
Patches 3-5 rename 'camellia' module to 'camellia_generic'.
Patch 6 adds x86_64 implementation of camellia.

Series depends on patch:
  http://marc.info/?l=linux-crypto-vger&m=133077599602729&w=2

---

Jussi Kivilinna (6):
      crypto: testmgr - add more camellia test vectors
      crypto: tcrypt - add more camellia tests
      crypto: camellia - rename camellia module to camellia_generic
      crypto: camellia - fix checkpatch warnings
      crypto: camellia - rename camellia.c to camellia_generic.c
      crypto: camellia - add assembler implementation for x86_64


 arch/x86/crypto/Makefile                 |    2 
 arch/x86/crypto/camellia-x86_64-asm_64.S |  521 ++++++++
 arch/x86/crypto/camellia_glue.c          | 1953 ++++++++++++++++++++++++++++++
 crypto/Kconfig                           |   18 
 crypto/Makefile                          |    2 
 crypto/camellia.c                        | 1098 -----------------
 crypto/camellia_generic.c                | 1102 +++++++++++++++++
 crypto/tcrypt.c                          |   12 
 crypto/testmgr.c                         |   45 +
 crypto/testmgr.h                         | 1383 +++++++++++++++++++++
 10 files changed, 5033 insertions(+), 1103 deletions(-)
 create mode 100644 arch/x86/crypto/camellia-x86_64-asm_64.S
 create mode 100644 arch/x86/crypto/camellia_glue.c
 delete mode 100644 crypto/camellia.c
 create mode 100644 crypto/camellia_generic.c

-- 
