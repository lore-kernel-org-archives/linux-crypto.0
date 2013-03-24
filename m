From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH] crypto: x86/crc32-pclmul - assembly clean-ups: use
 ENTRY/ENDPROC
Date: Sun, 24 Mar 2013 14:32:01 +0200
Message-ID: <20130324123201.10259.59712.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:53040 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3CXMcE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 24 Mar 2013 08:32:04 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 arch/x86/crypto/crc32-pclmul_asm.S |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/crypto/crc32-pclmul_asm.S b/arch/x86/crypto/crc32-pclmul_asm.S
index c8335014..94c27df 100644
--- a/arch/x86/crypto/crc32-pclmul_asm.S
+++ b/arch/x86/crypto/crc32-pclmul_asm.S
@@ -101,9 +101,8 @@
  *      uint crc32_pclmul_le_16(unsigned char const *buffer,
  *	                     size_t len, uint crc32)
  */
-.globl crc32_pclmul_le_16
-.align 4, 0x90
-crc32_pclmul_le_16:/* buffer and buffer size are 16 bytes aligned */
+
+ENTRY(crc32_pclmul_le_16) /* buffer and buffer size are 16 bytes aligned */
 	movdqa  (BUF), %xmm1
 	movdqa  0x10(BUF), %xmm2
 	movdqa  0x20(BUF), %xmm3
@@ -244,3 +243,4 @@ fold_64:
 	pextrd  $0x01, %xmm1, %eax
 
 	ret
+ENDPROC(crc32_pclmul_le_16)
