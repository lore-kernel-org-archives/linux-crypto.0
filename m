From: Antoine Tenart <antoine.tenart@bootlin.com>
Subject: [PATCH] crypto: inside-secure - initialize first_rdesc to make GCC happy
Date: Fri, 13 Jul 2018 17:43:16 +0200
Message-ID: <20180713154316.15689-1-antoine.tenart@bootlin.com>
Cc: Antoine Tenart <antoine.tenart@bootlin.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, maxime.chevallier@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, oferh@marvell.com, igall@marvell.com
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In the cipher safexcel_send_req function, GCC warns that
first_rdesc may be used uninitialized. While this should never
happen, this patch removes the warning by initializing this
variable to NULL to make GCC happy.

This was reported by the kbuild test robot.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 27fee069ee5a..f09a96d23c44 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -378,7 +378,7 @@ static int safexcel_send_req(struct crypto_async_request *base, int ring,
 	struct safexcel_cipher_ctx *ctx = crypto_tfm_ctx(base->tfm);
 	struct safexcel_crypto_priv *priv = ctx->priv;
 	struct safexcel_command_desc *cdesc;
-	struct safexcel_result_desc *rdesc, *first_rdesc;
+	struct safexcel_result_desc *rdesc, *first_rdesc = NULL;
 	struct scatterlist *sg;
 	unsigned int totlen = cryptlen + assoclen;
 	int nr_src, nr_dst, n_cdesc = 0, n_rdesc = 0, queued = totlen;
-- 
2.17.1
