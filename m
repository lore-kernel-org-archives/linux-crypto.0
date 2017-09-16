From: Colin King <colin.king@canonical.com>
Subject: [PATCH] staging: ccree: remove unused and redundant variable idx
Date: Sat, 16 Sep 2017 17:32:51 +0100
Message-ID: <20170916163251.29796-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53899 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751233AbdIPQcx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Sep 2017 12:32:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Variable idx is being set but never read and thus it can be
removed because it is redundant. Cleans up clang build warnings:

warning: Value stored to 'idx' during its initialization is never read
warning: Value stored to 'idx' is never read
warning: Value stored to 'idx' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/ccree/ssi_aead.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 5abe6b24ff8c..8d6b95efce86 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1812,7 +1812,6 @@ static inline int ssi_aead_gcm(
 	unsigned int *seq_size)
 {
 	struct aead_req_ctx *req_ctx = aead_request_ctx(req);
-	unsigned int idx = *seq_size;
 	unsigned int cipher_flow_mode;
 
 	if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT) {
@@ -1829,7 +1828,6 @@ static inline int ssi_aead_gcm(
 		ssi_aead_create_assoc_desc(req, DIN_HASH, desc, seq_size);
 		ssi_aead_gcm_setup_gctr_desc(req, desc, seq_size);
 		ssi_aead_process_gcm_result_desc(req, desc, seq_size);
-		idx = *seq_size;
 		return 0;
 	}
 
@@ -1844,7 +1842,6 @@ static inline int ssi_aead_gcm(
 		ssi_aead_process_cipher_data_desc(req, cipher_flow_mode, desc, seq_size);
 	ssi_aead_process_gcm_result_desc(req, desc, seq_size);
 
-	idx = *seq_size;
 	return 0;
 }
 
-- 
2.14.1
