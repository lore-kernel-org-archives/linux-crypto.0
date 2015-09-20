From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH] crypto: crc32c-pclmul: use .rodata instead of .rotata
Date: Sun, 20 Sep 2015 16:42:36 +0200
Message-ID: <1442760156-2501-1-git-send-email-nicolas.iooss_linux@m4x.org>
Cc: linux-kernel@vger.kernel.org,
	Nicolas Iooss <nicolas.iooss_linux@m4x.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Module crc32c-intel uses a special read-only data section named .rotata.
This section is defined for K_table, and its name seems to be a spelling
mistake for .rodata.

Fixes: 473946e674eb ("crypto: crc32c-pclmul - Shrink K_table to 32-bit words")
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 225be06edc80..4fe27e074194 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -330,7 +330,7 @@ ENDPROC(crc_pcl)
 	## PCLMULQDQ tables
 	## Table is 128 entries x 2 words (8 bytes) each
 	################################################################
-.section	.rotata, "a", %progbits
+.section	.rodata, "a", %progbits
 .align 8
 K_table:
 	.long 0x493c7d27, 0x00000001
-- 
2.5.2
