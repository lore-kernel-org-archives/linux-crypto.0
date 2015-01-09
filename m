From: Bruce Allan <bruce.w.allan@intel.com>
Subject: [PATCH] crypto: qat - remove unnecessary include of atomic.h header
	file
Date: Fri, 09 Jan 2015 11:55:20 -0800
Message-ID: <20150109195519.28205.93244.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:48829 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbbAITyx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Jan 2015 14:54:53 -0500
Received: from gitlad.jf.intel.com (gitlad.jf.intel.com [127.0.0.1])
	by gitlad.jf.intel.com (8.14.2/8.14.2) with ESMTP id t09JtK59028299
	for <linux-crypto@vger.kernel.org>; Fri, 9 Jan 2015 11:55:20 -0800
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
---

 drivers/crypto/qat/qat_common/adf_accel_devices.h  |    1 -
 .../crypto/qat/qat_common/adf_transport_internal.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index ed226ce..19c0efa 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -47,7 +47,6 @@
 #ifndef ADF_ACCEL_DEVICES_H_
 #define ADF_ACCEL_DEVICES_H_
 #include <linux/module.h>
-#include <linux/atomic.h>
 #include <linux/list.h>
 #include <linux/proc_fs.h>
 #include <linux/io.h>
diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index c405460..a486962 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_internal.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -48,7 +48,6 @@
 #define ADF_TRANSPORT_INTRN_H
 
 #include <linux/interrupt.h>
-#include <linux/atomic.h>
 #include <linux/spinlock_types.h>
 #include "adf_transport.h"
 
