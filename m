From: Jhih-Ming Huang <fbihjmeric@gmail.com>
Subject: [PATCH 4/6] staging: ccree: move * to close variable name instead of type.
Date: Tue, 20 Jun 2017 22:52:02 +0800
Message-ID: <1497970324-9725-5-git-send-email-fbihjmeric@gmail.com>
References: <1497970324-9725-1-git-send-email-fbihjmeric@gmail.com>
Cc: Jhih-Ming Hunag <fbihjmeric@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35410 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdFTOw0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2017 10:52:26 -0400
In-Reply-To: <1497970324-9725-1-git-send-email-fbihjmeric@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Jhih-Ming Hunag <fbihjmeric@gmail.com>

Move * to close variable name instead of type.

Signed-off-by: Jhih-Ming Hunag <fbihjmeric@gmail.com>
---
 drivers/staging/ccree/ssi_aead.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 3d9957f..6b9de35 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -1843,7 +1843,7 @@ static inline int ssi_aead_gcm(
 
 #ifdef CC_DEBUG
 static inline void ssi_aead_dump_gcm(
-	const char* title,
+	const char *title,
 	struct aead_request *req)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
-- 
2.7.4
