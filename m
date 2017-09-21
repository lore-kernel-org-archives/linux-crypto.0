From: Janani Sankara Babu <jananis37@gmail.com>
Subject: [PATCH] staging:ccree Fix dont use assignment in if condition
Date: Thu, 21 Sep 2017 12:07:04 +0530
Message-ID: <1505975824-28175-1-git-send-email-jananis37@gmail.com>
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Janani Sankara Babu <jananis37@gmail.com>
To: gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:38450 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751436AbdIUGmA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 02:42:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch solves the following error shown by checkpatch script
ERROR: do not use assignment in if condition

Signed-off-by: Janani Sankara Babu <jananis37@gmail.com>
---
 drivers/staging/ccree/ssi_hash.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index ae8f36a..08eaa56 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -601,8 +601,8 @@ static int ssi_hash_update(struct ahash_req_ctx *state,
 		/* no real updates required */
 		return 0;
 	}
-
-	if (unlikely(rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, src, nbytes, block_size))) {
+	rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, src, nbytes, block_size);
+	if (unlikely(rc)) {
 		if (rc == 1) {
 			SSI_LOG_DEBUG(" data size not require HW update %x\n",
 				     nbytes);
@@ -1403,8 +1403,8 @@ static int ssi_mac_update(struct ahash_request *req)
 	}
 
 	state->xcbc_count++;
-
-	if (unlikely(rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, req->src, req->nbytes, block_size))) {
+	rc = ssi_buffer_mgr_map_hash_request_update(ctx->drvdata, state, req->src, req->nbytes, block_size);
+	if (unlikely(rc)) {
 		if (rc == 1) {
 			SSI_LOG_DEBUG(" data size not require HW update %x\n",
 				     req->nbytes);
-- 
1.9.1
