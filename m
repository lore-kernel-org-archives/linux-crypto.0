From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [RFC 4/6] [crypto] geode: move defines into a headerfile
Date: Fri, 12 Oct 2007 14:47:37 +0200
Message-ID: <E1IgMP4-0002l0-4H@Chamillionaire.breakpoint.cc>
References: <1192202467-10335-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.2.5"
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50916 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753568AbXJLP0T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Oct 2007 11:26:19 -0400
Received: id: bigeasy by Chamillionaire.breakpoint.cc authenticated by bigeasy with local
	(easymta 1.00 BETA 1)
	id 1IgMP4-0002l0-4H
	for linux-crypto@vger.kernel.org; Fri, 12 Oct 2007 17:26:18 +0200
In-Reply-To: <1192202467-10335-1-git-send-email-linux-crypto@ml.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This is a multi-part message in MIME format.
--------------1.5.2.5
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
---
 drivers/crypto/geode-aes.c |   32 --------------------------------
 drivers/crypto/geode-aes.h |   36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 34 deletions(-)
--------------1.5.2.5
Content-Type: text/x-patch; name="9d0ae577c2187fe914aab2f3f486036f2ded01b9.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="9d0ae577c2187fe914aab2f3f486036f2ded01b9.diff"

diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index 99ea594..da6164a 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -20,38 +20,6 @@
 
 #include "geode-aes.h"
 
-/* Register definitions */
-
-#define AES_CTRLA_REG  0x0000
-
-#define AES_CTRL_START     0x01
-#define AES_CTRL_DECRYPT   0x00
-#define AES_CTRL_ENCRYPT   0x02
-#define AES_CTRL_WRKEY     0x04
-#define AES_CTRL_DCA       0x08
-#define AES_CTRL_SCA       0x10
-#define AES_CTRL_CBC       0x20
-
-#define AES_INTR_REG  0x0008
-
-#define AES_INTRA_PENDING (1 << 16)
-#define AES_INTRB_PENDING (1 << 17)
-
-#define AES_INTR_PENDING  (AES_INTRA_PENDING | AES_INTRB_PENDING)
-#define AES_INTR_MASK     0x07
-
-#define AES_SOURCEA_REG   0x0010
-#define AES_DSTA_REG      0x0014
-#define AES_LENA_REG      0x0018
-#define AES_WRITEKEY0_REG 0x0030
-#define AES_WRITEIV0_REG  0x0040
-
-/*  A very large counter that is used to gracefully bail out of an
- *  operation in case of trouble
- */
-
-#define AES_OP_TIMEOUT    0x50000
-
 /* Static structures */
 
 static void __iomem * _iobase;
diff --git a/drivers/crypto/geode-aes.h b/drivers/crypto/geode-aes.h
index f479686..2f1d559 100644
--- a/drivers/crypto/geode-aes.h
+++ b/drivers/crypto/geode-aes.h
@@ -9,9 +9,9 @@
 #ifndef _GEODE_AES_H_
 #define _GEODE_AES_H_
 
-#define AES_KEY_LENGTH 16
+/* driver logic flags */
 #define AES_IV_LENGTH  16
-
+#define AES_KEY_LENGTH 16
 #define AES_MIN_BLOCK_SIZE 16
 
 #define AES_MODE_ECB 0
@@ -22,6 +22,38 @@
 
 #define AES_FLAGS_HIDDENKEY (1 << 0)
 
+/* Register definitions */
+
+#define AES_CTRLA_REG  0x0000
+
+#define AES_CTRL_START     0x01
+#define AES_CTRL_DECRYPT   0x00
+#define AES_CTRL_ENCRYPT   0x02
+#define AES_CTRL_WRKEY     0x04
+#define AES_CTRL_DCA       0x08
+#define AES_CTRL_SCA       0x10
+#define AES_CTRL_CBC       0x20
+
+#define AES_INTR_REG  0x0008
+
+#define AES_INTRA_PENDING (1 << 16)
+#define AES_INTRB_PENDING (1 << 17)
+
+#define AES_INTR_PENDING  (AES_INTRA_PENDING | AES_INTRB_PENDING)
+#define AES_INTR_MASK     0x07
+
+#define AES_SOURCEA_REG   0x0010
+#define AES_DSTA_REG      0x0014
+#define AES_LENA_REG      0x0018
+#define AES_WRITEKEY0_REG 0x0030
+#define AES_WRITEIV0_REG  0x0040
+
+/*  A very large counter that is used to gracefully bail out of an
+ *  operation in case of trouble
+ */
+
+#define AES_OP_TIMEOUT    0x50000
+
 struct geode_aes_op {
 
 	void *src;

--------------1.5.2.5--
