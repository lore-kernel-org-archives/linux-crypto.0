From: Stanimir Varbanov <svarbanov-NEYub+7Iv8PQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 2/3] crypto: qce: Build Qualcomm crypto driver
Date: Wed, 25 Jun 2014 19:28:58 +0300
Message-ID: <1403713739-3074-3-git-send-email-svarbanov@mm-sol.com>
References: <1403713739-3074-1-git-send-email-svarbanov@mm-sol.com>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stanimir Varbanov <svarbanov-NEYub+7Iv8PQT0dZR+AlfA@public.gmane.org>
To: Rob Herring <rob.herring-bsGFqQB8/DxBDgjK7y7TUQ@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>,
	Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403713739-3074-1-git-send-email-svarbanov-NEYub+7Iv8PQT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Modify crypto Kconfig and Makefile in order to build the qce
driver and adds qce Makefile as well.

Signed-off-by: Stanimir Varbanov <svarbanov-NEYub+7Iv8PQT0dZR+AlfA@public.gmane.org>
---
 drivers/crypto/Kconfig      |   15 +++++++++++++++
 drivers/crypto/Makefile     |    1 +
 drivers/crypto/qce/Makefile |    6 ++++++
 3 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 drivers/crypto/qce/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f066fa2..8b87362 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -418,4 +418,19 @@ config CRYPTO_DEV_MXS_DCP
 	  To compile this driver as a module, choose M here: the module
 	  will be called mxs-dcp.
 
+config CRYPTO_DEV_QCE
+	tristate "Qualcomm crypto engine accelerator"
+	select CRYPTO_AES
+	select CRYPTO_DES
+	select CRYPTO_ECB
+	select CRYPTO_CBC
+	select CRYPTO_XTS
+	select CRYPTO_CTR
+	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
+	help
+	  This driver supports Qualcomm crypto engine accelerator
+	  hardware. To compile this driver as a module, choose M here. The
+	  module will be called qcrypto.
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 482f090..320937b 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
+obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
diff --git a/drivers/crypto/qce/Makefile b/drivers/crypto/qce/Makefile
new file mode 100644
index 0000000..348dc31
--- /dev/null
+++ b/drivers/crypto/qce/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_CRYPTO_DEV_QCE) += qcrypto.o
+qcrypto-objs := core.o \
+		common.o \
+		dma.o \
+		sha.o \
+		ablkcipher.o
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
