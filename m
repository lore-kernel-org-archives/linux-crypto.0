From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [RFC][PATCH 8/8 v4] crypto: Update to makefiles
Date: Thu, 05 Jun 2014 13:44:39 -0700
Message-ID: <20140605204425.1400.28427.stgit@gitlad.jf.intel.com>
References: <20140605204133.1400.64237.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: tadeusz.struk@intel.com, davem@davemloft.net,
	john.griffin@intel.com, bruce.w.allan@intel.com,
	john.ronciak@intel.com, karen.xiang@intel.com,
	pingchaox.yang@intel.com, bo.cui@intel.com, qat-linux@intel.com,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14027 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaFEUpR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jun 2014 16:45:17 -0400
In-Reply-To: <20140605204133.1400.64237.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Update to makefiles etc.
Don't update the firmware/Makefile yet since there is no FW binary in
the crypto repo yet. This will be added later.

v3 - removed change to ./firmware/Makefile

Reviewed-by: Bruce W. Allan <bruce.w.allan@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---

 Documentation/ioctl/ioctl-number.txt |    1 +
 MAINTAINERS                          |    6 ++++++
 drivers/crypto/Kconfig               |    1 +
 drivers/crypto/Makefile              |    1 +
 4 files changed, 9 insertions(+)

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
