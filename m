From: Colin King <colin.king@canonical.com>
Subject: [PATCH] staging: ccree: fix incorrect indentation of break statement
Date: Fri, 17 Nov 2017 18:19:08 +0000
Message-ID: <20171117181908.2257-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48438 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752501AbdKQSTL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Nov 2017 13:19:11 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The break statement is indented one level too many, fix this.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/staging/ccree/ssi_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index ba0954e4d2e5..446da9d47cd9 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -2108,7 +2108,7 @@ static int ssi_aead_process(struct aead_request *req, enum drv_crypto_direction
 		if (ctx->cipher_mode == DRV_CIPHER_GCTR)
 			ssi_aead_gcm(req, desc, &seq_len);
 #endif /*SSI_CC_HAS_AES_GCM*/
-			break;
+		break;
 #endif
 	default:
 		dev_err(dev, "Unsupported authenc (%d)\n", ctx->auth_mode);
-- 
2.14.1
