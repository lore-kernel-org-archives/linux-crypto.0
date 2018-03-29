From: Atul Gupta <atul.gupta@chelsio.com>
Subject: [PATCH v14 net-next 12/12] crypto: chtls - Makefile Kconfig
Date: Thu, 29 Mar 2018 21:27:54 +0530
Message-ID: <1522339074-4681-13-git-send-email-atul.gupta@chelsio.com>
References: <1522339074-4681-1-git-send-email-atul.gupta@chelsio.com>
Cc: davejwatson@fb.com, sd@queasysnail.net, sbrivio@redhat.com,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        werner@chelsio.com, leedom@chelsio.com,
        swise@opengridcomputing.com, indranil@chelsio.com,
        ganeshgr@chelsio.com, atul.gupta@chelsio.com
To: davem@davemloft.net, herbert@gondor.apana.org.au
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1522339074-4681-1-git-send-email-atul.gupta@chelsio.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Entry for Inline TLS as another driver dependent on cxgb4 and chcr

Signed-off-by: Atul Gupta <atul.gupta@chelsio.com>
---
 drivers/crypto/chelsio/Kconfig        | 11 +++++++++++
 drivers/crypto/chelsio/Makefile       |  1 +
 drivers/crypto/chelsio/chtls/Makefile |  4 ++++
 3 files changed, 16 insertions(+)
 create mode 100644 drivers/crypto/chelsio/chtls/Makefile

diff --git a/drivers/crypto/chelsio/Kconfig b/drivers/crypto/chelsio/Kconfig
index 5ae9f87..930d82d 100644
--- a/drivers/crypto/chelsio/Kconfig
+++ b/drivers/crypto/chelsio/Kconfig
@@ -29,3 +29,14 @@ config CHELSIO_IPSEC_INLINE
         default n
         ---help---
           Enable support for IPSec Tx Inline.
+
+config CRYPTO_DEV_CHELSIO_TLS
+        tristate "Chelsio Crypto Inline TLS Driver"
+        depends on CHELSIO_T4
+        depends on TLS
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
