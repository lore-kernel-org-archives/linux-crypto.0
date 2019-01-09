Return-Path: <SRS0=1Gsi=PR=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr770055.outbound.protection.outlook.com ([40.107.77.55]:8155
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729686AbfAIJ05 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Jan 2019 04:26:57 -0500
From: Kalyani Akula <kalyani.akula@xilinx.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>,
        Kalyani Akula <kalyani.akula@xilinx.com>
Subject: [RFC PATCH V2 2/4] firmware: xilinx: Add ZynqMP sha_hash API for SHA3 functionality
Date: Wed, 9 Jan 2019 14:56:23 +0530
Message-ID: <1547025985-7228-3-git-send-email-kalyani.akula@xilinx.com>
In-Reply-To: <1547025985-7228-1-git-send-email-kalyani.akula@xilinx.com>
References: <1547025985-7228-1-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add ZynqMP firmware SHA_HASH API to compute SHA3 hash of given data.

Signed-off-by: Kalyani Akula <kalyani.akula@xilinx.com>
---
 drivers/firmware/xilinx/zynqmp.c     |   27 +++++++++++++++++++++++++++
 include/linux/firmware/xlnx-zynqmp.h |    2 ++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index 9a1c72a..c51ecce 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -469,8 +469,35 @@ static int zynqmp_pm_ioctl(u32 node_id, u32 ioctl_id, u32 arg1, u32 arg2,
 				   arg1, arg2, out);
 }
 
+/**
+ * zynqmp_pm_sha_hash - Access the SHA engine to calculate the hash
+ * @address:	Address of the data/ Address of output buffer where
+ *		hash should be stored.
+ * @size:	Size of the data.
+ * @flags:
+ *	BIT(0) - for initializing csudma driver and SHA3(Here address
+ *		 and size inputs can be NULL).
+ *	BIT(1) - to call Sha3_Update API which can be called multiple
+ *		 times when data is not contiguous.
+ *	BIT(2) - to get final hash of the whole updated data.
+ *		 Hash will be overwritten at provided address with
+ *		 48 bytes.
+ *
+ * Return:	Returns status, either success or error code.
+ */
+static int zynqmp_pm_sha_hash(const u64 address, const u32 size,
+			      const u32 flags)
+{
+	u32 lower_32_bits = (u32)address;
+	u32 upper_32_bits = (u32)(address >> 32);
+
+	return zynqmp_pm_invoke_fn(PM_SECURE_SHA, upper_32_bits, lower_32_bits,
+				   size, flags, NULL);
+}
+
 static const struct zynqmp_eemi_ops eemi_ops = {
 	.get_api_version = zynqmp_pm_get_api_version,
+	.sha_hash = zynqmp_pm_sha_hash,
 	.query_data = zynqmp_pm_query_data,
 	.clock_enable = zynqmp_pm_clock_enable,
 	.clock_disable = zynqmp_pm_clock_disable,
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index 3c3c28e..72ffe09 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -34,6 +34,7 @@
 
 enum pm_api_id {
 	PM_GET_API_VERSION = 1,
+	PM_SECURE_SHA = 26,
 	PM_IOCTL = 34,
 	PM_QUERY_DATA,
 	PM_CLOCK_ENABLE,
@@ -102,6 +103,7 @@ struct zynqmp_eemi_ops {
 	int (*clock_setparent)(u32 clock_id, u32 parent_id);
 	int (*clock_getparent)(u32 clock_id, u32 *parent_id);
 	int (*ioctl)(u32 node_id, u32 ioctl_id, u32 arg1, u32 arg2, u32 *out);
+	int (*sha_hash)(const u64 address, const u32 size, const u32 flags);
 };
 
 #if IS_REACHABLE(CONFIG_ARCH_ZYNQMP)
-- 
1.7.1
