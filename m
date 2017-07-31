From: RishabhHardas <rishabheudyptula@gmail.com>
Subject: [PATCH] staging/ccree: Declare compiled out fuctions static inline
Date: Mon, 31 Jul 2017 14:47:23 +0530
Message-ID: <1501492643-7087-1-git-send-email-rishabheudyptula@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        RishabhHardas <rishabhhardas@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33867 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750807AbdGaJTp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 05:19:45 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: RishabhHardas <rishabhhardas@gmail.com>

Sparse was giving out a warning for symbols 'cc_set_ree_fips_status' and 'fips_handler'
that they were not declared and need to be made static. This patch makes both the symbols
static inline, to remove the warnings.

Signed-off-by: RishabhHardas <rishabhhardas@gmail.com>
---
 drivers/staging/ccree/ssi_fips.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips.h b/drivers/staging/ccree/ssi_fips.h
index 369ddf9..63bcca7 100644
--- a/drivers/staging/ccree/ssi_fips.h
+++ b/drivers/staging/ccree/ssi_fips.h
@@ -40,1 +40,1 @@ static inline int ssi_fips_init(struct ssi_drvdata *p_drvdata)
 }

 static inline void ssi_fips_fini(struct ssi_drvdata *drvdata) {}
-void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
-void fips_handler(struct ssi_drvdata *drvdata) {}
+static inline void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool ok) {}
+static inline void fips_handler(struct ssi_drvdata *drvdata) {}

 #endif /* CONFIG_CRYPTO_FIPS */
