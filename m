From: srishti sharma <srishtishar@gmail.com>
Subject: [PATCH] Staging: ccree: cc_crypto_ctx.h: Fixed a comment coding style issue.
Date: Wed, 31 May 2017 18:24:55 +0530
Message-ID: <1496235295-2696-1-git-send-email-srishtishar@gmail.com>
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        srishti sharma <srishtishar@gmail.com>
To: gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:35961 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdEaMzA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 May 2017 08:55:00 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed a comment coding style issue that generated a warning stating that block comments should align the * on each line.

Signed-off-by: srishti sharma <srishtishar@gmail.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index c5784bc..38f6615 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -239,10 +239,10 @@ struct drv_ctx_cipher {
 	enum drv_crypto_padding_type padding_type;
 	u32 key_size; /* numeric value in bytes   */
 	u32 data_unit_size; /* required for XTS */
-	/* block_state is the AES engine block state.
-	*  It is used by the host to pass IV or counter at initialization.
-	*  It is used by SeP for intermediate block chaining state and for
-	*  returning MAC algorithms results.           */
+	/*  block_state is the AES engine block state.
+	 *  It is used by the host to pass IV or counter at initialization.
+	 *  It is used by SeP for intermediate block chaining state and for
+	 *  returning MAC algorithms results.           */
 	u8 block_state[CC_AES_BLOCK_SIZE];
 	u8 key[CC_AES_KEY_SIZE_MAX];
 	u8 xex_key[CC_AES_KEY_SIZE_MAX];
2.7.4
