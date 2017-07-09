From: sleepingzucchini@gmail.com
Subject: [PATCH 4/5] staging: ccree: export symbol immediately following function
Date: Sun,  9 Jul 2017 17:10:46 -0400
Message-ID: <6acd3dbaeaba5df3c91462932b6295fc107a7c7e.1499608047.git.sleepingzucchini@gmail.com>
References: <cover.1499608047.git.sleepingzucchini@gmail.com>
Cc: gregkh@linuxfoundation.orgc, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org,
        Tyler Olivieri <sleepingzucchini@gmail.com>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35873 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752770AbdGIWQA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Jul 2017 18:16:00 -0400
Received: by mail-qk0-f195.google.com with SMTP id v143so10811863qkb.3
        for <linux-crypto@vger.kernel.org>; Sun, 09 Jul 2017 15:16:00 -0700 (PDT)
In-Reply-To: <cover.1499608047.git.sleepingzucchini@gmail.com>
In-Reply-To: <cover.1499608047.git.sleepingzucchini@gmail.com>
References: <cover.1499608047.git.sleepingzucchini@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tyler Olivieri <sleepingzucchini@gmail.com>

Patch to fix following checkpatch warning:
WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable

Signed-off-by: Tyler Olivieri <sleepingzucchini@gmail.com>
---
 drivers/staging/ccree/ssi_fips.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
index fdc40f3..523057c 100644
--- a/drivers/staging/ccree/ssi_fips.c
+++ b/drivers/staging/ccree/ssi_fips.c
@@ -39,7 +39,6 @@ int ssi_fips_get_state(enum cc_fips_state_t *p_state)
 
 	return rc;
 }
-
 EXPORT_SYMBOL(ssi_fips_get_state);
 
 /*
@@ -57,5 +56,4 @@ int ssi_fips_get_error(enum cc_fips_error *p_err)
 
 	return rc;
 }
-
 EXPORT_SYMBOL(ssi_fips_get_error);
-- 
2.9.4
