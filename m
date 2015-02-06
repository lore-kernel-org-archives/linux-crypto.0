From: "Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>
Subject: [PATCHv2 7/7] Enabling VMX module for PPC64
Date: Fri, 6 Feb 2015 14:59:48 -0200
Message-ID: <20150206165945.GA24403@bluepex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch enables VMX module in PPC64.

Signed-off-by: Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
---
 drivers/crypto/Kconfig      |  9 +++++++++
 drivers/crypto/Makefile     |  1 +
 drivers/crypto/vmx/Kconfig  |  8 ++++++++
 drivers/crypto/vmx/Makefile | 19 +++++++++++++++++++
 4 files changed, 37 insertions(+)
 create mode 100644 drivers/crypto/vmx/Kconfig
 create mode 100644 drivers/crypto/vmx/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 2fb0fdf..5da83c4 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -436,4 +436,13 @@ config CRYPTO_DEV_QCE
 	  hardware. To compile this driver as a module, choose M here. The
 	  module will be called qcrypto.
 
+config CRYPTO_DEV_VMX
+	bool "Support for VMX cryptographic acceleration instructions"
+	depends on PPC64
+	default n
+	help
+	  Support for VMX cryptographic acceleration instructions.
+
+source "drivers/crypto/vmx/Kconfig"
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 3924f93..20a7127 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -25,3 +25,4 @@ obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
 obj-$(CONFIG_CRYPTO_DEV_QAT) += qat/
 obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
+obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
diff --git a/drivers/crypto/vmx/Kconfig b/drivers/crypto/vmx/Kconfig
new file mode 100644
index 0000000..771babf
--- /dev/null
+++ b/drivers/crypto/vmx/Kconfig
@@ -0,0 +1,8 @@
+config CRYPTO_DEV_VMX_ENCRYPT
+	tristate "Encryption acceleration support on P8 CPU"
+	depends on PPC64 && CRYPTO_DEV_VMX
+	default y
+	help
+	  Support for VMX cryptographic acceleration instructions on Power8 CPU.
+	  This module supports acceleration for AES and GHASH in hardware. If you
+	  choose 'M' here, this module will be called vmx-crypto.
diff --git a/drivers/crypto/vmx/Makefile b/drivers/crypto/vmx/Makefile
new file mode 100644
index 0000000..c699c6e
--- /dev/null
+++ b/drivers/crypto/vmx/Makefile
@@ -0,0 +1,19 @@
+obj-$(CONFIG_CRYPTO_DEV_VMX_ENCRYPT) += vmx-crypto.o
+vmx-crypto-objs := vmx.o aesp8-ppc.o ghashp8-ppc.o aes.o aes_cbc.o aes_ctr.o ghash.o
+
+ifeq ($(CONFIG_CPU_LITTLE_ENDIAN),y)
+TARGET := linux-ppc64le
+else
+TARGET := linux-pcc64
+endif
+
+quiet_cmd_perl = PERL $@
+      cmd_perl = $(PERL) $(<) $(TARGET) > $(@)
+
+$(src)/aesp8-ppc.S: $(src)/aesp8-ppc.pl
+	$(call cmd,perl)
+  
+$(src)/ghashp8-ppc.S: $(src)/ghashp8-ppc.pl
+	$(call cmd,perl)
+
+.PRECIOUS: $(obj)/aesp8-ppc.S $(obj)/ghashp8-ppc.S
-- 
2.1.0
