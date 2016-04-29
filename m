From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - fix adf_ctl_drv.c:undefined reference to adf_init_pf_wq
Date: Fri, 29 Apr 2016 10:43:40 -0700
Message-ID: <1461951820-11225-1-git-send-email-tadeusz.struk@intel.com>
References: <201604290313.pe3TL9PF%fengguang.wu@intel.com>
Cc: linux-crypto@vger.kernel.org, fengguang.wu@intel.com,
	tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:45364 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbcD2RoY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 13:44:24 -0400
In-Reply-To: <201604290313.pe3TL9PF%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Fix undefined reference issue reported by kbuild test robot.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_common_drv.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index ff0b37b..35ffa940 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -146,8 +146,6 @@ int adf_init_aer(void);
 void adf_exit_aer(void);
 int adf_init_vf_wq(void);
 void adf_exit_vf_wq(void);
-int adf_init_pf_wq(void);
-void adf_exit_pf_wq(void);
 int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
 void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
 int adf_send_admin_init(struct adf_accel_dev *accel_dev);
@@ -243,6 +241,8 @@ void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 
 int adf_vf2pf_init(struct adf_accel_dev *accel_dev);
 void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev);
+int adf_init_pf_wq(void);
+void adf_exit_pf_wq(void);
 #else
 static inline int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 {
@@ -269,5 +269,14 @@ static inline int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
 static inline void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
 {
 }
+
+static inline int adf_init_pf_wq(void)
+{
+	return 0;
+}
+
+static inline void adf_exit_pf_wq(void)
+{
+}
 #endif
 #endif
-- 
2.1.4
