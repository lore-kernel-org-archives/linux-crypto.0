From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 0/5] Avoid stack buffers in glue code of AVX implementations
Date: Sat, 20 Oct 2012 15:06:31 +0300
Message-ID: <20121020120431.19422.17000.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:56084 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab2JTMGe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 20 Oct 2012 08:06:34 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patches modify AVX implementations so that they avoid using extra
stack memory. Stack is not needed since implementation store
blocks in registers.

---

Jussi Kivilinna (5):
      crypto: x86/glue_helper - use le128 instead of u128 for CTR mode
      crypto: cast6/avx - avoid using temporary stack buffers
      crypto: twofish/avx - avoid using temporary stack buffers
      crypto: serpent/avx - avoid using temporary stack buffers
      crypto: cast5/avx - avoid using temporary stack buffers


 arch/x86/crypto/camellia_glue.c             |   16 +
 arch/x86/crypto/cast5-avx-x86_64-asm_64.S   |  332 +++++++++++++++++++++------
 arch/x86/crypto/cast5_avx_glue.c            |   79 ++----
 arch/x86/crypto/cast6-avx-x86_64-asm_64.S   |  190 ++++++++++-----
 arch/x86/crypto/cast6_avx_glue.c            |   77 +-----
 arch/x86/crypto/glue_helper-asm-avx.S       |   91 +++++++
 arch/x86/crypto/glue_helper.c               |   12 -
 arch/x86/crypto/serpent-avx-x86_64-asm_64.S |  166 +++++++++-----
 arch/x86/crypto/serpent_avx_glue.c          |   49 +---
 arch/x86/crypto/serpent_sse2_glue.c         |   12 -
 arch/x86/crypto/twofish-avx-x86_64-asm_64.S |  208 +++++++++++------
 arch/x86/crypto/twofish_avx_glue.c          |   73 +-----
 arch/x86/crypto/twofish_glue_3way.c         |   20 +-
 arch/x86/include/asm/crypto/glue_helper.h   |   28 +-
 arch/x86/include/asm/crypto/serpent-avx.h   |   27 +-
 arch/x86/include/asm/crypto/twofish.h       |    4 
 16 files changed, 835 insertions(+), 549 deletions(-)
 create mode 100644 arch/x86/crypto/glue_helper-asm-avx.S
