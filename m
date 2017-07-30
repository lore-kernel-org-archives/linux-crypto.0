From: rishabh hardas <rishabheudyptula@gmail.com>
Subject: [PATCH] ccree: Removed a sparse warning in ssi_fips.h
Date: Sun, 30 Jul 2017 19:45:33 +0530
Message-ID: <1501424133-27810-1-git-send-email-rishabheudyptula@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        rishabh hardas <rishabheudyptula@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:37602 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751360AbdG3OPo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 30 Jul 2017 10:15:44 -0400
Received: by mail-pf0-f193.google.com with SMTP id 72so3663686pfl.4
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jul 2017 07:15:44 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sparse was giving out a warning 'warning: symbol 'cc_set_ree_fips_status' was not declared. Should it be static?'
which has been removed by making it static.

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
