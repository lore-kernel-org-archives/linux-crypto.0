From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [RFC][PATCH 4/4 v2] crypto: Updated makefiles to add Intel(R) QAT
Date: Tue, 3 Jun 2014 15:20:14 -0700
Message-ID: <20140603222014.GA6239@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, john.griffin@intel.com,
	bruce.w.allan@intel.com, karen.xiang@intel.com,
	pingchaox.yang@intel.com, bo.cui@intel.com, davem@davemloft.net,
	qat-linux@intel.com, linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38637 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbaFCWUP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Jun 2014 18:20:15 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update to makefiles etc.
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 Documentation/ioctl/ioctl-number.txt | 1 +
 MAINTAINERS                          | 6 ++++++
 drivers/crypto/Kconfig               | 1 +
 drivers/crypto/Makefile              | 1 +
 firmware/Makefile                    | 1 +
 5 files changed, 10 insertions(+)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index d7e43fa..7e240a7 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -197,6 +197,7 @@ Code  Seq#(hex)	Include File		Comments
 					<mailto:gregkh@linuxfoundation.org>
 'a'	all	linux/atm*.h, linux/sonet.h	ATM on linux
 					<http://lrcwww.epfl.ch/>
+'a'	00-0F	drivers/crypto/qat/qat_common/adf_cfg_common.h	conflict! qat driver
 'b'	00-FF				conflict! bit3 vme host bridge
 					<mailto:natalia@nikhefk.nikhef.nl>
 'c'	all	linux/cm4000_cs.h	conflict!
diff --git a/MAINTAINERS b/MAINTAINERS
index 3467445..624a9cf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7060,6 +7060,12 @@ M:	Robert Jarzmik <robert.jarzmik@free.fr>
 L:	rtc-linux@googlegroups.com
 S:	Maintained
 
+QAT DRIVER
+M:      Tadeusz Struk <tadeusz.struk@intel.com>
+L:      qat-linux@intel.com
+S:      Supported
+F:      drivers/crypto/qat/
+
 QIB DRIVER
 M:	Mike Marciniszyn <infinipath@intel.com>
 L:	linux-rdma@vger.kernel.org
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f066fa2..1f20814 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -418,4 +418,5 @@ config CRYPTO_DEV_MXS_DCP
 	  To compile this driver as a module, choose M here: the module
 	  will be called mxs-dcp.
 
+source "drivers/crypto/qat/Kconfig"
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 482f090..f996ed7 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
+obj-$(CONFIG_CRYPTO_DEV_QAT) += qat/
diff --git a/firmware/Makefile b/firmware/Makefile
index cbb09ce..89ac80b 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -135,6 +135,7 @@ fw-shipped-$(CONFIG_USB_SERIAL_XIRCOM) += keyspan_pda/xircom_pgs.fw
 fw-shipped-$(CONFIG_USB_VICAM) += vicam/firmware.fw
 fw-shipped-$(CONFIG_VIDEO_CPIA2) += cpia2/stv0672_vp4.bin
 fw-shipped-$(CONFIG_YAM) += yam/1200.bin yam/9600.bin
+fw-shipped-$(CONFIG_CRYPTO_DEV_QAT_DH895xCC) += qat_895xcc.bin
 
 fw-shipped-all := $(fw-shipped-y) $(fw-shipped-m) $(fw-shipped-)
 
-- 
1.8.5.rc2.6.gc6f1b92.dirty
