From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 19/24] staging: ccree: rename long define for readability
Date: Mon, 13 Nov 2017 14:45:47 +0000
Message-ID: <1510584358-29473-20-git-send-email-gilad@benyossef.com>
References: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1510584358-29473-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Rename the too long  SSI_MAX_HASH_OPAD_TMP_KEYS_SIZE
to SSI_MAX_OPAD_KEYS_SIZE for better code readability.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_hash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 0f67737..afdc44e 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -32,7 +32,7 @@
 #include "ssi_sram_mgr.h"
 
 #define SSI_MAX_AHASH_SEQ_LEN 12
-#define SSI_MAX_HASH_OPAD_TMP_KEYS_SIZE SSI_MAX_HASH_BLCK_SIZE
+#define SSI_MAX_OPAD_KEYS_SIZE SSI_MAX_HASH_BLCK_SIZE
 
 struct ssi_hash_handle {
 	ssi_sram_addr_t digest_len_sram_addr; /* const value in SRAM*/
@@ -94,7 +94,7 @@ struct ssi_hash_ctx {
 	 * the initial digest if HASH.
 	 */
 	u8 digest_buff[SSI_MAX_HASH_DIGEST_SIZE]  ____cacheline_aligned;
-	u8 opad_tmp_keys_buff[SSI_MAX_HASH_OPAD_TMP_KEYS_SIZE]  ____cacheline_aligned;
+	u8 opad_tmp_keys_buff[SSI_MAX_OPAD_KEYS_SIZE]  ____cacheline_aligned;
 
 	dma_addr_t opad_tmp_keys_dma_addr  ____cacheline_aligned;
 	dma_addr_t digest_buff_dma_addr;
-- 
2.7.4
