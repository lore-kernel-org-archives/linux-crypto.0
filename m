From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 2/2] crypto: qat - make adf_vf_isr.c dependant on IOV config
Date: Fri, 29 Apr 2016 11:00:00 -0700
Message-ID: <1461952800-14876-2-git-send-email-tadeusz.struk@intel.com>
References: <1461952800-14876-1-git-send-email-tadeusz.struk@intel.com>
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6078 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbcD2SAp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Apr 2016 14:00:45 -0400
In-Reply-To: <1461952800-14876-1-git-send-email-tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The adf_vf_isr.c should only be build if CONFIG_PCI_IOV is enabled

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/Makefile         |  4 ++--
 drivers/crypto/qat/qat_common/adf_common_drv.h | 14 ++++++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 5873d22..6d74b91 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -9,7 +9,6 @@ clean-files += qat_rsaprivkey-asn1.c qat_rsaprivkey-asn1.h
 obj-$(CONFIG_CRYPTO_DEV_QAT) += intel_qat.o
 intel_qat-objs := adf_cfg.o \
 	adf_isr.o \
-	adf_vf_isr.o \
 	adf_ctl_drv.o \
 	adf_dev_mgr.o \
 	adf_init.o \
@@ -27,4 +26,5 @@ intel_qat-objs := adf_cfg.o \
 	qat_hal.o
 
 intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o
-intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_pf2vf_msg.o adf_vf2pf_msg.o
+intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_pf2vf_msg.o \
+			       adf_vf2pf_msg.o adf_vf_isr.o
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 35ffa940..75faa39 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -144,8 +144,6 @@ void adf_disable_aer(struct adf_accel_dev *accel_dev);
 void adf_dev_restore(struct adf_accel_dev *accel_dev);
 int adf_init_aer(void);
 void adf_exit_aer(void);
-int adf_init_vf_wq(void);
-void adf_exit_vf_wq(void);
 int adf_init_admin_comms(struct adf_accel_dev *accel_dev);
 void adf_exit_admin_comms(struct adf_accel_dev *accel_dev);
 int adf_send_admin_init(struct adf_accel_dev *accel_dev);
@@ -243,6 +241,8 @@ int adf_vf2pf_init(struct adf_accel_dev *accel_dev);
 void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev);
 int adf_init_pf_wq(void);
 void adf_exit_pf_wq(void);
+int adf_init_vf_wq(void);
+void adf_exit_vf_wq(void);
 #else
 static inline int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 {
@@ -278,5 +278,15 @@ static inline int adf_init_pf_wq(void)
 static inline void adf_exit_pf_wq(void)
 {
 }
+
+static inline int adf_init_vf_wq(void)
+{
+	return 0;
+}
+
+static inline void adf_exit_vf_wq(void)
+{
+}
+
 #endif
 #endif
-- 
2.1.4
