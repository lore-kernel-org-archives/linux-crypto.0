From: Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: [RFC PATCH v2 7/9] crypto: qce: Adds Makefile to build the driver
Date: Mon, 14 Apr 2014 15:48:43 +0300
Message-ID: <1397479725-20954-8-git-send-email-svarbanov@mm-sol.com>
References: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
Cc: Stanimir Varbanov <svarbanov@mm-sol.com>,
	linux-arm-msm@vger.kernel.org,
	Mona Hossain <mhossain@codeaurora.org>,
	Hariprasad Dhalinarasimha <hnamgund@codeaurora.org>,
	Zhen Kong <zkong@codeaurora.org>,
	Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
	Rohit Vaswani <rvaswani@codeaurora.org>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1397479725-20954-1-git-send-email-svarbanov@mm-sol.com>
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
