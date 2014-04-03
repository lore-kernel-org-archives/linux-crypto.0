From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [PATCH 7/9] crypto: qce: Adds Makefile to build the driver
Date: Thu,  3 Apr 2014 19:18:04 +0300
Message-ID: <1396541886-10966-8-git-send-email-svarbanov@mm-sol.com>
References: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1396541886-10966-1-git-send-email-svarbanov@mm-sol.com>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Adds Makefile needed to build the driver.

Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
---
 drivers/crypto/qce/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)
 create mode 100644 drivers/crypto/qce/Makefile

diff --git a/drivers/crypto/qce/Makefile b/drivers/crypto/qce/Makefile
new file mode 100644
index 000000000000..348dc3173afa
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
1.8.4.4
