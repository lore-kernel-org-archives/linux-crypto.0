From: rishabh hardas <rishabheudyptula@gmail.com>
Subject: [PATCH] Removed a sparse warning
Date: Sun, 30 Jul 2017 15:05:18 +0530
Message-ID: <1501407318-24081-1-git-send-email-rishabheudyptula@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        rishabh hardas <rishabheudyptula@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36074 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdG3Jf2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jul 2017 05:35:28 -0400
Received: by mail-pg0-f67.google.com with SMTP id y129so27779682pgy.3
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jul 2017 02:35:28 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: rishabh hardas <rishabheudyptula@gmail.com>
---
 drivers/staging/ccree/ssi_fips.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index 369ddf9..846bd55 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -40,7 +40,7 @@ static inline int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 }

 static inline void ssi_fips_fini(struct ssi_drvdata *drvdata) {}
-void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
+static void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
 void fips_handler(struct ssi_drvdata *drvdata) {}

 #endif /* CONFIG_CRYPTO_FIPS */
