Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF4DAC433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 21:22:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A13420760
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 21:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbgFKVWF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 17:22:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:17090 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726153AbgFKVWF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 17:22:05 -0400
IronPort-SDR: aVXfT0g4FwV0zV4BpVVO31zLNZzQ/iLYlHvna3CtzRrf6lqdm0m03D8NkVKa0Wg3rB+TJA756T
 kO9hCN8ZEMYA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 14:22:04 -0700
IronPort-SDR: d4cAU04gFWhTVPJqJdCuYnE/tam7EzMyg/MqRU/SL0hlUp2MxdTzoOWv8BQc0YPLoThyXyslE/
 zRMZa5C9Avdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="314926411"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by FMSMGA003.fm.intel.com with ESMTP; 11 Jun 2020 14:22:02 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 3/3] crypto: qat - update timeout logic in put admin msg
Date:   Thu, 11 Jun 2020 22:14:49 +0100
Message-Id: <20200611211449.76144-4-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611211449.76144-1-giovanni.cabiddu@intel.com>
References: <20200611211449.76144-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Wojciech Ziemba <wojciech.ziemba@intel.com>

Replace timeout logic in adf_put_admin_msg_sync() with existing macro
readl_poll_timeout().

Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_common/adf_admin.c | 34 +++++++++++++----------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_admin.c b/drivers/crypto/qat/qat_common/adf_admin.c
index aa610f80296d..1c8ca151a963 100644
--- a/drivers/crypto/qat/qat_common/adf_admin.c
+++ b/drivers/crypto/qat/qat_common/adf_admin.c
@@ -3,7 +3,7 @@
 #include <linux/types.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/delay.h>
+#include <linux/iopoll.h>
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include "adf_accel_devices.h"
@@ -17,6 +17,8 @@
 #define ADF_DH895XCC_MAILBOX_STRIDE 0x1000
 #define ADF_ADMINMSG_LEN 32
 #define ADF_CONST_TABLE_SIZE 1024
+#define ADF_ADMIN_POLL_DELAY_US 20
+#define ADF_ADMIN_POLL_TIMEOUT_US (5 * USEC_PER_SEC)
 
 static const u8 const_tab[1024] __aligned(1024) = {
 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -111,12 +113,13 @@ struct adf_admin_comms {
 static int adf_put_admin_msg_sync(struct adf_accel_dev *accel_dev, u32 ae,
 				  void *in, void *out)
 {
+	int ret;
+	u32 status;
 	struct adf_admin_comms *admin = accel_dev->admin;
 	int offset = ae * ADF_ADMINMSG_LEN * 2;
 	void __iomem *mailbox = admin->mailbox_addr;
 	int mb_offset = ae * ADF_DH895XCC_MAILBOX_STRIDE;
 	struct icp_qat_fw_init_admin_req *request = in;
-	int times, received;
 
 	mutex_lock(&admin->lock);
 
@@ -127,24 +130,25 @@ static int adf_put_admin_msg_sync(struct adf_accel_dev *accel_dev, u32 ae,
 
 	memcpy(admin->virt_addr + offset, in, ADF_ADMINMSG_LEN);
 	ADF_CSR_WR(mailbox, mb_offset, 1);
-	received = 0;
-	for (times = 0; times < 50; times++) {
-		msleep(20);
-		if (ADF_CSR_RD(mailbox, mb_offset) == 0) {
-			received = 1;
-			break;
-		}
-	}
-	if (received)
-		memcpy(out, admin->virt_addr + offset +
-		       ADF_ADMINMSG_LEN, ADF_ADMINMSG_LEN);
-	else
+
+	ret = readl_poll_timeout(mailbox + mb_offset, status,
+				 status == 0, ADF_ADMIN_POLL_DELAY_US,
+				 ADF_ADMIN_POLL_TIMEOUT_US);
+	if (ret < 0) {
+		/* Response timeout */
 		dev_err(&GET_DEV(accel_dev),
 			"Failed to send admin msg %d to accelerator %d\n",
 			request->cmd_id, ae);
+	} else {
+		/* Response received from admin message, we can now
+		 * make response data available in "out" parameter.
+		 */
+		memcpy(out, admin->virt_addr + offset +
+		       ADF_ADMINMSG_LEN, ADF_ADMINMSG_LEN);
+	}
 
 	mutex_unlock(&admin->lock);
-	return received ? 0 : -EFAULT;
+	return ret;
 }
 
 static int adf_send_admin(struct adf_accel_dev *accel_dev,
-- 
2.26.2

