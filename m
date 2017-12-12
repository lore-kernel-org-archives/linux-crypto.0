From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [RFC crypto v2 9/9] Makefile Kconfig
Date: Tue, 12 Dec 2017 17:36:11 +0530
Message-ID: <1513080371-11668-1-git-send-email-atul.gupta@chelsio.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, davejwatson@fb.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        ganeshgr@chelsio.com
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Entry for Inline TLS as another driver dependent on cxgb4 and chcr

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/Kconfig        | 10 ++++++++++
 drivers/crypto/chelsio/Makefile       |  1 +
 drivers/crypto/chelsio/chtls/Makefile |  4 ++++
 3 files changed, 15 insertions(+)
 create mode 100644 drivers/crypto/chelsio/chtls/Makefile

diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index 51932c7..686d246 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -28,3 +28,13 @@ config CHELSIO_IPSEC_INLINE
         default n
         ---help---
           Enable support for IPSec Tx Inline.
+
+config CRYPTO_DEV_CHELSIO_TLS
+        tristate "Chelsio Crypto Inline TLS Driver"
+        depends on CHELSIO_T4
+        select CRYPTO_DEV_CHELSIO
+        ---help---
+          Support Chelsio Inline TLS with Chelsio crypto accelerator.
+
+          To compile this driver as a module, choose M here: the module
+          will be called chtls.
diff --git a/drivers/crypto/chelsio/Makefile b/drivers/crypto/chelsio/Makefile
index eaecaf1..639e571 100644
--- a/drivers/crypto/chelsio/Makefile
+++ b/drivers/crypto/chelsio/Makefile
@@ -3,3 +3,4 @@ ccflags-y := -Idrivers/net/ethernet/chelsio/cxgb4
 obj-$(CONFIG_CRYPTO_DEV_CHELSIO) += chcr.o
 chcr-objs :=  chcr_core.o chcr_algo.o
 chcr-$(CONFIG_CHELSIO_IPSEC_INLINE) += chcr_ipsec.o
+obj-$(CONFIG_CRYPTO_DEV_CHELSIO_TLS) += chtls/
diff --git a/drivers/crypto/chelsio/chtls/Makefile b/drivers/crypto/chelsio/chtls/Makefile
new file mode 100644
index 0000000..df13795
--- /dev/null
+++ b/drivers/crypto/chelsio/chtls/Makefile
@@ -0,0 +1,4 @@
+ccflags-y := -Idrivers/net/ethernet/chelsio/cxgb4 -Idrivers/crypto/chelsio/
+
+obj-$(CONFIG_CRYPTO_DEV_CHELSIO_TLS) += chtls.o
+chtls-objs := chtls_main.o chtls_cm.o chtls_io.o chtls_hw.o
-- 
1.8.3.1
