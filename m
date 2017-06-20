From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 6/6] staging: ccree: move else to follow close brace '}'
Date: Tue, 20 Jun 2017 22:52:04 +0800
Message-ID: <1497970324-9725-7-git-send-email-fbihjmeric@gmail.com>
References: <1497970324-9725-1-git-send-email-fbihjmeric@gmail.com>
Cc: Jhih-Ming Hunag <fbihjmeric@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35645 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdFTOwb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 10:52:31 -0400
In-Reply-To: <1497970324-9725-1-git-send-email-fbihjmeric@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jhih-Ming Hunag <fbihjmeric@gmail.com>

Move else to follow close brace '}'

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 57c7c68..c70e450 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1919,8 +1919,7 @@ static int config_gcm_context(struct aead_request *req)
 		memcpy (&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
 		temp64 = cpu_to_be64(cryptlen * 8);
 		memcpy (&req_ctx->gcm_len_block.lenC, &temp64, 8);
-	}
-	else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
+	} else { //rfc4543=>  all data(AAD,IV,Plain) are considered additional data that is nothing is encrypted.
 		__be64 temp64;
 		temp64 = cpu_to_be64((req->assoclen+GCM_BLOCK_RFC4_IV_SIZE+cryptlen) * 8);
 		memcpy (&req_ctx->gcm_len_block.lenA, &temp64, sizeof(temp64));
-- 
2.7.4
