From: srishti sharma <srishtishar@gmail.com>
Subject: [PATCH 3/4] Staging: ccree: cc_crypto_ctx.h: Fixed * alignment issues in a comment block
Date: Sun,  4 Jun 2017 05:03:12 +0530
Message-ID: <b829c555e473cd597e641365473b35c1be1f4ab4.1496531673.git.srishtishar@gmail.com>
References: <cover.1496531673.git.srishtishar@gmail.com>
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        srishti sharma <srishtishar@gmail.com>
To: gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:36803 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdFCXdS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 3 Jun 2017 19:33:18 -0400
In-Reply-To: <cover.1496531673.git.srishtishar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fixed the alignment of * in a comment block.

Signed-off-by: srishti sharma <srishtishar@gmail.com>
---
 drivers/staging/ccree/cc_crypto_ctx.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/cc_crypto_ctx.h b/drivers/staging/ccree/cc_crypto_ctx.h
index 27a5914..03164624 100644
--- a/drivers/staging/ccree/cc_crypto_ctx.h
+++ b/drivers/staging/ccree/cc_crypto_ctx.h
@@ -242,9 +242,9 @@ struct drv_ctx_cipher {
	u32 key_size; /* numeric value in bytes */
	u32 data_unit_size; /* required for XTS */
	/* block_state is the AES engine block state.
-	*  It is used by the host to pass IV or counter at initialization.
-	*  It is used by SeP for intermediate block chaining state and for
-	*  returning MAC algorithms results. */
+	 * It is used by the host to pass IV or counter at initialization.
+	 * It is used by SeP for intermediate block chaining state and for
+	 * returning MAC algorithms results. */
	u8 block_state[CC_AES_BLOCK_SIZE];
	u8 key[CC_AES_KEY_SIZE_MAX];
	u8 xex_key[CC_AES_KEY_SIZE_MAX];
