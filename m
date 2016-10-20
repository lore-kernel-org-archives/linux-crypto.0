From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH][TRIVIAL] crypto: ccp - fix typo "CPP"
Date: Thu, 20 Oct 2016 21:20:59 +0200
Message-ID: <1476991259-4061-1-git-send-email-pebolle@tiscali.nl>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The abbreviation for Cryptographic Coprocessor is "CCP".

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 include/linux/ccp.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index a7653339fedb..c71dd8fa5764 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -11,8 +11,8 @@
  * published by the Free Software Foundation.
  */
 
-#ifndef __CPP_H__
-#define __CPP_H__
+#ifndef __CCP_H__
+#define __CCP_H__
 
 #include <linux/scatterlist.h>
 #include <linux/workqueue.h>
@@ -553,7 +553,7 @@ enum ccp_engine {
 #define CCP_CMD_PASSTHRU_NO_DMA_MAP	0x00000002
 
 /**
- * struct ccp_cmd - CPP operation request
+ * struct ccp_cmd - CCP operation request
  * @entry: list element (ccp driver use only)
  * @work: work element used for callbacks (ccp driver use only)
  * @ccp: CCP device to be run on (ccp driver use only)
-- 
2.7.4
