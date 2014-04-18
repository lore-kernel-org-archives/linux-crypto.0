From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH crypto 1/2] crypto: caam - fix mem leak in ahash_setkey
Date: Fri, 18 Apr 2014 13:01:41 +0300
Message-ID: <1397815302-15915-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <stable@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In case hash key is bigger than algorithm block size, it is hashed.
In this case, memory is allocated to keep this hash in hashed_key.
hashed_key has to be freed on the key_dma dma mapping error path.

Cc: <stable@vger.kernel.org> # 3.10+
Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 0378328f47a7..2d244e629ed2 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -545,7 +545,8 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 				      DMA_TO_DEVICE);
 	if (dma_mapping_error(jrdev, ctx->key_dma)) {
 		dev_err(jrdev, "unable to map key i/o memory\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto map_err;
 	}
 #ifdef DEBUG
 	print_hex_dump(KERN_ERR, "ctx.key@"__stringify(__LINE__)": ",
@@ -559,6 +560,7 @@ static int ahash_setkey(struct crypto_ahash *ahash,
 				 DMA_TO_DEVICE);
 	}
 
+map_err:
 	kfree(hashed_key);
 	return ret;
 badkey:
-- 
1.8.3.1
