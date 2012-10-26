From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 0/3] [v2] AES-NI/AVX implementation of Camellia cipher
Date: Fri, 26 Oct 2012 14:48:45 +0300
Message-ID: <20121026114845.3373.17236.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:35598 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932403Ab2JZLst (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 26 Oct 2012 07:48:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patchset adds AES-NI/AVX assembler implementation of Camellia cipher
for x86-64.

[v2]:
 - No missing patches
 - No missing files

---

Jussi Kivilinna (3):
      [v2] crypto: tcrypt - add async speed test for camellia cipher
      [v2] crypto: camellia-x86_64 - share common functions and move structures and function definitions to header file
      [v2] crypto: camellia - add AES-NI/AVX/x86_64 assembler implementation of camellia cipher


 arch/x86/crypto/Makefile                    |    3 
 arch/x86/crypto/camellia-aesni-avx-asm_64.S | 1102 +++++++++++++++++++++++++++
 arch/x86/crypto/camellia_aesni_avx_glue.c   |  558 ++++++++++++++
 arch/x86/crypto/camellia_glue.c             |   80 +-
 arch/x86/include/asm/crypto/camellia.h      |   82 ++
 crypto/Kconfig                              |   22 +
 crypto/tcrypt.c                             |   23 +
 crypto/testmgr.c                            |   62 ++
 8 files changed, 1875 insertions(+), 57 deletions(-)
 create mode 100644 arch/x86/crypto/camellia-aesni-avx-asm_64.S
 create mode 100644 arch/x86/crypto/camellia_aesni_avx_glue.c
 create mode 100644 arch/x86/include/asm/crypto/camellia.h
