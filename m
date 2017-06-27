From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 06/14] staging: ccree: fix unmatched if/else braces
Date: Tue, 27 Jun 2017 10:27:18 +0300
Message-ID: <1498548449-10803-7-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-crypto@vger.kernel.org, driverdev-devel@linuxdriverproject.org,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Fix mismatched braces between if and else.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 3 ++-
 drivers/staging/ccree/ssi_cipher.c     | 7 +++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 9e8a134..f9720fc 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -551,8 +551,9 @@ int ssi_buffer_mgr_map_blkcipher_request(
 		SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=0x%llX\n",
 			ivsize, info,
 			(unsigned long long)req_ctx->gen_ctx.iv_dma_addr);
-	} else
+	} else {
 		req_ctx->gen_ctx.iv_dma_addr = 0;
+	}
 
 	/* Map the src SGL */
 	rc = ssi_buffer_mgr_map_scatterlist(dev, src,
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index c233b7c..88ed777 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -401,8 +401,9 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 	/* STAT_PHASE_1: Copy key to ctx */
 	dma_sync_single_for_cpu(dev, ctx_p->user.key_dma_addr,
 					max_key_buf_size, DMA_TO_DEVICE);
-#if SSI_CC_HAS_MULTI2
+
 	if (ctx_p->flow_mode == S_DIN_to_MULTI2) {
+#if SSI_CC_HAS_MULTI2
 		memcpy(ctx_p->user.key, key, CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE);
 		ctx_p->key_round_number = key[CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE];
 		if (ctx_p->key_round_number < CC_MULTI2_MIN_NUM_ROUNDS ||
@@ -410,10 +411,8 @@ static int ssi_blkcipher_setkey(struct crypto_tfm *tfm,
 			crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 			SSI_LOG_DEBUG("ssi_blkcipher_setkey: SSI_CC_HAS_MULTI2 einval");
 			return -EINVAL;
-		}
-	} else
 #endif /*SSI_CC_HAS_MULTI2*/
-	{
+	} else {
 		memcpy(ctx_p->user.key, key, keylen);
 		if (keylen == 24)
 			memset(ctx_p->user.key + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
-- 
2.1.4
