From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v3 05/18] staging: ccree: move M/LLI defines to header file
Date: Sun,  4 Jun 2017 11:02:26 +0300
Message-ID: <1496563362-7954-6-git-send-email-gilad@benyossef.com>
References: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Cc: Joe Perches <joe@perches.com>, Ofir Drang <ofir.drang@arm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52702 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751230AbdFDIDU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 4 Jun 2017 04:03:20 -0400
In-Reply-To: <1496563362-7954-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

A bunch of macros used to define M/LLI descriptors where
being defined in the C file. Move them over to private
include file where other relevant definitions are stored.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/cc_lli_defs.h    | 8 ++++++++
 drivers/staging/ccree/ssi_buffer_mgr.c | 7 -------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ccree/cc_lli_defs.h b/drivers/staging/ccree/cc_lli_defs.h
index 876dde0..78811aa 100644
--- a/drivers/staging/ccree/cc_lli_defs.h
+++ b/drivers/staging/ccree/cc_lli_defs.h
@@ -28,6 +28,14 @@
 
 #define CC_MAX_MLLI_ENTRY_SIZE 0xFFFF
 
+#define LLI_MAX_NUM_OF_DATA_ENTRIES 128
+#define LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES 4
+#define MLLI_TABLE_MIN_ALIGNMENT 4 /* 32 bit alignment */
+#define MAX_NUM_OF_BUFFERS_IN_MLLI 4
+#define MAX_NUM_OF_TOTAL_MLLI_ENTRIES \
+		(2 * LLI_MAX_NUM_OF_DATA_ENTRIES + \
+		 LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES)
+
 /* Size of entry */
 #define LLI_ENTRY_WORD_SIZE 2
 #define LLI_ENTRY_BYTE_SIZE (LLI_ENTRY_WORD_SIZE * sizeof(u32))
diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 24ba51d..63ffcd5 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -33,13 +33,6 @@
 #include "ssi_hash.h"
 #include "ssi_aead.h"
 
-#define LLI_MAX_NUM_OF_DATA_ENTRIES 128
-#define LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES 4
-#define MLLI_TABLE_MIN_ALIGNMENT 4 /*Force the MLLI table to be align to uint32 */
-#define MAX_NUM_OF_BUFFERS_IN_MLLI 4
-#define MAX_NUM_OF_TOTAL_MLLI_ENTRIES (2*LLI_MAX_NUM_OF_DATA_ENTRIES + \
-					LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES )
-
 #ifdef CC_DEBUG
 #define DUMP_SGL(sg) \
 	while (sg) { \
-- 
2.1.4
