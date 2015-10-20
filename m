From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - when stopping all devices make fure VF are
 stopped first
Date: Tue, 20 Oct 2015 12:50:03 -0700
Message-ID: <20151020195003.8954.19651.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:50409 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbbJTTw3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Oct 2015 15:52:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When stopping all devices make sure VFs are stopped before the
corresponding PF.
VFs will always be after PF so just need to loop back.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_ctl_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 03856ad..bd8dfa1 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -278,7 +278,7 @@ static int adf_ctl_stop_devices(uint32_t id)
 	struct list_head *itr, *head = adf_devmgr_get_head();
 	int ret = 0;
 
-	list_for_each(itr, head) {
+	list_for_each_prev(itr, head) {
 		struct adf_accel_dev *accel_dev =
 				list_entry(itr, struct adf_accel_dev, list);
 		if (id == accel_dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
