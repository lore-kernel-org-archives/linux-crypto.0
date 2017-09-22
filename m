From: sunil.m@techveda.org
Subject: [PATCH] staging: ccree: else is not generally useful after a break or return
Date: Fri, 22 Sep 2017 10:12:21 +0530
Message-ID: <1506055341-15379-1-git-send-email-sunil.m@techveda.org>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Suniel Mahesh <sunil.m@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36657 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751790AbdIVEmd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Sep 2017 00:42:33 -0400
Received: by mail-pf0-f196.google.com with SMTP id f84so7337pfj.3
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 21:42:33 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Suniel Mahesh <sunil.m@techveda.org>

Fixes checkpatch warnings:

WARNING: else is not generally useful after a break or return

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
---
Note:
- Patch was tested and built(ARCH=arm) on next-20170921.
  No build issues reported.
---
 drivers/staging/ccree/ssi_request_mgr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index daa5432..25eecbb 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -387,10 +387,9 @@ int send_request(
 		 */
 		wait_for_completion(&ssi_req->seq_compl);
 		return 0;
-	} else {
-		/* Operation still in process */
-		return -EINPROGRESS;
 	}
+	/* Operation still in process */
+	return -EINPROGRESS;
 }
 
 /*!
-- 
1.9.1
