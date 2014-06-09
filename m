From: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/4] crypto: Update makefile and Kconfig for
 Security System
Date: Mon,  9 Jun 2014 12:59:09 +0200
Message-ID: <1402311551-19564-3-git-send-email-clabbe.montjoie@gmail.com>
References: <1402311551-19564-1-git-send-email-clabbe.montjoie@gmail.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	pawel.moll-5wv7dgnIgG8@public.gmane.org,
	mark.rutland-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org,
	galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
	maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
	linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBBCVH22OAKGQET6SPG5Q-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1402311551-19564-1-git-send-email-clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

Add necessary changes for configuring and compiling the Security System driver.

Signed-off-by: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/crypto/Kconfig  | 76 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/crypto/Makefile |  1 +
 2 files changed, 77 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 03ccdb0..758f63d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -418,4 +418,80 @@ config CRYPTO_DEV_MXS_DCP
 	  To compile this driver as a module, choose M here: the module
 	  will be called mxs-dcp.
 
+config CRYPTO_DEV_SUNXI_SS
+        tristate "Support for Allwinner Security System cryptographic accelerator"
+        depends on ARCH_SUNXI
+        help
+          Some Allwinner SoC have a crypto accelerator named
+          Security System. Select this if you want to use it.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss.
+
+if CRYPTO_DEV_SUNXI_SS
+config CRYPTO_DEV_SUNXI_SS_PRNG
+	tristate "Security System PRNG"
+	select CRYPTO_RNG2
+	help
+	  If you enable this option, the SS will provide a pseudo random
+	  number generator.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-prng.
+
+config CRYPTO_DEV_SUNXI_SS_MD5
+	tristate "Security System MD5"
+	select CRYPTO_MD5
+	help
+	  If you enable this option, the SS will provide MD5 hardware
+	  acceleration.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-md5.
+
+config CRYPTO_DEV_SUNXI_SS_SHA1
+	tristate "Security System SHA1"
+	select CRYPTO_SHA1
+	help
+	  If you enable this option, the SS will provide SHA1 hardware
+	  acceleration.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-sha1.
+
+config CRYPTO_DEV_SUNXI_SS_AES
+	tristate "Security System AES"
+	select CRYPTO_AES
+	select CRYPTO_BLKCIPHER
+	help
+	  If you enable this option, the SS will provide AES hardware
+	  acceleration.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-aes.
+
+config CRYPTO_DEV_SUNXI_SS_DES
+	tristate "Security System DES"
+	select CRYPTO_DES
+	select CRYPTO_BLKCIPHER
+	help
+	  If you enable this option, the SS will provide DES hardware
+	  acceleration.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-des.
+
+config CRYPTO_DEV_SUNXI_SS_3DES
+	tristate "Security System 3DES"
+	select CRYPTO_DES
+	select CRYPTO_BLKCIPHER
+	help
+	  If you enable this option, the SS will provide 3DES hardware
+	  acceleration.
+
+          To compile this driver as a module, choose M here: the module
+          will be called sunxi-ss-3des.
+
+endif #CRYPTO_DEV_SUNXI_SS
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 482f090..855292a 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -23,3 +23,4 @@ obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_SAHARA) += sahara.o
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
+obj-$(CONFIG_CRYPTO_DEV_SUNXI_SS) += sunxi-ss/
-- 
1.8.5.5
