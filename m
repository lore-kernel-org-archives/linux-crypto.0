From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: [PATCH 1/2] drivers: crypto: move nx build to driver/crypto Makefile
Date: Wed, 13 Jun 2012 13:22:42 -0500
Message-ID: <1339611763-14603-1-git-send-email-sjenning@linux.vnet.ibm.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
	Paul Mackerras <paulus@samba.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Kent Yoder <key@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

When the nx driver was pulled, the Makefile that actually
builds it is arch/powerpc/Makefile. This is unnatural.

This patch moves the line that builds the nx driver from
arch/powerpc/Makefile to drivers/crypto/Makefile where it
belongs.

Cc: Kent Yoder <key@linux.vnet.ibm.com>
Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 arch/powerpc/Makefile   |    1 -
 drivers/crypto/Makefile |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 950d1f7..159e94f 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -149,7 +149,6 @@ core-$(CONFIG_KVM) 		+= arch/powerpc/kvm/
 core-$(CONFIG_PERF_EVENTS)	+= arch/powerpc/perf/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
-drivers-$(CONFIG_CRYPTO_DEV_NX) += drivers/crypto/nx/
 
 # Default to zImage, override when needed
 all: zImage
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 0139032..67b4fbf 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -14,4 +14,5 @@ obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) += omap-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PICOXCELL) += picoxcell_crypto.o
 obj-$(CONFIG_CRYPTO_DEV_S5P) += s5p-sss.o
 obj-$(CONFIG_CRYPTO_DEV_TEGRA_AES) += tegra-aes.o
-obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
\ No newline at end of file
+obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
+obj-$(CONFIG_CRYPTO_DEV_NX) += nx/
-- 
1.7.9.5
