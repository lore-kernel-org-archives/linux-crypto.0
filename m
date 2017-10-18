From: sunil.m@techveda.org
Subject: [PATCH v2] staging: ccree: Fix bool comparison
Date: Wed, 18 Oct 2017 07:40:14 +0530
Message-ID: <1508292614-15682-1-git-send-email-sunil.m@techveda.org>
References: <20171016211708.GM16106@eros>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org,
        Suniel Mahesh <sunil.m@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org, me@tobin.cc
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:50022 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762620AbdJRCKw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2017 22:10:52 -0400
Received: by mail-pg0-f66.google.com with SMTP id g6so2976833pgn.6
        for <linux-crypto@vger.kernel.org>; Tue, 17 Oct 2017 19:10:51 -0700 (PDT)
In-Reply-To: <20171016211708.GM16106@eros>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Suniel Mahesh <sunil.m@techveda.org>

Comparision operator "equal to" not required on a variable
"foo" of type "bool". Bool has only two values, can be used
directly or with logical not.

This fixes the following coccinelle warning:
WARNING: Comparison of bool to 0/1

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
---
Changes for v2:
- Changed the commit log to give a more accurate description
  of the changeset as suggested by Toby C.Harding
---
Note:
- Patch was built(ARCH=arm) on latest linux-next.
- No build issues reported, however it was not
  tested on real hardware.
- Please discard this changeset, if this is not
  helping the code look better.
---
 drivers/staging/ccree/ssi_request_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 2e0df57..942afe2 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -272,7 +272,7 @@ int send_request(
 	unsigned int max_required_seq_len = (total_seq_len +
 					((ssi_req->ivgen_dma_addr_len == 0) ? 0 :
 					SSI_IVPOOL_SEQ_LEN) +
-					((is_dout == 0) ? 1 : 0));
+					(!is_dout ? 1 : 0));
 
 #if defined(CONFIG_PM_RUNTIME) || defined(CONFIG_PM_SLEEP)
 	rc = ssi_power_mgr_runtime_get(dev);
-- 
1.9.1
