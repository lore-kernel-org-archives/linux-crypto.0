From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - correctly type a boolean
Date: Fri, 09 Jan 2015 11:55:04 -0800
Message-ID: <20150109195503.28205.68665.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53271 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbbAITyg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Jan 2015 14:54:36 -0500
Received: from gitlad.jf.intel.com (gitlad.jf.intel.com [127.0.0.1])
	by gitlad.jf.intel.com (8.14.2/8.14.2) with ESMTP id t09Jt4KO028257
	for <linux-crypto@vger.kernel.org>; Fri, 9 Jan 2015 11:55:04 -0800
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---

 drivers/crypto/qat/qat_common/adf_init.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index a3afa0f..edbf85a 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -276,7 +276,8 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
 	struct list_head *list_itr;
-	int ret, wait = 0;
+	bool wait = false;
+	int ret;
 
 	if (!adf_dev_started(accel_dev) &&
 	    !test_bit(ADF_STATUS_STARTING, &accel_dev->status)) {
@@ -298,7 +299,7 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 		if (!ret) {
 			clear_bit(accel_dev->accel_id, &service->start_status);
 		} else if (ret == -EAGAIN) {
-			wait = 1;
+			wait = true;
 			clear_bit(accel_dev->accel_id, &service->start_status);
 		}
 	}
