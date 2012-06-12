From: Phil Sutter <phil.sutter@viprinet.com>
Subject: [PATCH 02/13] mv_cesa: minor formatting cleanup, will all make sense soon
Date: Tue, 12 Jun 2012 19:17:16 +0200
Message-ID: <1339521447-17721-3-git-send-email-phil.sutter@viprinet.com>
References: <20120612113941.GA14757@gondor.apana.org.au>
 <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:58650 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819Ab2FLRR5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jun 2012 13:17:57 -0400
In-Reply-To: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is just to keep formatting changes out of the following commit,
hopefully simplifying it a bit.

Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
---
 drivers/crypto/mv_cesa.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 818a5c7..59c2ed2 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -269,12 +269,10 @@ static void mv_process_current_q(int first_block)
 	}
 	if (req_ctx->decrypt) {
 		op.config |= CFG_DIR_DEC;
-		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_dec_key,
-				AES_KEY_LEN);
+		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_dec_key, AES_KEY_LEN);
 	} else {
 		op.config |= CFG_DIR_ENC;
-		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_enc_key,
-				AES_KEY_LEN);
+		memcpy(cpg->sram + SRAM_DATA_KEY_P, ctx->aes_enc_key, AES_KEY_LEN);
 	}
 
 	switch (ctx->key_len) {
@@ -335,9 +333,8 @@ static void mv_process_hash_current(int first_block)
 	}
 
 	op.mac_src_p =
-		MAC_SRC_DATA_P(SRAM_DATA_IN_START) | MAC_SRC_TOTAL_LEN((u32)
-		req_ctx->
-		count);
+		MAC_SRC_DATA_P(SRAM_DATA_IN_START) |
+		MAC_SRC_TOTAL_LEN((u32)req_ctx->count);
 
 	setup_data_in();
 
@@ -372,7 +369,8 @@ static void mv_process_hash_current(int first_block)
 		}
 	}
 
-	memcpy(cpg->sram + SRAM_CONFIG, &op, sizeof(struct sec_accel_config));
+	memcpy(cpg->sram + SRAM_CONFIG, &op,
+			sizeof(struct sec_accel_config));
 
 	/* GO */
 	mv_setup_timer();
-- 
1.7.3.4
