From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH 3/4] crypto: s5p-sss - Document the struct s5p_aes_dev
Date: Fri, 17 Mar 2017 16:49:21 +0200
Message-ID: <20170317144922.27379-4-krzk@kernel.org>
References: <20170317144922.27379-1-krzk@kernel.org>
Cc: Nathan Royce <nroycea+kernel@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vz@mleia.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170317144922.27379-1-krzk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add kernel-doc to s5p_aes_dev structure.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/crypto/s5p-sss.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 35ea84b7d775..7ac657f46d15 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -170,6 +170,32 @@ struct s5p_aes_ctx {
 	int				keylen;
 };
 
+/**
+ * struct s5p_aes_dev - Crypto device state container
+ * @dev:	Associated device
+ * @clk:	Clock for accessing hardware
+ * @ioaddr:	Mapped IO memory region
+ * @aes_ioaddr:	Per-varian offset for AES block IO memory
+ * @irq_fc:	Feed control interrupt line
+ * @req:	Crypto request currently handled by the device
+ * @ctx:	Configuration for currently handled crypto request
+ * @sg_src:	Scatter list with source data for currently handled block
+ *		in device.  This is DMA-mapped into device.
+ * @sg_dst:	Scatter list with destination data for currently handled block
+ *		in device. This is DMA-mapped into device.
+ * @sg_src_cpy:	In case of unaligned access, copied scatter list
+ *		with source data.
+ * @sg_dst_cpy:	In case of unaligned access, copied scatter list
+ *		with destination data.
+ * @tasklet:	New request scheduling jib
+ * @queue:	Crypto queue
+ * @busy:	Indicates whether the device is currently handling some request
+ *		thus it uses some of the fields from this state, like:
+ *		req, ctx, sg_src/dst (and copies).  This essentially
+ *		protects against concurrent access to these fields.
+ * @lock:	Lock for protecting both access to device hardware registers
+ *		and fields related to current request (including the busy field).
+ */
 struct s5p_aes_dev {
 	struct device			*dev;
 	struct clk			*clk;
@@ -182,7 +208,6 @@ struct s5p_aes_dev {
 	struct scatterlist		*sg_src;
 	struct scatterlist		*sg_dst;
 
-	/* In case of unaligned access: */
 	struct scatterlist		*sg_src_cpy;
 	struct scatterlist		*sg_dst_cpy;
 
-- 
2.9.3
