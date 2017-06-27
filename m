From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 03/14] staging: ccree: fix else placement
Date: Tue, 27 Jun 2017 10:27:15 +0300
Message-ID: <1498548449-10803-4-git-send-email-gilad@benyossef.com>
References: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52432 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752364AbdF0H17 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Jun 2017 03:27:59 -0400
In-Reply-To: <1498548449-10803-1-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix cases where the else clause was not located correctly after the if
brace.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/ssi_buffer_mgr.c | 3 +--
 drivers/staging/ccree/ssi_pm.c         | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
index 5c46145..3c74ae3 100644
--- a/drivers/staging/ccree/ssi_buffer_mgr.c
+++ b/drivers/staging/ccree/ssi_buffer_mgr.c
@@ -852,8 +852,7 @@ static inline int ssi_buffer_mgr_aead_chain_assoc(
 	sg_index = current_sg->length;
 	if (sg_index > size_of_assoc) { //the first entry in the scatter list contains all the associated data
 		mapped_nents++;
-	}
-	else{
+	} else {
 		while (sg_index <= size_of_assoc) {
 			current_sg = sg_next(current_sg);
 			//if have reached the end of the sgl, then this is unexpected
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index c8c5875..ae1f7f0 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -110,8 +110,7 @@ int ssi_power_mgr_runtime_put_suspend(struct device *dev)
 				(struct ssi_drvdata *)dev_get_drvdata(dev))) {
 		pm_runtime_mark_last_busy(dev);
 		rc = pm_runtime_put_autosuspend(dev);
-	}
-	else {
+	} else {
 		/* Something wrong happens*/
 		BUG();
 	}
-- 
2.1.4
