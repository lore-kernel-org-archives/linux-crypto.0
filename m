From: Dhananjay Balan <mail@dbalan.in>
Subject: [PATCH] drivers: staging: ccree: use __func__ to get function name in error messages.
Date: Mon, 17 Jul 2017 15:53:05 +0200
Message-ID: <20170717135305.28296-1-mail@dbalan.in>
Cc: gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Dhananjay Balan <mail@dbalan.in>
To: gilad@benyossef.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35275 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751280AbdGQNya (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Jul 2017 09:54:30 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

fixes checkpatch warning.

Signed-off-by: Dhananjay Balan <mail@dbalan.in>
---
 drivers/staging/ccree/ssi_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index d7b9a636d907..e0faca0a30a6 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -81,7 +81,7 @@ void dump_byte_array(const char *name, const u8 *the_array, unsigned long size)
 	char line_buf[80];
 
 	if (!the_array) {
-		SSI_LOG_ERR("cannot dump_byte_array - NULL pointer\n");
+		SSI_LOG_ERR("cannot %s - NULL pointer\n", __func__);
 		return;
 	}
 
-- 
2.13.2
