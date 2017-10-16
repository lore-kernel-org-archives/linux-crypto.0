From: sunil.m@techveda.org
Subject: [PATCH] staging: ccree: Fix bool comparison
Date: Mon, 16 Oct 2017 15:38:11 +0530
Message-ID: <1508148491-11837-1-git-send-email-sunil.m@techveda.org>
Cc: linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, karthik@techveda.org,
        Suniel Mahesh <sunil.m@techveda.org>
To: gilad@benyossef.com, gregkh@linuxfoundation.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:53767 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751438AbdJPKIX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2017 06:08:23 -0400
Received: by mail-pg0-f66.google.com with SMTP id s2so6420492pge.10
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2017 03:08:23 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Suniel Mahesh <sunil.m@techveda.org>

Bool tests don't need comparisons.

This fixes the following coccinelle warning:
WARNING: Comparison of bool to 0/1

Signed-off-by: Suniel Mahesh <sunil.m@techveda.org>
---
Note:
- Patch was tested and built(ARCH=arm) on latest
  linux-next.
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
