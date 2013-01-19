From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: [PATCH 07/12] crypto: x86/crc32c - assembler clean-up: use
 ENTRY/ENDPROC
Date: Sat, 19 Jan 2013 13:39:21 +0200
Message-ID: <20130119113921.22319.2197.stgit@localhost6.localdomain6>
References: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:58320 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab3ASLjX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 19 Jan 2013 06:39:23 -0500
In-Reply-To: <20130119113818.22319.26924.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
index 93c6d39..cf1a7ec 100644
--- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
+++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
@@ -42,6 +42,8 @@
  * SOFTWARE.
  */
 
+#include <linux/linkage.h>
+
 ## ISCSI CRC 32 Implementation with crc32 and pclmulqdq Instruction
 
 .macro LABEL prefix n
@@ -68,8 +70,7 @@
 
 # unsigned int crc_pcl(u8 *buffer, int len, unsigned int crc_init);
 
-.global crc_pcl
-crc_pcl:
+ENTRY(crc_pcl)
 #define    bufp		%rdi
 #define    bufp_dw	%edi
 #define    bufp_w	%di
@@ -323,6 +324,9 @@ JMPTBL_ENTRY %i
 .noaltmacro
 	i=i+1
 .endr
+
+ENDPROC(crc_pcl)
+
 	################################################################
 	## PCLMULQDQ tables
 	## Table is 128 entries x 2 quad words each
